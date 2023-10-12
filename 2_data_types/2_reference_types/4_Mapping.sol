// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract MappingDemo {

    // Mapping is an interesting type in Solidity. It does what its name suggest, maps a key to a value.
    // The type of the keys can only be elementary value types, user-defined types, enums, and contract types (no arrays, structs, other mappings).
    // The type of the values can be any type including other mappings

    mapping(uint8 => uint256) mappingVariable;

    function demo() public {

        // IMPORTANT: mappings can exist only in storage. You cannot declare them as memory variables nor part of a sruct declared in memory. We will see why.

        // Operations
        // Addition
        mappingVariable[10] = 123456789;
        mappingVariable[15] = 121212;

        // Getter
        uint256 value = mappingVariable[15]; // 121212

        // Deletion
        delete mappingVariable[10];
        delete mappingVariable[1]; // Keys do not need to exist

        // Check if a key exist
        // Unfortunatelly there is no way.
        // The best we can do is to check if the value of a key is other than 0 (or the default type).
        // Although this would not detect if a key was purposely set to 0.
        bool keyExist = mappingVariable[15] != 0;

        // So technically deletion could be written as
        mappingVariable[10] = 0;

        // Get a list of keys -> NOT POSSIBLE!
    }

    /*
    Mapping is quite unique and a bit complex. Do not worry if you do not understand it now:
    - Why we cannot declare mappings in memory
    - Why we cannot check if a key exists
    - Why we cannot get a list of keys

    All of these will be answered in an upcoming chapter, when we dig deeply into how storage and memory work.
    */

    // As mentioned, we can do nested mappings, for example to track how much eth a user gave to another one as allowance.
    mapping (address => mapping (address => uint256)) allowances;
}
