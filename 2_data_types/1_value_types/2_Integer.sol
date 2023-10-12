// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract IntegerDemo {
    function demo() public {
        // Signed types
        // The number at the end can be 8, 16, 24, 32, ..., 256
        int8 int8Variable; // 8 bits = 1 byte
        int16 int16Variable; // 2 bytes
        /* ... */
        int256 int256Variable; // 32 bytes

        // Unsigned types, same rule
        uint8 uint8Variable; // 1 byte
        /*...*/
        uint256 uint256Variable; // 32 bytes

        // Without number in the type name, the default is translated into int256 or uint256
        int intVariable; // equals to: int256 intVariable;
        uint uintVariable; // equals to: uint256 uintVariable;

        // Assignment is only possible: 1) between signed-to-signed or unsigned-to-unsigned AND 2) left-side is "bigger in capacity".
        // intVariable = uintVariable; // Invalid, unsigned-to-signed or signed-to-unsigned implicit convertion is not allowed.
        // int8Variable = int16Variable; // This is also invalid as you cannot fit a bigger type into a smaller one.
        int16Variable = int8Variable; // However this is valid and the right-side will be left-padded by one byte. Left-padding means, 0-bytes will be inserted to the left side.

        // Operators
        // Comparison
        uint8 x = 42;
        uint8 y = 6;

        bool comparison = x > y; // true
        // <, <=, ==, !=, >=, >

        uint16 z = 6;
        bool comparison2 = y == z; // true, `y` will be left-padded

        int16 w = 6;
        // bool comparison3 = y == w; // This is invalid as `y` is unsigned but `w` is signed

        // Arithmetic
        // Usual arithmetic operators
        x + y;
        x - y;
        x * y;
        x / y; // y != 0, rounds towards zero
        x % y; // y != 0
        -x; -y; // Only for signed
        x**z; // z can only be unsigned, 0**0 == 1 by convention

        // Bit operators
        /*
        x = 42 ->    00101010
        y = 6 ->     00000110
        -------------------
        x & y ->     00000010 (=2)
        x | y ->     00101110 (=46)
        x ^ y ->     00101100 (=44)
        ~x ->        11010101 (=213)
        */

        // Shift operators
        /*
        x = 42 ->    00101010 (=42)
        x << 1 ->    01010100 (=84)
        x << 2 ->    10101000 (=168)
        x >> 1 ->    00010101 (=21)
        x >> 2 ->    00001010 (=10)
        */

        // Number literals
        // You can use underscores to visually divide numbers into blocks
        z = 5_000_000;
        console.log(z);

        // You can also you hex expressions and scientific notation
        z = 0x4C4B40;
        console.log(z);
        z = 5e6;
        console.log(z);

        // IMPORTANT: Number literals are do not truncate until they are casted into non-literal types
        uint a = 6 / 4 * 2;
        console.log(a); // Prints 3

        // This is contrary to what I said before about division. Division between integer variables rounds toward zero. However, divison between number literals, not.
        uint b = 6;
        uint c = 4;
        uint d = 2;
        a = b / c * d;
        console.log(a); // Prints 2

        // Solidity compiler can optimize literals so it does not need to compute everything
        a = (2**1000 + 1) - 2**1000;
        console.log(a);

        a = 2**1000 / 2**999;
        console.log(a);
    }
}
