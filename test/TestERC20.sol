pragma solidity ^0.8.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/XToken.sol";

contract TestERC20
{
    uint256 public constant TOKENS_TOTAL_QUANTITY = 10000;

    XToken private xToken;
    string private errorTestInitialization = "wrong initial amount!";
    string private errorTestMsgSender = "wrong MsgSender";
    string private errorTestTransfer = "amounts not equals!";
    address private constant _TO_ADDRESS = 0x25075f2ADf4a1dFeD4DFFEfB9747112ca5c168D1; //"0x25075f2ADf4a1dFeD4DFFEfB9747112ca5c168D1"
    address private constant _ACCOUNT_0 = 0x25075f2Adf4A1dFed4DffeFb9747112cA5C168d3;
    
    //represente msg.sender lorsqu'on l'apelle de XToken(DeployedAddresses.XToken()).
    address private constant _MSG_SENDER = 0xbaAA2a3237035A2c7fA2A33c76B44a8C6Fe18e87; //"0xbaAA2a3237035A2c7fA2A33c76B44a8C6Fe18e87"
     
    //represente msg.sender lorsqu'on l'apelle de ce contrat.
    //lorsque l'initialisation est faite, on a _balances[_MSG_SENDER_DIRECT] ==  TOKENS_TOTAL_QUANTITY.
    //address private constant _MSG_SENDER_DIRECT = 0x627306090abab3a6e1400e9345bc60c78a8bef57;
    
    constructor() public
    {
        xToken = XToken(DeployedAddresses.XToken());
        xToken.setBalanceOf(xToken.getMsgSender(), TOKENS_TOTAL_QUANTITY);
    }

    
    function addressToString(address _addr) public pure returns(string memory)
    {
        bytes32 value = bytes32(uint256(uint160(_addr)));
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(51);
        str[0] = "0";
        str[1] = "x";
        for (uint i = 0; i < 20; i++) 
        {
            str[2+i*2] = alphabet[uint(uint8(value[i + 12] >> 4))];
            str[3+i*2] = alphabet[uint(uint8(value[i + 12] & 0x0f))];
        }
        return string(str);
    }

    function concatenate(string memory a,string memory b) public pure returns (string memory)
    {
        return string(bytes.concat(bytes(a), " ", bytes(b)));
    }

    function testInitialization() public
    {
        Assert.equal(xToken.totalSupply(), TOKENS_TOTAL_QUANTITY, errorTestInitialization);
    }

    function testXTokenMsgSender() public
    {
        address msgSender = xToken.getMsgSender();
        //ici msg.sender == 0xbaaa2a3237035a2c7fa2a33c76b44a8c6fe18e87
        string memory msgSendertoSring = addressToString(msgSender);
        string memory errorMessage = concatenate(errorTestMsgSender, msgSendertoSring);
        Assert.equal(msgSender, _MSG_SENDER, errorMessage);
    }

    function testBalanceOfDirectMsgSender() public
    {
        address msgSender = msg.sender;
        //ici msg.sender == 0x627306090abab3a6e1400e9345bc60c78a8bef57
        Assert.equal(xToken.balanceOf(msgSender), TOKENS_TOTAL_QUANTITY, errorTestInitialization);
    }

    function testBalanceOfXTokenMsgSender() public
    {
        address msgSender = xToken.getMsgSender();
        //ici msg.sender == 0x4E72770760c011647D4873f60A3CF6cDeA896CD8
        Assert.equal(xToken.balanceOf(msgSender), TOKENS_TOTAL_QUANTITY, errorTestInitialization);
    }

    function testTransfer() public
    {
        uint256 amountToTransfer = 2000;
        uint256 toBalanceBeforeTransaction = xToken.balanceOf(_TO_ADDRESS);
        xToken.transfer(_TO_ADDRESS, amountToTransfer);
        uint256 toBalanceAfterTransaction = xToken.balanceOf(_TO_ADDRESS);
        bool test = toBalanceBeforeTransaction + amountToTransfer == toBalanceAfterTransaction;
        Assert.equal(toBalanceBeforeTransaction + amountToTransfer, toBalanceAfterTransaction, errorTestTransfer);
    }
}