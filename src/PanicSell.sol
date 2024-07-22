// Uzumaki Naruto

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {ERC20Permit, ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract PanicSell is ERC20Permit {
    constructor() ERC20Permit("Noruta Uzamuki") ERC20("Noruta Uzamuki", "Noruta") {
        uint256 amount = 720 * 10 ** 9 * 10 ** 18;
        _mint(msg.sender, amount);
    }
}
