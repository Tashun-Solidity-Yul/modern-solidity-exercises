const Web3 = require("web3");
const hre = require('hardhat');


async function main() {
    // Configuring the connection to an Ethereum node
    // const network = process.env.ETHEREUM_NETWORK;
    const web3 = new Web3(
        new Web3.providers.HttpProvider(
            `https://mainnet.infura.io/v3/01d971f6819441aeb04f14cbfe8fe181`
        )
    );
    // Creating a signing account from a private key
    const signer = web3.eth.accounts.privateKeyToAccount(
        // process.env.SIGNER_PRIVATE_KEY
        "0xa0dc65ffca799873cbea0ac274015b9526505daaaed385155425f7337704883e"
    );
    web3.eth.accounts.wallet.add(signer);

    // Estimatic the gas limit
    const limit = web3.eth.estimateGas({
        from: signer.address,
        to: "0xAED01C776d98303eE080D25A21f0a42D94a86D9c",
        value: web3.utils.toWei("0.001")
    }).then(console.log);

    // Creating the transaction object
    const tx = {
        from: signer.address,
        to: "0xAED01C776d98303eE080D25A21f0a42D94a86D9c",
        value: 0,
        gas: web3.utils.toHex(limit),
        nonce: web3.eth.getTransactionCount(signer.address),
        maxPriorityFeePerGas: web3.utils.toHex(web3.utils.toWei('2', 'gwei')),
        chainId: 1,
        type: 0x2
    };

    signedTx = await web3.eth.accounts.signTransaction(tx, signer.privateKey)

    console.log(await getTransactionDataHash(tx))
    console.log(signedTx)

    // Sending the transaction to the network
    // const receipt = await web3.eth
    //   .sendSignedTransaction(signedTx.rawTransaction)
    //   .once("transactionHash", (txhash) => {
    //     console.log(`Mining transaction ...`);
    //     console.log(`https://${network}.etherscan.io/tx/${txhash}`);
    //   });
    // // The transaction is now on chain!
    // console.log(`Mined in block ${receipt.blockNumber}`);

}

require("dotenv").config();
main();


async function getTransactionDataHash(tx) {
    const data = {
        type: 2,
        maxPriorityFeePerGas: tx.maxPriorityFeePerGas,
        maxFeePerGas: tx.maxFeePerGas,
        gasLimit: tx.gasLimit,
        to: tx.to,
        value: tx.value,
        nonce: tx.nonce,
        data: tx.data,
        chainId: tx.chainId,
    };
    const resolvedData = await hre.ethers.utils.resolveProperties(data);
    const serializedTransaction = hre.ethers.utils.serializeTransaction(resolvedData);
    return hre.ethers.utils.keccak256(serializedTransaction);
}