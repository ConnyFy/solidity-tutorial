// SPDX-License-Identifier: MIT
pragma solidity >=0.8.20;


/*
Assignment between different locations - if it is possible - creates a copy: the two variables are independent.
Assignment in the same location usually creates a reference: the two variables are dependent.
Assignment to a storage variable always creates a copy, assignment to a storage reference always creates a reference.
*/
/*
            TO \ FROM   | Storage variable  | Storage reference | Memory reference  |     Calldata      |Calldata reference |
    --------------------+-------------------+-------------------+-------------------+-------------------+-------------------+
    Storage variable    |       copy        |       copy        |       copy        |       copy        |       copy        |
    --------------------+-------------------+-------------------+-------------------+-------------------+-------------------+
    Storage reference   |     reference     |     reference     |         X         |         X         |         X         |
    --------------------+-------------------+-------------------+-------------------+-------------------+-------------------+
    Memory reference    |       copy        |       copy        |     reference     |       copy        |       copy        |
    --------------------+-------------------+-------------------+-------------------+-------------------+-------------------+
    Calldata            |         X         |         X         |         X         |         X         |         X         |
    --------------------+-------------------+-------------------+-------------------+-------------------+-------------------+
    Calldata reference  |         X         |         X         |         X         |     reference     |     reference     |
    --------------------+-------------------+-------------------+-------------------+-------------------+-------------------+
*/
contract DataLocationAssignment {
    bytes storageVariable1 = "CAFE";
    bytes storageVariable2 = "CAFE";

    function method(bytes calldata _calldataVariable1) public {
        bytes storage storageReference1 = storageVariable2;
        bytes memory memoryReference1 = "CAFE";
        bytes calldata calldataReference1 = msg.data;
        
        // ----------

        storageVariable2 = storageVariable1; // copy
        storageVariable2 = storageReference1; // copy
        storageVariable2 = memoryReference1; // copy
        storageVariable2 = msg.data; // copy
        storageVariable2 = calldataReference1; // copy

        bytes storage storageReference2 = storageVariable1; // reference
        storageReference2 = storageReference1; // reference
        // storageReference2 = memoryReference1;
        // storageReference2 = msg.data;
        // storageReference2 = calldataReference1;

        bytes memory memoryReference2 = memoryReference1; // reference
        memoryReference2 = storageVariable1; // copy
        memoryReference2 = storageReference1; // copy
        memoryReference2 = msg.data; // copy
        memoryReference2 = calldataReference1; // copy

        bytes calldata calldataReference2 = msg.data; // reference
        calldataReference2 = calldataReference1; // reference
        // calldataReference2 = memoryReference1;
        // calldataReference2 = storageVariable1;
        // calldataReference2 = storageReference1;
    }
}