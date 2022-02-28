const XToken = artifacts.require("XToken");

const web3 = require("web3-utils");

module.exports = (deployer, network, [owner]) =>
{
  return deployer.then(() => deployer.deploy(XToken))
                  .then(() => XToken.deployed())

};
