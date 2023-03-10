// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract EnumDemo {
    enum Status { DRAFT, SENT, DELIVERED }

    function enum_demo() public pure {
        Status enum_var; // DRAFT
        Status enum_var2 = Status.SENT; // SENT
        Status enum_var3 = Status(2); // DELIVERED
        // Status enum_var4 = Status(-1);
        // Status enum_var5 = Status(3);
    }
}
