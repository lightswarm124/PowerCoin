pragma solidity ^0.4.8;

import "./tools/SafeMath.sol";

contract Meter is SafeMath {
    address public meterOwner;
    mapping (address => Consumers) powerConsumers;

    // @Dev Info on data interval
    uint256 public last_reading_nonce;
    uint256 public last_reading_time;

    // @Dev Use Power Production (Supply) and Consumption (Demand)
    uint256 public powerSupply;

    // Pricing
    uint256 public sell_price;
    uint256 public pay_amount;

    struct Consumers {
        uint256 demandAmount;
        uint256 timeDuration;
        bool active;
    }

    // @Dev "_initial_value" takes input from existing
    function Meter (uint256 _initial_nonce) {
        meterOwner = msg.sender;
        last_reading_nonce = _initial_nonce;
        last_reading_time = now;
        powerSupply = 0;
    }

    function buyConsumedPower (uint256 _timeDuration, uint256 _powerConsumed) {
        // Set time interval for buying power
        if (_powerConsumed > powerSupply
            || powerConsumers[msg.sender].timeDuration > now) throw;

        pay_amount = safeMul (_powerConsumed, sell_price);

        // @Dev Attempt to pay powerProducer
        if (powerProducer.send(pay_amount)) {
            powerConsumers.timeDuration = safeAdd (now, _timeDuration);
            powerSupply = safeSub(powerSupply, _powerConsumed);
        } else {
            throw;
        }
    }

    function changePowerPrice (uint256 _price) {
        if (msg.sender != meterOwner) throw;
        // Wei / khW
        sell_price = _price;
    }

    function updateReading (uint256 _nonce, uint256 _time, uint256 _add_production) {
        if (msg.sender != meterOwner
            || _nonce < last_reading_nonce) throw;

        powerSupply += _add_production;
        last_reading_nonce = _nonce;
        last_reading_time = _time;
    }

    // @Dev _price is set in Wei (10^-18 ETH)
    function changePrice (uint256 _price) {
        // Wei / khW
        sell_price = _price;
    }

    function get_powerSupply () constant returns (uint256) {
        return powerSupply;
    }

    // @Dev Return ETH sent to contract address
    function () {
        throw;
    }
}
