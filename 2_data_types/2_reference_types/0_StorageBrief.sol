/*
Before we start with reference types, we need to quickly cover data storage in Solidity.
This will be just a very short introduction as we will cover it in more details in a later chapter.
There are 4 way we can declare a variable in terms of data storage.

Storage
- The purpose of Storage is to store long-term data, that needs no be persisted between calls to the contract, between transactions, throughout the whole life of the contract.
- Storage is also reffered as State.
- Variables defined outside of functions (i.e. at contract-level) are storage variables.

Memory
- Memory is meant to store short-term data, that only lives for a transaction.
- Memory is reset between calls.
- Memory is like heap for C-like languages.
- You can use memory for variables of reference-types declared inside a function.

Calldata
- Calldata is a special data location that is very similar to memory. It is where arguments of a function call live.
- Compared to memory, calldata variables are read-only, so you cannot accidentally overwrite them.

Stack
- The good old stack, known from every programming language.
- Value-type variables declared inside a function.
*/

/*
                | Contract-level    | Function declared | Function parameter
--------------------------------------------------------------------------------
Value types     | Storage           | Stack             | Stack
--------------------------------------------------------------------------------
Reference types | Storage           | Memory            | Memory / Calldata
--------------------------------------------------------------------------------
*/