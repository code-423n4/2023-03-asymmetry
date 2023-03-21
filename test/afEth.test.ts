import { ethers, network, waffle } from "hardhat";
import { CVX_ADDRESS, CVX_WHALE } from "./helpers/constants";
import ERC20 from "@openzeppelin/contracts/build/contracts/ERC20.json";
import { time } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";

describe("AfEth", async function () {
  it("Should trigger withdrawing of vlCVX rewards", async function () {
    const AfEth = await ethers.getContractFactory("AfEth");
    // The address params dont matter for this test.
    const address = "0x0000000000000000000000000000000000000000";
    const afEth = await AfEth.deploy(address, address, address, address);
    await afEth.deployed();
    // impersonate an account that has rewards to withdraw at the current block
    await network.provider.request({
      method: "hardhat_impersonateAccount",
      params: [CVX_WHALE],
    });
    const whaleSigner = await ethers.getSigner(CVX_WHALE);
    const cvx = new ethers.Contract(CVX_ADDRESS, ERC20.abi, whaleSigner);

    const cvxAmount = ethers.utils.parseEther("100");
    await cvx.transfer(afEth.address, cvxAmount);

    const tx1 = await afEth.lockCvx(cvxAmount);
    await tx1.wait();
    await time.increase(1000);

    const provider = waffle.provider;
    const startingBalance = await provider.getBalance(afEth.address);

    const tx2 = await afEth.claimRewards(ethers.utils.parseEther("0.01")); //  1% slippage tolerance when claiming
    await tx2.wait();
    const endingBalance = await provider.getBalance(afEth.address);

    expect(endingBalance.gt(startingBalance)).eq(true);

    await expect(
      afEth.claimRewards(ethers.utils.parseEther("0.0000001")) // very low slippage reverts
    ).to.be.reverted;
  });
});
