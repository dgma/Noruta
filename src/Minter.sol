// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
import {Context} from "@openzeppelin/contracts/utils/Context.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

abstract contract Minter is Context {
    using SafeERC20 for ERC20;
    using Math for uint256;

    event Mint(address user, uint256 value, bool native);

    uint256 private constant _HALVING_GAS_USAGE = 650_000_000;
    uint256 private gasInEpochLeft = _HALVING_GAS_USAGE;
    uint256 private _epoch = 0;

    function epoch() public view returns (uint256) {
        return _epoch;
    }

    modifier gasBasedNativeMint() {
        uint256 initGas = gasleft();
        _;
        uint256 burnedGas = initGas - gasleft();
        emit Mint(_msgSender(), _mintNoruta(burnedGas), true);
    }

    modifier gasBasedERC20Mint() {
        uint256 initGas = gasleft();
        _;
        uint256 burnedGas = initGas - gasleft();
        emit Mint(_msgSender(), _mintNoruta(burnedGas), false);
    }

    function token() public view virtual returns (ERC20);

    function _tokensPerGas(uint256 gasSpend) internal view virtual returns (uint256) {
        return Math.mulDiv(gasSpend, token().decimals(), 2 ** _epoch);
    }

    function _mintNoruta(uint256 gasUsed) internal virtual returns (uint256) {
        if (gasUsed > gasInEpochLeft) {
            uint256 gasInCurrentEpochSpend = gasInEpochLeft;
            uint256 cheapTokens = _tokensPerGas(gasInCurrentEpochSpend);
            uint256 gasInNextEpochSpend = gasUsed - gasInCurrentEpochSpend;
            _epoch += 1;
            gasInEpochLeft = _HALVING_GAS_USAGE - gasInNextEpochSpend;
            uint256 totalTokensToMint = cheapTokens + _tokensPerGas(gasInCurrentEpochSpend);
            token().safeTransfer(_msgSender(), totalTokensToMint);
            return totalTokensToMint;
        }
        gasInEpochLeft -= gasUsed;
        uint256 tokensToMint = _tokensPerGas(gasUsed);
        token().safeTransfer(_msgSender(), tokensToMint);
        return tokensToMint;
    }

    function _burnGas(uint16 iterations) internal virtual {
        uint16 count = 0;
        while (iterations > count) {
            count++;
            keccak256(abi.encode(_msgSender(), count));
        }
    }
}
