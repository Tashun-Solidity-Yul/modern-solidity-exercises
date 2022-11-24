pragma solidity ^0.8.0;
/**
first 10 array start slots 

290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e563
b10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6
405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace
c2575a0e9e593c00f959f8c92f12db2869c3395a3b0502d05e2516446f71f85b
8a35acfbc15ff81a39ae7d344fd709f28e8600b4aa8c65c6b64bfe7fe36bd19b
036b6384b5eca791c62761152d0c79bb0604c104a5fb6f4eb0703f3154bb3db0
f652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f
a66cc928b5edb82af9bd49922954155ab7b0942694bea4ce44661d9a8736c688
f3f7a9fe364faab93b216da50a3214154f22a0a2b415b23a84c8169e8b636ee3
6e1540171b6c0c960b71a7020d9f60077f6af931a8bbf590da0223dacf75c7af
c65a7bb8d6351c1cf70c95a316cc6a92839c986682d98bc35f958f4883f9d2a8




**/
contract Exercise_4 {
   
   uint256[3]  fixedArray;
   uint256[]  bigArray;
   uint8[] public smallArray;
   uint128[] public smallArray2;

   mapping(uint256 => uint256 ) public myMapping;
   mapping(uint256 => mapping(uint256 => uint256) ) public nestedMapping;
   mapping(address => uint256[] ) public addressToList;

   constructor(){
      fixedArray =[99, 999, 9999];
      bigArray =[10,20,30];
      smallArray =[1, 2, 3];
      smallArray2 =[1, 2, 3,4,5,6,7,8,9];

      myMapping[10] =5;
      myMapping[11] =6;
      nestedMapping[2][4] =7;

      addressToList[0x5C0122Eb7AE6F776E63A1294c1dd0d66FB221F6e] = [42,1337,777];
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

   //-------------------------------------------------------------------------------------------------------
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




//-------------------------------------------------------------------------------------------------------


   function readMyMapping(uint256 key) external view returns(uint256 ret) {
      bytes32 slot;

      assembly {
         slot := myMapping.slot
      }

      bytes32 keySlot = keccak256(abi.encode(key, slot));

      assembly {
         ret := sload(add(keySlot,0))
      }

   }

   function writeMyMapping(uint256 key, uint256 value) external {
      bytes32 slot;

      assembly {
         slot := myMapping.slot
      }

      bytes32 keySlot = keccak256(abi.encode(key, slot));

      assembly {
         sstore(add(keySlot,0),value)
      }
   }



   //-------------------------------------------------------------------------------------------------------

   function readNestedMapping(uint256 firstKey, uint256 secondKey) public view returns(uint256 ret) {
      bytes32 slot;
      assembly {
         slot := nestedMapping.slot
      }
      bytes32 valueIndex = keccak256(abi.encode(secondKey, keccak256(abi.encode(firstKey,slot))));

      assembly {
         ret := sload(valueIndex)
      }
   }

    function writeNestedMapping(uint256 firstKey, uint256 secondKey, uint256 value) public {
      bytes32 slot;
      assembly {
         slot := nestedMapping.slot
      }
      bytes32 valueIndex = keccak256(abi.encode(secondKey, keccak256(abi.encode(firstKey,slot))));

      assembly {
         sstore(valueIndex, value)
      }
   }

   //-------------------------------------------------------------------------------------------------------

      function readAddressToList(address key, uint256 indexInList) external view returns(uint256 ret) {
         bytes32 slot;
         assembly {
            slot := addressToList.slot
         }
         bytes32 listStartIndex = keccak256(abi.encode(keccak256(abi.encode(key, slot))));
         assembly {
            ret := sload(add(listStartIndex, indexInList))
         }

      }

      function writeAddressToList(address key, uint256 indexInList, uint256 value) external {
         bytes32 slot;
         assembly {
            slot := addressToList.slot
         }
         bytes32 listStartIndex = keccak256(abi.encode(keccak256(abi.encode(key, slot))));
         assembly {
            sstore(add(listStartIndex, indexInList),value)
         }

      }

   //-------------------------------------------------------------------------------------------------------


   //-------------------------------------------------------------------------------------------------------




}
