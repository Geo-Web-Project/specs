# Land Representation v0.1

This specification defines the answer to the question:

> How is a piece of physical land defined and represented in the Geo Web?

## Requirements

- Identifying parcels of land must not depend on a central party or service
- It must be verifiable that no two parcels of land shall overlap
- Determining who owns the land containing a specific point must be a constant-time operation

## Background

Defining physical land in a digital world is not a new concept or problem. Inspiration is taken from existing, open mechanisms from the GIS community. They are compared with each other and the requirements of the Geo Web.

### WGS84

Before defining a standard for representing an _area_ of land, we must define a standard coordinate system. [WGS84](https://en.wikipedia.org/wiki/World_Geodetic_System)<sup>[1](#f1)</sup> is the standard coordinate system used by GPS.

Note that WGS is a coordinate system, and not the actual technology and system of satellites that powers GPS. Using this coordinate system still leaves room for alternatives to GPS to be used as part of the Geo Web.<sup>[2](#f2)</sup>

### Raw Coordinate Regions

A simple approach to representing land is to take a point with a given radius to define a circular region:

```
(Lat, Long, Radius)
```

Or minimum and maximum coordinates to define a rectangular region:

```
(MinLat, MinLong, MaxLat, MaxLong)
```

These approaches, however, limit the complexity of shapes we can represent.

Another approach is to define a polygon with a set of coordinates:

```
{(Lat, Long), (Lat, Long) ...}
```

All these approaches look similar when comparing to our requirements:

- [x] No central party
- [ ] Verifiable non-overlapping
  - Circular regions cannot define a complete set of land on Earth without overlaps
  - Determining if rectangular regions overlaps requires some error-prone, inefficient math that scales with the number of parcels
- [ ] Fast lookups
  - No clear method for lookups that does not scale with number of parcels

### Open Location Codes (Plus Codes)

[Open Location Codes](https://github.com/google/open-location-code/blob/master/docs/olc_definition.adoc)<sup>[3](#f3)</sup> is an open standard created by Google as an alternative to street addresses. This is also known as [Plus Codes](https://plus.codes)<sup>[4](#f4)</sup>. Some properties of Open Location Codes include:

- Human readable and memorable
- Functions offline (no central party)
- Flexible precision
- Base20 encoded

When comparing to the requirements of the Geo Web, we find:

- [x] No central party
  - Works deterministically offline without a central party or service
- [x] Verifiable non-overlapping
  - Flexible precision through prefixes supports a hierarchy of land areas
  - Verifiable and deterministic that two codes are either non-overlapping or one is contained in the other
- [x] Fast lookups
  - More-precise areas can be determined to be contained in a less-precise area in constant time

### Geohash

[Geohash](https://en.wikipedia.org/wiki/Geohash)<sup>[5](#f5)</sup> is an open standard that encodes geographic locations to a deterministic, short string of characters. It is very similar to Open Location Codes. See [Evaluation of Location Encoding Systems](https://github.com/google/open-location-code/wiki/Evaluation-of-Location-Encoding-Systems)<sup>[6](#f6)</sup> for more details on the differences.

The main differences that are relevant to Geo Web are:

- Geohash is Base32 encoded and Open Location Codes are Base20
- Geohash may have wider adoption and familiarity. Other Ethereum-based protocols like FOAM use Geohash

Geohash also satisfies our requirements:

- [x] No central party
  - Works deterministically offline without a central party or service
- [x] Verifiable non-overlapping
  - Flexible precision through prefixes supports a hierarchy of land areas
  - Verifiable and deterministic that two codes are either non-overlapping or one is contained in the other
- [x] Fast lookups
  - More-precise areas can be determined to be contained in a less-precise area in constant time

In addition, the base32 encoding of Geohash enables simpler and more efficient storage on Ethereum. The bitwise logic needed to compare areas is also simpler than base20 since no padding is needed.

## Definition

Land is defined as a single Geohash. A Geohash represents some rectangular area of land anywhere on Earth. The size of this area varies depending on the length of the Geohash.

In this iteration, each Geohash is considered a separate piece of land no matter the length. However, note that this results in conflicts of ownership as the owner of a large area of land may be different than an owner of a smaller area of land within it. Future iterations will deal with these conflicts by not allowing longer prefixed Geohashes from being owned by someone else.

A Geohash can be converted from a base32 string and stored as an unsigned integer. Note that the base32 encoding of Geohash may not be the same as other commonly known base32 encodings.

```
uint256 geohash
```

---

<a name="f1">1</a>: WGS84, https://en.wikipedia.org/wiki/World_Geodetic_System

<a name="f2">2</a>: FOAM Location, https://foam.space/location

<a name="f3">3</a>: Open Location Codes, https://github.com/google/open-location-code/blob/master/docs/olc_definition.adoc

<a name="f4">4</a>: Plus Codes, https://plus.codes

<a name="f5">5</a>: Geohash, https://en.wikipedia.org/wiki/Geohash

<a name="f6">6</a>: Evaluation of Location Encoding Systems, https://github.com/google/open-location-code/wiki/Evaluation-of-Location-Encoding-Systems
