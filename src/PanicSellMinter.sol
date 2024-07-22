// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Minter} from "./Minter.sol";
import {PanicSell, ERC20} from "./PanicSell.sol";

contract PanicSellMinter is Minter {
    address private immutable _TOKEN = address(new PanicSell());

    function token() public view override returns (ERC20) {
        return ERC20(_TOKEN);
    }

    function mint(uint16 iterations) public payable gasBasedNativeMint {
        _burnGas(iterations);
    }

    /**
     * * * * * * * * *
     * Fallbacks     *
     * * * * * * * * *
     */

    fallback() external payable {
        mint(0);
    }

    receive() external payable {
        mint(0);
    }
}
