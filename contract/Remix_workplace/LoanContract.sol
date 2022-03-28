// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;
contract LoanContract {
// FIX 一人同时多个借贷，可能用uuid存入一个解决？改下数据结构
// Demo 存入 ETH 换 USDT 或者 DAI
    struct Loan {
        // 可能要存入一个uuid，后续加钱定位用，
        address borrower;
        uint ethValue;
        uint startTime;
        uint endTime;
        uint APR;
    }
    
    mapping(address => Loan[] ) public loanList;
    
    address owner;
    uint public APR;

    // 没有浮点数，0.09 * 100 = 9，最后交易转账要除100
    constructor(uint _APR) public {
        owner = msg.sender;
        APR = _APR;

    }

    event LoanStart(address borrower, uint eth_value, uint startTime, uint endTime, uint APR);
    event APRChanged(uint APR);


    // 创建抵押贷款
    function setLoan(uint _loanDay) public payable returns(bool){
        Loan memory loan;
        loan.borrower = msg.sender;
        loan.startTime = block.timestamp;
    //    还款日期后面还有宽限期
        loan.endTime = block.timestamp + _loanDay * 1 days ; 
        loan.ethValue = msg.value;
        loan.APR = APR;
        loanList[msg.sender].push(loan);
        emit LoanStart(loan.borrower, loan.ethValue, loan.startTime, loan.endTime, loan.APR);
        return true;
   }

    function getloanList() public view returns (Loan[] memory) {
        // FIX 暂时只能返回一个人的贷款数据
        return loanList[msg.sender];
   }



    // 修改APR
    function setAPR(uint _APR) public returns(bool){
        require(msg.sender == owner, "Forbidden");
        APR = _APR;
        emit APRChanged(_APR);
        return true;
       

   }

}