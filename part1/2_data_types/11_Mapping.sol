// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract MappingDemo {

    mapping(uint8 => uint256) mapping_var;

    function demo() public {
        // KeyType can only be elementary value types, user-defined value types, enums, and contract types
        // ValueType can be any type including other mappings

        // Interesting type, not something one would see in other languages.

        // Operations
        // Addition
        mapping_var[10] = 123456789;
        mapping_var[15] = 121212;

        // Getter
        uint256 value = mapping_var[15]; // 121212

        // Deletion
        delete mapping_var[10];
        delete mapping_var[1]; // Keys do not need to exist

        // Check if a key exist
        // Unfortunatelly there is no way.
        // The best we can do if the value of the key is different than 0.
        // Although this would not detect if a key was purposely set to 0.
        bool keyExist = mapping_var[15] != 0;

        // So technically deletion could be written as
        mapping_var[10] = 0;

        // Get a list of keys -> NOT POSSIBLE!

        // It can only be declared as a storage variable.
        // mapping(uint8 => uint8) memory mapping_memory; // invalid
        // It is true for structs that contain mappings
    }

    // Nested mappings
    mapping (address => mapping (address => uint256)) private _allowances;

    // It can only be part of a function header if the function is private/internal
    function fc_with_mapping(mapping(uint8 => uint256) storage mapping_param) internal pure {

    }
}
