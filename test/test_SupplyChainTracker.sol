const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SupplyChainTracker", function () {
  let supplyChainTracker;
  let owner;
  let otherAccount;

  beforeEach(async function () {
    [owner, otherAccount] = await ethers.getSigners();
    const SupplyChainTrackerFactory = await ethers.getContractFactory("SupplyChainTracker");
    supplyChainTracker = await SupplyChainTrackerFactory.deploy();
    await supplyChainTracker.deployed();
  });

  it("should allow ordering an item", async function () {
    await supplyChainTracker.connect(owner).orderItem("Item 1");

    const item = await supplyChainTracker.getItem(0);
    expect(item.name).to.equal("Item 1");
    expect(item.status).to.equal(0); // Status.Ordered
    expect(item.orderedBy).to.equal(owner.address);
  });

  it("should allow cancelling an ordered item", async function () {
    await supplyChainTracker.connect(owner).orderItem("Item 1");
    await supplyChainTracker.connect(owner).cancelItem(0);

    const item = await supplyChainTracker.getItem(0);
    expect(item.status).to.equal(3); // Status.Cancelled
  });

  it("should allow the owner to approve an ordered item", async function () {
    await supplyChainTracker.connect(owner).orderItem("Item 1");
    await supplyChainTracker.connect(owner).approveItem(0);

    const item = await supplyChainTracker.getItem(0);
    expect(item.status).to.equal(1); // Status.Shipped
    expect(item.approvedBy).to.equal(owner.address);
  });

  it("should allow the owner to ship a shipped item", async function () {
    await supplyChainTracker.connect(owner).orderItem("Item 1");
    await supplyChainTracker.connect(owner).approveItem(0);
    await supplyChainTracker.connect(owner).shipItem(0);

    const item = await supplyChainTracker.getItem(0);
    expect(item.status).to.equal(2); // Status.Delivered
    expect(item.deliveredTo).to.equal(owner.address);
  });

  it("should return the correct item count", async function () {
    await supplyChainTracker.connect(owner).orderItem("Item 1");
    await supplyChainTracker.connect(owner).orderItem("Item 2");

    const itemCount = await supplyChainTracker.getItemCount();
    expect(itemCount).to.equal(2);
  });

  it("should return all items", async function () {
    await supplyChainTracker.connect(owner).orderItem("Item 1");
    await supplyChainTracker.connect(owner).orderItem("Item 2");

    const allItems = await supplyChainTracker.getAllItems();
    expect(allItems.length).to.equal(2);
    expect(allItems[0].name).to.equal("Item 1");
    expect(allItems[1].name).to.equal("Item 2");
  });
});
