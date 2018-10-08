pragma solidity ^0.4.24;

contract LinkTokenInterface {
  uint256 public totalSupply;
  string public name;
  uint8 public decimals;
  string public symbol;
  mapping(address => uint256) public balances;

  function balanceOf(address who) external returns (uint256);
  function transfer(address to, uint256 value) external returns (bool);
  function allowance(address owner, address spender) external constant returns (uint256);
  function transferFrom(address from, address to, uint256 value) external returns (bool);
  function approve(address spender, uint256 value) external returns (bool);
  function transferAndCall(address to, uint value, bytes data) external returns (bool success);

  event Approval(address indexed owner, address indexed spender, uint256 value);
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Transfer(address indexed from, address indexed to, uint value, bytes data);
}
