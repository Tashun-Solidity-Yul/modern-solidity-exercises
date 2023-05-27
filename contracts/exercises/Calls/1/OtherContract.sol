contract OtherContract {
    //0c55699c : x()
    uint256 public x;

    // 0x71e5ee5f arr(uint256)
    uint256[] public arr;


    // 9a884bde : get21()
    function get21() external pure returns(uint256) {
        return 21;
    }
    
   // 73712595 : revertWith999()
    function revertWith999() external pure returns(uint256) {
        assembly {
            mstore(0x0, 999)
            revert(0x0,0x20)
        }
    }

    // 0x4018d9aa : setX(uint256)
    function setX(uint256 _x) external {
        x = _x;
    }
    // 0x196e6d84 : multiply(uint128,uint16)
    function multiply(uint128 _x, uint16 _y) external pure returns(uint256) {
        assembly{
            mstore(0x0, mul(_x,_y))
            return(0x0,0x20)
        }
    } 
    
    // 0x87133d08 : variableLength(uint256)
    function variableLength(uint256 len) external pure returns(bytes memory) {
        bytes memory ret = new bytes(len);
        for (uint256 i = 0; i < ret.length; i++) {
            ret[i] = 0xab;
        }
        return ret;
    }



    function getFunctionSelector(string memory selector) external view returns(bytes4 val){
        val = bytes4(keccak256(abi.encodePacked(selector)));
    }

    function getFullFunctionSelector(string memory selector) external view returns(bytes32 val){
        val = keccak256(abi.encodePacked(selector));
    }

    // exercise for the reader
    // 0x5fa88e2a
    function multipleVariableLength(uint256[] calldata data1, uint256[] calldata data2) external view returns(bool){
        require(data1.length != data2.length, "invalid length");
        // this is often better done with a hash function, but we want to enforce
        // the array is proper for this test

        for(uint256 i = 0; i< data1.length; i++) {
            if (data1[i] == data2[i]) {
                return false;
            }
        }
        return true;

    }
    //0x60ebca55
    function multipleVariableLength2(uint256 max, uint256[] calldata data1, uint256[] calldata data2) external pure returns(bool){
        require(data1.length < max,  "data1 to long");
        require(data2.length < max,  "data2 to long");

          for (uint256 i=0; i< data1.length; i++) {
            if (data1[i] == data2[i]) {
                return false;
            }
        }
        return true;
    }

}