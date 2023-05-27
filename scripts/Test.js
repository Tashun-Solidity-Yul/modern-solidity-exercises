const {ethers} = require("hardhat");

async function main() {
    // let privateKey = "0x0123456789012345678901234567890123456789012345678901234567890123";
    // let wallet = new ethers.Wallet(privateKey);

// Connect a wallet to mainnet
//     const provider = new ethers.providers.Web3Provider('https://polygon-mainnet.g.alchemy.com/v2/SK-AglEa1XAc7r5God-PDwdnQ2ru3Xpo')

    // let walletWithProvider = new ethers.Wallet(privateKey, provider);
    // let data = {
    //     id: "fb1280c0-d646-4e40-9550-7026b1be504a",
    //     address: "88a5c2d9919e46f883eb62f7b8dd9d0cc45bc290",
    //     Crypto: {
    //         kdfparams: {
    //             dklen: 32,
    //             p: 1,
    //             salt: "bbfa53547e3e3bfcc9786a2cbef8504a5031d82734ecef02153e29daeed658fd",
    //             r: 8,
    //             n: 262144
    //         },
    //         kdf: "scrypt",
    //         ciphertext: "10adcc8bcaf49474c6710460e0dc974331f71ee4c7baa7314b4a23d25fd6c406",
    //         mac: "1cf53b5ae8d75f8c037b453e7c3c61b010225d916768a6b145adf5cf9cb3a703",
    //         cipher: "aes-128-ctr",
    //         cipherparams: {
    //             iv: "1dcdf13e49cea706994ed38804f6d171"
    //         }
    //     },
    //     "version" : 3
    // };
    //
    // let json = JSON.stringify(data);
    // let password = "foo";
    //
    // ethers.Wallet.fromEncryptedJson(json, password).then(function(wallet) {
    //     console.log("Address: " + wallet.address);
    //     // "Address: 0x88a5C2d9919e46F883EB62F7b8Dd9d0CC45bc290"
    // });
    //


//
//     let mnemonic = "radar blur cabbage chef fix engine embark joy scheme fiction master release";
//     let mnemonicWallet = ethers.Wallet.fromMnemonic(mnemonic);
//
// // Load the second account from a mnemonic
//     let path = "m/44'/60'/1'/0/0";
//     let secondMnemonicWallet = ethers.Wallet.fromMnemonic(mnemonic, path);
//
// // Load using a non-english locale wordlist (the path "null" will use the default)
//     let secondMnemonicWallet = ethers.Wallet.fromMnemonic(mnemonic, null, ethers.wordlists.ko);
//
//
//
    let wallet = ethers.Wallet.createRandom();


    // All properties are optional
    let transaction = {
        nonce: 0,
        gasLimit: 21000,
        gasPrice: ethers.BigNumber.from("20000000000"),

        to: "0x88a5C2d9919e46F883EB62F7b8Dd9d0CC45bc290",
        // ... or supports ENS names
        // to: "ricmoo.firefly.eth",

        value: ethers.utils.parseEther("1.0"),
        data: "0x",

        // This ensures the transaction cannot be replayed on different networks
        chainId: "137"
    }

    let signPromise = wallet.signTransaction(transaction)
    signPromise.then((signedTransaction) => {

        console.log(signedTransaction);
        // "0xf86c808504a817c8008252089488a5c2d9919e46f883eb62f7b8dd9d0cc45bc2
        //    90880de0b6b3a76400008025a05e766fa4bbb395108dc250ec66c2f88355d240
        //    acdc47ab5dfaad46bcf63f2a34a05b2cb6290fd8ff801d07f6767df63c1c3da7
        //    a7b83b53cd6cea3d3075ef9597d5"

        // This can now be sent to the Ethereum network
        let provider = ethers.getDefaultProvider()
        provider.sendTransaction(signedTransaction).then((tx) => {

            console.log(tx);
            // {
            //    // These will match the above values (excluded properties are zero)
            //    "nonce", "gasLimit", "gasPrice", "to", "value", "data", "chainId"
            //
            //    // These will now be present
            //    "from", "hash", "r", "s", "v"
            //  }
            // Hash:
        });
    })

}

main()

