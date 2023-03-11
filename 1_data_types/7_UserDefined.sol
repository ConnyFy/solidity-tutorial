// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract UserDefinedDemo {
    // type Price is uint256;

    function demo() public view {
        Price price;
        
        // Price price_10 = 10; // User-defined types do not inherit any operators, hence conversion is not possible.
        // Price price_10 = Price(10); // Not even explicit conversion.
        Price price_10 = Price.wrap(10);

        // price = price + 20; // It is also invalid
        uint256 price_unwrapped = Price.unwrap(price);
        price_unwrapped = price_unwrapped + 20;
        Price increased_price = Price.wrap(price_unwrapped);

        // pay_function(10); // Invalid, fails type-check
        pay_function(increased_price);

        Price even_higher_price = increased_price.addPrice(price_10);
        // We could also call:
        // Price even_higher_price = addPrice(increased_price, price_10);
        console.log(Price.unwrap(even_higher_price)); // Outputs 30
    }
    function pay_function(Price p) public view {
        console.log("You paid", Price.unwrap(p));
    }
}
type Price is uint256;

// Operator functions will take the value itself as first parameter and all the "real parameters" after it.
function addPrice(Price self, Price other) pure returns (Price) {
    return Price.wrap(Price.unwrap(self) + Price.unwrap(other));
}
using { addPrice } for Price;