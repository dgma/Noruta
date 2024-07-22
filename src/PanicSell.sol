// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20Permit, ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract PanicSell is ERC20Permit {
    constructor() ERC20Permit("PANICSELL") ERC20("PANICSELL", "PANICSELL") {
        uint256 amount = 720 * 10 ** 9 * 10 ** 18;
        _mint(msg.sender, amount);
    }
}
