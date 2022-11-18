// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Exercise_2 {
    uint256 x =5;
    uint256 y =15;
    uint256 z =25;
    uint128 m = 3;
    uint128 k = 1;
    address me = address(15);


    function loadFromSlot(uint256 slot) public view returns(uint256 val) {

        assembly{
            val:= sload(slot)
        }
    }

      function loadY() public view returns(uint256 val) {

        assembly{
            val:= sload(y.slot)
        }
    }

    function saveToSlot(uint256 slot, uint256 value) public {
        assembly {
            sstore(slot, value)
        }
    }

     function saveY(uint256 value) public {
        assembly {
            sstore(y.slot, value)
        }
    }

    function getByteValue(uint256 slot) external view returns(bytes32 val) {
        assembly {
            val:=sload(slot)
        }
    }
}