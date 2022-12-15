
/**
    abi.encode result should always go to memory 
    (should be either storage, memory or calldata)

    abi.encode(uint256(5),uint256(6));

    1. length of the data follows 0x40 in this case (32 bytes per one value)
    2. Value one stored
    3. Value two stored

**/
contract Exercise_8 {
    event MemoryPointer(bytes32);
    event MemoryPointerMSize(bytes32, bytes32);

    constructor(){}


    function encodingFucntion() external {
        bytes32 x40;
        bytes32 _mSize;

        assembly {
            x40 := mload(0x40)
            _mSize := msize()
        }
     emit MemoryPointerMSize(x40, _mSize);

    // abi.encode(5);
    // bytes memory m = abi.encode(uint256(5),uint256(6));
    abi.encode(uint256(5),uint256(6));

         assembly {
            x40 := mload(0x40)
            _mSize := msize()
        }
     emit MemoryPointerMSize(x40, _mSize);
    //  emit MemoryPointer(bytes32(m));  - result is 5 


    }
/**
 Difference is that, there is a uint128 number for encoding, but the abi encode uses 
 32 bytes in memory even to store the inputs
**/
    function encodingV2 () external {
         bytes32 x40;
        bytes32 _mSize;

        assembly {
            x40 := mload(0x40)
            _mSize := msize()
        }
     emit MemoryPointerMSize(x40, _mSize);

    // abi.encode(5);
    // bytes memory m = abi.encode(uint256(5),uint256(6));
    abi.encode(uint256(5),uint128(6));

         assembly {
            x40 := mload(0x40)
            _mSize := msize()
        }
     emit MemoryPointerMSize(x40, _mSize);
    }


/**
 Difference is that, there is a uint128 number for encoding, memery storage use only
 16 bytes to store the second input of type uint256 
 1. uint256(5) - would take 32 bytes
 2. uint128(6) - would take 16 bytes other 16 bytes of the memory will be filled with 0s (but the memory size would be of 32 bytes factors)
**/
    function packedEncode() external {
          bytes32 x40;
        bytes32 _mSize;

        assembly {
            x40 := mload(0x40)
            _mSize := msize()
        }
     emit MemoryPointerMSize(x40, _mSize);

    // abi.encode(5);
    // bytes memory m = abi.encode(uint256(5),uint256(6));
    abi.encodePacked(uint256(5),uint128(6));

         assembly {
            x40 := mload(0x40)
            _mSize := msize()
        }
     emit MemoryPointerMSize(x40, _mSize);
    }

}