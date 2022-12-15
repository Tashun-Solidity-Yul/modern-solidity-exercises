contract Exercise_12 {
    event SomeLog(uint256 indexed a, uint256 indexed b);
    event SomeLogV1(uint256 indexed a, bool c);
    event BytesLog(bytes32);

    constructor(){}

    function emitLog() external {
        emit SomeLog(5,6);
    }

    function yulEmitLog() external {
        //  bytes32 signature = bytes32(keccak256("SomeLog(uint256,uint256)"));
        //  bytes32 signature1;
        assembly {

            let signature := 0xc200138117cf199dd335a2c6079a6e1be01e6592b6a76d4b5fc31b169df819cc
            log3(0,0,signature,5,6)
        }
        // emit BytesLog(signature1);


    }

    function test() external {
        bytes32 _id = hex"420042";
        bytes32 t1 = bytes32(uint256(123));
        bytes32 t2 = bytes32(keccak256("SomeLog(uint256,uint256)"));
        bytes32 t3 = bytes32(uint256(uint160(msg.sender)));
        

        assembly {
            let freeMemPointer := mload(0x40)
            let p := add(freeMemPointer, 0x20)
            mstore(0x40,add(freeMemPointer,0x20))
            mstore(p, t1)
            log3(p, 0x20, t2, t3, _id)
        }
    }


    function logUnIndexEvent() external {
        emit SomeLogV1(5, false);
    }
/**
 index does not need to be in the memory and can use specific methods likg log 3 or log 2
 when unindex parameters are available, need to store the value in memory and provide the memory indexes in the log arguements
*/
     function yulLogUnIndexEvent() external {
        assembly {
            let freeMemPointer := mload(0x40)
            let signature := 0xdfd9f25f75a582ed6a2096b609f29606325db623577321d567baab206569c15a
            mstore(freeMemPointer,1)
            mstore(0x40, add(freeMemPointer, 0x20))
            log2(freeMemPointer,add(0x20, freeMemPointer),signature,5)
        }
    }


}