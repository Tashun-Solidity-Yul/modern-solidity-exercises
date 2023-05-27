pragma solidity ^0.8.0;

// 147606
contract EthTransferV1 {
    constructor() {}
    // 	25382 gas
    function withdraw(address acc) external {
        payable(acc).transfer(address(this).balance);
        // (bool success, ) = payable(owner).call{gas: 2300, value: address(this).balance} ("");

    }
}
// 	174378 gas
contract EthTransferV2 {
    // 25602 gas
    function withdraw(address acc) external {
    (bool success, ) = payable(acc).call{value: address(this).balance} ("");
    }
}

// 	130425 gas
contract EthTransferV3 {
    // 25307 gas
    function withdraw(address acc) external {
        assembly {
            let success := call(gas(), acc, selfbalance(), 0, 0, 0, 0)
            if iszero(success) {
                revert(0,0)
            }
        }
    }
}
