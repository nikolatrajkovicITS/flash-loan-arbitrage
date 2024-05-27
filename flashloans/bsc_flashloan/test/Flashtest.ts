import { ethers } from "hardhat";
import { network } from "hardhat";
import { expect } from "chai";

// This is an utility function that we will use to load the fixture
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";

// This is the ABI of the Flashloan contract that we want to test
import { abi as abiFlashLoan } from "../artifacts/contracts/Flashloan.sol/Flashloan.json";

const WBNB = "0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c";
const BUSD = "0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56";
const CAKE = "0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82";

const v3Fee = 500;

describe("DeployGetPool", function () {
  it("Deploy and gets pool address", async function () {
    // Deploys the Flashloan contract and gets the address of the deployed contract
    const FlashLoan = await ethers.getContractFactory("FlashLoan");
    let flashLoan = await FlashLoan.deploy(WBNB, BUSD, v3Fee);
    await flashLoan.deployed();

    console.log("Flashloan deployed to: __\t", flashLoan.address);
  });
});
