// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract StructDemo {
    // Structs can contain multiple different typed fields.
    
    enum EyeColor { BROWN, BLUE, GREEN, HAZAL, OTHER }
    struct Person {
        uint16 height;
        uint16 weight;
        address account;
        EyeColor eyeColor;
    }

    function demo() public {
        Person memory person;
        console.log(person.height); // Outputs 0
        
        Person memory person2 = Person(190, 85, 0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF, EyeColor.BROWN);
        console.log(person2.height); // Outputs 190
        person2.height = 195;
        console.log(person2.height); // Outputs 195

        // Recursive structs are not supported yet, so we cannot create linked lists the usual way.
    }
}
