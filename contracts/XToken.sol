pragma solidity ^0.8.0;

import "./ERC20/ERC20Token.sol";

contract XToken is ERC20Token
{
    string public constant TOKEN_NAME = "XToken";
    string public constant TOKEN_SYMBOL = "XTKN";
    uint256 public constant TOTAL_TOKENS = 10000;

    constructor ()
    ERC20Token(TOKEN_NAME, TOKEN_SYMBOL, TOTAL_TOKENS) public
    {
      initContractAddress(TOTAL_TOKENS);
    }
}