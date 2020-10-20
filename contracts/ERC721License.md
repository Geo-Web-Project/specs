# ERC721License

The `ERC721License` contract is responsible for managing the ownership of licenses that allow the anchoring of digital content to land parcels. It is mostly [ERC721](http://erc721.org)-compliant, except for not allowing owners to approve any account to transfer licenses on their behalf.

## Token Identifiers

Token identifiers must be a parcel ID taken from the [GeoWebParcel](./GeoWebParcel.md) contract.

## Minting and Burning

Minting and burning tokens is allowed only by some external account. This account is the [GeoWebAdmin](./GeoWebAdmin.md) contract.

## Transfers

Transfers are only allowed by token owners and some external admin account ([GeoWebAdmin](./GeoWebAdmin.md)). The owner is not allowed to approve transfers to be done by another account (like decentralized exchanges).

This allows users to transfer tokens between their own wallets and the [GeoWebAdmin](./GeoWebAdmin.md) to process transfers based on the Harberger Tax mechanism.

## Content Anchoring

The owner of a license is granted one simple permission: to attach content to a land parcel.

This content is represented as a [Ceramic Document Identifier](https://github.com/ceramicnetwork/specs#document-identifiers), which is a CID.

A CID is stored as a byte array of the following format:

```
<cid-version><multicodec-content-type><multihash-content-address>
```

```
function setContent(uint256 tokenId, bytes ceramicDocId) external onlyTokenOwner;

function removeContent(uint256 tokenId) external onlyTokenOwner;
```

**Note**: There are ongoing discussions with Ceramic about an NFT being an owner of a document. This may move the responsibility of setting content up a layer to Ceramic. Attaching a Ceramic doc may only be needed when minting the license for the first time and not also when the license changes owners, saving on gas. 