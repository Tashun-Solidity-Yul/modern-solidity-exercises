const {ethers} = require('hardhat');
const {expect} = require('chai');
const {loadFixture} = require("ethereum-waffle");

describe("Week22Exercise4", function () {

    const deployToken = async () => {
        const [deployer] = await ethers.getSigners();
        let ContractFactory = await ethers.getContractFactory(
            "Week22Exercise4",
            deployer
        );
        const contractInstance = await ContractFactory.deploy();
        return {deployer, contractInstance}
    }

    it("should be abe to claim the air drop", async function () {
        const provider = new ethers.providers.JsonRpcProvider(
            process.env.POLYGON_RPC_PROVIDER
        );
        const txHash =
            "0x09281ab72c20092dc9b414745ef2673116e36dfe069b61d2e37ecb8815b140bf";
        const tx = await provider.getTransaction(txHash);

        const {contractInstance} = await loadFixture(deployToken);
        await expect(contractInstance.deployed()).to.be.ok;
        expect(await contractInstance.hacked()).to.be.false;

        console.log(await getTransactionDataHash(tx))

        const signatureObject = {
            v: tx.v,
            r: tx.r,
            s: tx.s,
        };
        const signature = ethers.utils.joinSignature(signatureObject);

        await contractInstance.claimAirdrop(100, getTransactionDataHash(tx), signature)

    });

    after(async () => {
        const {contractInstance} = await loadFixture(deployToken);
        expect(await contractInstance.hacked()).to.be.true;

    })

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
        return ethers.utils.keccak256(serializedTransaction);
    }
});

