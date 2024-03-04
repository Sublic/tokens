const hre = require("hardhat");
const Big = require("big.js");

const erc20Json = require("../contractABIs/ERC20.json");

var currentSublicFactory = "";
const algebraFactory = "0xFBFB64eD1C70bb8d4c8bFCc338C10a5120809538";
const algebraPositiionManager = "0xF1E919e24159b14aC32790dD4828B671E2158982";
const algebraSwapRouter = "0xc12f40f584A751C032e18f5757d3b7EE6fD74289";
const mediaFactory = "0x763463468E37424ED7a8740d412DD87f216Ff9C5";

const verify = true;
var deployer;

async function main() {
  const [fetchedDeployer] = await ethers.getSigners();
  deployer = fetchedDeployer;

  console.log("Current account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  // Factory setup
  await deploySublicFactory();
}

async function deploySublicFactory() {
  console.log("Deploying Sublic Factory");
  if (currentSublicFactory != "") {
    console.log("Already deployed: " + currentSublicFactory);
    return;
  }

  const Factory = await ethers.getContractFactory("SublicFactory");
  const contract = await Factory.deploy(
    algebraFactory,
    algebraPositiionManager,
    algebraSwapRouter,
    mediaFactory
  );
  await contract.deployed();
  console.log("Address of Sublic Factory:", contract.address);
  currentSublicFactory = contract.address;

  if (!verify) {
    return;
  }
  await delay(30000);
  try {
    await hre.run("verify:verify", {
      address: currentSublicFactory,
      network: hre.network,
      constructorArguments: [
        algebraFactory,
        algebraPositiionManager,
        algebraSwapRouter,
        mediaFactory,
      ],
    });
  } catch (error) {
    console.error(error);
    return contract;
  }
}

async function approveToken(spender, amount, tokenAddress, abi) {
  console.log("Approving token spend " + tokenAddress);
  let contract = await getTokenContract(tokenAddress);
  let tx = await contract.approve(spender, amount);
  await tx.wait();
  console.log("Approve token hash: " + tx.hash);
}

async function getTokenDecimals(tokenAddress) {
  let contract = await getTokenContract(tokenAddress);
  return await contract.decimals();
}

async function getTokenContract(address) {
  return new hre.ethers.Contract(address, erc20Json, deployer);
}

async function deployFactory(svgPath, scale) {
  const SublicFactory = await ethers.getContractFactory("SublicFactory", {});
  const contract = await SublicFactory.attach(
    currentFactoryAddress // The deployed contract address
  );

  // Now you can call functions of the contract
  const result = await contract.createVault();
  console.log(result);
}

const delay = (ms) => new Promise((res) => setTimeout(res, ms));

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
