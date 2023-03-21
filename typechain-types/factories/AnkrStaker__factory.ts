/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import { Provider } from "@ethersproject/providers";
import type { AnkrStaker, AnkrStakerInterface } from "../AnkrStaker";

const _abi = [
  {
    inputs: [],
    name: "stakeAndClaimAethC",
    outputs: [],
    stateMutability: "payable",
    type: "function",
  },
];

export class AnkrStaker__factory {
  static readonly abi = _abi;
  static createInterface(): AnkrStakerInterface {
    return new utils.Interface(_abi) as AnkrStakerInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): AnkrStaker {
    return new Contract(address, _abi, signerOrProvider) as AnkrStaker;
  }
}