// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";

// TODO: Slice demo, maybe move 1_3_ArraySlice after this and merge it with bytes and string slice
contract BytesStringDemo {

    function demo() public {
        // bytes and string are very similar to dynamic arrays.
        // bytes can store any value.
        // string can only store valid UTF-8 characters.
        bytes memory bytesVariable = hex"1234CAFE";
        string memory stringVariable = "apple";

        bytes memory bytesVariable2 = "pear";
        // string memory stringVariable2 = hex"1234F00D"; // Contains invalid UTF-8 sequence at position 2.
        string memory stringVariable2 = hex"78797A77";

        // Members
        uint256 bytesLength = bytesVariable2.length;
        bytes1 bytesFirst = bytesVariable2[0]; // "p"
        bytesVariable2[2] = "e"; // NOTE: For static sized bytes (bytes1, bytes2, ..., bytes32) index operator was read-only!
        console.log(string(bytesVariable2)); // "peer"

        // uint256 stringLength = stringVariable.length; // No length on strings
        // bytes1 stringFirst = stringVariable[0]; // No index on strings
        // stringVariable[0] = "A"; // Not even assignment
        
        bytes memory bytesConcat = bytes.concat(bytesVariable, bytesVariable2, hex"78797A77", "Literal", bytes(stringVariable));
        string memory stringConcat = string.concat(stringVariable, stringVariable2, string(bytesVariable), hex"78797A77", "Literal"); // NOTE: Be careful with string(bytesVariable), it won't produce a compile-time error, but can lead to errors.

        // bool stringEqual = stringVariable == stringVariable2; // Technically, no operations exist on string apart from .concat()
        // You can compare two strings by comparing their hashes.
        bool stringEqual = keccak256(bytes(stringVariable)) == keccak256(bytes(stringVariable2));
    }
}
