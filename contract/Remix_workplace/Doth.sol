// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
// import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";

/// @title Doth contract implementation
/// @author Zejiang Yang
/// @notice Day Day money
contract Doth {
    struct Loan {
        uint256 id; // loan id
        uint256 term; // loan term
        uint256 APR; // loan APR
        uint256 usdAmount; // amount in USD
        uint256 tokenAmount; // collateral: amount in token
        address tokenAddress; // collateral: token address
        uint256 status; // loan status -- 0: outstanding, 1: repaid
        uint256 startTime; // loan start time
        uint256 endTime; // loan end time
        uint256 LastMarginCall; // last margin call time
        uint256 LastOverdueCall; // last overdue call time
    }

    address owner;
    address[] managers;
    uint256 id; // auto increment
    uint256 public APY; // Annual Percentage Yield. For deposit
    uint256 public APR; // Annual Percentage Rate. For borrow
    uint256 public InitialLTV; // Initial Loan to Value.
    uint256 public MarginCallLTV; // Margin Call Loan to Value.
    uint256 public LiquidationLTV; // Liquidation Loan to Value.
    address[] public borrowers; // Array of current outstanding borrowers
    address[] public allowedTokens; // Array of allowed token addresses
    mapping(address => address) public tokenPriceFeedMapping; // Mapping of token address to price feed address
    mapping(address => Loan[]) public Loans; // Loan detail for each borrower
    mapping(address => uint256) public curLoanNum; // current outstanding loan number for each borrower

    // mapping of loan term to overdue duration, i.e.
    // 7/14days -> 72 hours and 30/90/180 days -> 168 hours
    mapping(uint256 => uint256) public overdueDuration;
    uint256[] public allowedLoanTerm; // Array of allowed term

    constructor() {
        owner = msg.sender;
        managers = [msg.sender];
        APR = 9;
        APY = 3;
        InitialLTV = 65;
        MarginCallLTV = 75;
        LiquidationLTV = 83;
        overdueDuration[7 days] = 72 hours;
        overdueDuration[14 days] = 72 hours;
        overdueDuration[30 days] = 168 hours;
        overdueDuration[90 days] = 168 hours;
        overdueDuration[180 days] = 168 hours;
        allowedLoanTerm = [7 days, 14 days, 30 days, 90 days, 180 days];
        // Kovan Testnet
        tokenPriceFeedMapping[0xd0A1E359811322d97991E03f863a0C30C2cF029C] = 0x9326BFA02ADD2366b30bacB125260Af641031331; // WETH
        tokenPriceFeedMapping[0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa] = 0x777A68032a88E5A84678A77Af2CD65A7b3c0775a; // DAI
        allowedTokens = [0xd0A1E359811322d97991E03f863a0C30C2cF029C, 0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa];   // [WETH, DAI]
    }

    event APRChanged(uint256 APR);
    event APYChanegd(uint256 APY);
    event ManagerAdded(address manager);
    event ManagerRemoved(address manager);

    /////// common ///////
    // setIntialLTV - Done!
    // setMarginCallLTV - Done!
    // setLiquidationLTV - Done!
    // TODO ****chainlink keeper****
    // addManager - Done!
    // removeManager - Done!

    /////// borrow ///////
    // setAPR - Done!
    // TODO createLoan
    // TODO liquidateLoan
    // TODO addCollateral(address borrower, uint tokenAmount, address tokenAddress)
    // TODO removeCollateral(address borrower, uint tokenAmount, address tokenAddress)
    // addAllowedTokens - Done!
    // removeAllowedTokens - Done!
    // setPriceFeedContract - Done!
    // setOverdueDuration
    // setAllowedLoanTerm

    /////// deposit ///////
    // setAPY - Done!

    function addAllowedTokens(address _token) public onlyManager {
        require(!isTokenExisted(_token), "Token already exists");
        allowedTokens.push(_token);
        // emit
    }

    function removeAllowedTokens(address _token) public onlyManager {
        require(isTokenExisted(_token), "Token does not exist");
        for (uint256 i = 0; i < allowedTokens.length; i++) {
            if (allowedTokens[i] == _token) {
                allowedTokens[i] = allowedTokens[allowedTokens.length - 1];
                allowedTokens.pop();
                // emit
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
        // emit
    }

    function setIntialLTV(uint256 _LTV) public onlyManager {
        InitialLTV = _LTV;
        // emit
    }

    function setMarginCallLTV(uint256 _LTV) public onlyManager {
        MarginCallLTV = _LTV;
        // emit
    }

    function setLiquidationLTV(uint256 _LTV) public onlyManager {
        LiquidationLTV = _LTV;
        // emit
    }

    /// @notice Set the new APR
    /// @param _APR The new APR you want to set
    function setAPR(uint256 _APR) public onlyManager {
        APR = _APR;
        emit APRChanged(_APR);
    }

    /// @notice Set the new APY
    /// @param _APY The new APY you want to set
    function setAPY(uint256 _APY) public onlyManager {
        APY = _APY;
        emit APRChanged(_APY);
    }

    /// @notice Add a manager
    /// @param _manager The manager you want to add
    function addManager(address _manager) public {
        require(owner == msg.sender, "Only Owner can add manager");
        require(!isManager(_manager), "Manager already exists");
        managers.push(_manager);
        emit ManagerAdded(_manager);
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
                emit ManagerRemoved(_manager);
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
