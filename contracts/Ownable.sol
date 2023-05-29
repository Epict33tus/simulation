// SPDX-License-Identifier: UNLICENSED
pragma solidity >="0.8.19";

contract Ownable {

  address private owner;
  bool private owned = true;
  address[] releaseList;
  address releaser = address(0);
  constructor() {
    owner = msg.sender;
  }
  modifier ownership {
    require(msg.sender == owner || !owned);
    _;
  }
  function setOwned() private view returns (bool isOwner) {
    for (uint i = 0; i < releaseList.length; i++) {
      if (releaseList[i] == msg.sender) {
        isOwner = true;
        continue;
      }
    }
    isOwner = false;
    return isOwner;
  }

  function setOwner(address newOwner) public ownership returns (bool success) {
    if (releaseList.length != 0 && !owned) {
      bool isOwner = setOwned();
      if (!isOwner) return false;
    }
    owner = newOwner;
    owned = true;
    return true;
  }
  function release() public ownership {
    owned = false;
  }
  function setReleaseList(address[] calldata list) public ownership {
    releaser = msg.sender;
    releaseList = list;
  }
  function flushRelease() public {
    require(msg.sender == releaser);
    releaseList = new address[](0);
  }
}

