// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract generalTests1 {


    function whatIsTheMeaningOfLife() external returns(uint8) {
        return 42;
    }
    function getFunctionSelector1(string calldata sel) external view returns(bytes4 val){
        val = bytes4(keccak256(abi.encodePacked(sel)));
    }
    
}