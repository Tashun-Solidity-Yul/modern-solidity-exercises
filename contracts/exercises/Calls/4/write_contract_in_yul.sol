
/**
    To Learn

    1. calldataload                                   -     always loads increments of 32 bytes
    2. imitating function with selector              -     need to shift the four bytes relating to the function selector to mathc the function selector
    3. switch statement                             -   switch variable and use case to specify cases
    4. yul functions with arguments                 - function name() -> r {} - r value would be returned to the yul code
    5, functions that return                        - return (0x0, 0x20), will not return back to yul code
    6. exit from a funtion without returning        - leave
    7. validating calldata                          

**/




contract yulContract {
    event Test(bytes32);

    fallback(bytes calldata data) external returns(bytes memory returnData) {
        bytes32 emitData;
        bytes32 callData1;
        bytes32 selector;
        assembly{
            callData1 := calldataload(0) // always loads 32 bytes from the index
            // d2178b0800000000000000000000000000000000000000000000000000000000 - function argument and 28 bytes

            // we won't know what would be with in the 32 bytes after the function selector, to ensure only it would be there, we are doing the shifting
            emitData := callData1
            
        }

        assembly {

            selector := shr(0xe0, callData1)  // shift right 224 bits or 28 bytes to get the last 4 bytes
            //  00000000000000000000000000000000000000000000000000000000d2178b08
        }

        assembly {
            // in swith statement, if a match is found it is not going to find other matching statements 
            switch selector
            case 0xd2178b08 {
                returnUint(2)
            }
             case 0xba88df04 {
                returnUint(getNotSoSecretValue())
            }
            default {
                revert(0,0)
            }


            function returnUint(v) {
                mstore(0x0, v)
                return(0x0, 0x20)
            }

            function getNotSoSecretValue() -> r {
                // check enough data 4 - function selector, 32 - first argument 
                if lt(calldatasize(), 36) {
                    revert(0,0)
                }
                let arg1 := calldataload(4) // if no data result will be zero
                if eq( arg1, 8) {
                    r := 88
                    // returns to the original yul call
                    leave 
                }
                r := 99
            }
        }



    }
}