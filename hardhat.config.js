require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
  networks: {
    swisstronik: {
      url: "https://json-rpc.testnet.swisstronik.com/",
      accounts: ["PRIVATE_KEY_GOES_HERE"],
    },
  },
};


// SupplyChainTracker contract deployed to 
// 0x4838854e5150E4345Fb4Ae837E9FcCa40D51F3Fe