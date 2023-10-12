// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract OperatorsDemo {

    function demo() public {
        // What happens if you have multiple reference to the same value?

        // Value types are copied, so deleting one variable does not affect others
        uint valueX = 1;
        uint valueY = valueX;
        delete valueX;
        console.log(valueX, valueY); // Outputs 0 1

        // Delete behaves like an assignment, it creates a new object.
        // It only resets the variable itself, not the value it referred to previously.
        uint8[2] memory refX = [1, 2];
        uint8[2] memory refY = refX;
        delete refX;
        console.log(refX[0], refY[0]); // Outputs 0 1

        // However, deleting a part of a reference type only resets that part, not the whole variable.
        // Other variables will still point to that space, i.e. delete affects all of them.
        refX = [1, 2];
        refY = refX;
        delete refX[0];
        console.log(refX[0], refY[0]); // Outputs 0 0
    }
}
