contract Exercise_10 {

    constructor(){}
/**
 Updates the memory value in the pointer 0x80 -0xa0  by the values of foo
**/
    function breakMemoryFreePointer(uint256[1] memory foo) external view returns(uint256 ret) {
        assembly {
            mstore(0x40, 0x80)
        }
        uint256[1] memory bar =[uint256(6)];
        ret =foo[0];
    } 

    uint8[] foo = [1,2,3,4,5,6];
    // all the uint8 would be unpacked to 0x20 bytes
    function unpacked() external {
        uint8[] memory bar = foo;

    }

}