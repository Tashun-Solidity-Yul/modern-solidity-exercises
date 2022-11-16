// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


contract Exercise_3 {
    // up to 2 ** 128 - 1 
    uint128 public C = 4;
    // up to 2 ** 96 - 1
    uint96 public D = 6;
    // up to 2 ** 16 - 1
    uint16 public E = 8;
    // up to 2 ** 8 - 1
    uint8 public F = 1;

    bytes32 testval;

    constructor(){}

    function readBySlot(uint256 slot) public view returns (bytes32 slotValue) {
        assembly {
            slotValue := sload(slot)
        }
    }

    function writeToSlot(uint256 slot, uint256 value) public {
        assembly {
            sstore(slot, value)
        }
    }

    function getC() pure public returns (uint256 slot, uint256 offset) {
        assembly {
            slot := C.slot
            offset := C.offset
        }
    }
    /**
   Number of fs added = 128 / 4
   **/

    function readC() public view returns (uint128 cVal) {
        assembly {
            let slotValue := sload(C.slot)
            cVal := and(slotValue, 0xffffffffffffffffffffffffffffffff)
        }
    }

    function getD() pure public returns (uint256 slot, uint256 offset) {
        assembly {
            slot := D.slot
            offset := D.offset
        }
    }
    /**
       Number of fs added = 96 / 4
       **/
    function readD() view public returns (uint96 dVal) {
        assembly {
            let val := sload(D.slot)
            let shiftedVal := shr(mul(16, 8), val)
        // dVal:=shr(mul(16,8), val)
            dVal := and(0xffffffffffffffffffffffff, shiftedVal)
        }
    }


    function getE() pure public returns (uint256 slot, uint256 offset) {
        assembly {
            slot := E.slot
            offset := E.offset
        }
    }

    /**
    Number of fs added = 16 / 4
    **/
    function readE() view public returns (uint16 eVal) {
        assembly{
            let val := sload(E.slot)
            let shiftedVal := shr(mul(E.offset, 8), val)
            eVal := and(0xffff, shiftedVal)
        }
    }


    function getF() pure public returns (uint256 slot, uint256 offset) {
        assembly {
            slot := F.slot
            offset := F.offset
        }
    }
    /**
     Number of fs added = 8 / 4
     **/
    function readF() view public returns (uint8 fVal) {
        assembly {
            let val := sload(F.slot)
            let shiftedVal := shr(mul(F.offset, 8), val)
            fVal := and(0xff, shiftedVal)
        }
    }
    /**
    number of zeros would be = F.offset * 2 - represent the number of digits to skip 
    **/
    function FWithDivShifting() view public returns (uint8 fVal){
        assembly {
            let val := sload(F.slot)
            let dividedValue := div(val, 0x1000000000000000000000000000000000000000000000000000000000000)
            fVal := and(0xff, dividedValue)
        }
    }

    function writeC(uint128 val) public {
        assembly {
        // load C
            let localC := sload(C.slot)
            // clear old C from slot
            let tempVal := not(shl(mul(),))
            //shift new C to offset
            // take the or and get the new value
            // store slot relating to C
        }
    }
/**

**/
    function writeD(uint96 val) public {

        assembly {
        let dValue := sload(D.slot)

        // let byteVale := not(shl(mul(D.offset, 8), 0xffffffffffffffffffffffff))
            // let valueClearedBytes := and(dValue, byteVale)
            // sstore(testval.slot,byteVale)
            let valueClearedBytes := and(dValue, 0xffffffff000000000000000000000000ffffffffffffffffffffffffffffffff)
            

            let leftShiftedVal := shl(mul(D.offset, 8), val)
            sstore(D.slot, add(valueClearedBytes, leftShiftedVal)) // doing or in the video
        }
    }

        function writeE(uint16 val) public {
            assembly {
                // load E locally
                let localEValue := sload(E.slot)
                // clear the E value from slot
               let byteVale := not(shl(mul(E.offset, 8), 0xffff))
                sstore(testval.slot,byteVale)
                let clearedE := and (localEValue, 0xffffffffffffffffffffffffffff0000ffffffffffffffffffffffffffffffff)

                let shiftedValue := shl(mul(E.offset, 8), val)

                sstore(E.slot, or(shiftedValue,clearedE))

            }

        }

}