// SPDX-License-Identifier: UNLICENSED
pragma solidity >="0.8.19";
import "contracts/Ownable.sol";

// SimulationObject interface?
contract BinaryObject is Ownable {
  // likely have to return by uint and do complete interface
  mapping(uint => bytes32[]) private raw;
  uint[] private idUpdates;
  function getRaw(uint[] memory ids) public view returns (bytes32[][] memory array) {
    for (uint i = 0; i < ids.length; i++) {
      array[i] = raw[ids[i]];
    }
    return array;
  }
  
  function populate(bytes32[][] calldata data) public ownership returns (uint i) {
    for (i = 0; i < data.length; i++) {
      raw[i] = data[i];
    }
    return i;
  }
  function updateRaw(uint[] memory ids, bytes32[][] memory data) public ownership returns (uint len) {
    require(data.length == ids.length);
    for (uint i = 0; i < ids.length; i++) {
      raw[ids[i]] = data[ids[i]]; 
      // REVIEW - cost
      idUpdates.push(ids[i]);
    }
    return data.length;
  }
  // REVIEW - should this be private?
  function getIdUpdates() public view returns (uint[] memory updates) {
    return idUpdates;
  }
}
