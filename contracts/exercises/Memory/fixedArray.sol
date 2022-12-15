contract Exercise_7 {

    struct Point {
        uint256 x;
        uint256 y;
    }

    event MemoryPointer(bytes32);
    event MemoryPointerMSize(bytes32, bytes32);
    
    constructor(){}

    function highAccess() external pure {
        assembly {
            pop(mload(0xffffffffffff))
    }}

    function readPointInMemory(uint128 slot) external view returns( bytes32 freeMemPointer, bytes32 mSize){
        // bytes32 data;

        assembly {
            freeMemPointer := mload(slot)
            mSize := msize()
        }

        // emit MemoryPointer(data);
    }

    function memPointer() external {
        bytes32 X40;

        assembly {
            X40 := mload(0x40)
        }
        // value is 0x80(free memory pointer value) First 0x80 is filled hence the msize (free memory pointer will be 0x80) 
        emit MemoryPointer(X40);
        Point memory p = Point(1,2);
        // free memory pointer is at 0x80 two 32 bytes will be added to the memory hence -> 0x80 + 0x40 = 0xc0
        assembly {
            X40 := mload(0x40)
        }
        emit MemoryPointer(X40);
    }


    function memPointerV2() external {
        bytes32 x40;
        bytes32 _mSize;

        assembly {
            // at start free memory pointer will be on 0x80
            x40 := mload(0x40)
            // at start this is 0x60 as solidity leaves a gap when writing new variables to memory this gap is there
            _mSize := msize()
        }

        emit MemoryPointerMSize(x40, _mSize);
        Point memory p = Point({ x: 1, y: 2});
          assembly {
              // earlier it was 0x80 + added 0x40 now 0xc0
            x40 := mload(0x40)
            // m size will be the same as free memory pointer as solidity has started to write to memroy the free gap is taken
            _mSize := msize()
        }
        emit MemoryPointerMSize(x40, _mSize);

        assembly {
            pop ( mload(0xff))
            // solidity does book keeping on this, as we are using assembly solidity does not know about the memory access todo
            // last memory loaded location is 0xc0, it remains the same
            x40 := mload(0x40)
            // as we have accessed further in the memory the msize has changed 
            _mSize := msize()
        }
        emit MemoryPointerMSize(x40, _mSize);
    }
    function loadFixedArray() external {
        bytes32 x40;
        bytes32 _mSize;

        assembly {
            x40 := mload(0x40)
            _mSize := msize()
        }

        emit MemoryPointerMSize(x40, _mSize);
        uint256[2] memory p = [uint256(1),uint256(2)];
          assembly {
            x40 := mload(0x40)
            _mSize := msize()
        }
        emit MemoryPointerMSize(x40, _mSize);

        assembly {
            pop ( mload(0xff))
            // solidity does book keeping on this, as we are using assembly solidity does not know about the memory access todo
            // last memory loaded location is 0xc0, it remains the same
            x40 := mload(0x40)
            // as we have accessed further in the memory the msize has changed 
            _mSize := msize()
        }
        emit MemoryPointerMSize(x40, _mSize);
    }

}