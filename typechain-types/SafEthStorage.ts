/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import {
  BaseContract,
  BigNumber,
  BigNumberish,
  BytesLike,
  CallOverrides,
  PopulatedTransaction,
  Signer,
  utils,
} from "ethers";
import { FunctionFragment, Result } from "@ethersproject/abi";
import { Listener, Provider } from "@ethersproject/providers";
import { TypedEventFilter, TypedEvent, TypedListener, OnEvent } from "./common";

export interface SafEthStorageInterface extends utils.Interface {
  functions: {
    "derivativeCount()": FunctionFragment;
    "derivatives(uint256)": FunctionFragment;
    "maxAmount()": FunctionFragment;
    "minAmount()": FunctionFragment;
    "pauseStaking()": FunctionFragment;
    "pauseUnstaking()": FunctionFragment;
    "totalWeight()": FunctionFragment;
    "weights(uint256)": FunctionFragment;
  };

  encodeFunctionData(
    functionFragment: "derivativeCount",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "derivatives",
    values: [BigNumberish]
  ): string;
  encodeFunctionData(functionFragment: "maxAmount", values?: undefined): string;
  encodeFunctionData(functionFragment: "minAmount", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "pauseStaking",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "pauseUnstaking",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "totalWeight",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "weights",
    values: [BigNumberish]
  ): string;

  decodeFunctionResult(
    functionFragment: "derivativeCount",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "derivatives",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "maxAmount", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "minAmount", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "pauseStaking",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "pauseUnstaking",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "totalWeight",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "weights", data: BytesLike): Result;

  events: {};
}

export interface SafEthStorage extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: SafEthStorageInterface;

  queryFilter<TEvent extends TypedEvent>(
    event: TypedEventFilter<TEvent>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TEvent>>;

  listeners<TEvent extends TypedEvent>(
    eventFilter?: TypedEventFilter<TEvent>
  ): Array<TypedListener<TEvent>>;
  listeners(eventName?: string): Array<Listener>;
  removeAllListeners<TEvent extends TypedEvent>(
    eventFilter: TypedEventFilter<TEvent>
  ): this;
  removeAllListeners(eventName?: string): this;
  off: OnEvent<this>;
  on: OnEvent<this>;
  once: OnEvent<this>;
  removeListener: OnEvent<this>;

  functions: {
    derivativeCount(overrides?: CallOverrides): Promise<[BigNumber]>;

    derivatives(
      arg0: BigNumberish,
      overrides?: CallOverrides
    ): Promise<[string]>;

    maxAmount(overrides?: CallOverrides): Promise<[BigNumber]>;

    minAmount(overrides?: CallOverrides): Promise<[BigNumber]>;

    pauseStaking(overrides?: CallOverrides): Promise<[boolean]>;

    pauseUnstaking(overrides?: CallOverrides): Promise<[boolean]>;

    totalWeight(overrides?: CallOverrides): Promise<[BigNumber]>;

    weights(
      arg0: BigNumberish,
      overrides?: CallOverrides
    ): Promise<[BigNumber]>;
  };

  derivativeCount(overrides?: CallOverrides): Promise<BigNumber>;

  derivatives(arg0: BigNumberish, overrides?: CallOverrides): Promise<string>;

  maxAmount(overrides?: CallOverrides): Promise<BigNumber>;

  minAmount(overrides?: CallOverrides): Promise<BigNumber>;

  pauseStaking(overrides?: CallOverrides): Promise<boolean>;

  pauseUnstaking(overrides?: CallOverrides): Promise<boolean>;

  totalWeight(overrides?: CallOverrides): Promise<BigNumber>;

  weights(arg0: BigNumberish, overrides?: CallOverrides): Promise<BigNumber>;

  callStatic: {
    derivativeCount(overrides?: CallOverrides): Promise<BigNumber>;

    derivatives(arg0: BigNumberish, overrides?: CallOverrides): Promise<string>;

    maxAmount(overrides?: CallOverrides): Promise<BigNumber>;

    minAmount(overrides?: CallOverrides): Promise<BigNumber>;

    pauseStaking(overrides?: CallOverrides): Promise<boolean>;

    pauseUnstaking(overrides?: CallOverrides): Promise<boolean>;

    totalWeight(overrides?: CallOverrides): Promise<BigNumber>;

    weights(arg0: BigNumberish, overrides?: CallOverrides): Promise<BigNumber>;
  };

  filters: {};

  estimateGas: {
    derivativeCount(overrides?: CallOverrides): Promise<BigNumber>;

    derivatives(
      arg0: BigNumberish,
      overrides?: CallOverrides
    ): Promise<BigNumber>;

    maxAmount(overrides?: CallOverrides): Promise<BigNumber>;

    minAmount(overrides?: CallOverrides): Promise<BigNumber>;

    pauseStaking(overrides?: CallOverrides): Promise<BigNumber>;

    pauseUnstaking(overrides?: CallOverrides): Promise<BigNumber>;

    totalWeight(overrides?: CallOverrides): Promise<BigNumber>;

    weights(arg0: BigNumberish, overrides?: CallOverrides): Promise<BigNumber>;
  };

  populateTransaction: {
    derivativeCount(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    derivatives(
      arg0: BigNumberish,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    maxAmount(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    minAmount(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    pauseStaking(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    pauseUnstaking(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    totalWeight(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    weights(
      arg0: BigNumberish,
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;
  };
}