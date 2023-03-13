// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract BytesStringDemo {
    function demo() public view {
        bytes memory bytes_var = hex"1234CAFE";
        string memory string_var = "apple";

        bytes memory bytes_var2 = "pear";
        //string memory string_var2 = hex"1234F00D"; // Contains invalid UTF-8 sequence at position 2.

        // Members
        uint256 bytes_length = bytes_var.length;
        bytes1 bytes_firt = bytes_var[0];
        // uint256 string_length = string_var.length;
        // bytes1 string_firt = string_var[0];

        bytes memory bytes_concat = bytes.concat(bytes_var, bytes_var2, hex"78797A77", "Literal", bytes(string_var));

        string memory string_var2 = "tree";
        string memory string_concat = string.concat(string_var, string_var2, string(bytes_var), hex"78797A77", "Literal");

        // bool string_eq = string_var == string_var2;
        bool string_eq = keccak256(bytes(string_var)) == keccak256(bytes(string_var2));
    }

    bytes1[] bytes_static_storage;

    function array_demo() public {
        bytes memory bytes_var = hex"1234CAFE";

        // Can be imagined as an array
        bytes1[] memory bytes_static_memory = new bytes1[](4);
        bytes_static_memory[0] = 0x12;
        bytes_static_memory[1] = 0x34;
        bytes_static_memory[2] = 0xCA;
        bytes_static_memory[3] = 0xFE;

        bytes_static_storage.push(0x12);
        bytes_static_storage.push(0x34);
        bytes_static_storage.push(0xCA);
        bytes_static_storage.push(0xFE);

        // bytes is thight packed even in memory
        // element of bytes cannot be modified
    }
}
