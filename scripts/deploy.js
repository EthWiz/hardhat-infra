// npx hardhat run scripts\deploy.js --network hardhat

const hre = require("hardhat");

async function main() {

  // owner, deployer, operator
  const [owner] = await hre.ethers.getSigners();
  console.log("Owner address:", owner.address);

  // Token
  let totalSupply = 10000
  console.log('Setting total supply to:', totalSupply)
  const RedefineToken = await hre.ethers.getContractFactory("RedefineToken");
  const token = await RedefineToken.deploy(totalSupply);

  await token.deployed();

  console.log("RedefineToken deployed to:", token.address);

  let ownerBalance = await token.balanceOf(owner.address);
  console.log("Balance of owner:", ownerBalance);


  // Staking Contract

  const RedefineMoneyMarket = await hre.ethers.getContractFactory(
    "RedefineMoneyMarket"
  );
  const contract = await RedefineMoneyMarket.deploy(token.address);

  await contract.deployed();

  console.log("RedefineMoneyMarket deployed to:", contract.address);

  const contractOwner = await contract.owner();

  console.log("Contract owner:", contractOwner);

  const contractAsset = await contract.asset();

  console.log("Contract asset:", contractAsset);

  let amount = totalSupply/2
  console.log('Approving:', amount)
  let txn = await token.approve(contract.address, amount);
  let allowance = await token.allowance(owner.address, contract.address);
  console.log('Allowance:', allowance)
  // const receipt = await txn.wait();
  // console.log(receipt)
  
  console.log('Depositing:', amount)
  let txn2 = await contract.deposit(amount);
  // const receipt = await txn2.wait();
  // console.log(receipt)

  let st = await contract.staked_balance(owner.address);
  console.log('Staked balance of owner:', st)
  ownerBalance = await token.balanceOf(owner.address);
  console.log("Balance of owner:", ownerBalance);

  amount = parseInt(totalSupply/3)
  console.log('Withdrawing:', amount)
  let txn3 = await contract.withdraw(amount);
  
  st = await contract.staked_balance(owner.address);
  console.log('Staked balance of owner:', st)

  ownerBalance = await token.balanceOf(owner.address);
  console.log("Balance of owner:", ownerBalance);


  // Proxy contract

  const RedefineMoneyMarketProxy = await hre.ethers.getContractFactory(
    "RedefineMoneyMarketProxy"
  );
  const proxy = await hre.upgrades.deployProxy(RedefineMoneyMarketProxy, {
    initializer: "initialize",
  });

  await proxy.deployed();

  console.log("RedefineMoneyMarketProxy deployed to:", proxy.address);
  
  const RedefineMoneyMarketUpgrade = await hre.ethers.getContractFactory(
    "RedefineMoneyMarketUpgrade"
  );
  console.log("Upgrading RedefineMoneyMarketProxy");
  const upgraded = await hre.upgrades.upgradeProxy(proxy.address, RedefineMoneyMarketUpgrade);
  console.log("Upgraded address:", upgraded.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
