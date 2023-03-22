// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../SafEth/SafEth.sol";
import "./SafEthV2MockStorage.sol";

contract SafEthV2Mock is SafEth, SafEthV2MockStorage {
    function newFunction() public {
        newFunctionCalled = true;
    }

    /// Show we can upgrade to withdraw from any derivative in case of emergency
    function adminWithdrawDerivative(
        uint256 index,
        uint256 amount
    ) public onlyOwner {
        derivatives[index].withdraw(amount);
    }

    // Show we can upgrade to withdraw erc20 tokens that were accidentally sent to this contract
    function adminWithdrawErc20(
        address tokenAddress,
        uint256 amount
    ) public onlyOwner {
        IERC20(tokenAddress).transfer(msg.sender, amount);
    }
}
