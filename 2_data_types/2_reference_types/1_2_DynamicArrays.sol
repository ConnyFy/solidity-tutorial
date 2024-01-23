// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract ArrayDemo {
    // There are two types of arrays: Static or fixed sized, and dynamic sized
    uint8[5] staticArray;
    uint8[] dynamicArray;

    function demo() public {
        // Dynamic sized arrays
        // They are a bit more complex.
        // uint8[] memory array = [0,1,2,3,4]; // Error, cannot initialize dynamic arrays with array literals
        uint8[] memory array = new uint8[](5);
        array[0] = 0;
        array[1] = 1;
        array[2] = 2;
        array[3] = 3;
        array[4] = 4;
        uint256 length = array.length; // 5

        // array[-1] = 5; // Cannot use Python-like negative indexing
        uint8 lastElement = array[length-1]; // 4

        // IMPORTANT:
        // array.push(5); // Not possible for dynamic arrays in memory. But why if they are _dynamic_?

        // Technically memory dynamic arrays are just dynamically allocated static sized arrays.
        // The difference is that you can create an array with arbitrary length not just that was defined by the type.
        // You can write the following:
        array = new uint8[](10);
        array = new uint8[](100);
        uint arraySize = 1;
        array = new uint8[](arraySize);

        // So, dynamic arrays in memory are dynamic in the meaning they can be assigned to an arbitrary length array.
        // But, once assigned, they cannot be expanded. (Of course, you could allocate a bigger array, and copy the elements).
        // Actually, this is how dynamic arrays work in other languages. For example in Java, you might call .add() on a List.
        // It seems that you can simply add elements to it, but under the hood it allocates a large-enough array initially and tracks the actual size.
        // If it runs out of free elements, it allocates a new, bigger array and copies the elements from the old one.

        // Real dynamic arrays live in storage. By real, I mean that you can simply keep adding elements to it without the need to ever re-allocate and copy elements.
        console.log(dynamicArray.length); // Outputs 0
        dynamicArray.push();
        console.log(dynamicArray.length); // Outputs 1
        dynamicArray.push(1);
        console.log(dynamicArray.length); // Outputs 2
        dynamicArray.pop();
        console.log(dynamicArray.length); // Outputs 1

        // The reason behind the difference between memory dynamic arrays and storage dynamic arrays lies in how memory and storage stores data.
        // As mentioned earlier, we will cover this topic in depth later on the course.

        // push() returns a reference
        dynamic_storage.push() = 10;
    }
    
    // These are optional:
    // Demo of multidimension arrays
}
