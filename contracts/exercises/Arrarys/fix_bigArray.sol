contract BigArray {
    uint256[3] public fixedArray;
    uint256[] public bigArray;


    constructor(){
        fixedArray =[99, 999, 9999];
        bigArray =[10,20,30];
    }


    /**
     Testing Operations
 **/


    function testReadBigArrayLocation(uint256 index) external  returns(uint256 ret) {

        assembly {
            let startingIndex := keccak256(add(bigArray.slot, 0x20), mload(bigArray.slot))
            sstore(100,startingIndex)
            ret := sload(add(startingIndex,index))
        }
    }

    function readSlotValue(uint256 slot) external view returns(uint256 ret) {
        assembly {
            ret:= sload(slot)
        }
    }

    function testArrayLocations(uint256 slot ) external view returns(bytes32 start) {

        start = keccak256(abi.encode(slot));

        // assembly {
        //     sstore(100,start)
        // }

    }

    /**
       fix Array Operations
   **/

    function fixedArrayView(uint256 index)public view returns(uint256 ret){
        assembly {
            ret := sload(add(fixedArray.slot, index))
        }
    }

    function fixArrayWrite(uint256 index, uint256 value) external {
        assembly{
            if lt(index,3) {
                revert(0,0)
            }

            sstore(add(fixedArray.slot, index),value)
        }
    }
    //-------------------------------------------------------------------------------------------------------
    /**
       Big Array Operations
   **/

    function bigArrayLength() external view returns(uint256 ret) {
        assembly {
            ret := sload(bigArray.slot)
        }
    }

    function readBigArray(uint256 index ) external  returns(uint256 ret) {
        bytes32 slot;
        assembly {
            slot := bigArray.slot
        }
        bytes32 start = keccak256(abi.encode(slot));

        assembly {
            sstore(100,start)
            ret := sload(add(start,index))
        }

    }

    function writeBigArray(uint256 index, uint256 value ) external {
        bytes32 slot;
        assembly {
            slot := bigArray.slot
        }

        bytes32 startingIndex = keccak256(abi.encode(slot));

        assembly{
            sstore(add(startingIndex, index), value)
        }


    }
}