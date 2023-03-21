// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../interfaces/IDerivative.sol";

/**
 @notice - Storage abstraction for SafEth contract
 @dev - Upgradeability Rules:
        DO NOT change existing variable names or types
        DO NOT change order of variables
        DO NOT remove any variables
        ONLY add new variables at the end
        Constant values CAN be modified on upgrade
*/
contract SafEthStorage {
    bool public pauseStaking; // true if staking is paused
    bool public pauseUnstaking; // true if unstaking is pause
    uint256 public derivativeCount; // amount of derivatives added to contract
    uint256 public totalWeight; // total weight of all derivatives (used to calculate percentage of derivative)
    uint256 public minAmount; // minimum amount to stake
    uint256 public maxAmount; // maximum amount to stake
    mapping(uint256 => IDerivative) public derivatives; // derivatives in the system
    mapping(uint256 => uint256) public weights; // weights for each derivative
}
