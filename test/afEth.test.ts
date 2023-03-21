import { ethers, network } from "hardhat";
import { CVX_ADDRESS, CVX_WHALE } from "./helpers/constants";
import ERC20 from "@openzeppelin/contracts/build/contracts/ERC20.json";
import { time } from "@nomicfoundation/hardhat-network-helpers";

describe.skip("AfEth", async function () {
  it("Should trigger withdrawing of vlCVX rewards", async function () {
    const AfEth = await ethers.getContractFactory("AfEth");

    // The address params dont matter for this test.
    const address = "0x0000000000000000000000000000000000000000";
    const afEth = await AfEth.deploy(address, address, address, address);
    await afEth.deployed();

    console.log("deployed", afEth.address);

    console.log("block is", await ethers.provider.getBlock("latest"));

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
    const mined1 = tx1;
    console.log("mined1 is", mined1);
    await time.increase(1000);

    const tx2 = await afEth.claimRewards();
    const mined2 = await tx2.wait();
    console.log("mined2 is", mined2);
  });
});
