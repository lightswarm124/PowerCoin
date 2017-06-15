var Web3 = require('web3');
var web3 = new Web3();
web3.setProvider(new web3.providers.HttpProvider());
var PowerCoinMeter = require('./../../build/contracts/PowerCoinMeter.sol');
PowerCoinMeter.setProvider(web3.currentProvider);
console.log('Included');

var pcm = PowerCoinMeter.deployed();
console.log(pcm.address);

var currentPrice = 20;

pcm.sell_price().then(onReady)

function onReady(price) {
	currentPrice = 20;
	socket.on('meter_data', updateMarketData);
}

function processMeterData(data) {
	console.log(data);
}

var socket_io = require('socket.io-client');
var socket = socket_io();

var _latestReadings = new CircularBuffer(7);

pcm.priceChanged(function(err, event) {
	currentPrice = event.args.newPrice.toString();
});


function updateMarketData(data) {
	_latestReadings.enq(data);
	var readings = _latestReadings.toarray();
	console.log('mapping');
	readings = readings.map(function(a) {
		var timestamp = a.timestamp.toString();
		var timestampMoment = moment(timestamp, 'x')
		var current = moment();
		a.price = '$' + currentPrice;
		a.timestamp_text = current.diff(timestampMoment, 'seconds') + ' seconds ago';
		return a;
	})
	var template = '{{#readings}}<tr><td>V:{{volt}} W:{{watt}} A:{{amps}} K:{{kwh}}</td><td>{{price}}</td><td><button onclick="window.buyConsumedPower({{kwh}})" class="w3-button w3-dark-grey">BUY  <i class="fa fa-arrow-right"></i></button</td></tr>{{/readings}}'
	document.getElementById('market_data').innerHTML = Mustache.render(template, {readings : readings});

}


function buyConsumedPower(powerConsumed) {
	var duration = prompt("You are buying " + powerConsumed + "KWH @ $" + currentPrice + '.' + 'Please enter time duration');
	var timeDuration = parseInt(duration);
	// var timeDuration = 1;
	pcm.buyConsumedPower(powerConsumed, timeDuration, {
		from : web3.eth.accounts[1],
		value : powerConsumed * currentPrice
	}).then(function(tx) {
		var msg = powerConsumed + ' KWH @ $' + currentPrice + ' for' + timeDuration + ' was bought. Here is the transaction hash ' + tx;
		alert(msg);
		console.log(tx);

	});
}

window.buyConsumedPower = buyConsumedPower;
