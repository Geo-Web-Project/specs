# Harberger Smart Contract v0.1

## Overview

The Harberger Smart Contract is the mechanism by which land ownership in the Geo Web Registry is administered.

It maintains an owner-assessed value for parcels of land from the registry and carries out two basic fuctions:

- Calculating, assessing, and collecting a "tax" on each parcel of land (Owner-Assessed Value x 10% Tax Rate)
- Facilitates transfers of land parcels from the current owner to any entity willing to pay the owner's self-assessed price

## Goals

The initial version of this specification is focused on demonstrating the basic functions of the Harberger system, but in isolation from the Geo Web Registry. The minimum requirements are:

-Maintain a set list of digital land parcels (geohashes) along with their respective owners (Ethereum address) and owner-assessed values (price in Eth)
-Allow an entity (Ethereum address) to "purchase" a land parcel for the current self-assessed value (if zero or null then no payment transfer is required) and set a new one
-Collect a periodic tax payments from owners based on their self-assessed land values in batch and send them to an admin address

## Get Owner

An owner of a parcel of land is defined as some Ethereum account. This can be an externally owned account (EOA) or smart contract.

The specification does not currently include more extensive forms of identity.

```
function owner(uint256 geohash) external view returns (address owner);
```

## Get Value

Each parcel of land that has an owner has a owner-assessed value. The value is represented in wei and is used as the basis for tax caluclations and land transfers.

```
function value(uint256 geohash) external view returns (uinit256 value);
```

## Purchase Land

A land parcel may be purchased by any Ethereum account by paying the owner-assessed value to the current owner. Eth is transferred from the purchaser's wallet to the seller's wallet and the new owner sets a new owner-assessed value. Land parcels without a current owner may be purchased with no initial payment. 

```
function purchase(uint256 geohash, address owner, float value);
```

Add ability for a new land owner to stake 10% of new owner-assessed value at time of purchase to be drawn down in tax payments. The previous owner's stake should be returned at time of transfer.

## Collect Tax

On a nightly basis, calculate and collect tax payments for claimed land parcels from their current owners. The tax should be calculated as 10%/365 * Owner-Assessed Value. Eth payment should collected from the owner's wallet and sent to an admin wallet. This initial batch approach means that taxes on parcels transferred during the day will be attributed only to the new owner.

## Roadmap

- Allow owners to update self-assessed values of land parcels (without purchased land from themselves)
- Integrate with Geo Web Registry
- Enhanced tax collection and calculation (monthly tax collection; mid-period changes in owner-assessed values and transfers)
- Add mechanisms and flow for resolving non-payment of taxes/insuficient funds and re-staking
- Auctions for unclaimed land
- Enhanced forms of identity
- Allow owner-assessed values in dollars (payment still in Eth)
- Allow owners to combine land parcels
