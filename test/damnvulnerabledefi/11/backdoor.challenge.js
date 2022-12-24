const {ethers} = require('hardhat');
const {expect} = require('chai');

describe('[Challenge] Backdoor', function () {
    let deployer, users, alice, bob, charlie, david, attacker;

    const AMOUNT_TOKENS_DISTRIBUTED = ethers.utils.parseEther('40');

    before(async function () {
        /** SETUP SCENARIO - NO NEED TO CHANGE ANYTHING HERE */
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
        console.log("masterCopy", this.masterCopy.address);
        console.log("walletFactory", this.walletFactory.address);
        console.log("token", this.token.address);
        // Deploy the registry
        this.walletRegistry = await (await ethers.getContractFactory('WalletRegistry', deployer)).deploy(
            this.masterCopy.address,
            this.walletFactory.address,
            this.token.address,
            users
        );
        console.log("walletRegistry", this.walletRegistry.address);
        // https://www.youtube.com/watch?v=GHyxe32Z814
        // Users are registered as beneficiaries
        for (let i = 0; i < users.length; i++) {
            expect(
                await this.walletRegistry.beneficiaries(users[i])
            ).to.be.true;
        }

        // Transfer tokens to be distributed to the registry
        await this.token.transfer(this.walletRegistry.address, AMOUNT_TOKENS_DISTRIBUTED);

    });

    it.only('Exploit', async function () {
        /** CODE YOUR EXPLOIT HERE */
        const ABI = [
            "function setup(address[] calldata _owners, uint256 _threshold, address to, bytes calldata data, address fallbackHandler, address paymentToken, uint256 payment, address payable paymentReceiver) external"
        ];

        const selector = new ethers.utils.Interface(ABI)
        let functionFragment = "setup";
        functionFragment = selector.getFunction(functionFragment);

        // const attackContract = await  (await ethers.getContractFactory('AttackGenosisSafe', attacker)).deploy();
        // await attackContract.deployed();
        // console.log(await attackContract.attack())

        console.log(selector.getSighash(functionFragment));
        const tnx = await this.walletFactory.connect(alice).createProxyWithCallback(this.masterCopy.address, "0xb63e800d" , 0, this.walletRegistry.address);
        const data = await tnx.wait();
        console.log(data);
    });

    after(async function () {
        /** SUCCESS CONDITIONS */
        for (let i = 0; i < users.length; i++) {
            let wallet = await this.walletRegistry.wallets(users[i]);

            // User must have registered a wallet
            expect(wallet).to.not.eq(ethers.constants.AddressZero, "User did not register a wallet");

            // User is no longer registered as a beneficiary
            expect(
                await this.walletRegistry.beneficiaries(users[i])
            ).to.be.false;
        }

        // Attacker must have taken all tokens
        expect(
            await this.token.balanceOf(attacker.address)
        ).to.eq(AMOUNT_TOKENS_DISTRIBUTED);
    });
});