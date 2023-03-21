// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// https://etherscan.io/address/0xd658A338613198204DCa1143Ac3F01A722b5d94A#code
interface ICvxFxsFxsPool {
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

    function get_virtual_price() external view returns (uint256);

    function price_oracle() external view returns (uint256);

    function get_dy(
        uint256 i,
        uint256 j,
        uint256 dx
    ) external view returns (uint256);
}
