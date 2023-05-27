contract exec_1 {
    // 65 gas - for doing nothing just opcodes + (21,000)

    // calldata (tnx data) if zero 4 gas, non-zero 16 gas per byte (4 bytes -> 64 gas)

    // memory (for every 32 byte allocation) gas cost is 3 gas (charged till the last slot that is available) 
        // if we do push 20 push a0 mstore - in a0 slot 20 will be stored so charges will be applicable for 6 slots

    // writing to 0x40 (9 gas)

    // tricks 
    // 1. try to use more zeros
    // 2. use less opcodes in init
    // 3. use less opcodes in runtime
    // 4. less calldata use with more zero
    // 5. reuse memory
    

    // using unchecked when possible
    // access list and access storage
    function doingNothing() external {

    }
}