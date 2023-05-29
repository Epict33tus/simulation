//SPDX-License-Identifier: UNLICENSED
pragma solidity >="0.8.19";

library controls {
  struct BinaryMap {
    mapping(uint => bytes32[]) raw;
  } 
}
