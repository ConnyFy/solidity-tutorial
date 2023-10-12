// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract EnumDemo {
    enum Status {
        DRAFT,
        SENT,
        DELIVERED
    }

    function demo() public {
        Status enumDraft; // DRAFT
        Status enumSent = Status.SENT; // SENT
        Status enumDelivered = Status(2); // DELIVERED
        // Status enum_var4 = Status(-1); // invalid
        // Status enum_var5 = Status(3); // invalid

        // Enums cannot have more than 256 members as the underlying datatype is uint8
    }
}
