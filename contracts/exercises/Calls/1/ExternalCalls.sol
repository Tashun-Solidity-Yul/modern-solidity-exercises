contract ExternalCalls {
    event MemCheck(bytes32 indexed a);



/**
    to call an external function, need to load the function selector to 0x0 memory slot
    mstore(0x0,0x9a884bde)
    staticcall(
        1. Gas passed for the function to execute - receiving contract consume all gas can lead to denial of service
        2. Address of the external Contract
        3. Starting memory index of the zero memory slot which includes the function selector
        4. Ending memory index of the zero memory slot which includes the function selector
        5. Start memory index of the 
         )
*/
    function externalViewCallNoArgs(address _a) external view returns(uint256){
        // bytes32 signature = bytes32(keccak256("MemCheck(bytes32)"));
        assembly {
            let freeMemoryPointer := mload(0x40)
            mstore(freeMemoryPointer,0x9a884bde)
            mstore(0x0,0x9a884bde)
            mstore(freeMemoryPointer, add(freeMemoryPointer, 0x20))

            //  as we are inside of a view function we have to use staticcall (this does not change the state)
            // call() delegatecall() change the states 
            // let success := staticcall(gas(), _a, 28, 32, freeMemoryPointer, mload(0x40))
            let success := staticcall(gas(), _a, 28, 32, 0x00, 0x20) // overriding the 0 slot as it is not needed again
            if iszero(success) {
                revert(0,0)
            } 
            // log2(0,0,signature, mload(freeMemoryPointer))
            // return(freeMemoryPointer,mload(0x40))
            return(0x0,0x20)
        }
    }

    function getRevertingValue(address _a) external view returns(uint256){
        assembly {
             mstore(0x0,0x73712595)
            let success := staticcall(gas(),_a,28,32,0x0,0x20)
            if iszero(not(success)) {
                revert(0,0)
            }
            return (0x0,0x20)
        }
    }

    function externalPureFunctionWithArgs(address _a, uint256 a, uint256 b) external view returns(uint256) {

        assembly{
            let oldFreeMemPointerRef := mload(0x40)
            mstore(oldFreeMemPointerRef,0x196e6d84)
            mstore(add(oldFreeMemPointerRef,0x20),a)
            mstore(add(oldFreeMemPointerRef,0x40),b)
            mstore(0x40, add(oldFreeMemPointerRef,0x60))

            let success := staticcall(gas(), _a, add(oldFreeMemPointerRef,28), mload(0x40), 0x0, 0x20)
            if iszero(success) {
                revert(0,0)
            }
            return(0x0,0x20)
        }

    }

    function externalStateChangingCall(address _a, uint256 val) external {
        assembly {
            let oldMemReference := mload(0x40)
            mstore(oldMemReference, 0x4018d9aa)
            mstore(add(oldMemReference,0x20), val)
            mstore(0x40, add(oldMemReference, 0x60))

            // let success := call(gas(), _a, callValue(), oldMemReference, mload(0x40), 0x0, 0x20)
            let success := call(gas(), _a, 0, add(oldMemReference, 28), mload(0x40), 0x0, 0x20)
            if iszero(success) {
                revert(0,0)
            }
        }

    }

    function externalStateChangingPayableCall(address _a, uint256 val) external payable{
        assembly {
            let oldMemReference := mload(0x40)
            mstore(oldMemReference, 0x4018d9aa)
            mstore(add(oldMemReference,0x20), val)
            mstore(0x40, add(oldMemReference, 0x60))

            let success := call(gas(), _a, callvalue(), add(oldMemReference, 28), mload(0x40), 0x0, 0x20)
            // let success := call(gas(), _a, 0, add(oldMemReference, 28), mload(0x40), 0x0, 0x20)
            if iszero(success) {
                revert(0,0)
            }
        }

    }

    function unknownReturnSize(address _a, uint256 len) external view returns(bytes memory) {

        assembly {
            mstore(0x0, 0x87133d08)
            mstore(0x20, len)
            // let success := staticcall(gas(), _a, 28, add(28,32) ,0x0,0x0)
            let success := staticcall(gas(), _a, 28, add(28,32) ,0x0,0x0)

            if iszero(success) {
                revert(0,0)
            }
            // copy starting from the memory slot zero,  copy from 0 up until the total size of the return data
            // 1. memory pointer
            // 2. start index of the slice
            // 3. end index of the slice
            returndatacopy(0,0,returndatasize())
            return (0, returndatasize() )
        }


    }

    // todo - later
    function externalMultipleVariableLength1(address _a, uint256[] calldata data1, uint256[] calldata data2 ) external view returns(bool) {
        assembly {
            let freeMemoryPointer1 := mload(0x40)
            mstore(freeMemoryPointer1, 0x5fa88e2a)
            mstore(add(freeMemoryPointer1,0x20),add(freeMemoryPointer1,0x40))
            mstore(add(freeMemoryPointer1,0x40), 2)
            mstore(add(freeMemoryPointer1,0x60), 1)
            mstore(add(freeMemoryPointer1,0x80), 2)

            mstore(0x40,add(freeMemoryPointer1, 0xa0))

            let freeMemoryPointer2 := mload(0x40)
            mstore(add(freeMemoryPointer2,0x0),add(freeMemoryPointer2,0x40))
            mstore(add(freeMemoryPointer2,0x20), 3)
            mstore(add(freeMemoryPointer2,0x40), 5)
            mstore(add(freeMemoryPointer2,0x60), 6)
            mstore(add(freeMemoryPointer2,0x80), 6)

            mstore(0x40,add(freeMemoryPointer2, 0xa0))

            // let xy := calldatacopy(0, 0, data1.length)
            // mstore(0x40,add(add(freeMemoryPointer1,0x60),mul(data1.length,0x10)))

            // let freeMemoryPointer2 := mload(0x40)
            // mstore(add(freeMemoryPointer2,0x20),add(freeMemoryPointer2,0x40))
            // mstore(add(freeMemoryPointer2,0x40), data2.length)
            // calldatacopy(add(freeMemoryPointer2,0x60), 0, data2.length)
            // mstore(0x40,add(add(freeMemoryPointer2,0x60),mul(data2.length,0x10)))

            let success := staticcall(gas(), _a, add(freeMemoryPointer1,28), mload(0x40),0x0,0x20)
            // if iszero(success) {
                // revert(0,0)
            // }
            return(0x0,0x20)
            
        }

    }
}