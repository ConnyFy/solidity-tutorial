// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "hardhat/console.sol";


contract UnitsDemo {
    function demo() public {

        // Ether Units
        uint _wei = 1 wei; // == 1
        uint _gwei = 1 gwei; // == 1000000000 == 1e9
        uint _ether = 1 ether; // == 1000000000000000000 == 1e18

        console.log(_wei);
        console.log(_gwei);
        console.log(_ether);
        
        // Time Units
        uint _sec = 1 seconds; // == 1
        uint _min = 1 minutes; // == 60 seconds == 60
        uint _hour = 1 hours; // == 60 minutes == 3600
        uint _day = 1 days; // == 24 hours == 86400
        uint _week = 1 weeks; // == 7 days == 604800
        
        console.log(_sec);
        console.log(_min);
        console.log(_hour);
        console.log(_day);
        console.log(_week);

        console.log(1 weeks == 604800 wei); // prints true

        uint dayIndex = 5;
        // uint secondsUntilDeadline = dayIndex days;
        uint secondsUntilDeadline = dayIndex * 1 days;
    }

    function conversionDemo() public {
        uint ethToUsd = 1852813012412; // 1852.813012412, 9 decimal places
        uint entryFeeInUsd = 50; // 0 decimal places

        uint transferedEth = 27012425000000000; // 0.027012425000000000, 18 decimal places

        // How to calculate if the value of the transferred ether is enough?

        // 1) Wrong: one is in "ETH", the other is in "USD"
        if (transferedEth >= entryFeeInUsd) {
            // Do something
        }

        // 2) Better, unit of meassures are matching, but still wrong because decimal places do not match
        if (transferedEth * ethToUsd >= entryFeeInUsd) {
            // Do something
        }
        
        // 3) Right
        /*
        ethToUsd has 9 decimal places, so its in "gweis" (1852.813012412 * 1 gwei)
        entryFeeInUsd has 0 decimal places, it is in "weis"
        transferedEth has 18 decimal places, so its in "ethers" (0.027012425 * 1 ether)
        */
        uint transferedUsd = (transferedEth * ethToUsd) / 1 ether / 1 gwei;
        if (transferedUsd >= entryFeeInUsd) {
            // Do something
            console.log("Transfered:", transferedUsd);
            console.log("Entry fee :", entryFeeInUsd);
        }

        // 4) Even better
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
