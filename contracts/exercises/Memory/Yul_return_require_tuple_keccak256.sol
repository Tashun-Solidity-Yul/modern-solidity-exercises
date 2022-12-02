contract Exercise_11 {

    // trying to return less or more bytes can cause client side issues, but not cause any issue when executing the Yul
    constructor(){}


    /** if value storing is larger than 32 bytes we can store it in two separate slots and return as a tuple
    return - (start pointer of value in memory, end point in value in memory)
    */
    function return2And4() external pure returns(uint256,uint256) {
        assembly {
            mstore(0x0,2)
            mstore(0x20,4)
            return(0x0,0x40)
        }
    }


    function requireV1() external view{
        require(msg.sender == 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2);
    }

    function requireV2() external view {
        assembly {
            if iszero(eq(caller(), 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2)) {
                revert(0,0)
            }
        }
    }


    function HashingV1() external pure returns(bytes32) {
        bytes memory toBehashed = abi.encode(1,2,3);
        // bytes memory toBehashed = abi.encode([1,2,3]);
        return keccak256(toBehashed);
    }
/**
        if the scrach space was used to store the values the free memory pointer would get overridden and can cause issues
**/
    function HashingV2() external pure returns(bytes32) {
        assembly {
            let freeMemPointer := mload(0x40)

            // store 1, 2, 3 in free memory by extending
            mstore(freeMemPointer,1)
            mstore(add(freeMemPointer, 0x20),2)
            mstore(add(freeMemPointer,0x40 ),3)

            // update the free memory pointer
            mstore(0x40, add(freeMemPointer,0x60))
            
            // keccak256 takes starting point on memory and how many bytes, that we are hashing
            // store the hash value n 0x0 slot
            mstore(0x0, keccak256(freeMemPointer, 0x60))

            return(0x0,0x20)
        }
    }

    function getString() external{
        assembly{
            mstore(0x00, 0x20) // you need to say where in *the return data* (btw. not relative to your own memory) the string starts (aka where it's length is stored - here it's 0x20)
            mstore(0x20, 0xe) // then the length of the string, let's say it's 14 bytes
            mstore(0x40, 0x737461636B6F766572666C6F7721000000000000000000000000000000000000) // the string to return in hex
            return(0, 0x60)
        }
}
}