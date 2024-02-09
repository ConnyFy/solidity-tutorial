// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract OperatorsDemo {
    uint uintVariable = 1;
    mapping(uint => uint) mappingVariable;
    uint[] arrayVariable;
    struct Person {
        string name;
        uint favoriteNumber;
        mapping(string => uint8) ratings;
    }
    Person personVariable;

    function demo() public {
        // Delete
        // Technically, it just resets the variable to the 'default value'

        // Value-type
        delete uintVariable; // Equivalent to uintVariable = 0;
        
        // Mapping
        mappingVariable[10] = 20;
        delete mappingVariable[10]; // Equivalent to mappingVariable[10] = 0;
        // delete mappingVariable; // Invalid, we cannot reset the whole mapping, because we cannot get a list of existing keys.

        // Array
        arrayVariable.push(1);
        arrayVariable.push(2);
        arrayVariable.push(3);
        // arrayVariable is equal to [1,2,3]

        delete arrayVariable[1]; // Equivalent to arrayVariable[1] = 0
        console.log(arrayVariable[0]); // Outputs 1
        console.log(arrayVariable[1]); // Outputs 0
        console.log(arrayVariable[2]); // Outputs 2
        console.log(arrayVariable.length); // Outputs 3

        delete arrayVariable; // Equivalent to arrayVariable = new uint[](0)
        console.log(arrayVariable.length); // Outputs 0

        // Struct
        personVariable.name = "Bob";
        personVariable.favoriteNumber = 42;
        personVariable.ratings["Lasagne"] = 5;

        console.log("Name:", personVariable.name); // "Bob"
        console.log("Favorite number:", personVariable.favoriteNumber); // 42
        console.log("Lasagne rating:", personVariable.ratings["Lasagne"]); // 5
        console.log("---");

        delete personVariable.favoriteNumber;
        console.log("Name:", personVariable.name); // "Bob"
        console.log("Favorite number:", personVariable.favoriteNumber); // 0
        console.log("Lasagne rating:", personVariable.ratings["Lasagne"]); // 5
        console.log("---");

        // delete personVariable.ratings; // Invalid, cannot delete mapping

        delete personVariable;
        console.log("Name:", personVariable.name); // ""
        console.log("Favorite number:", personVariable.favoriteNumber); // 0
        console.log("Lasagne rating:", personVariable.ratings["Lasagne"]); // 5
        console.log("---");

        // If you delete a struct, it will reset all members that are not mappings
    }
}
