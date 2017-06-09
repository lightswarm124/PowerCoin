var Web3 = require('web3');
var web3 = new Web3();

web3.setProvider(new web3.providers.HttpProvider());



console.log(web3.eth.getBalance(web3.eth.accounts[0]).toString());


function getAddressInfo(x) {
	var address = document.getElementById('ethAddress').value;
	var balance = web3.eth.getBalance(address).toString();
	document.getElementById('addressInfo').innerHTML = 'Account Balance: ' + balance;
}

debugger;
document.getElementById('ethAddress').value = web3.eth.accounts[0];
window.getAddressInfo = getAddressInfo;
