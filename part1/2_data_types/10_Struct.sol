// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract StructDemo {
    enum EyeColor { BROWN, BLUE, GREEN, HAZAL, OTHER }
    struct Person {
        uint16 height;
        uint16 weight;
        address account;
        EyeColor eyeColor;
    }

    function struct_demo() public view {
        Person memory person;
        console.log(person.height);
        
        Person memory person2 = Person(190, 85, 0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF, EyeColor.BROWN);
        console.log(person2.height);
        person2.height = 195;
        console.log(person2.height);

        // No recursive struct
    }
}
