pragma solidity ^0.4.8;

//import "./utils/Meter.sol";
import "./tools/SafeMath.sol";

contract PowerDelivery {
    address public powerProducer;
    Consumers[] public powerConsumers;

    // Data feed metadata
    uint256 public last_reading_nonce;
	uint256 public last_reading_time;

    // Block times
	uint256 public time_start;				// starting time of delivery
	uint256 public time_end;				// end time of delivery

    // Commitment
    // uint256 public total_power_supply;   // Total Power (Wh) covered by contract
    uint256 public powerSupply;

    // Pricing
    uint256 public sell_price;
    uint256 public pay_amount;

    struct Consumers {
        address consumerID;
        uint256 demandAmount;
        uint256 timeDuration;
        bool active;
    }

    function PowerDelivery (uint256 _powerSupply, uint256 _price) {
        msg.sender = powerProducer;
        powerSupply = _powerSupply;
        sell_price = _price
    }

    // @Dev _price is set in Wei (10^-18 ETH)
    function changePowerPrice (uint256 _price) {
        if (msg.sender != powerProducer) throw;
        // Wei / khW
        sell_price = _price;
    }

    function buyConsumedPower (uint256 _timeDuration, uint256 _powerConsumed) {
        // Set time interval for buying power
        if (_powerConsumed > powerSupply || ) throw;

        pay_amount = safeMul (_powerConsumed, sell_price);

        // @Dev Attempt to pay powerProducer
        if (powerProducer.send(pay_amount)) {
            powerConsumers.timeDuration = safeAdd (now, _timeDuration);
            powerSupply -= _powerConsumed;
        } else {
            throw;
        }
    }
}
