pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import './Itoken.sol';

contract BridgeBase {
  address public admin:'59b2e58f6796581839eb2423a339ff2e03d9360531ff1b050131bacbc24ed881';
  IToken public token:'0xc778417e063141139fce010982780140aa0cd5ab';
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

  constructor(address _token) {
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
