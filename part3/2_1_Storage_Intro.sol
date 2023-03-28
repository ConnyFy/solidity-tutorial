// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";

/*
- It is a quite unique mechanism, nothing you would see in any other programming languages.
- As mentioned, the purpose of Storage is to store long-term data, that needs no be persisted between calls to the contract, between transactions, throughout the whole life of the contract. That is why storage is also reffered as State.
- Each contract can maintain their own Storage and can access - meaning both reading and writing - only their own data by default. The only way contract A can read or write contract B storage is when contract B exposes functions that enable it to do so.
- Technically it is a huge array with full of zeros. It has a length of 2^256 and contains 32byte values.
- Of course that is not how it actually stored as that number is approximately the number of atoms in the observable universe. It is implemented by a slotnumber->value mapping that maps 32byte keys to 32byte values.
*/

contract StorageDemo1 {
    uint256 zero;
    uint8 ten = 10;
    bool[2] answers = [false, true];
    string pie = "apple pie";
    string cake = "chocolate cake";
    uint256[] numbers = [1, 2, 3];
    mapping(address => uint256) owe;

    function demo() public {
        zero = 1;
        ten += 10;
        answers = [true, false];
        numbers.push(4);
        owe[0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF] = 10;
    }

    function checkValues() public view {
        console.log("zero", zero);
        console.log("ten", ten);
        console.log("answers", answers[0]);
        console.log("numbers", numbers[3]);
        console.log("owe", owe[0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF]);

    }

    // Pointers
    /*
    - Value types are always copied. You can only modify them via their original name, you cannot have references to them.
    - Storage variables declared in the body of a function are just pointers to an actual storage variable.
    - You cannot assign new value to them, nor memory values. You can only assign real storage variables.
    */
    function pointerDemo() public {
        uint twenty = ten*2;

        string memory cupcake = "cupcake";

        // string storage dessert = "cupcake";

        // string storage dessert = cupcake;

        // string storage dessert;
        // console.log(dessert);

        string storage dessert = pie;
        console.log(dessert);

        //---
        
        uint[] storage newNumbers = numbers;
        newNumbers.push(4);
        console.log("numbers:", numbers[3]);
        console.log("newNumbers:", newNumbers[3]);

        // newNumbers = [9,8,7];
        numbers = [9,8,7];
        console.log("numbers:", numbers[0]);
        console.log("newNumbers:", newNumbers[0]);

        // delete newNumbers;
        delete numbers;
        console.log("numbers:", numbers.length);
        console.log("newNumbers:", newNumbers.length);
    }

    /*
    - Storage parameters are similar to storage pointers.
    - It means you need to pass a storage variable of that type as parameter.
    - Because of that, only internal or private functions can have storage parameters. (We will explain in the next lecture what internal and external calls are.)
    - The purpose of these parameters is if you explicitely want to perform an operation on a desired storage variable, but you want to decide at the time of the calling, which storage variable you want to perform on.
    */
    function parameterDemo(string storage favoriteDessert) internal {
        console.log("My favorite dessert is", favoriteDessert);
    }

    function callParameterDemo() public {
        parameterDemo(pie);
        parameterDemo(cake);
    }

    function addAnElement(uint[] storage array, uint newElement) internal {
        array.push(newElement);
        console.log("New length from addAnElement:", array.length);
    }
    function addNine() public {
        console.log("Length of original numbers:", numbers.length);
        addAnElement(numbers, 9);
        addAnElement(numbers, 9);
        addAnElement(numbers, 9);
        addAnElement(numbers, 9);
        addAnElement(numbers, 9);
        console.log("Length of original numbers:", numbers.length);
    }
}
