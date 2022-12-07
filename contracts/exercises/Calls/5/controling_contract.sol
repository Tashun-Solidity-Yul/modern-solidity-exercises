
/**
    1. Yul contract access is maintained by another contract
    2. Yul contract structure is maintained by an interface


**/




interface IpureYulContractInterface {
    function doesntmatterthename() external view returns(uint256);
}

contract accessContract5 {

    IpureYulContractInterface yulContract;

    constructor(IpureYulContractInterface _deployedAddress) {
        yulContract = _deployedAddress;
    }     

    function callFuntion1() external view returns(uint256) {
        return yulContract.doesntmatterthename();
    }

    function callYulWrittenFunction() external view returns(string memory) {
        // assembly {
                (bool success, bytes memory data ) = address(yulContract).staticcall("");
                if (!success) {
                    revert("");
                }
                return string(data);
        // }
    }



}