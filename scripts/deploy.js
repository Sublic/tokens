const hre = require("hardhat");
const Big = require('big.js');

const erc20Json = require('../contractABIs/ERC20.json');

var currentSublicFactory = "";

const verify = false
var deployer;

async function main() {
  const [fetchedDeployer] = await ethers.getSigners();
  deployer = fetchedDeployer

  console.log("Current account:", deployer.address);
  console.log("Account balance:", (await deployer.getBalance()).toString());

  // Factory setup
  // await deploySublicFactory()
}

async function deploySublicFactory() {
  console.log("Deploying Sublic Factory")

  const Factory = await ethers.getContractFactory("SublicFactory");
  const contract = await Factory.deploy(
  );
  await contract.deployed();
  console.log("Address of Sublic Factory:", contract.address);
  currentSublicFactory = contract.address

  if (!verify) { return }
  await delay(30000);
  try {
    await hre.run("verify:verify", {
        address: currentSublicFactory,
        network: hre.network,
        constructorArguments: [
        ]
    });
  } catch (error) {
      console.error(error);
      return contract
  }
}

async function approveToken(
  spender,
  amount,
  tokenAddress,
  abi,
) {
  console.log("Approving token spend " + tokenAddress)
  let contract = await getTokenContract(tokenAddress);
  let tx = await contract.approve(spender, amount);
  await tx.wait();
  console.log('Approve token hash: ' + tx.hash);
}

async function getTokenDecimals(
  tokenAddress
) {
  let contract = await getTokenContract(tokenAddress);
  return await contract.decimals();
}

async function getTokenContract(address) {
  return new hre.ethers.Contract(address, erc20Json, deployer);
}

async function deployFactory(svgPath, scale) {
  const SublicFactory = await ethers.getContractFactory("SublicFactory", {
  });
  const contract = await SublicFactory.attach(
    currentFactoryAddress // The deployed contract address
  );

  // Now you can call functions of the contract
  const result = await contract.createVault(
  );
  console.log(result);
}

const delay = ms => new Promise(res => setTimeout(res, ms));

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
