// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract UserDefinedTypeDemo {
    type Price is uint256;

    function demo() public {
        Price price;
        
        // Price price10 = 10; // User-defined types do not inherit any operators, hence conversion is not possible.
        // Price price10 = Price(10); // Not even explicit conversion.
        Price price10 = Price.wrap(10);

        // price = price + 20; // It is also invalid
        uint256 unwrappedPrice = Price.unwrap(price);
        unwrappedPrice = unwrappedPrice + 20;
        Price increasedPrice = Price.wrap(unwrappedPrice);

        // payMoney(20); // Invalid, fails type-check
        payMoney(increasedPrice);
    }
    function payMoney(Price price) public {
        console.log("You paid", Price.unwrap(price));
    }
}
