// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require('hardhat')
const { ethers, utils } = require('hardhat')

async function main() {
  const baseFactory = await ethers.getContractFactory('Exercise_12')
  const contract = await baseFactory.deploy()
  await contract.deployed()

  const tnx = await contract.yulEmitLog()
  let receipt = await tnx.wait()
  console.log(
    receipt.events?.filter((x) => {
      return x.event == 'SomeLog'
    }),
  )
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
