// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
// const hre = require('hardhat')
// const { ethers, utils } = require('hardhat')

async function main() {
    const characters = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"];

    // console.log(getNextString("z", characters))
    console.log(getNextString("2zz", characters))
    // console.log(getNextString("zz", characters))
    // console.log(getNextString("zzz", characters))
    // console.log(getNextString("zzzz", characters))
    // console.log(getNextString("zz1", characters))
    // console.log(getNextString("zz1z", characters))
}


function getNextString(currentString, charactersArray) {

    let returnString = "";
    let tempString = "";

    tempString = currentString.substring(0, currentString.length - 1);

    const lastCharacter = currentString[currentString.length - 1];
    const index = charactersArray.indexOf(lastCharacter);


    if (index + 1 < charactersArray.length) {
        returnString += tempString + charactersArray[index + 1]

    } else {
        if (!(tempString.length > 0)) {
            returnString += getNextString(tempString, charactersArray) + charactersArray[0]
        } else {
            returnString += getNextString(tempString, charactersArray) + charactersArray[0]
        }

    }

    return returnString;
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
async function main() {
    const characters = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"];

    // console.log(getNextString("z", characters))
    console.log(getNextString("2zz", characters))
    // console.log(getNextString("zz", characters))
    // console.log(getNextString("zzz", characters))
    // console.log(getNextString("zzzz", characters))
    // console.log(getNextString("zz1", characters))
    // console.log(getNextString("zz1z", characters))
}

