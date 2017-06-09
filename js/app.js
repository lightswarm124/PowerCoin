var Web3 = require('web3');

const fs = require('fs');

if (typeof web3 !== 'undefined') {
  web3 = new Web3(web3.currentProvider);
} else {
  // set the provider you want from Web3.providers
  web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}

var source = fs.readFileSync("./contracts/PowerCoinMeter.sol").toString();
var contract = web3.eth.compile.solidity(source);
// now returns "contract.code" & "contract.info.abiDefinition"
var contractInterface = web3.eth.contract(contract.info.abiDefinition);

var deployedContract = contractInterface.new({
    data: contract.code,
    from: web3.eth.accounts[0],
    gas: 90000*2
}, (err, res) => {
    if (err) {
        console.log(err);
        return;
    }

    // Log the tx, you can explore status with eth.getTransaction()
    console.log(res.transactionHash);

    // If we have an address property, the contract was deployed
    if (res.address) {
        console.log('Contract address: ' + res.address);
        // Let's test the deployed contract
        testContract(res.address);
    }
});

var contractInstance = contractInstance.at(deployedContract.address);
