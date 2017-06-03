var SerialPort = require("serialport");
var port = new SerialPort("COM3", {
  baudRate: 9600
});
port.on('data', function(data) {
  console.log('' + data);
});
