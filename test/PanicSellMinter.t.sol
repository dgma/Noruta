// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

// solhint-disable no-global-import
// solhint-disable no-console

import "@std/Test.sol";
import "forge-std/console.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {PanicSellMinter} from "src/PanicSellMinter.sol";

contract PanicSellMinterTest is Test {
    PanicSellMinter private minter;

    address private Alice = makeAddr("alice");

    function setUp() public {
        minter = new PanicSellMinter();
    }

    function balanceOf(address account) internal view returns (uint256) {
        return IERC20(minter.token()).balanceOf(account);
    }

    function testTokenSupply() public {
        uint256 supply = IERC20(minter.token()).totalSupply();
        uint256 expectedSupply = 720 * 10 ** 9 * 10 ** 18;
        assertEq(supply, expectedSupply);
    }

    function testFuzz_mint(uint16 iterations) public {
        vm.startPrank(Alice);
        minter.mint(iterations);
        uint256 balance1 = balanceOf(Alice);
        minter.mint(iterations);
        uint256 balance2 = balanceOf(Alice);
        assertEq(balance2, balance1 * 2);
    }
}
