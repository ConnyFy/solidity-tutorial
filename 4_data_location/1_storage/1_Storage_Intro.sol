// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";

/*
Storage
- It is a quite unique mechanism, nothing you would see in any other programming language.
- As mentioned, the purpose of Storage is to store long-term data, that needs no be persisted between calls to the contract, between transactions, throughout the whole life of the contract. That is why storage is also reffered as State.
*/

contract StorageIntroduction {
    uint256 one;
    uint8 ten;
    bool[2] answers = [false, true];
    bytes secret = hex"CAFE";
    string keyword = "magic";
    uint256[] numbers = [1, 2, 3];
    mapping(address => uint256) owe;

    struct Person {
        uint256 age;
    }
    Person person = Person({age:60});

    function a_demo() public {
        one += 1;
        ten = 10;
        answers = [true, false];
        numbers.push(4);
        owe[0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF] = 10;
    }

    function a_checkValues() public {
        console.log("one:", one);
        console.log("ten:", ten);
        console.log("answers:", answers[0], answers[1]);
        console.log("numbers last element:", numbers[numbers.length-1]);
        console.log("owe:", owe[0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF]);
    }

    /*
    Pointers/References
    - Value types are always copied. You can only modify them via their original name, you cannot have pointers/references to them.
    - You can only have references to data types.
    - Storage variables declared in the body of a function are just pointers to an actual storage variable.
    - You cannot assign new value to them, nor memory/calldata values. You can only assign real storage variables.
    */
    
    string pie = "apple pie";
    string cake = "chocolate cake";

    function b_pointerDemo() public {
        // Working with value type storage variables is easy. Assigning them to a local variable always create a copy (on the Stack).
        uint twenty = ten;
        twenty *= 2; // twenty will be equal to 20, while ten will still be equal to 10.

        // string storage dessert = "cupcake"; // This is invalid, we cannot make a reference to a newly created value.

        string memory cupcake = "cupcake";
        // string storage dessert = cupcake; // This is also invalid, we cannot refer to a memory value.

        // string storage dessert; // This is also invalid as it would be a dangling reference.
        // console.log(dessert);

        string storage dessert = pie; // This will refer to storage variable 'pie'.
        console.log(dessert); // Prints "apple pie"
    }

    uint[] oldNumbers = [1, 2, 3];

    function c_pointerDemo2() public {
        uint[] storage newNumbers = oldNumbers;
        newNumbers.push(4); // Both newNumbers and oldNumbers will have '4' as their last element.
        console.log("oldNumbers[3]:", oldNumbers[3], "length:", oldNumbers.length);
        console.log("newNumbers[3]:", newNumbers[3], "length:", newNumbers.length);

        // newNumbers = [9,8,7]; // We cannot assign a newly created value to a storage reference.
        oldNumbers = [9,8,7]; // However, we can assign it to the original storage variable. Note that the change will be reflected by newNumbers.
        console.log("oldNumbers[0]:", oldNumbers[0], "length:", oldNumbers.length);
        console.log("newNumbers[0]:", newNumbers[0], "length:", newNumbers.length);

        // delete newNumbers; // We cannot call delete on a storage reference, as it would create a dangling reference.
        delete oldNumbers; // However, we can call delete on the original storage variable. Remember, delete is just simple "reset" the variable. In this case, sets is length to 0.
        console.log("oldNumbers length:", oldNumbers.length);
        console.log("newNumbers length:", newNumbers.length);
    }

    /*
    Parameters
    - Storage parameters are similar to storage pointers.
    - It means you need to pass a storage variable of that type as parameter.
    - Because of that, only internal or private functions can have storage parameters. (We will explain in the next lecture what internal and external calls are.)
    - The purpose of these parameters is if you explicitly want to perform an operation on an arbitrary storage variable, but you want to decide at the time of the calling, on which storage variable you want to perform it.
    */
    function d_printDessert(string storage favoriteDessert) internal {
        console.log("My favorite dessert is", favoriteDessert);
    }

    function d_favoriteDesserts() public {
        d_parameterDemo(pie);
        d_parameterDemo(cake);
    }

    // Just like in case of storage pointers, you can modify the original data through the parameter.
    function e_addElementToArray(uint[] storage array, uint newElement) internal {
        array.push(newElement);
        console.log("New length from addElement:", array.length, "new element:", newElement);
    }

    uint[] odd;
    uint[] even;
    function e_fillArrays() public {
        e_addElement(odd, 1);
        e_addElement(even, 2);
        e_addElement(odd, 3);
        e_addElement(even, 4);
        e_addElement(odd, 5);
        console.log("Length of odd numbers:", odd.length);
        console.log("Length of even numbers:", even.length);
    }
}
