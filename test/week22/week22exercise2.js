const {ethers} = require('hardhat');
const {expect} = require('chai');
const {loadFixture} = require("ethereum-waffle");
describe("Week22Exercise2", function () {
    const deployToken = async () => {
        const [deployer] = await ethers.getSigners();
        let ContractFactory = await ethers.getContractFactory(
            "Week22Exercise2",
            deployer
        );
        const contractInstance = await ContractFactory.deploy();
        return {deployer, contractInstance}
    }

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

        const resolvedData = await ethers.utils.resolveProperties(data);
        const serializedTransaction = ethers.utils.serializeTransaction(resolvedData);
        const hash = ethers.utils.keccak256(serializedTransaction);
        return {hash, serializedTransaction};
    }

    it("should not be reverted when calling challenge function", async function () {


        const {contractInstance} = await loadFixture(deployToken);

        await contractInstance.challenge("attack at dawn" , "0xe5d0b13209c030a26b72ddb84866ae7b32f806d64f28136cb5516ab6ca15d3c438d9e7c79efa063198fda1a5b48e878a954d79372ed71922003f847029bf2e751b");


    });
});

