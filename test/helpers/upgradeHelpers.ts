import { ethers, upgrades } from "hardhat";

export const initialUpgradeableDeploy = async function () {
  const SafEth = await ethers.getContractFactory("SafEth");
  const safEth = await upgrades.deployProxy(SafEth, [
    "Asymmetry Finance ETH",
    "safETH",
  ]);
  await safEth.deployed();

  // deploy derivatives and add to strategy

  const derivativeFactory0 = await ethers.getContractFactory("Reth");
  const derivative0 = await upgrades.deployProxy(derivativeFactory0, [
    safEth.address,
  ]);
  await derivative0.deployed();
  await safEth.addDerivative(derivative0.address, "1000000000000000000");

  const derivativeFactory1 = await ethers.getContractFactory("SfrxEth");
  const derivative1 = await upgrades.deployProxy(derivativeFactory1, [
    safEth.address,
  ]);
  await derivative1.deployed();
  await safEth.addDerivative(derivative1.address, "1000000000000000000");

  const derivativeFactory2 = await ethers.getContractFactory("WstEth");
  const derivative2 = await upgrades.deployProxy(derivativeFactory2, [
    safEth.address,
  ]);
  await derivative2.deployed();
  await safEth.addDerivative(derivative2.address, "1000000000000000000");

  return safEth;
};

export const getLatestContract = async function (
  proxyAddress: string,
  latestContractName: string
) {
  const afStrategyLatest = await upgrades.forceImport(
    proxyAddress,
    await ethers.getContractFactory(latestContractName)
  );
  return afStrategyLatest;
};

export const upgrade = async function (
  proxyAddress: string,
  contractName: string
) {
  const NewContractFactory = await ethers.getContractFactory(contractName);
  const newContract = await upgrades.upgradeProxy(
    proxyAddress,
    NewContractFactory
  );
  return newContract;
};
