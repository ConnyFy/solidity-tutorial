// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract MainContract {
    // State variables can have visibility. Unlike local variables that are alive for a transaction, state variables are part of the contract's data that is visible on the ledger.

    uint withoutVisibility = 1;
    uint public publicVisibility = 2;
    uint internal internalVisibility = 3;
    uint private privateVisibility = 4;
    /*
        Default visibility is internal
        - Public is accessible from outside, meaning other contracts can read its value.
            - The current contract and derived contracts (more on that later) can read and write it
            - Other contracts can only read it by default.
            - This is done by a getter that is automatically generated for public state variables.
        - Internal is only accessible by the current contract and derived contracts (it is like protected in other languages).
        - Private is only accessible by the current contract.

        - IMPORTANT: Setting the visibility of a function or variable to private does not make it invisible on the blockchain. It simply restricts its accessability from contracts.
    */
    
}

contract OtherContract {
    function demo() public {
        MainContract mainContract = new MainContract();
        mainContract.publicVisibility;
        // mainContract.internalVisibility; // Member not found
        // mainContract.privateVisibility; // Member not found

        // mainContract.publicVisibility = 1; // Can read, but cannot assign
    }
}

contract DerivedContract is MainContract {
    function demo1() public {
        MainContract mainContract = new MainContract();
        mainContract.publicVisibility;
        // mainContract.internalVisibility; // Member not found, because this calls counts as external
        
        // mainContract.publicVisibility = 1; // Stil not working
    }

    function demo2() public {
        publicVisibility;
        internalVisibility;
        // privateVisibility;

        publicVisibility = 20;
        internalVisibility = 30;
        // privateVisibility = 40;

        // Fun fact (later it will be explained)
        // These will not work because the 'this' keyword makes them an external call
        // this.publicVisibility = 20; 
        // this.internalVisibility = 30;
    }
}

// To summarize,
// The current contract can read and write any of its variables regardless of their visibility.
// A derived contract can read and write its parent contract's public and external variables.
// Any other contract can read our contract's public variables.