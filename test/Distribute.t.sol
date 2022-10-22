// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Distribute} from "../src/Distribute.sol";

contract DistributeTest is Test {
    Distribute public instance;

    function setUp() public {
        instance = new Distribute{value: 1 ether}(
            [makeAddr("user1"),
            makeAddr("user2"),
            makeAddr("user3"),
            makeAddr("user4")]
        );
    }

    function testPayable() public {
        vm.expectRevert();
        address(instance).call{value: 1}(abi.encodeWithSignature("distribute()"));
    }

    function testGasTarget() public {
        uint256 TARGET_GAS_PRICE = 57_044;
        vm.warp(8 days);

        uint256 gasStart = gasleft();
        instance.distribute();
        uint256 totalGas = gasStart - gasleft();
        console.log("Total spend gas: ", totalGas);
        assertLt(totalGas, TARGET_GAS_PRICE, "Please save more gas");
    }

    function testBusinessLogic() public {
        vm.expectRevert("cannot distribute yet");
        instance.distribute();

        vm.warp(8 days);
        instance.distribute();

        assertEq(makeAddr("user1").balance, 0.25 ether);
        assertEq(makeAddr("user2").balance, 0.25 ether);
        assertEq(makeAddr("user3").balance, 0.25 ether);
        assertEq(makeAddr("user4").balance, 0.25 ether);
    }
}
