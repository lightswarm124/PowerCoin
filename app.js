var express = require('express');
var app = express();
var http = require('http').Server(app);




var io = require('socket.io')(http);

app.get('/', function(req, res){
  res.sendfile('index.html');
});

app.use(express.static('public'));

//Whenever someone connects this gets executed
io.on('connection', function(socket){
  console.log('A user connected');
  setInterval(function(){
	  	//Sending an object when emmiting an event
		volt = Math.floor((Math.random() * 220) + 1);
		watt = Math.floor((Math.random() * 110) + 1);
		amps = Math.round(watt/ volt * 100)/100 ;
		socket.emit('meter_data', {
			volt : volt,
			watt : watt,
			amps : amps,
			kwh : Math.floor((Math.random() * 10) + 1),
			timestamp : new Date()/1
		});
    }, 4000);
  socket.on('disconnect', function () {
    console.log('A user disconnected');
  });

  //Whenever someone disconnects this piece of code executed
  socket.on('disconnect', function () {
    console.log('A user disconnected');
  });

});

http.listen(3000, function(){
  console.log('listening on *:3000');
});
