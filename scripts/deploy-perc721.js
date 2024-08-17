const hre = require("hardhat");
const { encryptDataField } = require("@swisstronik/swisstronik.js");

const sendShieldedTransaction = async (signer, destination, data, value) => {
  const rpclink = hre.network.config.url;
  const [encryptedData] = await encryptDataField(rpclink, data);
  return await signer.sendTransaction({
    from: signer.address,
    to: destination,
    data: encryptedData,
    value,
  });
};

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying PERC721Soultest contract with the account:", deployer.address);

  const PERC721Soultest = await hre.ethers.getContractFactory("PERC721Soultest");
  
  // Деплой контракта без использования шифрования
  const perc721Soultest = await PERC721Soultest.deploy(deployer.address);
  
  await perc721Soultest.waitForDeployment();

  console.log("PERC721Soultest deployed to:", await perc721Soultest.getAddress());

  // Дополнительная проверка (опционально)
  const contractAddress = await perc721Soultest.getAddress();
  const nameData = PERC721Soultest.interface.encodeFunctionData("name");
  
  try {
    const nameTransaction = await sendShieldedTransaction(deployer, contractAddress, nameData, 0);
    await nameTransaction.wait();
    console.log("Name function called successfully");
  } catch (error) {
    console.error("Error calling name function:", error);
  }

  console.log("Deployment and verification complete.");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });