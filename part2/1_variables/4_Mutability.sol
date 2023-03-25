// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract MutabilityDemo {

    /*
        Constants (constant variables) has to be assigned where the variable is declared.
        The value has to be fixed at compile-time.
        The expression assigned to it is copied to all the places where it is accessed.

        Immutables (immutable variables) can be assigned an arbitrary value in the constructor
        of the contract or at the point of their declaration. They can be assigned only once.
        Immutable variables are evaluated once at construction time and their value is copied
        to all the places in the code where they are accessed.
        The contract creation code generated by the compiler will modify the contract’s runtime code
        before it is returned by replacing all references to immutables with the values assigned to them.

        The compiler does not reserve a storage slot for these variables, and every occurrence
        is replaced by the respective value.
        Compared to regular state variables, the gas costs of constant and immutable variables
        are much lower.

    */

    // Variables
    uint x_variable;
    uint x_variable2 = 123;

    // Constant
    uint constant CONSTANT = 42;
    // uint constant CONSTANT2 = address(this).balance; // Initial value for constant variable has to be compile-time constant

    // Immutable
    uint immutable i_immutable;
    uint immutable i_immutable2 = 7331;
    uint immutable i_immutable3 = address(this).balance;

    // Reference types
    string constant C_STRING = "apple";
    bytes constant C_BYTES = hex"1234CAFE";
    // string immutable i_string = "pear";
    // bytes immutable i_bytes = hex"C0FFEE";


    constructor() {
        i_immutable = 1337;
        // x_immutable = 1338; // Cannot reassign
    }
}
