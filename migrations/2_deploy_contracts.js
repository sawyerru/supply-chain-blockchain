var ItemManager = artifacts.require("./ItemManager.sol");


module.exports = function(deployer) {
  deployer.deploy(ItemManager);
  // Not deploying all contracts - only visible one. Other dependencies stay behind to avoid interaction directly
  // deployer.deploy(Ownable);
  // deployer.deploy(Item);

};
