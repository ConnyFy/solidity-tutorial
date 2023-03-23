// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract GettersDemo {
    uint public x_public;

    // Identifier already declared
    // function x_public() view external returns (uint) {
    //     return x_public;
    // }
    
}

contract OtherContract {
    function demo() public {
        GettersDemo gettersDemo = new GettersDemo();
        gettersDemo.x_public;
        gettersDemo.x_public(); // Automatically generated getter
        // gettersDemo.x_public = 1; // Can read, but cannot assign
        //gettersDemo.x_public(1); // Not even as function call
    }
}

contract DerivedContract is GettersDemo {
    function demo() public {
        x_public;
        // x_public();
        x_public = 1;

        this.x_public;
        this.x_public();
        // this.x_public = 2;
    }
}