// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// https://etherscan.io/address/0x8301AE4fc9c624d1D396cbDAa1ed877821D7C511#code
interface IAfEthPool {
    function add_liquidity(
        uint256[2] memory amounts,
        uint256 min_mint_amount,
        bool use_eth
    ) external payable returns (uint256);

    function remove_liquidity(
        uint256 _amount,
        uint256[2] memory _min_amounts
    ) external;
}
