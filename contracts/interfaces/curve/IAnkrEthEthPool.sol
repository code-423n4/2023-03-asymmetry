// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// https://etherscan.io/address/0xA96A65c051bF88B4095Ee1f2451C2A9d43F53Ae2#code
interface IAnkrEthEthPool {
    function exchange(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 min_dy
    ) external payable returns (uint256);

    function get_virtual_price() external view returns (uint256);
}
