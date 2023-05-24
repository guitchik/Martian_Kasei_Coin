pragma solidity ^0.5.0;

import "./KaseiCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";


// Have the KaseiCoinCrowdsale contract inherit the following OpenZeppelin:
// * Crowdsale
// * MintedCrowdsale
contract KaseiCoinCrowdsale is Crowdsale, MintedCrowdsale { // UPDATED CONTRACT SIGNATURE TO ADD INHERITANCE
    
    constructor(
        uint256 rate, // Rate of the crowdsale
        address payable wallet, // Wallet address where funds are collected
        KaseiCoin token // Token contract address
    )
        public
        Crowdsale(rate, wallet, token)
    {
        // constructor can stay empty
    }
}

contract KaseiCoinCrowdsaleDeployer {
    address public kasei_token_address; // Create an `address public` variable called `kasei_token_address`.
    address public kasei_crowdsale_address; // Create an `address public` variable called `kasei_crowdsale_address`.

    constructor(uint256 rate, address payable wallet) public {
        // Create a new instance of the KaseiCoin contract.
        KaseiCoin token = new KaseiCoin();

        // Assign the token contract’s address to the `kasei_token_address` variable.
        kasei_token_address = address(token);

        // Create a new instance of the `KaseiCoinCrowdsale` contract
        KaseiCoinCrowdsale crowdsale = new KaseiCoinCrowdsale(rate, wallet, token);

        // Assign the `KaseiCoinCrowdsale` contract’s address to the `kasei_crowdsale_address` variable.
        kasei_crowdsale_address = address(crowdsale);

        // Set the `KaseiCoinCrowdsale` contract as a minter
        token.addMinter(kasei_crowdsale_address);

        // Have the `KaseiCoinCrowdsaleDeployer` renounce its minter role.
        token.renounceMinter();
    }
}
