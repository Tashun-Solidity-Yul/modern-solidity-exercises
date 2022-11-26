contract Exercise_9 {
    event Debug(bytes32,bytes32,bytes32,bytes32);
    constructor(){}

    function readDynamicArray(uint256[] memory arr) external {
        bytes32 location;
        bytes32 len;
        bytes32 valueAtIndex0;
        bytes32 valueAtIndex1;

        assembly {
            location := arr
            len := mload(location)
            valueAtIndex0 := mload(add(location,0x20))
            valueAtIndex1 := mload(add(location,0x40))

        }
        emit Debug(location,len,valueAtIndex0,valueAtIndex1);
    }

}