# LandParcelManager

The `LandParcelManager` contract is responsible for organizing land into parcels. Each parcel is simply a set of contiguous geohashes. No two parcels share any overlapping land.

## Requirements

- A parcel must represent a contiguous set of land
- No two parcels may overlap

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

In addition, the base32 encoding of a geohash enables simpler and more efficient storage on Ethereum. The bitwise logic needed to compare areas is also simpler than base20 since no padding is needed.

## Definition

Land is defined as a set of fixed-size geohashes. A geohash represents some rectangular area of land anywhere on Earth. The size of this area varies depending on the length of the geohash and where on Earth it is located.

All geohashes that make up land parcels will have a fixed size of 10 digits. This is roughly a square meter area when near the equator and should allow for complex enough areas to be defined. Using a fixed size allows for simple lookup and storage of land owners.

### Geohash Type

A geohash can be converted from a base32 string and stored as an unsigned integer. Note that the base32 encoding of a geohash may not be the same as other commonly known base32 encodings.

```
uint256 geohash
```

### Land Structure

```
struct LandParcel {
  EnumerableSet.UintSet geohashes
}

// Parcel ID -> LandParcel
mapping (uint256 => LandParcel) landParcels;
```

### Land Parcel Index

The smart contract stores a mapping of which parcel a geohash belongs to for efficient lookups.

```
// Geohash -> Parcel ID
mapping (uint256 => uint256) private geohashIndex;
```

### Minting Land

Some external account is given authority to mint land. This account is the [GeoWebAdmin](./GeoWebAdmin.md) contract.

Minting requires on input:
- A single, base geohash
- A path, starting at the base geohash, representing bordering geohashes

A path is an array of directions:
```
enum Direction { North, South, East, West }
```

Starting from the base geohash this path is followed, with each geohash along the way:

- If belongs to existing parcel, burn parcel
- Add to parcel being minted

This is a concise way of ensuring a land parcel is contiguous and never overlaps with other parcels. It is up to the minter ([GeoWebAdmin](./GeoWebAdmin.md)) to enforce additional authorization around when minting can occur. For example, nobody should be able to mint land with geohashes belonging to other parcels that are not expired or in auction.

```
function mintLandParcel(uint256 baseGeohash, Direction[] memory path) external onlyMinter;
```

---

<a name="f1">1</a>: WGS84, https://en.wikipedia.org/wiki/World_Geodetic_System

<a name="f2">2</a>: FOAM Location, https://foam.space/location

<a name="f3">3</a>: Open Location Codes, https://github.com/google/open-location-code/blob/master/docs/olc_definition.adoc

<a name="f4">4</a>: Plus Codes, https://plus.codes

<a name="f5">5</a>: Geohash, https://en.wikipedia.org/wiki/Geohash

<a name="f6">6</a>: Evaluation of Location Encoding Systems, https://github.com/google/open-location-code/wiki/Evaluation-of-Location-Encoding-Systems
