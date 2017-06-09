console.log('Included');
var socket = io();
<<<<<<< HEAD
socket.on('meter_data', processMeterData);

function processMeterData(data) {
	console.log(data);
=======
var _latestReadings = new CircularBuffer(7);
socket.on('meter_data', processMeterData);

function processMeterData(data) {
	updateReadings(data);
	updateLatestReadingsTable(data);

}

function updateReadings(data) {
>>>>>>> ui
	var volts = data.volt;
	var watts = data.watt;
	var amps = data.amps;
	var kwh = data.kwh;
	document.getElementById("volt_reading").innerHTML = volts;
	document.getElementById("watt_reading").innerHTML = watts;
	document.getElementById("amps_reading").innerHTML = amps;
	document.getElementById("kwh_reading").innerHTML = kwh;
<<<<<<< HEAD
	console.log("displaying");

}
=======
}

function updateLatestReadingsTable(data) {
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
	var template = '{{#readings}}<tr><td><i class="fa fa-laptop w3-text-red w3-large">{{kwh}} kwh</i></td><td>{{timestamp_text}}</td></tr>{{/readings}}'
	document.getElementById('latestReadings').innerHTML = Mustache.render(template, {readings : readings});

}

/*
<tr>
  <td><i class="fa fa-laptop w3-text-red w3-large"></i></td>
  <td>New record, over 90 views.</td>
  <td><i>10 mins</i></td>
</tr>
<tr>
  <td><i class="fa fa-laptop w3-text-red w3-large"></i></td>
  <td>Database error.</td>
  <td><i>15 mins</i></td>
</tr>
<tr>
  <td><i class="fa fa-laptop w3-text-red w3-large"></i></td>
  <td>New record, over 40 users.</td>
  <td><i>17 mins</i></td>
</tr>
<tr>
  <td><i class="fa fa-laptop w3-text-red w3-large"></i></td>
  <td>New comments.</td>
  <td><i>25 mins</i></td>
</tr>
<tr>
  <td><i class="fa fa-laptop w3-text-red w3-large"></i></td>
  <td>Check transactions.</td>
  <td><i>28 mins</i></td>
</tr>
<tr>
  <td><i class="fa fa-laptop w3-text-red w3-large"></i></td>
  <td>CPU overload.</td>
  <td><i>35 mins</i></td>
</tr>
<tr>
  <td><i class="fa fa-laptop w3-text-red w3-large"></i></td>
  <td>New shares.</td>
  <td><i>39 mins</i></td>
</tr>
*/
>>>>>>> ui
