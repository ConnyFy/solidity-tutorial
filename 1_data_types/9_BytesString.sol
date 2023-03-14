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
        uint256 bytes_length = bytes_var2.length;
        bytes1 bytes_firt = bytes_var2[0]; // "p"
        bytes_var2[2] = "e"; // NOTE: For static sized bytes index was read-only!
        console.log(string(bytes_var2)); // "peer"

        // uint256 string_length = string_var.length; // No length on strings
        // bytes1 string_firt = string_var[0]; // No index on strings
        // string_var[0] = "A";
        
        bytes memory bytes_concat = bytes.concat(bytes_var, bytes_var2, hex"78797A77", "Literal", bytes(string_var));

        string memory string_var2 = "tree";
        string memory string_concat = string.concat(string_var, string_var2, string(bytes_var), hex"78797A77", "Literal");

        // bool string_eq = string_var == string_var2; // Technically there are no operations (apart from concat) exist
        bool string_eq = keccak256(bytes(string_var)) == keccak256(bytes(string_var2));
    }

    bytes bytes_storage;
    string string_storage;
    bytes1[] bytes_static_storage;

    function array_demo() public {
        // Can be imagined as an array

        // # Memory
        // In memory they are different
        // bytes and string are immutable and thight packed
        // While bytes1[] are mutable and sparse packet
        bytes memory bytes_memory = "pear";
        string memory string_memory = "pear";
        bytes1[] memory bytes_static_memory = new bytes1[](4);
        bytes_static_memory[0] = "p";
        bytes_static_memory[1] = "e";
        bytes_static_memory[2] = "a";
        bytes_static_memory[3] = "r";

        // We cannot push characters to them
        // bytes_memory.push("t");
        // string_memory.push("t");
        // bytes_static_memory.push("t"); // This was already mentioned in the arrays section

        // # Storage
        // However in storage they are very similar.
        // bytes and string are thight packed just like bytes1[]
        // We can push, pop and get the length of bytes and bytes1[]
        // However on strings we cannot use these, neither - as mentioned earlier - index and length
        bytes_storage.push("t");
        // string_storage.push("t");
        bytes_static_storage.push("t");
    }
}
