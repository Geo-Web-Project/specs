# 2021 Geo Web Roadmap Epics

## Build a simple Geo Web browser (Q1 2021)

**Description:** Create an application/website accessible from a smartphone that resolves parcel-level content based on the user’s current location. This initial implementation can assume mapping of geolocation to a single Geo Web parcel to a single linked document. The document contents should render within the browser upon initial load and significant user movement.

Leveraging existing tools, assets, and standards is advantageous for our development speed, for content publishers/creators, and for users, so existing web standards should be used whenever feasible. Ideally, the browser should be able to resolve modern web pages, but also switch to an augmented reality view (non-point anchored).

**Why:** A browser that leverages user location for content resolution demonstrates the novel user experience that the Geo Web enables. It shows how Geo Web content and use cases differ from the traditional web. Even though spoofing will be possible, the cause and effect of moving from one parcel to another starts to establish the concept of digital rights in the physical world. This is important to attract new landowners, users, and developers. 

This item is proposed for pre-production launch because of its potential impact on user understanding and value of the network relative to its complexity and development time requirements.

**References:** [Pilgrimage](https://github.com/nurecas/pilgrimage) by [Fabin Rasheed](https://twitter.com/fabinrasheed) is a good reference implementation for the targeted user experience for this browser. Fabin’s implementation uses a [web app](https://nurecas.github.io/pilgrimage/) accessible from a mobile web browser to render content if the user is within 2km of any of his 9 geo-anchored pieces of art. It included the ability to see a 3D model of the art in the web page, but also switch to a camera view to render the art as AR. Fabin’s overview of the project can be found [here](https://nurecas.com/pilgrimage).

* [Anchoring Index](https://github.com/nurecas/pilgrimage/blob/master/index.html)
* [Geolocation API](https://www.w3schools.com/html/html5_geolocation.asp)
* [Model Viewer](https://modelviewer.dev/)
* [three.js](https://threejs.org/)

## Onboard beta network creators and contributors (Now to ∞)

**Description:** Recruit and engage artists, creators, and contributors to utilize the Geo Web testnet. Explore use cases, encourage experimentation, and gather user feedback.

Build a catalog of content for the Geo Web to seed the network at production launch.

**Why:** While the network economics and flywheel can’t be tested without real money involved, the browsing user experience on testnet can effectively be the same. Creators can experiment with the Geo Web on testnet infrastructure with zero/little cost.

## Implement production smart contracts (Q2 2021)

**Description:** Explore and potentially implement an L2, side chain, or scalable solution that allows us to have relatively cheap transactions (<$10/residential parcel) at a grid size of ~10sqft per Geo Web coordinate.  Fast transaction confirmations will be a huge plus, but are not a make or break requirement. 

A reputable stablecoin should be the currency in which transactions are denominated to avoid external volatility unnecessarily affecting land parcel prices. Transaction fees paid for with the same stablecoin would also be highly advantageous.

The chosen solution should minimize long-term lock-in especially when it comes to future security needs as the Geo Web grows in importance and value.

**Why:** Currently, Ethereum L1 transactions are too expensive, size constrained, and slow to support the user experience that we want for the Geo Web. Our current Kovan testnet land grid is orders of magnitude greater than we’d want in a production implementation.

We do not want to stray too far from Ethereum because of its great long-term sustainability, security, and ecosystem, but we likely can’t wait on ETH2, roll-ups, and other scaling solutions to be implemented before we launch the Geo Web.

## Complete a security audit (Q2 2021)

**Description:** Get a second (third, or nth) set of eyes on our smart contracts before we start transacting in real money. There’s no buzzkill like betraying your users’ trust by losing their assets.

Our code is pretty vanilla relative to DeFi swaps, bonding curves, etc, but in addition to a general security review, there are several areas which we should examine carefully:

Front-running of land claims & transfers
Manipulation of self-assessed values & network fees
Network fee treasury security

**Why:** Security is important. An audit is a strong signal for potential adopters/land investors and likely table stakes for any significant money flow. We don’t want to become (in)famous for the wrong reasons.

## Launch the production network

**Description:** Migrate all tested smart contract code and supporting infrastructure to our production network/environments. This effort also calls for supporting updates to the Cadastre and Geo Web browser to enable production/testnet modes with corresponding UX affordances.

The production treasury for network fees should be minimally controlled by a DAO or multi-sig consisting of Cody and Graven.

We should also market the shit out of this milestone.

**Why:** While not likely to be a big splash launch, this marks an important step in the Geo Web’s development. Actual money is at stake and ownership feels more “real.”

## Integrate Filecoin storage

**Description:** Integrate the Filecoin network as a persistent storage option for Geo Web landowners/publishers. This can start with the Geo Web picking up the storage tab for a small amount of data per parcel. It should transition to individual payment and management in the long-term as the Filecoin network and ecosystem integrations (like Metamask) mature to make it easier for users to transact.

**Why:** Distributed, sustainable, and scalable storage of Geo Web content is a must. We plan to leverage IPFS for it’s p2p capabilities and strong ecosystem, but an incentive layer is needed to persist data at scale. Protocol Labs has a [strong grant program](https://github.com/filecoin-project/devgrants#submit-a-proposal-for-open-grants) that could help fund this work and support Geo Web adoption.

## Make UX improvements for parcel ownership

**Description:** Enable claims of non-rectangular shaped parcels and implement management functions that more closely reflect physical land transactions.

The Cadastre should allow the user to select contiguous Geo Web coordinates with serial/multi-select function. The UI should still order coordinates in a way that makes it easy for the smart contracts to validate a valid coordinate path. Digital land licensors should also be able to merge and split contiguous land parcels according to their needs.

We should also explore implementation of periodic SALSA auctions (e.g. monthly) rather than continuous auctions to better align with the speed at which physical land control changes hands.

**Why:** Our digital land needs to be able to mirror the irregular shapes of physical land parcels with reasonable fidelity. This will become increasingly important as geo-anchored augmented reality content becomes more prevalent and valuable.

One of the most common feedback items we encounter is fear of digital land being bought out from under the current licensor without warning. SALSA is a radical idea that will take getting used to, but shifting to a monthly auction could help soften the shock and discourage “attacks” on short-term event/festival/conference spaces.

## Network fee distribution governance

**Description:** Maturation of our network governance will be a continual march toward more transparency, wider engagement, and an eventual exit to the community. Post-launch and with accumulation of any network fees, we’ll need to implement formal off-chain or DAO-based mechanisms to distribute network funds to core developers, creators, users, and any other stakeholder helping grow the network in a way that is consistent with our project values.

Initial governance will likely consist of a membership DAO of Cody & Graven. Before distributing network funds, we should implement credibly neutral on-ramps for the DAO and to have a vote in allocating the funds.

Development and technical decisions being made at this point will likely still be closer to benevolent dictator style decisions, but categorical financial allocations (x% to developers, y% to creators, etc.) lend themselves to wider engagement of stakeholders.

**Why:** We want to begin the process of exit-to-community sooner rather than later. Creating mechanisms for participation in financial decisions will encourage governance participation (easier to understand, everyone naturally has an opinion, etc.) and help establish community trust.

## Improved content anchoring capabilities

**Description:** Add intra-parcel anchoring, new Ceramic doc templates, and NFT capabilities to the Geo Web’s content linking options. The Geo Web’s core infrastructure is designed to be agnostic to the content being linked, allowing standards, norms, and tools to be innovated independently, but we need to show the way.

**Why:** Intra-parcel anchoring is required for geospatial augmented reality and other next gen use cases. Every additional Ceramic document template makes it easier for the next developer, land licensor, and user to link and resolve new content. Native NFT linking and NFT ownership of NFTs (i.e. the land owning the content) create interesting value propositions and land appreciation opportunities.

## App-based browser

**Description:** Create a native app for the major hardware/OSs to browse the Geo Web. There are significant advantages to having a native app on today’s smartphones (better tooling, performance, etc.), but it will likely be a requirement for smart glasses usage. We do not want to hold a monopoly on development of Geo Web browsers, but developing the first iterations will be required.

**Why:** We need the performance, functionality, and UX advantages associated with native apps vs a piggy-backed web implementation. If smartglasses are paired with/offload computation to smartphones in their early days of mass adoption, they’ll almost assuredly rely on functionality only available to native applications.
