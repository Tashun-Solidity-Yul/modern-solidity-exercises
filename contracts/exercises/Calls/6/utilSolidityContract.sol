contract valueTestUtil {

    event test(bytes32);
     function getFunctionSelector(string memory selector) external view returns(bytes4 val){
        val = bytes4(keccak256(abi.encodePacked(selector)));
    }
    function getHash(string memory selector) external view returns(bytes32 val){
        val = bytes32(keccak256(abi.encodePacked(selector)));
    }

}