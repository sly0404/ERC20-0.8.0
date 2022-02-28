//migrate --reset

token = await XToken.deployed()

let blockNumber = await token.getBlockNumber()
let convertedBlockNumber = await blockNumber.toString(10)
token.getBlockBaseFee()
let gasLimit = await token.getBlockGasLimit()
let convertedGasLimit = await gasLimit.toString(10)

token.gasCost("getBlockNumber", token.getBlockNumber())
token.callGasCost()

token = await VToken.deployed()
token.transfer("0x25075f2adf4a1dfed4dffefb9747112ca5c168d1", 2000)