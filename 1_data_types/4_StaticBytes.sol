// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract StaticBytesDemo {
    function static_bytes_demo() public view {
        bytes4 bytes_string = "xyzw";
        bytes4 bytes_hex = hex"78797A77"; //xyzw

        // Comparison
        // <, <=, ==, !=, >=, >
        console.log("1", bytes_string == bytes_hex); // true

        bytes2 bytes_short = "ab";
        bytes4 bytes_rightpad = "ab\x00\x00";
        bytes4 bytes_leftpad = "\x00\x00ab";
        
        console.log("right", bytes_short == bytes_rightpad); //true
        console.log("left", bytes_short == bytes_leftpad); //false

        // Bit operators
        // &, |, ^, ~

        // Shift operators
        // <<, >>
        {
            bytes2 bytes_shift = "11"; //00110001, 00110001
            console.log(string(abi.encode(bytes_shift))); //11
            bytes2 bytes_shifted_by1 = bytes_shift<<1; //01100010, 01100010
            console.log(string(abi.encode(bytes_shifted_by1))); //bb
        }

        {
            bytes2 bytes_shift = hex"F133"; //11110001 00110011
            console.log(string(abi.encode(bytes_shift))); //??
            bytes2 bytes_shifted_by1 = bytes_shift>>2; //00111100 01001100
            console.log(string(abi.encode(bytes_shifted_by1))); //<L;
        }

        // Similar to an array
        bytes1 bytes_element = bytes_rightpad[0]; //a;
        // bytes1 bytes_element_inv = bytes_string_rightpad[4];

        uint8 bytes_length = bytes_rightpad.length; //4;

        // bytes (without number suffix) is dynamically sized!
        // static sized byte arrays is copied by value and cannot be modified
        // bytes_short_copy[0] = "A";
    }
}
