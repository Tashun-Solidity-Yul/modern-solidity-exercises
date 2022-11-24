// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const {ethers, utils} = require("hardhat");

async function main() {
    [deployer, alice, bob, charlie, david, attacker] = await ethers.getSigners();
    users = [alice.address, bob.address, charlie.address, david.address]

    // Deploy Gnosis Safe master copy and factory contracts
    this.masterCopy = await (await ethers.getContractFactory('GnosisSafe', deployer)).deploy();
    // this.gnosisSafeProxy = await (await ethers.getContractFactory('GnosisSafeProxy', deployer)).deploy();
    this.walletFactory = await (await ethers.getContractFactory('GnosisSafeProxyFactory', deployer)).deploy();
    this.token = await (await ethers.getContractFactory('DamnValuableToken', deployer)).deploy();


    await this.masterCopy.deployed();
    // await this.gnosisSafeProxy.deployed();
    await this.walletFactory.deployed();
    await this.token.deployed();

    // Deploy the registry
    this.walletRegistry = await (await ethers.getContractFactory('WalletRegistry', deployer)).deploy(
        this.masterCopy.address,
        this.walletFactory.address,
        this.token.address,
        users
    );
    // https://www.youtube.com/watch?v=GHyxe32Z814
    // Users are registered as beneficiaries
    for (let i = 0; i < users.length; i++) {
        expect(
            await this.walletRegistry.beneficiaries(users[i])
        ).to.be.true;
    }

    // Transfer tokens to be distributed to the registry
    await this.token.transfer(this.walletRegistry.address, AMOUNT_TOKENS_DISTRIBUTED);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
