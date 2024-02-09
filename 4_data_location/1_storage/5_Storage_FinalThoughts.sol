/*
- So, we have seen how storage and storage variables work. Here's some more useful mentions and tips.

- We have not covered yet what gas cost is, for now, imagine it like an answer to the question "how much money does this algorithm/method call/operation cost?".
- Reading from storage is very cheap. (Actually if you externally read contracts - meaning through a view function - it is free.)
- However writing is very expensive, it is one of the most expensive actions on the EVM.
- So you should really limit what and how you store in a contract's storage. Later we are going to cover some optimization techniques.

- Another thing is the layout of the storage. The storage of a smart contract is laid out during contract construction (at the time the contract is deployed).
- Once a contract is deployed, the storage layout is fixed and cannot be changed dynamically during contract execution. You cannot create new storage variables, or change the type of existing ones.
- It is quite inconvenient, because developers are limited from both sides: You cannot "overcreate" the storage as it can cost a lot, you also cannot "undercreate" it because you won't be able to declare more variables.
- So what's the deal? Careful planning. Sometimes blockchain development can feel like in the 60s where programmers had extremely limited storage space.

- The reason behind this design choice is that storage variables are part of the public interface of a contract.
- If you are here you probably know that smart contracts run in a decentralized environment.
- If we allowed smart contracts do dynamically create, delete or change type of storage variables, inconsistencies could happen.
- One node might already updated its "view" on a smart contract while another might not.
- In this case nodes might not have a consensus about incoming transactions.

TODO: How Ethereum avoids collision
*/