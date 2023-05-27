pragma solidity ^0.8.0;

import "./i_interface.sol";

contract solidityContract is IInterface {
    function get2() external override view returns(uint256){
        return 2;
    }
    function get99(uint256 s) external override view returns(uint256) {
        return 99;
    }
}