pragma solidity ^0.4.8;

contract Node {
    address public manager;
    Metering public metering;

    function Node (Metering _metering) {
        manager = msg.sender;
        metering = _metering;
    }

    function transferManager (address _manager) {
        if (msg.sender != manager) throw;
        manager = _manager;
    }

    function transferMetering (Metering _newMeter) {
        if (msg.sender != manager) throw;
        if (metering.meters(this).last_reading_value() == 0) throw;
        metering = _newMeter;
    }
}
