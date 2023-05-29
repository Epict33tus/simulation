//SPDX-License-Identifier: UNLICENSED
pragma solidity >="0.8.19";
import "../interfaces/SimulationObject.sol";
import "../contracts/BinaryObject.sol";
/*
The compiler maintains an internal database (virtual filesystem or VFS for short) where each source unit is assigned a unique source unit name which is an opaque and unstructured identifier. When you use the import statement, you specify an import path that references a source unit name.
*/

struct Loc {
  uint x;
  uint y;
  uint z;
}
// REVIEW - probably not needed
struct FreeLoc {
  // REVIEW should be enum?
  mapping(uint => uint) planes;
}

struct BinaryMap {
  mapping(uint => bytes32[]) raw;
}
// does solidity have middleware?
// should require address of owner in middleware
contract RigidObject is SimulationObject {
  Loc public loc;
  BinaryMap bin;
  address owner;
  uint[] indexArray;
  constructor(address receiver) {
    if (receiver != address(0)) {
      owner = receiver;
    }
    owner = msg.sender;
  }
  function binContractToMap(address binContract, uint[] memory ids) private {
    //BinaryObject
    BinaryObject binObject = BinaryObject(binContract);
    bytes32[][] memory binData = binObject.getRaw(ids);
    for (uint i = 0; i < binData.length; i++) {
      bin.raw[i] = binData[i];
    }
  }
  function place(uint x, uint y, uint z) public { // returns (int[] memory location)
    loc = Loc(x, y, z);
  }
  /*
    External functions with calldata parameters are incompatible with external function types with calldata parameters. They are compatible with the corresponding types with memory parameters instead. For example, there is no function that can be pointed at by a value of type function (string calldata) external while function (string memory) external can point at both function f(string memory) external {} and function g(string calldata) external {}. This is because for both locations the arguments are passed to the function in the same way. The caller cannot pass its calldata directly to an external function and always ABI-encodes the arguments into memory. Marking the parameters as calldata only affects the implementation of the external function and is meaningless in a function pointer on the caller’s side.
  */
  function getLoc() public view returns (Loc memory location) {
    return loc;
  }
  // I don't think I can pass the function directly in solidity, so we can do function types
  // we can make x, y, z array in later environments

  // serialized swaps
  // supress reverts with swap extender with empty bytes
  function indexSwap(uint[] memory indexSwaps, address binAddress) external returns (uint) {
    // TODO - change to class from stuct?
    BinaryObject contractBin = BinaryObject(binAddress);
    for (uint i = 0; i < indexSwaps.length - 1; i++) {
      bytes32[] memory cache = bin.raw[indexSwaps[i]]; 
      bin.raw[indexSwaps[i]] = bin.raw[indexSwaps[i + 1]];
      bin.raw[indexSwaps[i + 1]] = cache;
    }
    return indexSwaps.length;
  }
  function updateRaw(uint[] memory ids, bytes32[][] calldata data) external {
    require(ids.length == data.length);
    for(uint i = 0; i < ids.length; i++) {
      bin.raw[ids[i]] = data[i];
    }
  }
  function populate(address objectAddress, address objectOwner, bytes32[][] calldata data) external returns (uint) {
      // TODO - objectAddress is used to populate bin data from the contract.
      require(msg.sender == owner);
      owner = objectOwner;
      RigidObject externalContract = RigidObject(objectAddress);
      // creates transaction? Should revert local changes if changes don't stick in transaction
      uint[] memory ids;
      for (uint i = 0; i < data.length; i++) {
        bin.raw[i] = data[i];
        //externalContract.bin.raw[i] = data[i];
        ids[i] = i;
      }
      externalContract.updateRaw(ids, data);
      // REVIEW - the data array is a set of indexes on another contract to support NFT data by contract address.
      // redundant but for interface
      return data.length;
  }
  // indexes and data should have the same length
  function populate(address objectOwner, uint[] calldata indexes, bytes32[][] calldata data, address[] memory chain) external returns (address[] memory addresses) {
    require(msg.sender == owner);
    require(data.length == indexes.length);
    indexArray = indexes;
    owner = objectOwner;
    // "sinookas, the tendrils of my life"
    for (uint i = 0; i < indexes.length; i++) {
      bin.raw[indexes[i]] = data[i];
    }
    //address[] memory addresses = new address[](chain.length + 1);
    for (uint i = 0; i < chain.length; i++) {
      addresses[i] = chain[i];
    }
    //address[chain.length + 1] memory addr; 
    //addresses = chain[:];//slice?
    //addresses.push(objectOwner);
    //chain.push(objectOwner);
    return chain;
  }
  
  //indexSwap pairs of  swaps [1,3,4,7] always even swaps 1 with 3 and 4 with 7
  
  function action(address objectContract, address newOwner, uint[] calldata indexSwaps) external {
    require(msg.sender == owner);
    RigidObject externalContract = RigidObject(objectContract);
    // objectContract is the object we are performing opetations on, and should have permission
    // TODO - objectContract contract call assuming same ABI
    owner = newOwner;
    externalContract.action(indexSwaps);
  }
  // REVIEW - should this be length, and if so, turn to just array?
  function action(uint[] calldata indexSwaps) external returns (uint size) {
    // objectContract is the object we are performing opetations on, and should have permission
    for (uint i = 0; i < indexSwaps.length; i++) {
      // TODO - check if bin is working with real data and revert if not
      bin.raw[indexSwaps[i]] = bin.raw[indexSwaps[i]];
      size += 32;
    }
    return size;
  }
  
}

