// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract UserDefinedDemo {
    //type Price is uint256;

    function user_defined_demo() public {
        Price price;
        
        // Price price_10 = 10;
        Price price_10 = Price.wrap(10);

        //price = price + 20;
        uint256 price_unwrapped = Price.unwrap(price);
        price_unwrapped = price_unwrapped+20;
        Price increased_price = Price.wrap(price_unwrapped);

        // pay_function(10);
        pay_function(increased_price);

        Price even_higher_price = increased_price.addPrice(price_10);
        console.log(Price.unwrap(even_higher_price));
    }
    function pay_function(Price p) public {
        console.log("You paid", Price.unwrap(p));
    }

    using { addPrice } for Price;
}
type Price is uint256;
function addPrice(Price self, Price other) pure returns (Price) {
    return Price.wrap(Price.unwrap(self) + Price.unwrap(other));
}