pragma solidity ^0.4.8;

contract Meter {
    // @Dev "owner" is the Meter in question
    address public owner;
    // @Dev Value reflects power production (-) consumption
    bool public electricity_feed_in;

    uint256 public last_reading_value;
    uint256 public last_reading_time;

    uint256 public power_production;
    uint256 public power_consumption;

    // @Dev "_initial_value" takes input from existing
    function Meter (uint256 _initial_value) {
        owner = msg.sender;
        last_reading_value = _initial_value;
        last_reading_time = now;
        power_production = 0;
        power_consumption = 0;
    }

    function setFeedIn (bool _is_feeding) {
        if (msg.sender != owner) throw;
        electricity_feed_in = _is_feeding;
    }

    function updateReading (uint256 _value, uint256 _time, uint256 _add_production, uint256 _add_cconsumption) {
        //if(Metering(msg.sender)!=metering) throw;
        if (msg.sender != owner) throw;
        if (_time < last_reading_time) throw;
        if (_value < last_reading_value) throw;

        power_production += add_production;
        power_consumption += add_consumption;
        last_reading_value = value;
        last_reading_time = time;
    }

    function addPowerDebit (uint256 add_production) {
        if (msg.sender != owner) throw;
        power_production += add_production;
    }

    // @Dev Return ETH sent to contract address
    function () {
        throw;
    }
}
