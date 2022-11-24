contract SmallArray {
    uint8[] public smallArray;
   uint128[] public smallArray2;



   constructor(){
       smallArray =[1, 2, 3];
      smallArray2 =[1, 2, 3,4,5,6,7,8,9];
   }

   // todo - write functions

   function readSmallArray(uint256 index) view external returns(uint8 ret) {
      bytes32 startSlot;
      assembly {
         startSlot := smallArray.slot
      }
      bytes32 startingIndex = keccak256(abi.encode(startSlot));
      
      assembly {
          let storageShifts := 0
         let adjustedIndex := index
         if lt(sub(div(256,8),1),index) {
            storageShifts :=div(mul(8, index),256)
            adjustedIndex:=sub(index,mul(storageShifts, div(256,8)))
         }

         let value := sload(add(startingIndex,storageShifts))
         let shiftedValue := shr( mul(adjustedIndex , 8) ,value)
         ret := and(shiftedValue,0x00000000000000000000000000000000000000000000000000000000000000ff)
      }
   }

   function readSmallArray2(uint256 index) view external returns(bytes32 ret) {
      bytes32 startSlot;
      assembly {
         startSlot := smallArray2.slot
      }
      bytes32 startingIndex = keccak256(abi.encode(startSlot));
      
      assembly {
         let storageShifts := 0
         let adjustedIndex := index
         if lt(sub(div(256,128),1),index) {
            storageShifts :=div(mul(128, index),256)
            adjustedIndex:=sub(index,mul(storageShifts, div(256,128)))
         }

         let value := sload(add(startingIndex,storageShifts))
         let shiftedValue := shr( mul(adjustedIndex , 128) ,value)
         ret := and(shiftedValue,0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff)
      }
   }
}