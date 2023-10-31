// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract StorageLayout {
    /*
    - As mentioned, storage is built up of 32byte slots.
    - Variables with fixed sizes (e.g. value types, fixed sized arrays, structs that only contain these types) are allocated sequentially in the storage, starting with key 0.
    */
    
    uint256 a;
    uint256[2] b;

    struct Entry {
        uint256 id;
        uint256 value;
    }
    Entry c;
    /*
    In this code:
    a is stored at slot 0.
    b is stored at slots 1, and 2 (one for each element of the array).
    c starts at slot 3 and consumes two slots, because the Entry struct stores two 32-byte values.
    */

    // With inline assembly, we can get the value of a storage slot. We will cover inline assembly at a later lecture.
    function getStorageAt(uint idx) public view returns (uint r) {
        assembly {
            r := sload (idx)
        }   
    }
    
    function setFixedValues() public {
        a = 1;
        b = [5,6];
        c.id = 10;
        c.value = 11;
    }

    // ---

    /*
    - On the other hand, variables with dynamic size behave differently. Usually in a programming language, when you declare a static variable, it goes on the stack memory, and whenever you create a dynamic variable, a pointer or reference is push on the stack while the memory for the actual data is allocated on the heap memory. Those are two separate memory spaces usually filling up the physical memory from the opposite ends. Here, in Solidity, the concept is similar but the actual memory layout is different.
    - Instead of allocating space on the other end of the memory and storing a reference to it in the next storage slot, Solidity stores the data at a different location that is computed using a Keccak-256 hash.
    - We need to distinguish dynamic arrays and mappings.
    */

    // In case of dynamic arrays, the storage slot stores the length of the array, while the elements of the array are stored starting at the hash of the storage slot.
    uint256[] d;
    // For example here, d has a slotnumber of 5, so the elements of 5 will be stored starting from keccak256(5)
    
    // An example function for finding the location of an element of an array:
    function getArrayElemLocation(uint256 slot, uint256 index) public pure returns (uint256)
    {
        return uint256(keccak256(abi.encodePacked(slot))) + index;
    }

    function addToArray(uint256 elem) public {
        d.push(elem);
    }

    // Mappings do not have a length, so at the exact storage slot nothing is stored. Values are stored at the location determined by both the mapping key and the storage slot.
    mapping(uint256 => uint256) e;
    // Here, e has the 6th storage slot, so e[10] is stored at keccak256(10, 6).
    // Both the key and the slot number is used to compute the location to ensure that even if there are two mappings next to each other, their content ends up at different storage locations.
    function getMappingElemLocation(uint256 slot, uint256 key) public pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(key, slot)));
    }

    function addToMapping(uint256 key, uint256 value) public {
        e[key] = value;
    }
   
}
