// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface ICrvEthPool2 {
    function exchange(
        uint256 i,
        uint256 j,
        uint256 dx,
        uint256 min_dy
    ) external payable returns (uint256);

    function exchange_underlying(
        uint256 i,
        uint256 j,
        uint256 dx,
        uint256 min_dy
    ) external;
}
