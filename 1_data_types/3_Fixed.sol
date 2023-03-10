// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract FixedDemo {
    function fixed_demo() public view {
        // Not implemented yet

        /*
            fixedMxN, ufixedMxN, where M is 8, 16, ..., 256; and N is 0, 1, ..., 80
            fixed = fixed128x18
            ufixed = ufixed128x18
        */

        // Comparison
        // <, <=, ==, !=, >=, >

        // Arithmetic
        // a+b, a-b, a*b, a/b, a%b, -a (no power operator!)
        // a/0, a%0 == error

        uint256 var1 = 25 *10**18; // NOTE: 18 decimal places, so 25.000000000000000000
        
        uint256 var2 = 4 *10**10; // NOTE: 10 decimal places, so 4.0000000000

        uint256 var3 = var1*var2; // NOTE: 28 decimal places.
        var3 = var3 / 10**10;

    }
}
