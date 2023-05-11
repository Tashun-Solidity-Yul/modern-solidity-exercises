const {ethers} = require('hardhat');
const {expect} = require('chai');
describe("Gnosis", function () {
    it("should deploy the gnosis contract fine", async function () {
        const [deployer] = await ethers.getSigners();
        const characters = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"];
        let ContractFactory = await ethers.getContractFactory(
            "Week22Exercise2",
            deployer
        );
        let contractInstance = await ContractFactory.deploy();
        await expect(contractInstance.deployed()).to.be.ok;
        let condition = true;
        let permanentString = ""
        let temporaryString = "5t5y"
        let counter1 = 0; // loop through permanent string index
        let counter2 = 0; // loop through characters array

        while (condition) {
            try {
                temporaryString =getNextString(temporaryString, characters)
                const a = await deployer.signMessage(temporaryString);

                console.log(temporaryString)
                await contractInstance.challenge(temporaryString, a)
                condition = false;
                console.log(temporaryString)
                console.log(a)
            } catch (e) {

            }

        }
        console.log(getNextString("az", characters));
    });
});

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