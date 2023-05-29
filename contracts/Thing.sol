// SPDX-License-Identifier: UNLICENSED
pragma solidity >="0.8.19";
import "contracts/Ownable.sol";
import "contracts/RigidObject.sol";

contract Thing is Ownable {
  
  constructor(address rigidObjectAddress) {
    RigidObject rigidObject = RigidObject(rigidObjectAddress);
  }

}
