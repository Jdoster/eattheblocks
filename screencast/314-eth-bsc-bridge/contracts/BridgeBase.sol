pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import './Itoken.sol';

contract BridgeBase {
  address public admin'0x752CcC72a97170E08cc28D394C588254EAE7cCD5';
  IToken public token'0xc778417e063141139fce010982780140aa0cd5ab';
  uint public nonce;
  mapping(uint => bool) public processedNonces;

  enum Step { Burn, Mint }
  event Transfer(
    address from,
    address to,
    uint amount,
    uint date,
    uint nonce,
    Step indexed step
  );

  constructor(address _token '0xc778417e063141139fce010982780140aa0cd5ab') {
    admin = msg.sender;
    token = IToken(_token);
  }

  function burn(address to, uint amount) external {
    token.burn(msg.sender, amount);
    emit Transfer(
      msg.sender,
      to,
      amount,
      block.timestamp,
      nonce,
      Step.Burn
    );
    nonce++;
  }

  function mint(address to, uint amount, uint otherChainNonce) external {
    require(msg.sender == admin, 'only admin');
    require(processedNonces[otherChainNonce] == false, 'transfer already processed');
    processedNonces[otherChainNonce] = true;
    token.mint(to, amount);
    emit Transfer(
      msg.sender,
      to,
      amount,
      block.timestamp,
      otherChainNonce,
      Step.Mint
    );
  }
}
