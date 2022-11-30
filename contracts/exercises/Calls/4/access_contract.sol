pragma solidity ^0.8.0;
import "./i_interface.sol";

contract accessContract {
    IInterface interfaceInstance;

    constructor(IInterface _interfaceInstance){
        interfaceInstance= _interfaceInstance;
    }

    function callGet2() external view returns(uint256) {
        return interfaceInstance.get2();
    }

    function callGet99(uint256 arg) external view returns(uint256) {
        return interfaceInstance.get99(arg);
    }

    function getFunctionSelector(string memory selector) external view returns(bytes4 val){
        val = bytes4(keccak256(abi.encodePacked(selector)));
    }
}
