// SPDX-License-Identifier: UNLICENSED
pragma solidity >="0.8.19";

// TODO - move to library


interface SimulationObject {
  // REVIEW - may need to import and move out of interface
  struct BinaryMap {
    mapping(uint => bytes32[]) raw;
  }   
  struct Data {
    address objectContract;
    mapping(uint => bool) binary;
    mapping(uint => uint) raw;
    // maybe a conversion object instead of another map
    mapping(address => uint) globalMap;
    mapping(uint => address) objectOwner;
    bool oneOwner;
    BinaryMap binaryMap;
  }
  // possibly return uint array of bytes 32 and overload
  function populate(address objectAddress, address objectOwner, bytes32[][] calldata data) external returns (uint);
  //indexSwap pairs of  swaps [1,3,4,7] always even swaps 1 with 3 and 4 with 7
  function action(address objectContract, address newOwner, uint[] calldata indexSwaps) external;
  //function 
}


