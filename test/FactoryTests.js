const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SublicFactory", function () {
  it("Test contract deplyment", async function () {

    const OnchainArt = await ethers.getContractFactory("SublicFactory", {
    });
    const onchainArt = await OnchainArt.deploy(
    );
    await onchainArt.deployed();
  });
});
