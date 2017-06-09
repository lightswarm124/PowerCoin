(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){

console.log('Included');
// var socket = io();
// var _latestReadings = new CircularBuffer(7);
// socket.on('meter_data', processMeterData);
//
// function processMeterData(data) {
// 	updateMarketData(data);
// }
//
// function updateMarketData(data) {
// 	_latestReadings.enq(data);
// 	var readings = _latestReadings.toarray();
// 	console.log('mapping');
// 	readings = readings.map(function(a) {
// 		var timestamp = a.timestamp.toString();
// 		var timestampMoment = moment(timestamp, 'x')
// 		var current = moment();
// 		a.timestamp_text = current.diff(timestampMoment, 'seconds') + ' seconds ago';
// 		return a;
// 	})
// 	var template = '{{#readings}}<tr><td>V:{{volt}} W:{{watt}} A:{{amps}} K:{{kwh}}</td><td>$10</td><td><button class="w3-button w3-dark-grey">BUY  <i class="fa fa-arrow-right"></i></button</td></tr>{{/readings}}'
// 	document.getElementById('market_data').innerHTML = Mustache.render(template, {readings : readings});
//
// }

},{}]},{},[1]);
