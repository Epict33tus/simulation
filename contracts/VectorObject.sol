// SPDX-License-Identifier: UNLICENSED
pragma solidity >="0.8.19";

import "./RigidObject.sol";
import "../interfaces/SimulationObject.sol";
struct Vector {
    int[] x;
    int[] y;
    int[] z;
}
contract VectorObject {
  
  Vector v;
  RigidObject rigidObject;
  address owner;
  address objectAddress;

  constructor (address rigidBody, RigidObject object) {
    owner = msg.sender;
    objectAddress = rigidBody;
    rigidObject = object;
  }
  // I don't think I can pass the function directly in solidity, so we can do function types
  // we can make x, y, z array in later environments
  function move(uint x, uint y, uint z, uint submitTimestamp, int[] memory sampleRates) public returns (Vector memory movements) {
    // transaction timing
    // submitTimestamp subtract from block.timestamp and sample rate
    int difference = int(block.timestamp - submitTimestamp);
    int greatestSampleRate = 0;
    for (uint i = 0; i < sampleRates.length; i++) {
      if (sampleRates[i] > greatestSampleRate) greatestSampleRate = sampleRates[i];
    }

    //while (greatestSampleRate -= 1 > 0)
    //while (greatestSampleRate -= 1 >= 0)
    Loc memory loc = rigidObject.getLoc();
    int[3] memory differences = [int(loc.x) + difference, int(loc.y) + difference, int(loc.z)+ difference];
    //int[] differences = [loc.x + difference - x, loc.y + difference - y, loc.z + difference - z];
    // REVIEW - can calculate trajectories with differences for path prediction
    // probably should be storage instead of memory for cost but can compile two versions
    int[] memory xS;
    int[] memory yS;
    int[] memory zS;
    v = Vector(xS, yS, zS);
    while (greatestSampleRate-- > 0) {
      // difference -= sampleRate[0]
      differences[0] -= sampleRates[0];
      v.x.push(differences[0]);
      differences[1] -= sampleRates[1];
      v.y.push(differences[1]);
      differences[2] -= sampleRates[2];
      v.z.push(differences[2]);
    }

    /*rigidObject.loc.x = x;
    rigidObject.loc.y = y;
    rigidObject.loc.z = z;
    */
    rigidObject.place(x, y, z);
    return v;
  }
}
