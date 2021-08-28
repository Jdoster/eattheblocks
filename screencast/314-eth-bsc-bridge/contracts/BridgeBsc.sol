pragma solidity ^0.8.0;

import './BridgeBase.sol';

contract BridgeBsc is BridgeBase {
  constructor(address token '0x2170ed0880ac9a755fd29b2688956bd959f933f8') BridgeBase(token) {}
}
