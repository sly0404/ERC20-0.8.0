pragma solidity ^0.8.0;

library Utils
{
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
}