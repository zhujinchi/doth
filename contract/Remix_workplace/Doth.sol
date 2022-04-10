// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";

/// @title Doth contract implementation
/// @author Zejiang Yang
/// @notice Day Day money
contract Doth {
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

    address owner;
    address[] managers;
    uint256 public APY; // decimal 8
    uint256 public APR; // decimal 8
    uint256 public initialLTV; // Initial Loan to Value. decimal 4
    uint256 public marginCallLTV; // Margin Call Loan to Value. decimal 4
    uint256 public liquidationLTV; // Liquidation Loan to Value. decimal 4
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

    /////// common ///////
    // setIntialLTV - Done!
    // setMarginCallLTV - Done!
    // setLiquidationLTV - Done!
    // setPriceFeedContract - Done!
    // addAllowedToken - Done!
    // removeAllowedToken - Done!
    // addManager - Done!
    // removeManager - Done!
    // getLTV - Done!
    // getUserTotalValue - Done!
    // getUserSingleTokenValue - Done!
    // getUserSingleTokenAmount - Done!
    // getTokenValue - Done!
    // getUserLoanValue - Done!
    // getDaysFromNow - Done!
    /**
     * if LTV over 83 auto repay token make LTV back to 65;
     * if LTV over 75 auto send warning email;
     * if overdue, auto send warning email
     */
    // TODO ****chainlink keeper****

    /////// deposit ///////
    // setAPY - Done!
    // deposit - Done!
    // withdraw - Done!
    // issueDepositInterest - Done!

    /////// borrow ///////
    // setAPR - Done!
    // TODO borrow
    // repayByUSD - Done!
    // repayByCollateral - Done! -- param address[], if not Null list，repay by this order, otherwise [Weth, DAI]
    // issueLoanInterest - Done!
    // isBorrower - Done!
    // removeBorrower - Done!

    function borrow(uint256 _amount) public {
        require(_amount > 0, "Amount must be more than 0");
        require(getUserTotalValue(msg.sender) != 0, "User has no collateral");
        require(
            getLTV(msg.sender) < initialLTV,
            "Allow borrow only when LTV below initialLTV"
        );
        issueLoanInterest(msg.sender);
        loanBalance[msg.sender].principal += _amount;
        loanBalance[msg.sender].timestamp = block.timestamp;
        // TODO send http request to back end to lend money, if not listen to event

        if (!isBorrower(msg.sender)) {
            borrowers.push(msg.sender);
        }
        if (getLTV(msg.sender) > initialLTV) {
            revert("LTV is over initialLTV, not allowed borrow");
        }
        emit Borrow(msg.sender, _amount);
    }

    function repayByCollateral(address[] memory _tokens, uint256 _amount)
        public
    {
        require(_amount > 0, "Amount must be more than 0");
        require(isBorrower(msg.sender), "You do not have a loan");
        require(
            _amount <= getUserLoanValue(msg.sender),
            "Amount cannot more than loan balance"
        );
        issueLoanInterest(msg.sender);
        for (uint256 i = 0; i < allowedTokens.length; i++) {
            issueDepositInterest(msg.sender, allowedTokens[i]);
        }
        uint256 amount = _amount;
        for (uint256 i = 0; i < _tokens.length; i++) {
            if (collateralBalance[_tokens[i]][msg.sender].interest >= amount) {
                collateralBalance[_tokens[i]][msg.sender].interest -= amount;
                amount = 0;
            } else {
                amount -= collateralBalance[_tokens[i]][msg.sender].interest;
                collateralBalance[_tokens[i]][msg.sender].interest = 0;
                if (
                    collateralBalance[_tokens[i]][msg.sender].principal >=
                    amount
                ) {
                    collateralBalance[_tokens[i]][msg.sender]
                        .principal -= amount;
                    amount = 0;
                } else {
                    amount -= collateralBalance[_tokens[i]][msg.sender]
                        .principal;
                    collateralBalance[_tokens[i]][msg.sender].principal = 0;
                }
            }
            if (amount == 0) break;
        }

        if (getUserLoanValue(msg.sender) == 0) {
            removeBorrower(msg.sender);
        }
        emit RepayByCollateral(msg.sender, _amount);
    }

    function repayByUSD(address _user, uint256 _amount) public onlyManager {
        require(_amount > 0, "Amount must be more than 0");
        require(isBorrower(_user), "You do not have a loan");
        require(
            _amount <= getUserLoanValue(_user),
            "Amount cannot more than loan balance"
        );
        issueLoanInterest(_user);
        if (loanBalance[_user].interest >= _amount) {
            loanBalance[_user].interest -= _amount;
        } else {
            loanBalance[_user].interest = 0;
            loanBalance[_user].principal =
                loanBalance[_user].principal -
                _amount +
                loanBalance[_user].interest;
        }
        if (getUserLoanValue(_user) == 0) {
            removeBorrower(_user);
        }
        emit RepayByUSD(_user, _amount);
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

    function issueLoanInterest(address _user) internal {
        uint256 timeInterval = getDaysFromNow(loanBalance[_user].timestamp);
        if (
            loanBalance[_user].timestamp != 0 & loanBalance[_user].principal !=
            0 & timeInterval >= 1
        ) {
            // principal * (APR / 365) * days
            loanBalance[_user].interest +=
                (loanBalance[_user].principal * APR * (timeInterval + 1)) /
                (365 * (10**8));
            loanBalance[_user].timestamp = block.timestamp;
        }
    }

    function deposit(address _token, uint256 _amount) public {
        require(_amount > 0, "Amount must be more than 0");
        require(isTokenExisted(_token), "Token is not allowed");
        issueDepositInterest(msg.sender, _token);
        IERC20(_token).transferFrom(msg.sender, address(this), _amount);
        collateralBalance[_token][msg.sender].principal += _amount;
        collateralBalance[_token][msg.sender].timestamp = block.timestamp;
        emit Deposit(msg.sender, _token, _amount);
    }

    function withdraw(address _token, uint256 _amount) public {
        // after withdraw, check the LTV if over 83, revert the transaction.
        require(_amount > 0, "Amount cannot be 0");
        require(
            _amount <= getUserSingleTokenAmount(msg.sender, _token),
            "Insufficient balance"
        );
        issueDepositInterest(msg.sender, _token);
        IERC20(_token).transfer(msg.sender, _amount);
        if (collateralBalance[_token][msg.sender].interest >= _amount) {
            collateralBalance[_token][msg.sender].interest -= _amount;
        } else {
            collateralBalance[_token][msg.sender].interest = 0;
            collateralBalance[_token][msg.sender].principal =
                collateralBalance[_token][msg.sender].principal -
                _amount +
                collateralBalance[_token][msg.sender].interest;
        }
        if (getLTV(msg.sender) >= liquidationLTV) {
            revert("LTV is over liquidationLTV");
        }
        emit Withdraw(msg.sender, _token, _amount);
    }

    // issue the interest since the last time
    function issueDepositInterest(address _user, address _token) internal {
        uint256 timeInterval = getDaysFromNow(
            collateralBalance[_token][_user].timestamp
        );
        if (
            collateralBalance[_token][_user].timestamp !=
            0 & collateralBalance[_token][_user].principal !=
            0 & timeInterval >= 1
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

    function getDaysFromNow(uint256 _timestamp) public view returns (uint256) {
        return ((block.timestamp - _timestamp) / 1 days);
    }

    function getLTV(address _user) public view returns (uint256) {
        require(
            getUserTotalValue(_user) != 0,
            "Collateral value can not be zero"
        );
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

    function isBorrower(address _user) public view returns (bool) {
        for (uint256 i = 0; i < borrowers.length; i++) {
            if (borrowers[i] == _user) {
                return true;
            }
        }
        return false;
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

    function addAllowedToken(address _token) public onlyManager {
        require(!isTokenExisted(_token), "Token already exists");
        allowedTokens.push(_token);
        emit AddAllowedToken(msg.sender, _token);
    }

    function removeAllowedToken(address _token) public onlyManager {
        require(isTokenExisted(_token), "Token does not exist");
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

    function setPriceFeedContract(address _token, address _priceFeed)
        public
        onlyManager
    {
        tokenPriceFeedMapping[_token] = _priceFeed;
        emit SetPriceFeedContract(_token, _priceFeed);
    }

    function setIntialLTV(uint256 _LTV) public onlyManager {
        initialLTV = _LTV;
        emit SetIntialLTV(_LTV);
    }

    function setMarginCallLTV(uint256 _LTV) public onlyManager {
        marginCallLTV = _LTV;
        emit SetMarginCallLTV(_LTV);
    }

    function setLiquidationLTV(uint256 _LTV) public onlyManager {
        liquidationLTV = _LTV;
        emit SetLiquidationLTV(_LTV);
    }

    /// @notice Set the new APR
    /// @param _APR The new APR you want to set
    function setAPR(uint256 _APR) public onlyManager {
        APR = _APR;
        emit SetAPR(_APR);
    }

    /// @notice Set the new APY
    /// @param _APY The new APY you want to set
    function setAPY(uint256 _APY) public onlyManager {
        APY = _APY;
        emit SetAPY(_APY);
    }

    /// @notice Add a manager
    /// @param _manager The manager you want to add
    function addManager(address _manager) public {
        require(owner == msg.sender, "Only Owner can add manager");
        require(!isManager(_manager), "Manager already exists");
        managers.push(_manager);
        emit AddManager(_manager);
    }

    /// @notice Remove a manager
    /// @param _manager The manager you want to remove
    function removeManager(address _manager) public {
        require(owner == msg.sender, "Only Owner can remove manager");
        require(isManager(_manager), "Manager does not exist");
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

    modifier onlyManager() {
        bool flag = false;
        for (uint256 i = 0; i < managers.length; i++) {
            if (managers[i] == msg.sender) {
                flag = true;
                break;
            }
        }
        require(flag, "Only manager can do this");
        _;
    }
}
