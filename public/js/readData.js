console.log('Included');
var socket = io();
socket.on('meter_data', processMeterData);

function processMeterData(data) {
	console.log(data);
	var volts = data.volt;
	var watts = data.watt;
	var amps = data.amps;
	var kwh = data.kwh;
	document.getElementById("volt_reading").innerHTML = volts;
	document.getElementById("watt_reading").innerHTML = watts;
	document.getElementById("amps_reading").innerHTML = amps;
	document.getElementById("kwh_reading").innerHTML = kwh;
	console.log("displaying");

}
