// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import "hardhat/console.sol";


type Price is uint256;

// You can "attach" functions and operators to types with the `using for` directive.
// We will talk about it later when we cover libraries.
// Operator functions will take the value itself as first parameter and all the "real parameters" after it.
// These functions need to be declared at file level, or inside a library.
function addPrice(Price self, Price other) pure returns (Price) {
    return Price.wrap(Price.unwrap(self) + Price.unwrap(other));
}

using { addPrice } for Price;
// Since 0.8.19, you can define operators for user-defined types
using { addPrice as + } for Price global;

contract UserDefinedTypeDemo {

    function demo() public {
        Price price1 = Price.wrap(10);
        Price price2 = Price.wrap(20);

        Price sum = price1.addPrice(price2);
        Price sum2 = price1 + price2;

        console.log(Price.unwrap(sum));
        console.log(Price.unwrap(sum2));
    }
}
