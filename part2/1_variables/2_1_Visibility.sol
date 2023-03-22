// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract VisibilityDemo {
    uint x_nothing;
    uint public x_public;
    uint internal x_internal;
    uint private x_private;
    /*
        Default visibility is internal
        - Public is accessible from outside, meaning other contracts can read its value.
        The current contract and derived contracts (more on that later) can read and write it,
        other contracts can only read it by default.
        This is done by a getter that is automatically generated for public state variables.
        - Internal is only accessible by the current contract and derived contracts.
        - Private is only accessible by the current contract.

    */
    
}

contract OtherContract {
    function demo() public {
        VisibilityDemo visibilityDemo = new VisibilityDemo();
        visibilityDemo.x_public;
        // visibilityDemo.x_internal; // Member not found
        // visibilityDemo.x_private; // Member not found

        // visibilityDemo.x_public = 1; // Can read, but cannot assign
    }
}

contract DerivedContract is VisibilityDemo {
    function demo() public {
        VisibilityDemo visibilityDemo = new VisibilityDemo();
        visibilityDemo.x_public;
        // visibilityDemo.x_internal; // Member not found, because this calls counts as external
        
        x_public = 1;
        x_internal = 2;
        // x_private = 3;

        // Fun fact (later it will be explained)
        // this.x_internal = 2; // This is also not working as the 'this' keywords makes it an external call
    }
}