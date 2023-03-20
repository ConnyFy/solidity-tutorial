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
        The current contract and derived contract (more on that later) can read and write it,
        other contracts can only read it by default.
        This is done by a getter that is automatically generated for public state variables.
        - Internal is only accessible by the current contract and derived contracts.
        - Private is only accessible by the current contract.

    */

    function demo() public view {
        // uint public x;
    }
    
}

contract OtherContract {
    function demo() public {
        VisibilityDemo visibilityDemo = new VisibilityDemo();
        visibilityDemo.x_public;
        //visibilityDemo.x_internal;
        //visibilityDemo.x_private;

        //visibilityDemo.x_public = 1;

        visibilityDemo.x_public();
    }
}