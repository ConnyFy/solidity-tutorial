// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract FixedSizeBytesDemo {
    function demo() public {
        // Fixed-size byte types are bytes1, bytes2, bytes3, ..., bytes32
        // They can store exactly N bytes, indicated by their type.
        // IMPORTANT: `bytes` (without number suffix) does not follow the convention of integers. It is a totally different type, NOT a fixed-size byte type. We will talk about it later
        // There used to be a byte alias for bytes1, but it was removed in 0.8

        bytes4 bytesString = "ghij";
        bytes4 bytesHex = hex"6768696A"; //ghij

        // Comparison
        // <, <=, ==, !=, >=, >
        bool comparison = bytesString == bytesHex; // true

        // fixed-size byte types right-pad, contrary to integers.
        bytes2 bytesShort = "11"; // 00110001, 00110001
        bytes4 bytesLong = bytesShort; // 00110001, 00110001, 00000000, 0000000

        // Bit and Shift operators
        // &, |, ^, ~, <<, >>
        {
            bytes2 bytesShift = "11"; //00110001, 00110001
            console.log(string(abi.encode(bytesShift))); //11
            bytes2 bytesShifted = bytesShift << 1; //01100010, 01100010
            console.log(string(abi.encode(bytesShifted))); //bb
        }

        {
            bytes2 bytesShift = hex"F133"; //11110001 00110011
            console.log(string(abi.encode(bytesShift))); //?3
            bytes2 bytesShifted = bytesShift >> 2; //00111100 01001100
            console.log(string(abi.encode(bytesShifted))); //<L;
        }

        // Similar to an array
        uint8 bytesLength = bytesLong.length; //4;

        bytes1 bytesElement = bytesLong[0]; // 1;
        // The index can only be between 0 and length-1, negative indices are not supported
        // Moreover, the index operator is read-only, so we cannot set individual bytes
        // bytesLong[0] = "A"; // is invalid

        // NOTES (not necessary):
        // fixed-size byte arrays are copied by value but since you cannot modify the elements, it is similar to ref types.
    }
}
