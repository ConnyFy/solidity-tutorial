// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract ArrayDemo {

    function demo(uint8[] calldata param) public {
        // As of now, array slices only supported for calldata arrays. This is planned to change in the future.
        uint8[] memory slice = param[0:3];
        console.log(param.length);
        console.log(slice.length);
    }
}
