// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract OperatorsDemo {

    function demo(bool isMale, bool favoriteIsNumber, bool isHighNumber) public {
        // Ternary
        // guardExpression ? trueExpression : falseExpression
        uint8 avgHeight = isMale ? 180 : 167;

        // uint8 favoriteThing = favoriteIsNumber ? 42 : "red";
        // uint8 favoriteNumber = isHighNumber ? 256 : 1;

        // Operator assignment shorthand
        // a = a OP b -> a OP= b
        // OP can be
        // Arithmetic: +=, -=, *=, /=, %=
        // Bitwise: &=, |=, ^=
        // Shift: <<=, >>=
        // No shorthand for power OP (no **=)
        
        // Increment, decrement
        // a += 1 -> a++ or ++a
        // a -= 1 -> a-- or --a

        // Pre-increment
        uint a = 1;
        //a++; // a==2
        //++a; // a==3

        uint b = ++a;
        // 1. increment a: a==2
        // 2. assign a to b: b==2

        // Post-increment
        uint c = 1;
        uint d = c++;
        // 1. assign c to d: d==1
        // 2. increment c: c==2
    }

    mapping(uint => uint) mapping_var;
    uint[] array_var;
    struct Person {
        string name;
        uint favoriteNumber;
        mapping(string => uint8) ratings;
    }
    Person person_var;

    function delete_demo() public {
        // Delete
        // Technically just a reset to the 'default value'
        uint a = 1;
        delete a; // Equivalent to a = 0;
        
        // Mapping
        mapping_var[10] = 20;
        delete mapping_var[10]; // mapping_var[10] = 0;
        // delete mapping_var; // Invalid

        // Array
        array_var.push(1);
        array_var.push(2);
        array_var.push(3);

        delete array_var[1];
        console.log(array_var[0]); // Outputs 1
        console.log(array_var[1]); // Outputs 0
        console.log(array_var[2]); // Outputs 2
        console.log(array_var.length); // Outputs 3

        delete array_var; // array_var = new uint[](0)
        console.log(array_var.length);

        // Struct
        person_var.name = "Bob";
        person_var.favoriteNumber = 42;
        person_var.ratings["Lasagne"] = 5;

        console.log("Name:", person_var.name);
        console.log("Favorite number:", person_var.favoriteNumber);
        console.log("Lasagne rating:", person_var.ratings["Lasagne"]);
        console.log("---");

        delete person_var.favoriteNumber;
        console.log("Name:", person_var.name);
        console.log("Favorite number:", person_var.favoriteNumber);
        console.log("Lasagne rating:", person_var.ratings["Lasagne"]);
        console.log("---");

        delete person_var;
        console.log("Name:", person_var.name);
        console.log("Favorite number:", person_var.favoriteNumber);
        console.log("Lasagne rating:", person_var.ratings["Lasagne"]);
        console.log("---");
    }
}
