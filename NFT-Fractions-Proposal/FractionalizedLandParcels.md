# Fractionalized Land Parcels

Fractionalized digital land parcels create the opportunity for collective/cooperative licensing of Geo Web land parcels and open up the market for (high-value) land parcels to a wider audience. We will implement this functionality in an ongoing integration with the [NIFTEX platform](https://landing.niftex.com/). 

## Current Status

Both the Geo Web and NIFTEX are early in the development of their respective platforms. This is an exploratory proposal and will necessarily evolve as the platforms mature and community requirements are identified.

## Use Cases

Collective licensing of digital land parcels is a primitive on which the Geo Web community can utilize across a host of use cases. Some initial ideas and motivations include:

* Community ownership of public lands such as parks, nature preserves, historical monuments, etc.
* Multi-tenant buildings
* Cooperative ownership of high-traffic areas (compete in SALSA land market vs. potential larger commercial licensors)
* DAOs
* Generative content creation and placement

## Integration

### Licensor View

* In addition to the base “Edit” functionality, current licensors can initiate a “Fractionalize Parcel'' function. This is implemented as a native integration of NIFTEX on the Geo Web Cadastre.

### Fractionalize Function

* Full explanation of the fractionalization process, fees, best practices, & FAQ is found under “How does this work?”
* The Licensor enters the following required fields for fractionalizing their parcel:
  * Shard Name - Required for NIFTEX & potential future trading (not used on Cadastre)
  * Shard Ticker - Required for NIFTEX & potential future trading (not used on Cadastre)
  * Shards to Issue - Number of shards the licensor wants to create
  * Shards Kept by You - Number of shards the licensor will retain: 1% will go to NIFTEX & remainder are put up for sale
  * Price Per Shard - Must be calculated for integration with SALSA. It is calculated by dividing the current For Sale Price by the number of shards issued.
* The Geo Web limits Network Fee prepayment to 2 years maximum. It will be best practice for a Licensor to prepay the maximum Network Fees to maximize PPS & For Sale Price appreciation.
* Digital land prices on the Geo Web are calculated in DAI. NIFTEX uses ETH. An oracle implemented if NIFTEX can’t/doesn’t wish to implement stablecoin functionality.
* NIFTEX requires the following fields not shown on the Cadastre. They will be populated in the background:
  * Choose Network: Matic or Ethereum Mainnet
    * Geo Web = Ethereum Mainnet
  * OpenSea URL:
    * Geo Web = Alternative Identification
  * Is the NFT an artwork?
    * Geo Web = No

### Fractionalize Parcel

* Once a parcel is fractionalized, the Parcel Detail View will look like the mockup shown above.
* The Initiate Buyout function initiates a forced transfer of all outstanding shards by paying the For Sale Price (See Notes & Outstanding Items for additional information on the interaction between SALSA and NIFTEX’s Buyout Clause

### Buying Shards

* Any user can buy outstanding shards of a land parcel for the current price.
* Proceeds from the sale and any “Additional Network Fee Payments” are first applied directly to extending the expiration date of the land parcel. Once the maximum of two years is reached, the remaining fees are applied to increasing the “For Sale Price” of the land parcel. For example:
  * A parcel is currently valued at 100 DAI with a 15 DAI Network Fee Balance. 
  * 100 shards were created resulting in an initial 1 DAI PPS. 
  * A new user buys the 10 outstanding shards.
  * 5 DAI of the purchase price is applied to Network Fees (20 DAI = 2 years fees at 10%)
  * 5 DAI is applied to increase the For Sale Price (while attributing proportional fees to keep the Network Fee Balance = 2 Years)
    * New For Sale Price = 125
    * New Network Fee Balance = 25 DAI
  * Note: The initial licensor benefits from sale of shards via extended parcel expiration dates and increasing For Sale Price (and PPS) rather than direct sales proceeds.
* Methods for managing ongoing Network Fees and For Sale Price should be implemented once all shards have been sold must be implemented. 
  * E.g. Shard owners may be required to pay a proportion of Network Fees if the balance drops below a threshold or forfeit their shards.

## Notes and Outstanding Items
* NIFTEX currently expects NFTs to be on OpenSea. OpenSea doesn’t currently support the Geo Web’s SALSA market requirements, so digital land parcels will not be listed on OpenSea initially. Geo Web NFTs should be identified via a stand alone means.
* In the current NIFTEX fractionalization process, a smart contract takes custody of the NFT. This precludes licensors from anchoring content to the parcel. This means fractionalized parcels would effectively function as “open spaces” (a valid use case). NIFTEX is exploring on-chain processes that would allow a builder to be appointed for the parcel and enable other use cases.
* Additional design and functionality for the interaction between NIFTEX’s “Buyout Clause” and the Geo Web’s SALSA “For Sale Price” must be explored. In the Buyout Clause, current owners have the ability to reject an offer for buyout in a two week period. In a SALSA market, a prospective buyout is forced by paying an explicit price. Waiting periods, “freeloading” licensors, and licensor valuation differentials should be considered for an implementation that blends the best of both methods.
* Governance functionality (voting, proportional fee payments, collaborative content placement, etc.) should be explored to enable more complex forms of cooperative digital land ownership.
