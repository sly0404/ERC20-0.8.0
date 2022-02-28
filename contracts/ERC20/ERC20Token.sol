pragma solidity ^0.8.0;

import "./IERC20.sol";
import "../Utils.sol";
import "openzeppelin-solidity/contracts/utils/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/utils/Strings.sol";


contract ERC20Token is IERC20
{
    using SafeMath for uint256;

    string private _tokenName;
    string private _tokenSymbol;
    uint256 private _tokenTotalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor (string memory name, string memory symbol, uint256 total) public
    {
      _tokenName = name;
      _tokenSymbol = symbol;
      _tokenTotalSupply = total;
    }

    function concatenate(string memory a,string memory b) public pure returns (string memory)
    {
        return string(bytes.concat(bytes(a), " ", bytes(b)));
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

    function initContractAddress(uint256 amount) internal
    {
        require(msg.sender != address(0), "ERC20: mint to the zero address");
        _balances[msg.sender] = amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function totalSupply() external view returns (uint256)
    {
        return _tokenTotalSupply;
    }

    function balanceOf(address account) public view returns (uint256)
    {
        return _balances[account];
    }

    function setBalanceOf(address account, uint256 amount) external
    {
        _balances[account] = amount; 
    }

    function getMsgSender() external view returns (address)
    {
      return msg.sender;
    }

    function getBlockNumber() internal view returns (uint)
    {
      return block.number;
    }

    function getBlockBaseFee() external view returns (uint)
    {
      return block.basefee;
    }

    function getBlockGasLimit() external returns (uint)
    {
      return block.gaslimit;
    }

    
    function gasCost(string memory name, function () internal view returns (uint) f) 
        internal view returns (string memory) 
    {
        uint256 u0 = gasleft();
        uint rsltF = f();
        uint256 u1 = gasleft();
        uint diff = u0 - u1;
        string memory rsltFString = Strings.toString(rsltF);
        string memory s1 = concatenate(name, rsltFString);
        string memory diffFString = Strings.toString(diff);
        string memory s2 = concatenate(s1, diffFString);
        return s2;
    }

    function callGasCost() external view returns (string memory)
    {
      return gasCost("getBlockNumber", getBlockNumber);
    }
    

    function transfer(address recipient, uint256 amount) external returns (bool)
    { 
        uint256 callerBalance = _balances[msg.sender];
        string memory errorMessage = concatenate("ERC20: msg.sender balance must be greater than ", Strings.toString(amount));
        //string memory errorMessage = concatenate(addressToString(msg.sender), Strings.toString(callerBalance));
        require(callerBalance >= amount, errorMessage);
        _balances[recipient] = _balances[recipient].add(amount);
        _balances[msg.sender] = _balances[msg.sender].sub(amount);
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external returns (bool)
    {
        require(msg.sender != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool)
    {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        uint256 senderBalance = balanceOf(sender);
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");

        //sender autorise msg.sender à envoyer currentAllowance tokens à sa place
        uint256 currentAllowance = allowance(sender, msg.sender);
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        
        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);

        /*Etant donné que ces amount tokens vont être transférés, il ne reste plus que 
        currentAllowance - amount comme tokens que sender autorise msg.sender à envoyer à sa place*/
        _allowances[sender][msg.sender] = currentAllowance - amount;
        emit Approval(sender, msg.sender, amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }
}
