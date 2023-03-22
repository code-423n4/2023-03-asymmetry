// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// I couldnt find an official interface so I added the functions we need here
// https://etherscan.io/address/0x37ac345fa1428e3198b6a0d71deed41d83c140d3#code
interface AnkrStaker {
    function stakeAndClaimAethC() external payable;
}
