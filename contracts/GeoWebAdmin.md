# GeoWebAdmin

The `GeoWebAdmin` contract is the core administrative layer of the Geo Web and is responsible for:

- Setting and collecting license fees
- Tracking when licenses expire and get put up for auction
- Authorizing the transfer of licenses on the event of a sale
- Authorizing the initial claiming/minting of land parcels and licenses

## License Structure

The smart contract stores a small piece of state about each license that includes the value of the license the holder has set and the time at which the license will expire if no additional fees are paid.

```
struct License {
    uint256 value
    uint256 expirationTimestamp
}
```

## Approving Fees

The first step needed before interacting with the contract is to authorize the contract to withdraw fees from the user's wallet. This is needed to claim land, purchase land, or pay license fees.

The user needs to grant approval of the transfer of DAI to the contract.

## Claiming a License

Claiming a license will mint a new land parcel, mint the corresponding license, and grant control to the claimant. The claimant also needs to set the initial value and pay an initial license fee.

The contract must ensure that none of the geohashes in the land claim are currently part of another license that is not expired or currently in an auction. In addition, claims are only valid if:

- `initialValue` >= 10 DAI
- Resulting expiration date is >= 1 year and <= 2 years

```
function claim(uint256 baseGeohash, Direction[] memory path, uint256 initialValue, uint256 initialFeePayment) public;
```

## Purchasing a License

Since all licenses are always for sale, anyone may purchase an existing license at its set value. They must also set a new value and optionally pay additional license fees on top of the current remaining prepaid license fee balance.

Purchases are only valid if:
- New value >= 10 DAI
- Resulting expiration date is >= 2 weeks and <= 2 years

The sender is responsible for paying the current value of the license + the current remaining prepaid license fee balance, up to `maxPurchasePrice`. The `maxPurchasePrice` protects against attacks where the license holder quickly changes the value or fees paid before a buyer's transaction makes it into a block.

```
function purchaseLicense(uint256 identifier, uint256 maxPurchasePrice, uint256 newValue, uint256 additionalFeePayment) public;
```

## Paying License Fees

Additional license fee payments can be made at any time. This will push out the expiration date according to the tax rate and current value.

A license fee payment is valid if:
- Resulting expiration date is >= 2 weeks and <= 2 years

```
function payLicenseFee(uint256 identifier, uint256 amount) public onlyLicenseHolder;
```

## Changing a License Value

The holder of a license can change the value at any time. This will adjust the expiration date accordingly. The license holder can also send an additional fee payment in the same transaction if needed.

A change in value is valid if:
- New value >= 10 DAI
- Resulting expiration date is >= 2 weeks 

The holder may choose to drop the value to an amount where the expiration date would go beyond 2 years. However, the expiration date will not be extended beyond 2 years and the holder will lose those fees that have already been paid.

```
function updateValue(uint256 identifier, uint256 newValue, uint256 additionalFeePayment) public onlyLicenseHolder;
```

## Auctions

Once the expiration date passes for a license, it will be put up for a Dutch auction. The price will slowly decrease over a set period of time until reaching zero. Anyone may purchase the license for the given price at any point in time.

Purchasing a license in an auction is done using the same function as purchasing a license when there is no auction. The contract will automatically pro-rate the value of the license based on the amount of time that has passed since the expiration date. The purchase price is still rewarded to the previous holder.

If the auction period elapses without the license being purchased, each piece of the land becomes eligible for re-claiming into a new land parcel and license.