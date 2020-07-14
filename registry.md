# Geo Web Registry v0.1

## Overview

The Geo Web Registry is a mapping of some physical parcel of land to an owner and some piece of digital content.

```
Parcel of Land -> (Owner, Digital Content)
```

The owner controls what digital content corresponds to their land at the time of purchasing.

## Goals

The initial version of this specification is focused on delivering a working prototype for the [HackFS](https://hackfs.com) hackathon. The minimum requirements are:

- Define a mechanism for representing land
- Land can be claimed by an entity
- Digital content can be attached to land when claimed

## Land

At the core of the registry is how land is defined. This subtle, yet important, aspect of the registry is what the entire Geo Web depends upon. Improper or arbitrary definitions of land may result in ownership conflicts and inhibit the adoption of the Geo Web.

See the [Land Representation Spec](land-representation.md) for more details on how land is defined.

## Get Owner

An owner of a parcel of land is defined as some Ethereum account. This can be an externally owned account (EOA) or smart contract.

The specification does not currently include more extensive forms of identity.

```
function owner(uint256 geohash) external view returns (address);
```

## Get Content

For each parcel of land that is purchased, the registry stores an [IPLD CID](https://github.com/ipld/specs/blob/master/block-layer/CID.md) as a reference to some piece of digital content. This provides a simple mechanism for content from the registry to be fetched from a variety of IPLD sources such as IPFS or Filecoin.

A CID is stored as a byte array of the following format:

```
<cid-version><multicodec-content-type><multihash-content-address>
```

The specification does not define the schema or data formats of content.

```
function contentIdentifier(uint256 geohash) external view returns (bytes memory);
```

## Claim Land

A Geohash may be claimed by a new owner through some authoritative account owned and ran by the developers of the registry. Content can be attached to land at the time of claiming.

```
function claim(uint256 geohash, address owner, bytes cid) onlyAdmin external;
```

Land that is already owned cannot be claimed by others.

## Roadmap

- Transfer of ownership of land
- Mutability of content
- Time-to-live (TTL) of digital content
- Content schemas and protocols
- More enhanced forms of identity
- Complex areas of land
- No nested ownership conflicts
