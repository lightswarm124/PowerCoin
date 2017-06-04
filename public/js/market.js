console.log('Included');
var socket = io();
var _latestReadings = new CircularBuffer(7);
socket.on('meter_data', processMeterData);

function processMeterData(data) {
	updateMarketData(data);
}

function updateMarketData(data) {
	_latestReadings.enq(data);
	var readings = _latestReadings.toarray();
	console.log('mapping');
	readings = readings.map(function(a) {
		var timestamp = a.timestamp.toString();
		var timestampMoment = moment(timestamp, 'x')
		var current = moment();
		a.timestamp_text = current.diff(timestampMoment, 'seconds') + ' seconds ago';
		return a;
	})
	var template = '{{#readings}}<tr><td>V:{{volt}} W:{{watt}} A:{{amps}} K:{{kwh}}</td><td>$10</td><td><button class="w3-button w3-dark-grey">BUY  <i class="fa fa-arrow-right"></i></button</td></tr>{{/readings}}'
	document.getElementById('market_data').innerHTML = Mustache.render(template, {readings : readings});

}

/*
<tr>
  <td>V: 10 W: 20 A: 1 K:3</td>
  <td>$10</td>
  <td><button class="w3-button w3-dark-grey">BUY  <i class="fa fa-arrow-right"></i></button</td>
</tr>
<tr>
  <td>V: 10 W: 20 A: 1 K:3</td>
  <td>$10</td>
  <td><button class="w3-button w3-dark-grey">BUY  <i class="fa fa-arrow-right"></i></button</td>
</tr>
<tr>
  <td>V: 10 W: 20 A: 1 K:3</td>
  <td>$10</td>
  <td><button class="w3-button w3-dark-grey">BUY  <i class="fa fa-arrow-right"></i></button</td>
</tr>
<tr>
  <td>V: 10 W: 20 A: 1 K:3</td>
  <td>$10</td>
  <td><button class="w3-button w3-dark-grey">BUY  <i class="fa fa-arrow-right"></i></button></td>
</tr>
<tr>
  <td>V: 10 W: 20 A: 1 K:3</td>
  <td>$10</td>
  <td><button class="w3-button w3-dark-grey">BUY  <i class="fa fa-arrow-right"></i></button></td>
</tr>
<tr>
  <td>V: 10 W: 20 A: 1 K:3</td>
  <td>$10</td>
  <td><button class="w3-button w3-dark-grey">BUY  <i class="fa fa-arrow-right"></i></button></td>
</tr>
*/
