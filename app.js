var express = require('express');
var app = express();
var http = require('http').Server(app);
var _ = require('underscore');
var PCM = require('./build/contracts/PowerCoinMeter.sol');
var pcm = PCM.deployed();
console.log(pcm.address);

var accounts = require('./accounts.js')
var test_accounts = require('./test_accounts.json');
console.log(test_accounts);


var rpcURL = '127.0.0.1';
//
var Web3 = require('web3');
var web3 = new Web3();
web3.setProvider(new web3.providers.HttpProvider('http://localhost:8545'));
PCM.setProvider(web3.currentProvider);
//
var io = require('socket.io')(http);

app.get('/', function(req, res){
  res.sendFile('public/index.html' , { root : __dirname});
});

app.use(express.static('public'));

function generatePower() {
    var volt = Math.floor((Math.random() * 220) + 1);
    var watt = Math.floor((Math.random() * 110) + 1);
    var amps = Math.round(watt/ volt * 100)/100 ;
    var kwh = Math.floor((Math.random() * 10) + 1);
    return {
        volt : volt,
        watt : watt,
        amps : amps,
        kwh : kwh
    };
}


var nonce = 0;


pcm.changePowerPrice(20, {from : web3.eth.accounts[0]})


//updateReading();

// Whenever someone connects this gets executed
io.on('connection', function(socket){
  console.log('A user connected');

  function updateReading() {
      var nonce = 0;
      var current = _.now();
      var power = generatePower();
      console.log('Generating new power', power.kwh);
      pcm.updateReading(nonce++, _.now(), power.kwh, { from : web3.eth.accounts[0]}).then(function(tx) {
        socket.emit('meter_data', {
            volt : power.volt,
            watt : power.watt,
            amps : power.amps,
            kwh : power.kwh,
            timestamp : new Date()/1
        });
            _.delay(updateReading, 4000);
      }).catch(console.log);
  }


  updateReading();
  //Whenever someone disconnects this piece of code executed
  socket.on('disconnect', function () {
    console.log('A user disconnected');
  });

});

http.listen(3000, function(){
  console.log('listening on *:3000');
});
