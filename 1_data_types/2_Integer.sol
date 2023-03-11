// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract ItegerDemo {
    function demo() public view {
        // Signed types
        // The number at the end can be 8, 16, 24, 32, ..., 256
        int8 int8_var; // 8 bits = 1 byte
        int16 int16_var; // 2 bytes
        /* ... */
        int256 int256_var; // 32 bytes

        // Unsigned types, same rule
        uint8 uint8_var; // 1 byte
        /*...*/
        uint256 uint256_var; // 32 bytes

        // without number in the type name, the default is translated into *256
        int int_var; // == int256 int_var;
        uint uint_var; // == uint256 uint_var;

        //Left-padded
        uint8 a = 1;
        uint16 b = 1;

        // uint8 c = b; // This is invalid as you cannot fit a bigger type into a smaller one
        uint16 d = a; // However this is valid and a will be left-padded by one byte.

        // Operators
        // Comparison
        uint8 x = 7;
        uint8 y = 42;

        bool comparison = x < y; // true
        // <, <=, ==, !=, >=, >

        uint16 yy = 42;
        bool comparison2 = y == yy; // true, y will be left-padded

        int16 xx = 42;
        // bool comparison3 = x == xx; // This is invalid as x is unsigned but xx is signed

        // Arithmetic
        // Usual arithmetic operators
        // x+y, x-y, x*y, x/y, x%y, -x, x**y
        // x/0, x%0 == error
        // Division (x/y) rounds towards zero
        // 0**0 == 1 by convention
        // x**y, y can only be unsigned

        // Bit operators
        /*
        x=42 ->    00101010
        y=6 ->     00000110
        -------------------
        x&y ->     00000010 (=2)
        x|y ->     00101110 (=46)
        x^y ->     00101100 (=44)
        ~x ->      11010101 (=213)
        */

        // Shift operators
        /*
        x=42 ->    00101010 (=42)
        x<<1 ->    01010100 (=84)
        x<<2 ->    10101000 (=168)
        x>>1 ->    00010101 (=21)
        x>>2 ->    00001010 (=10)
        */

        //TODO: quick demo how signed integers behave
    }
}
