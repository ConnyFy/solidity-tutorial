// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract DeclarationDemo {
    
    uint numberStorage1;
    uint numberStorage2 = 1;
    // (uint numberStorage3, uint numberStorage4) = (33, 44); // In storage you cannot initialize multiple variables in one line
    // numberStorage2 = 2; // you cannot use assignment

    function demo() public {
        // Declaration, Initialization
        // type (memory_location) name;
        // type (memory_location) name = initial_value;
        uint number1; // default value
        uint number2 = 123123;
        (uint16 number3, int8 number4) = (33, 44);
        uint[10] memory array1;

        // Assignment
        // uint number2 = 456456; // Invalid, Identifier already declared
        number2 = 456456;
        (number1, number2) = (1, 2);
        (number1, number2) = (number2, number1);
        console.log(number1, number2); // Outputs 2, 1
        // (uint number5, number1) = (55, 11); // Cannot mix declaration and assignment
    }
}
