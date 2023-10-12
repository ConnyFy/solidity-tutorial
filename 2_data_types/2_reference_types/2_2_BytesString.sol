// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract BytesStringDemo {

    function demo() public {
        // As mentioned, bytes and array can be imagined as an array, what is the difference?

        // 1) Initialization is more convenient
        bytes memory bytesVariable = "pear";
        string memory stringVariable = "pear";
        bytes1[] memory bytes1Variable = new bytes1[](4);
        bytes1Variable[0] = "p";
        bytes1Variable[1] = "e";
        bytes1Variable[2] = "a";
        bytes1Variable[3] = "r";

        // 2) In memory, bytes and string are more memory-efficient
        // 3) string type ensures it only contains UTF-8 characters.
    }
}
