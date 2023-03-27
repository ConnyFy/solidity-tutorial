// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract DeclarationDemo {

    uint number_storage1;
    uint number_storage2 = 1;
    //(uint number_storage3, uint number_storage4) = (33, 44); // In storage you cannot initialize multuple variables in one line
    //number_storage2 = 2; // you cannot use assignment
    /*{
        uint number_storage3 = 1; // you cannot use block scopes
    }*/

    function demo() public view {
        // Declaration, Initialization
        // type name;
        // type name = initial_value;
        uint number1; // default value
        uint number2 = 123123;
        (uint number3, uint number4) = (33, 44);

        // Assignment
        //uint number2 = 456456; // Identifier already declared
        number2 = 456456;
        (number1, number2) = (1, 2);
        (number1, number2) = (number2, number1);
        console.log(number1, number2); // Outputs 2, 1
        //(uint number5, number1) = (55, 11); // Cannot mix declaration and assignment

        // Scoping
        uint outer_scoped = 10;
        {
            outer_scoped = 20;
            uint inner_scoped = 20;
        }
        outer_scoped = 30;
        //inner_scoped = 30; // Undeclared identifier

        {
            uint64 inner_scoped = 40;
        }

        {
            bool inner_scoped = true;
        }

        // Trick to save stack-depth
        uint final_result1;
        uint final_result2;
        {
            (uint something, uint complex, uint calculation) = (1,2,3);
            final_result1 = something+complex+calculation;
            final_result2 = something*complex*calculation;
        }
    }
}
