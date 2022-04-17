// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";

/// @title Doth contract implementation
/// @author Zejiang Yang
/// @notice Day Day money
contract Doth is KeeperCompatibleInterface {
    struct Loan {
        uint256 principal; // principal amount for USD
        uint256 interest;
        uint256 timestamp;
    }
    struct Collateral {
        uint256 principal;
        uint256 interest;
        uint256 timestamp;
    }

    address public owner;
    address[] managers;
    uint256 public APY; // decimal 8
    uint256 public APR; // decimal 8
    uint256 public initialLTV; // Initial Loan to Value. decimal 4
    uint256 public marginCallLTV; // Margin Call Loan to Value. decimal 4
    uint256 public liquidationLTV; // Liquidation Loan to Value. decimal 4
    address[] public depositors; // Array of current depositors
    address[] public borrowers; // Array of current outstanding borrowers
    address[] public allowedTokens; // Array of allowed token addresses
    mapping(address => address) public tokenPriceFeedMapping; // Mapping of token address to price feed address
    mapping(address => Loan) public loanBalance; // LoanBalance for each borrower. Only USD, decimal 2
    mapping(address => uint256) lastMarginCall; // last margin call time
    mapping(address => mapping(address => Collateral)) collateralBalance; // token address -> user address -> Collateral[], decimal 18

    constructor() {
        owner = msg.sender;
        managers = [msg.sender];
        APR = 9000000; // Annual Percentage Rate, decimal 8
        APY = 3000000; // Annual Percentage Yield, decimal 8
        initialLTV = 6500; // decimal 4
        marginCallLTV = 7500; // decimal 4
        liquidationLTV = 8300; // decimal 4
        // Kovan Testnet
        tokenPriceFeedMapping[
            0xd0A1E359811322d97991E03f863a0C30C2cF029C
        ] = 0x9326BFA02ADD2366b30bacB125260Af641031331; // WETH
        tokenPriceFeedMapping[
            0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa
        ] = 0x777A68032a88E5A84678A77Af2CD65A7b3c0775a; // DAI
        allowedTokens = [
            0xd0A1E359811322d97991E03f863a0C30C2cF029C,
            0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa
        ]; // [WETH, DAI]
    }

    event Borrow(address indexed user, uint256 amount);
    event RepayByCollateral(address indexed user, uint256 amount);
    event RepayByUSD(address indexed user, uint256 amount);
    event Deposit(address indexed user, address indexed token, uint256 amount);
    event Withdraw(address indexed user, address indexed token, uint256 amount);
    event AddAllowedToken(address indexed manager, address token);
    event RemoveAllowedToken(address indexed manager, address token);
    event SetPriceFeedContract(address token, address priceFeed);
    event SetIntialLTV(uint256 LTV);
    event SetMarginCallLTV(uint256 LTV);
    event SetLiquidationLTV(uint256 LTV);
    event SetAPR(uint256 APR);
    event SetAPY(uint256 APY);
    event AddManager(address manager);
    event RemoveManager(address manager);
    event IWithdraw(address to, address token, uint256 amount);
    event EmailCall(address to, uint256 format);
    event Liquidate(address user, uint256 amount);

    /**
     * if LTV over 83 auto repay token make LTV back to 65;
     * if LTV over 75 auto send warning email;
     * if overdue, auto send warning email
     */
    // ****chainlink keeper****
    function checkUpkeep(
        bytes calldata /* checkData */
    )
        external
        view
        override
        returns (
            bool upkeepNeeded,
            bytes memory /* performData */
        )
    {
        for (uint256 i = 0; i < borrowers.length; i++) {
            if (
                (getLTV(borrowers[i]) >= marginCallLTV) &&
                ((block.timestamp - lastMarginCall[borrowers[i]]) >= 1 days)
            ) upkeepNeeded = true;
            if (getLTV(borrowers[i]) >= liquidationLTV) upkeepNeeded = true;
        }
    }

    function performUpkeep(
        bytes calldata /* performData */
    ) external override {
        //We highly recommend revalidating the upkeep in the performUpkeep function
        for (uint256 i = 0; i < borrowers.length; i++) {
            if (
                (getLTV(borrowers[i]) >= marginCallLTV) &&
                ((block.timestamp - lastMarginCall[borrowers[i]]) >= 1 days)
            ) {
                lastMarginCall[borrowers[i]] = block.timestamp;
                emit EmailCall(borrowers[i], 1);
            }
            if (getLTV(borrowers[i]) >= liquidationLTV) {
                liquidate(borrowers[i]);
            }
        }
    }

    function liquidate(address _user) internal {
        issueLoanInterest(_user);
        for (uint256 i = 0; i < allowedTokens.length; i++) {
            issueDepositInterest(_user, allowedTokens[i]);
        }
        uint256 amount = (getUserTotalValue(_user) *
            (liquidationLTV - initialLTV)) / (10000 - initialLTV);
        _repayByCollateral(_user, allowedTokens, amount);
        emit Liquidate(_user, amount);
        emit EmailCall(_user, 2);
    }

    /////// Deposit ///////
    // deposit - Done!
    // withdraw - Done!
    // issueDepositInterest - Done!
    // isDepositor - Done!
    // removeDepositor - Done!

    function deposit(address _token, uint256 _amount) external {
        require(_amount > 0);
        require(isTokenExisted(_token));
        issueDepositInterest(msg.sender, _token);
        IERC20(_token).transferFrom(msg.sender, address(this), _amount);
        collateralBalance[_token][msg.sender].principal += _amount;
        collateralBalance[_token][msg.sender].timestamp = block.timestamp;
        if (!isDepositor(msg.sender)) {
            depositors.push(msg.sender);
        }
        emit Deposit(msg.sender, _token, _amount);
    }

    function withdraw(address _token, uint256 _amount) external {
        // after withdraw, check the LTV if over 83, revert the transaction.
        require(_amount > 0);
        require(_amount <= getUserSingleTokenAmount(msg.sender, _token));
        issueDepositInterest(msg.sender, _token);
        IERC20(_token).transfer(msg.sender, _amount);
        if (collateralBalance[_token][msg.sender].interest >= _amount) {
            collateralBalance[_token][msg.sender].interest -= _amount;
        } else {
            collateralBalance[_token][msg.sender].principal =
                collateralBalance[_token][msg.sender].principal +
                collateralBalance[_token][msg.sender].interest -
                _amount;
            collateralBalance[_token][msg.sender].interest = 0;
        }
        if (getLTV(msg.sender) >= liquidationLTV) {
            revert("LTV is over liquidationLTV");
        }
        if (getUserTotalValue(msg.sender) == 0) {
            removeDepositor(msg.sender);
        }
        emit Withdraw(msg.sender, _token, _amount);
    }

    // issue the interest since the last time
    function issueDepositInterest(address _user, address _token) internal {
        uint256 timeInterval = getDaysFromNow(
            collateralBalance[_token][_user].timestamp
        );
        if (
            (collateralBalance[_token][_user].timestamp != 0) &&
            (collateralBalance[_token][_user].principal != 0) &&
            (timeInterval >= 1)
        ) {
            // principal * (APY / 365) * days
            collateralBalance[_token][_user].interest +=
                (collateralBalance[_token][_user].principal *
                    APY *
                    timeInterval) /
                (365 * (10**8));
            collateralBalance[_token][_user].timestamp = block.timestamp;
        }
    }

    function isDepositor(address _user) public view returns (bool) {
        for (uint256 i = 0; i < depositors.length; i++) {
            if (depositors[i] == _user) {
                return true;
            }
        }
        return false;
    }

    function removeDepositor(address _user) internal {
        for (uint256 i = 0; i < depositors.length; i++) {
            if (depositors[i] == _user) {
                depositors[i] = depositors[depositors.length - 1];
                depositors.pop();
                break;
            }
        }
    }

    /////// Borrow ///////
    // borrow - Done!
    // repayByCollateral - Done! -- param address[], if not Null list，repay by this order, otherwise [Weth, DAI]
    // repayByUSD - Done!
    // issueLoanInterest - Done!
    // isBorrower - Done!
    // removeBorrower - Done!
    // verifyTokens - Done!
    // USDInToken - Done!

    function borrow(uint256 _amount) external {
        require(_amount > 0);
        require(getUserTotalValue(msg.sender) != 0);
        require(getLTV(msg.sender) < initialLTV);
        issueLoanInterest(msg.sender);
        loanBalance[msg.sender].principal += _amount;
        loanBalance[msg.sender].timestamp = block.timestamp;
        // TODO send http request to back end to lend money, if not listen to event

        if (!isBorrower(msg.sender)) {
            borrowers.push(msg.sender);
        }
        if (getLTV(msg.sender) > initialLTV) {
            revert("LTV is over initialLTV");
        }
        emit Borrow(msg.sender, _amount);
    }

    function repayByCollateral(address[] memory _tokens, uint256 _amount)
        external
    {
        require(verifyTokens(_tokens));
        require(_amount > 0);
        require(isBorrower(msg.sender));
        require(_amount <= getUserLoanValue(msg.sender));
        issueLoanInterest(msg.sender);
        for (uint256 i = 0; i < allowedTokens.length; i++) {
            issueDepositInterest(msg.sender, allowedTokens[i]);
        }
        _repayByCollateral(msg.sender, _tokens, _amount);
        emit RepayByCollateral(msg.sender, _amount);
    }

    function _repayByCollateral(
        address _user,
        address[] memory _tokens,
        uint256 _amount
    ) internal {
        uint256 amount = _amount;
        for (uint256 i = 0; i < _tokens.length; i++) {
            (uint256 price, uint256 decimals) = getTokenValue(_tokens[i]);
            uint256 iValue = (collateralBalance[_tokens[i]][_user].interest *
                price *
                (10**2)) / (10**(decimals + 18));
            uint256 pValue = (collateralBalance[_tokens[i]][_user].principal *
                price *
                (10**2)) / (10**(decimals + 18));
            if (iValue >= amount) {
                collateralBalance[_tokens[i]][_user].interest -= USDInToken(
                    _tokens[i],
                    amount
                );
                amount = 0;
            } else {
                amount -= iValue;
                collateralBalance[_tokens[i]][_user].interest = 0;
                if (pValue >= amount) {
                    collateralBalance[_tokens[i]][_user]
                        .principal -= USDInToken(_tokens[i], amount);
                    amount = 0;
                } else {
                    amount -= pValue;
                    collateralBalance[_tokens[i]][_user].principal = 0;
                }
            }
            if (amount == 0) break;
        }
        if (loanBalance[_user].interest >= _amount) {
            loanBalance[_user].interest -= _amount;
        } else {
            loanBalance[_user].principal =
                loanBalance[_user].principal +
                loanBalance[_user].interest -
                _amount;
            loanBalance[_user].interest = 0;
        }
        if (getUserLoanValue(_user) == 0) {
            removeBorrower(_user);
        }
        if (getUserTotalValue(_user) == 0) {
            removeDepositor(_user);
        }
    }

    function repayByUSD(address _user, uint256 _amount) external onlyManager {
        require(_amount > 0);
        require(isBorrower(_user));
        require(_amount <= getUserLoanValue(_user));
        issueLoanInterest(_user);
        if (loanBalance[_user].interest >= _amount) {
            loanBalance[_user].interest -= _amount;
        } else {
            loanBalance[_user].principal =
                loanBalance[_user].principal +
                loanBalance[_user].interest -
                _amount;
            loanBalance[_user].interest = 0;
        }
        if (getUserLoanValue(_user) == 0) {
            removeBorrower(_user);
        }
        emit RepayByUSD(_user, _amount);
    }

    function issueLoanInterest(address _user) internal {
        uint256 timeInterval = getDaysFromNow(loanBalance[_user].timestamp);
        if (
            (loanBalance[_user].timestamp != 0) &&
            (loanBalance[_user].principal != 0) &&
            (timeInterval >= 1)
        ) {
            // principal * (APR / 365) * days
            loanBalance[_user].interest +=
                (loanBalance[_user].principal * APR * (timeInterval + 1)) /
                (365 * (10**8));
            loanBalance[_user].timestamp = block.timestamp;
        }
    }

    function isBorrower(address _user) public view returns (bool) {
        for (uint256 i = 0; i < borrowers.length; i++) {
            if (borrowers[i] == _user) {
                return true;
            }
        }
        return false;
    }

    function removeBorrower(address _user) internal {
        for (uint256 i = 0; i < borrowers.length; i++) {
            if (borrowers[i] == _user) {
                borrowers[i] = borrowers[borrowers.length - 1];
                borrowers.pop();
                break;
            }
        }
    }

    function USDInToken(address _token, uint256 _amount)
        public
        view
        returns (uint256)
    {
        (uint256 price, uint256 decimals) = getTokenValue(_token);
        return (_amount * (10**(16 + decimals))) / price;
    }

    function verifyTokens(address[] memory _tokens)
        internal
        view
        returns (bool)
    {
        if (_tokens.length != allowedTokens.length) return false;
        for (uint256 i = 0; i < _tokens.length; i++) {
            bool flag = false;
            for (uint256 j = 0; j < allowedTokens.length; j++) {
                if (_tokens[i] == allowedTokens[j]) flag = true;
            }
            if (!flag) return false;
        }
        return true;
    }

    /////// Common ///////
    // getLTV - Done!
    // getUserLoanValue - Done!
    // getUserTotalValue - Done!
    // getUserSingleTokenValue - Done!
    // getUserSingleTokenAmount - Done!
    // getTokenValue - Done!
    // getDaysFromNow - Done!
    // modifier onlyManager() - Done!
    // modifier onlyOwner() - Done!
    function getLTV(address _user) public view returns (uint256) {
        require(getUserTotalValue(_user) != 0);
        if (!isBorrower(_user)) return 0;
        else {
            return ((getUserLoanValue(_user) * (10**4)) /
                getUserTotalValue(_user));
        }
    }

    function getUserLoanValue(address _user) public view returns (uint256) {
        uint256 timeInterval = getDaysFromNow(loanBalance[_user].timestamp);
        if (loanBalance[_user].timestamp != 0 && timeInterval >= 1) {
            return (loanBalance[_user].principal +
                loanBalance[_user].interest +
                (loanBalance[_user].principal * APR * (timeInterval + 1)) /
                (365 * (10**8)));
        }
        return loanBalance[_user].principal + loanBalance[_user].interest;
    }

    function getUserTotalValue(address _user) public view returns (uint256) {
        uint256 totalValue = 0;
        for (uint256 i = 0; i < allowedTokens.length; i++) {
            totalValue += getUserSingleTokenValue(_user, allowedTokens[i]);
        }
        return totalValue;
    }

    function getUserSingleTokenValue(address _user, address _token)
        public
        view
        returns (uint256)
    {
        uint256 singleTokenTotalAmount = getUserSingleTokenAmount(
            _user,
            _token
        );
        if (singleTokenTotalAmount == 0) {
            return 0;
        }
        (uint256 price, uint256 decimals) = getTokenValue(_token);
        return ((singleTokenTotalAmount * price * (10**2)) /
            (10**(decimals + 18)));
    }

    function getUserSingleTokenAmount(address _user, address _token)
        public
        view
        returns (uint256)
    {
        uint256 timeInterval = getDaysFromNow(
            collateralBalance[_token][_user].timestamp
        );
        if (
            collateralBalance[_token][_user].timestamp != 0 && timeInterval >= 1
        ) {
            return (collateralBalance[_token][_user].principal +
                collateralBalance[_token][_user].interest +
                (collateralBalance[_token][_user].principal *
                    APY *
                    timeInterval) /
                (365 * (10**8)));
        }
        return (collateralBalance[_token][_user].principal +
            collateralBalance[_token][_user].interest);
    }

    function getTokenValue(address _token)
        public
        view
        returns (uint256, uint256)
    {
        // priceFeedAddress
        address priceFeedAddress = tokenPriceFeedMapping[_token];
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            priceFeedAddress
        );
        (, int256 price, , , ) = priceFeed.latestRoundData();
        uint256 decimals = uint256(priceFeed.decimals());
        return (uint256(price), decimals);
    }

    function getDaysFromNow(uint256 _timestamp) public view returns (uint256) {
        return ((block.timestamp - _timestamp) / 1 days);
    }

    modifier onlyManager() {
        bool flag = false;
        for (uint256 i = 0; i < managers.length; i++) {
            if (managers[i] == msg.sender) {
                flag = true;
                break;
            }
        }
        require(flag);
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /////// Management ///////
    // iWithdraw - Done!
    // getTotalTokens - Done!
    // getDepositors - Done!
    // getBorrowers - Done!
    // addManager - Done!
    // removeManager - Done!
    // isManager - Done!
    // setIntialLTV - Done!
    // setMarginCallLTV - Done!
    // setLiquidationLTV - Done!
    // setAPY - Done!
    // setAPR - Done!
    // setPriceFeedContract - Done!
    // addAllowedToken - Done!
    // removeAllowedToken - Done!
    // isTokenExisted - Done!

    function iWithdraw(
        address _to,
        address _token,
        uint256 _amount
    ) public onlyOwner {
        require(_amount > 0);
        IERC20(_token).transfer(_to, _amount);
        emit IWithdraw(_to, _token, _amount);
    }

    function getTotalTokens()
        public
        view
        returns (address[] memory, uint256[] memory)
    {
        uint256[] memory tokenAmounts = new uint256[](allowedTokens.length);
        for (
            uint256 tokenIndex = 0;
            tokenIndex < allowedTokens.length;
            tokenIndex++
        ) {
            uint256 amount = 0;
            for (uint256 i = 0; i < depositors.length; i++) {
                amount += getUserSingleTokenAmount(
                    depositors[i],
                    allowedTokens[tokenIndex]
                );
            }
            tokenAmounts[tokenIndex] = amount;
        }
        return (allowedTokens, tokenAmounts);
    }

    function getDepositors() external view returns (address[] memory) {
        return depositors;
    }

    function getBorrowers() external view returns (address[] memory) {
        return borrowers;
    }

    /// @notice Add a manager
    /// @param _manager The manager you want to add
    function addManager(address _manager) external onlyOwner {
        require(!isManager(_manager));
        managers.push(_manager);
        emit AddManager(_manager);
    }

    /// @notice Remove a manager
    /// @param _manager The manager you want to remove
    function removeManager(address _manager) external onlyOwner {
        require(isManager(_manager));
        for (uint256 i = 0; i < managers.length; i++) {
            if (managers[i] == _manager) {
                managers[i] = managers[managers.length - 1];
                managers.pop();
                emit RemoveManager(_manager);
                break;
            }
        }
    }

    /// @notice Check if is a manager
    /// @param _manager Manager's address
    /// @return true if is a manager or owner, false otherwise
    function isManager(address _manager) public view returns (bool) {
        for (uint256 i = 0; i < managers.length; i++) {
            if (managers[i] == _manager) {
                return true;
            }
        }
        return false;
    }

    /// @notice Set the initial LTV
    /// @param _LTV initial LTV, must be below marginCallLTV and liquidationLTV
    function setIntialLTV(uint256 _LTV) external onlyManager {
        require(_LTV < marginCallLTV && _LTV < liquidationLTV);
        initialLTV = _LTV;
        emit SetIntialLTV(_LTV);
    }

    /// @notice Set the margin call LTV
    /// @param _LTV margin call LTV, must be over initialLTV and below liquidationLTV
    function setMarginCallLTV(uint256 _LTV) external onlyManager {
        require(_LTV > initialLTV && _LTV < liquidationLTV);
        marginCallLTV = _LTV;
        emit SetMarginCallLTV(_LTV);
    }

    /// @notice Set the liquidation LTV
    /// @param _LTV liquidation LTV, must be over initialLTV and marginCallLTV
    function setLiquidationLTV(uint256 _LTV) external onlyManager {
        require(_LTV > marginCallLTV && _LTV > initialLTV);
        liquidationLTV = _LTV;
        emit SetLiquidationLTV(_LTV);
    }

    /// @notice Set the new APR
    /// @param _APR The new APR you want to set
    function setAPR(uint256 _APR) external onlyManager {
        for (
            uint256 borrowerIndex = 0;
            borrowerIndex < borrowers.length;
            borrowerIndex++
        ) {
            issueLoanInterest(borrowers[borrowerIndex]);
        }
        APR = _APR;
        emit SetAPR(_APR);
    }

    /// @notice Set the new APY
    /// @param _APY The new APY you want to set
    function setAPY(uint256 _APY) external onlyManager {
        for (
            uint256 depositorIndex = 0;
            depositorIndex < depositors.length;
            depositorIndex++
        ) {
            for (
                uint256 tokenIndex = 0;
                tokenIndex < allowedTokens.length;
                tokenIndex++
            ) {
                issueDepositInterest(
                    depositors[depositorIndex],
                    allowedTokens[tokenIndex]
                );
            }
        }

        APY = _APY;
        emit SetAPY(_APY);
    }

    function setPriceFeedContract(address _token, address _priceFeed)
        external
        onlyManager
    {
        tokenPriceFeedMapping[_token] = _priceFeed;
        emit SetPriceFeedContract(_token, _priceFeed);
    }

    function addAllowedToken(address _token) external onlyManager {
        require(!isTokenExisted(_token));
        allowedTokens.push(_token);
        emit AddAllowedToken(msg.sender, _token);
    }

    function removeAllowedToken(address _token) external onlyManager {
        require(isTokenExisted(_token));
        for (uint256 i = 0; i < allowedTokens.length; i++) {
            if (allowedTokens[i] == _token) {
                allowedTokens[i] = allowedTokens[allowedTokens.length - 1];
                allowedTokens.pop();
                emit RemoveAllowedToken(msg.sender, _token);
                break;
            }
        }
    }

    function isTokenExisted(address _token) public view returns (bool) {
        for (uint256 i = 0; i < allowedTokens.length; i++) {
            if (allowedTokens[i] == _token) {
                return true;
            }
        }
        return false;
    }
}
