// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// https://etherscan.io/address/0x9D0464996170c6B9e75eED71c68B99dDEDf279e8
interface ICvxCrvCrvPool {
    function get_dy(
        int128 i,
        int128 j,
        uint256 dx
    ) external view returns (uint256);

    function exchange(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 min_dy
    ) external payable returns (uint256);
}
