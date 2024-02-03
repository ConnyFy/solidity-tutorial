/*
Pointers to a calldata multivalue types from the stack work just like pointers to memory:
They are absolute, given in bytes, and always point to the start of a word.
In calldata, though, the start of a word is congruent to 0x4 modulo 0x20, rather than being a multiple of 0x20.

Pointers to calldata lookup types from the stack take up two words on the stack rather than just one.
The bottom word is a pointer – absolute and given in bytes – but points not to the word containing the length,
but rather the start of the content, i.e., the word after the length (as described in the section on lookup types in memory),
since lookup types in calldata are similar). The top word contains the length.
Note, obviously, that if the length is zero then the value of the pointer is irrelevant (and the word it points to may contain unrelated data).
https://ethdebug.github.io/solidity-data-representation/#pointers-to-calldata-from-the-stack
*/

// This lesson is not necessary, probably it will be ignored.