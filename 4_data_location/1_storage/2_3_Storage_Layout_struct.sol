// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract StorageLayout {
    /*
    - Structs with dynamic parts shares the same characteristics.
    - Fields with fix size are inlined, they are stored after each other.
    - Fields with dynamic size are are stored like regular dynamic arrays and mappings.
    */
    struct Struct {
        uint number;
        bool boolean;
        uint[2] fixedArray;
        Person person;
        uint[] dynamicArray;
        mapping(uint => uint) coding;
    }
    struct Person {
        uint8 age;
    }

    Struct data;
    /*
    - number: slot 0
    - boolean: slot 1
    - fixedArray: slot 2 and 3
    - person: Starts from slot 4. Recursively does the same thing. Here, Person only has a single uint8 field,
        so it takes slot 4.
    - dynamicArray: slot 5, elements starts from hash(5)
    - coding: slot 6, elements starts from hash(key, 6)
    */

    function setValues() public {
        data.number = 10;
        data.boolean = true;
        data.fixedArray = [1,2];
        data.dynamicArray = [3,4,5];
        data.person = Person({age: 60});
        data.coding[10] = 20;
    }

    function getStorageAt(uint idx) public view returns (uint r) {
        assembly {
            r := sload (idx)
        }   
    }
    function getArrayElem(uint slot, uint index) public view returns (uint)
    {
        uint slot = uint(keccak256(abi.encodePacked(slot))) + index; // TODO: Rename
        return getStorageAt(slot);
    }
    function getMappingElem(uint slot, uint key) public view returns (uint) {
        uint slot = uint(keccak256(abi.encodePacked(key, slot)));
        return getStorageAt(slot);
    }
}
