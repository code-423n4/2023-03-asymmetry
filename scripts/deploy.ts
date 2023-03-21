import hre, { upgrades, ethers } from "hardhat";

async function main() {
  const SafEthDeployment = await ethers.getContractFactory("SafEth");
  const safEth = await upgrades.deployProxy(SafEthDeployment, [
    "Asymmetry Finance ETH",
    "safETH",
  ]);

  await safEth.deployed();

  console.log("AF Strategy deployed to:", safEth.address);

  await hre.ethernal.push({
    name: "SafEth",
    address: safEth.address,
  });

  // Deploy derivatives
  const rethDeployment = await ethers.getContractFactory("Reth");
  const reth = await upgrades.deployProxy(rethDeployment, [safEth.address]);
  await reth.deployed();
  await safEth.addDerivative(reth.address, "1000000000000000000");
  console.log("RETH deployed to:", reth.address);

  await hre.ethernal.push({
    name: "Reth",
    address: reth.address,
  });

  const SfrxDeployment = await ethers.getContractFactory("SfrxEth");
  const sfrx = await upgrades.deployProxy(SfrxDeployment, [safEth.address]);
  await sfrx.deployed();

  await safEth.addDerivative(sfrx.address, "1000000000000000000");
  console.log("sfrx deployed to:", sfrx.address);
  await hre.ethernal.push({
    name: "SfrxEth",
    address: sfrx.address,
  });

  const WstDeployment = await ethers.getContractFactory("WstEth");
  const wst = await upgrades.deployProxy(WstDeployment, [safEth.address]);
  await wst.deployed();

  await safEth.addDerivative(wst.address, "1000000000000000000");
  console.log("wst deployed to:", wst.address);
  await hre.ethernal.push({
    name: "WstEth",
    address: wst.address,
  });
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
