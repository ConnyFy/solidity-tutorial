// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract ItegerDemo {
    function integer_demo() public view {
        int8 int8_var; // 8 bits = 1 byte
        int16 int16_var; // 2 bytes
        /* ... */
        int256 int256_var; // 32 bytes

        uint8 uint8_var; // 1 byte
        /*...*/
        uint256 uint256_var; // 32 bytes

        int int_var; // == int256 int_var;
        uint uint_var; // == uint256 uint_var;

        //Left-padded
        uint8 a = 1;
        uint16 b = 1;

        //uint8 c = b;
        uint16 d = a;

        // Comparison
        uint8 x = 7;
        uint8 y = 42;
        
        bool comparison = x < y; // true
        // <, <=, ==, !=, >=, >
        
        uint16 yy = 42;
        bool comparison2 = y == yy; // true
        console.log(comparison2);

        // int16 xx = 42;
        // bool comparison3 = x == xx;

        // Arithmetic
        // x+y, x-y, x*y, x/y, x%y, -x, x**2
        // x/0, x%0 == error
        // Division rounds towards zero
        // 0**0 == 1

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
