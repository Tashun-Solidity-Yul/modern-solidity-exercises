require("@nomiclabs/hardhat-waffle");
require("dotenv").config();
require('@openzeppelin/hardhat-upgrades');
require('hardhat-dependency-compiler');
// task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
//   const accounts = await hre.ethers.getSigners();
//
//   for (const account of accounts) {
//     console.log(account.address);
//   }
// });
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    defaultNetwork: "hardhat",
    networks: {
        hardhat: {allowUnlimitedContractSize: true},
        localhost: {
            url: "http://127.0.0.1:8545",
            gas: 2500000,
            gasPrice: 8000000000
        },
        // matic: {
        //   url: "https://rpc-mumbai.maticvigil.com",
        //   accounts: [process.env.PRIVATE_KEY],
        //   gas: 2100000
        // },
        // mumbai: {
        //   url: process.env.STAGING_ALCHEMY_KEY,
        //   accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
        //   gas: 2100000,
        //   gasPrice: 8000000000
        // },
        // rinkeby: {
        //   url: process.env.STAGING_ALCHEMY_KEY,
        //   accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
        //   gas: 2100000,
        //   gasPrice: 8000000000
        // },
        ropston: {
            url: process.env.ROPSTON_RPC,
            accounts: process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
            gas: 2100000,
            gasPrice: 8000000000
        },

    },
    etherscan: {
        apiKey: process.env.POLYGONSCAN_API_KEY
    },
    solidity: {
        compilers: [
            {
                version: "0.8.16"

            },
            {version: "0.7.6"},
            {version: "0.6.6"}
        ]
    },
    dependencyCompiler: {
        paths: [
            '@gnosis.pm/safe-contracts/contracts/GnosisSafe.sol',
            '@gnosis.pm/safe-contracts/contracts/proxies/GnosisSafeProxyFactory.sol',
        ],
    }
};
