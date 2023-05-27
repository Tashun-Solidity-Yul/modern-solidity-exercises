
describe("Gnosis", function () {
    it("should deploy the gnosis contract fine", async function () {
        const [deployer] = await ethers.getSigners();
        let GnosisContractFactory = await ethers.getContractFactory(
            "GnosisSafe",
            deployer
        );
        let GnosisContract = await GnosisContractFactory.deploy();
        await expect(GnosisContract.deployed()).to.be.ok;
    });
});