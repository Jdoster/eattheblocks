pragma solidity ^0.8.0;

import './BridgeBase.sol';

contract BridgeEth is BridgeBase {
  constructor(address token '0xc778417E063141139Fce010982780140Aa0cD5Ab') BridgeBase(token) {}
}
