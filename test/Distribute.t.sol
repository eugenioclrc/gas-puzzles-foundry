// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Distribute} from "../src/Distribute.sol";

contract DistributeTest is Test {
    Distribute public distributeContract;

    function setUp() public {
        distributeContract = new Distribute{value: 1 ether}(
            [makeAddr("user1"),
            makeAddr("user2"),
            makeAddr("user3"),
            makeAddr("user4")]
        );
    }

    function testGas() public {
        uint256 TARGET_GAS_PRICE = 57_044;
        vm.warp(8 days);

        uint256 gasStart = gasleft();
        distributeContract.distribute();
        uint256 totalGas = gasStart - gasleft();
        console.log("Total spend gas: ", totalGas);
        assertLt(totalGas, TARGET_GAS_PRICE, "Please save more gas");
    }

}
