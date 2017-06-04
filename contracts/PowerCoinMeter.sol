pragma solidity ^0.4.8;

contract SafeMath {

    function safeMul(uint a, uint b) constant internal returns(uint) {
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function safeSub(uint a, uint b) constant internal returns(uint) {
        assert(b <= a);
        return a - b;
    }

    function safeAdd(uint a, uint b) constant internal returns(uint) {
        uint c = a + b;
        assert(c >= a && c >= b);
        return c;
    }
/*
    function safeDiv(uint a, uint b) constant internal returns (uint) {
        assert(b > 0);
        uint c = a / b;
        assert(a == b * c + a % b);
        return c;
    }
*/
    function assert(bool assertion) internal {
        if(!assertion) throw;
    }
}

contract PowerCoinPowMeter is SafeMath {
    address public meterOwner;
    mapping(address => Consumers) powerConsumers;

    // @Dev     Info on data interval
    // @Dev     *NOTE* Not sure if needed
    uint256 public last_reading_nonce;
    uint256 public last_reading_time;

    // @Dev     Use Power Production (Supply) and Consumption (Demand)
    uint256 public powerSupply;

    // Pricing
    uint256 public sell_price;
    uint256 public pay_amount;

    struct Consumers {
        uint256 demandAmount;
        uint256 timeDuration;
    }

    // @Dev     Constructor function to set up meter
    function Meter(uint256 _initial_nonce) {
        meterOwner = msg.sender;
        last_reading_nonce = _initial_nonce;
        last_reading_time = now;
        powerSupply = 0;
        sell_price = 0
    }

    function buyConsumedPower(uint256 _timeDuration, uint256 _powerConsumed) {
        if(_powerConsumed > powerSupply
            || powerConsumers[msg.sender].timeDuration > now
            || sell_price <= 0 ) throw;

        pay_amount = safeMul(_powerConsumed, sell_price);

        // @Dev     Attempt to pay powerProducer
        if(meterOwner.send(pay_amount)) {
            powerConsumers[msg.sender].timeDuration = safeAdd(now, _timeDuration);
            powerSupply = safeSub(powerSupply, _powerConsumed);
        } else {
            throw;
        }
    }

    // @Dev     Set new electricity price (Wei / kwH)
    // @Dev     Only allow owner to change set price
    function changePowerPrice(uint256 _price) {
        if(msg.sender != meterOwner) throw;
        sell_price = _price;
    }

    // @Dev     Update power supply from data feed
    // @Param1  Nonce value for each update call
    // @Param2  Update time (either block time or real time)
    // @Param3  New electricity production in time interval
    function updateReading(uint256 _nonce, uint256 _time, uint256 _add_production) {
        if(msg.sender != meterOwner
            || _nonce <= last_reading_nonce) throw;

        powerSupply = safeAdd(powerSupply, _add_production);
        last_reading_nonce = _nonce;
        last_reading_time = _time;
    }

    // @Dev     Check supply of available power for sale
    function get_powerSupply() constant returns(uint256) {
        return powerSupply;
    }

    // @Dev     Existing owner choose new owner
    // @Param1  Designate new owner
    function changeMeterOwner(address _newMeterOwner) {
        if(msg.sender != meterOwner) throw;
        meterOwner = _newMeterOwner;
    }

    // @Dev     Throw out non-function calls
    function() {
        throw;
    }
}
