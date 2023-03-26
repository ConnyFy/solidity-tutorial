// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract UnitsDemo {
    function demo() public {

        // Ether Units
        uint x_wei = 1 wei; // == 1
        uint x_gwei = 1 gwei; // == 1000000000 == 1e9
        uint x_ether = 1 ether; // == 1000000000000000000 == 1e18

        console.log(x_wei);
        console.log(x_gwei);
        console.log(x_ether);
        
        // Time Units
        uint x_sec = 1 seconds; // == 1
        uint x_min = 1 minutes; // == 60 seconds == 60
        uint x_hour = 1 hours; // == 60 minutes == 3600
        uint x_day = 1 days; // == 24 hours == 86400
        uint x_week = 1 weeks; // == 7 days == 604800
        
        console.log(x_sec);
        console.log(x_min);
        console.log(x_hour);
        console.log(x_day);
        console.log(x_week);

        console.log(1 weeks == 604800 wei); // prints true

        uint dayIndex = 5;
        // uint secondsUntilEOD = dayIndex days;
        uint secondsUntilEOD = dayIndex * 1 days;
    }

    function conversion_demo() public {
        uint ethToUsd = 1852813012412; // 1852.813012412, 9 decimal places
        uint entryFeeInUsd = 50; // 0 decimal places

        uint transferedEth = 27012425000000000; // 0.027012425000000000, 18 decimal places

        // Wrong: one is in "ETH", the other is in "USD"
        if (transferedEth >= entryFeeInUsd) {
            // Do something
        }

        // Better, still wrong: decimal places do not match
        if (transferedEth * ethToUsd >= entryFeeInUsd) {
            // Do something
        }
        
        // Right
        /*
        ethToUsd has 10 decimal places, so its in "gweis" (1852.813012412 * 1 gwei)
        entryFeeInUsd has 0 decimal places, it is in "weis"
        transferedEth has 18 decimal places, so its in "ethers" (0.027012425 * 1 ether)
        */
        uint transferedUsd = (transferedEth * ethToUsd) / 1 ether / 1 gwei;
        if (transferedUsd >= entryFeeInUsd) {
            // Do something
            console.log("Transfered:", transferedUsd);
            console.log("Entry fee :", entryFeeInUsd);
        }

        // Even better
        /*
        Since division rounds toward zero, you can lose information.
        Especially if you perform operations in the wrong order.
        E.g. (transferedEth / 1 ether) * (ethToUsd / 1 gwei) mathematically results in the same value
        However (transferedEth / 1 ether) equals to 0 (27012425000000000 / 1000000000000000000 == 0.027012425)
        
        It can be beneficial to increase the decimal points for conversion than reduce (Up to the limits of uint)
        */
        
        transferedUsd = (transferedEth * ethToUsd); // ether*gwei
        uint entryFeeInUsd_transformed = entryFeeInUsd * 1 ether * 1 gwei;
        if (transferedUsd >= entryFeeInUsd) {
            // Do something
            console.log("Transfered:", transferedUsd);
            console.log("Entry fee :", entryFeeInUsd_transformed);
        }
    }
}
