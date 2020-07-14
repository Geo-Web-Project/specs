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

### Background

Defining physical land in a digital world is not a new concept or problem. Inspiration is taken from existing, open mechanisms from the GIS community. They are compared with each other and the requirements of the Geo Web in this [research document](TODO).

#### Geohash

[Geohash](https://en.wikipedia.org/wiki/Geohash) is a geocode system that encodes a geographic location in a short, base32 string of characters. It has important properties that are believed to be suitable for efficient storage of land and lookup of ownership.

---

Land is defined as a single Geohash. A Geohash represents some rectangular area of land anywhere on Earth. The size of this area varies depending on the length of the Geohash.

In this iteration, each Geohash is considered a separate piece of land no matter the length. However, note that this results in conflicts of ownership as the owner of a large area of land may be different than an owner of a smaller area of land within it. Future iterations will deal with these conflicts by not allowing longer prefixed Geohashes from being owned by someone else.

A Geohash can be converted from a base32 string and stored as an unsigned integer. Note that the base32 encoding of Geohash may not be the same as other commonly known base32 encodings.

## Get Owner

An owner of a parcel of land is defined as some Ethereum account. This can be an externally owned account (EOA) or smart contract.

The specification does not currently include more extensive forms of identity.

```
function owner(uint256 geohash) external view returns (address);
```

## Get Content

For each parcel of land that is purchased, the registry stores an [IPLD CID](https://github.com/ipld/specs/blob/master/block-layer/CID.md) as a reference to some piece of digital content. This provides a simple mechanism for content from the registry to be fetched from a variety of IPLD sources such as IPFS or Filecoin.

The specification does not define the schema or data formats of content.

```
function content(uint256 geohash) external view returns (string);
```

## Claim Land

A Geohash may be claimed by a new owner through some authoritative account owned and ran by the developers of the registry. Content can be attached to land at the time of claiming.

```
function claim(uint256 geohash, address owner, string cid) onlyAdmin external;
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
