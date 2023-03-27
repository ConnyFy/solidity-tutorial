// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";

/*
Every reference type has an additional annotation, the "data location", about where it is stored. There are three data locations: memory, storage and calldata.
- Storage is the "long-term" memory where contract-scoped or in other words state variables live. They are persistent between function calls, they are meant to store the state of the contract. You can think on it like the storage of your computer - it is where you store data that will be present even if you restart you computer. Writing to the storage, however, is very expensive, so one should only store the really necessary things in it. Moreover, the layout of the storage is fixed once the contract is created - we are gonna talk about these later.
- Memory is a more light-weight, it acts as the "short-term" memory of a contract. Memory variables live up to a function call, after they are erased. It is very similar to the RAM of a computer. Writing memory variables is way cheaper than storage variables.
- Calldata is a special data location that is very similar to memory. It is where arguments of a function call live. Comparing to memory the difference is that accessing calldata variables is even cheaper but they are read-only, meaning you cannot declare or assign to calldata variables.
*/

contract DataLocationDemo {

    uint[] xStorage;

    function demo(uint[] calldata xCalldata) public {
        uint[] memory xMemory;
    }
}
