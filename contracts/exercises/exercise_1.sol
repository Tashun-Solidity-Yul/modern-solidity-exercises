// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Exercise_1  {
    constructor(){}

    function getUint() pure public returns(uint256) {
        uint256 val;

        assembly {
            val := 50
        }
    return val;
    }

    function getString() view public returns (string memory) {
        bytes32 val;

        assembly {
            val := " WElComE tO wOrLd"
        }

        return string(abi.encodePacked(val));
    }

    function isPrime(uint256 input) public pure returns(bool) {
        bool val = true;
        assembly {
            let halfBoundary := add(div(input,2),1)
            for {let y:=0} lt(y , halfBoundary) {y := add(y,1)} 
            {
                if iszero(mod(input,y)) {
                    val :=0
                    break
                }    
            }
        }
       
         return val;

    }

    function isPrimeAlternative(uint256 input) public pure returns(bool) {
        bool val = true;
        assembly {
            let halfBoundary := add(div(input,2),1)
            let y:=0
            for {} lt(y , halfBoundary) {} 
            {
                if iszero(mod(input,y)) {
                    val :=0
                    break
                }    
                y := add(y,1)
            }
        }
       
        return val;

    }
    
}