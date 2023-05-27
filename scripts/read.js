// const provider = new InfuraProvider();
//
// const tx = await provider.getTransaction(...)
// const expandedSig = {
//     r: tx.r,
//     s: tx.s,
//     v: tx.v
// }
// const signature = ethers.utils.joinSignature(expandedSig)
// const txData = {
//     gasPrice: tx.gasPrice,
//     gasLimit: tx.gasLimit,
//     value: tx.value,
//     nonce: tx.nonce,
//     data: tx.data,
//     chainId: tx.chainId,
//     to: tx.to // you might need to include this if it's a regular tx and not simply a contract deployment
// }
// const rsTx = await ethers.utils.resolveProperties(txData)
// const raw = ethers.utils.serializeTransaction(rsTx) // returns RLP encoded tx
// const msgHash = ethers.utils.keccak256(raw) // as specified by ECDSA
// const msgBytes = ethers.utils.arrayify(msgHash) // create binary hash
// const recoveredPubKey = ethers.utils.recoverPublicKey(msgBytes, signature)
// const recoveredAddress = ethers.utils.recoverAddress(msgBytes, signature)


const Web3 = require('web3');
const provider = 'https://mainnet.infura.io/v3/01d971f6819441aeb04f14cbfe8fe181';
const web3Provider = new Web3.providers.HttpProvider(provider);
const web3 = new Web3(web3Provider);
web3.eth.getBlockNumber().then((result) => {
    console.log("Latest Ethereum Block is ",result);
});



