# GeoWebParcel

The `GeoWebParcel` contract is responsible for organizing land into parcels. Each parcel is simply a set of contiguous `GeoWebCoordinate`. No two parcels share any overlapping land.

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

## Definition

A land parcel is defined as a set of `GeoWebCoordinate`. A `GeoWebCoordinate` represents some rectangular area of land anywhere on Earth. The size of this area varies depending on where on Earth it is located due to distortion, but it is approximately 10 square meters at the equator.

### GeoWebCoordinate

Earth is divided into a grid of `GeoWebCoordinate`. This grid is of size 2^24 (longitude) by 2^23 (latitude).

See converting from GPS to GeoWebCoordinate [TODO].

A `GeoWebCoordinate` is an unsigned 64-bit integer, where the most significant 32 bits are the X coordinate and the least significant 32 bits are the Y coordinate.

```
<32 bits of X><32 bits of Y>

uint64 coordinate;
```

### Land Parcel Structure

A parcel is represented with a single, base coordinate along with a path. The path is a series of directions (north, south, east, or west) to take starting at the base. This representation is an efficient way to store a land parcel that is always contiguous. Non-contiguous parcels cannot be represented if a path must be given.

```
struct LandParcel {
  uint64 baseCoordinate;
  uint256[] path;
}

// Parcel ID -> LandParcel
mapping(uint256 => LandParcel) landParcels;
```

Each direction of a path is represented as two bits:

```
00 -> North
01 -> South
10 -> East
11 -> West
```

A single path element of length 256 bits can represent up to 64 paths while only needing a single `SSTORE` EVM operation.

### Coordinate Availability Index

The smart contract stores an index about which coordinates belong to existing parcels. This is used to ensure no parcels being minted overlap with existing parcels.

At a minimum, the contract only needs to store a single bit for each coordinate, where `0` means the coordinate is available and `1` means it is not available.

In order to efficiently pack these bits, the availability of 256 coordinates is packed into a single slot or EVM word. These words make up another coordinate system that divides the `GeoWebCoordinate` system into a grid of size (2^24 / 16) by (2^23 / 16). Each word in this grid maps to a nested grid of 16x16 `GeoWebCoordinate` for a total of 256 coordinates in each word.

The local coordinate of a `GeoWebCoordinate` in a 16x16 word is used to calculate an index from 0 to 255. This index represents the bit position in the word that stores the availability of that coordinate.

```
((WordCoord_x => (WordCoord_y => Word))
mapping(uint256 => mapping(uint256 => uint256)) availabilityIndex;
```

### Minting a Parcel

Some external account is given authority to mint parcels. This account is the [GeoWebAdmin](./GeoWebAdmin.md) contract.

Minting requires on input a base coordinate and path.

Starting from the base coordinate the path is followed, with each coordinate along the way:

- If belongs to existing parcel, revert
- Mark coordinate as not available

This is a concise way of ensuring a land parcel is contiguous and never overlaps with other parcels. It is up to the minter ([GeoWebAdmin](./GeoWebAdmin.md)) to enforce additional authorization around when minting can occur. For example, nobody should be able to mint land that is not expired or in auction.

```
function mintLandParcel(uint64 baseCoordinate, uint256[] calldata path) external onlyMinter;
```

### Burning a Parcel

Some external account is given authority to burn parcels. This account is the [GeoWebAdmin](./GeoWebAdmin.md) contract.

Burning requires on input a `LandParcel` identifier.

Starting from the base coordinate the path is followed, with each coordinate along the way:

- Mark coordinate as available

```
function burnLandParcel(uint256 id) external onlyBurner;
```

## Converting Coordinates

In order to interact with or read data from the `GeoWebParcel` smart contract a `GeoWebCoordinate` needs to be converted to and from a GPS coordinate.

### GPS -> GeoWebCoordinate

This conversion is needed to lookup content that is associated with some GPS location.

#### Step 1: Normalize GPS Coordinates

The first step is to normalize a GPS coordinate. Given a GPS coordinate in degrees:

- Latitude from -90.0 to 90.0
  - Add 90.0 to get a value between 0.0 and <180.0
- Longitude from -180.0 to 180.0
  - Add 180.0 to get a value between 0.0 and <360.0

#### Step 2a: Convert Latitude

The latitude coordinate must be converted from a value between 0 and <180 to 0 and <2^23.

```
Lat_GW = floor(Lat_GPS / (180 / 2^23))
```

#### Step 2b: Convert Longitude

The longitude coordinate must be converted from a value between 0 and <360 to 0 and <2^24.

```
Lon_GW = floor(Lon_GPS / (360 / 2^24))
```

#### Step 3: Combine

The `Lat_GW` and `Lon_GW` can then be combined into a single 64-bit integer.

```
(Lon_GW << 32) | Lat_GW
```

### GeoWebCoordinate -> GPS Bounding Box

Another common use case is converting a `GeoWebCoordinate` to a GPS bounding box.

```
Bottom_Left_Lon = (Lon_GW * (360 / 2^24)) - 180
Bottom_Left_Lat = (Lat_GW * (180 / 2^23)) - 90

Top_Right_Lon = Bottom_Left_Lon + (360 / 2^24)
Top_Right_Lat = Bottom_Left_Lat + (180 / 2^23)

Bottom_Right_Lon = Top_Right_Lon
Bottom_Right_Lat = Bottom_Left_Lat

Top_Left_Lon = Bottom_Left_Lon
Top_Left_Lat = Top_Right_Lat
```

---

<a name="f1">1</a>: WGS84, https://en.wikipedia.org/wiki/World_Geodetic_System

<a name="f2">2</a>: FOAM Location, https://foam.space/location

<a name="f3">3</a>: Open Location Codes, https://github.com/google/open-location-code/blob/master/docs/olc_definition.adoc

<a name="f4">4</a>: Plus Codes, https://plus.codes

<a name="f5">5</a>: Geohash, https://en.wikipedia.org/wiki/Geohash

<a name="f6">6</a>: Evaluation of Location Encoding Systems, https://github.com/google/open-location-code/wiki/Evaluation-of-Location-Encoding-Systems
