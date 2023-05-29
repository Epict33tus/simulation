// may need to change path
import "./SimulationObject.sol";
interface GameObject is SimulationObject {
  struct name {
    string name;
    address objectAddress;
    // indexes
    uint[] raw;
  }
  function name(address objectAddress, string memory name) returns (uint[]);
}
