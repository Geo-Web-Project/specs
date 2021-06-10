## What is JSON-LD?

[JSON-LD](https://www.w3.org/TR/json-ld11/) is a JSON serialization format for [Linked Data](https://www.w3.org/standards/semanticweb/data). Linked Data is core to the [Semantic Web](https://en.wikipedia.org/wiki/Semantic_Web) and to the Geo Web as well.

## Why Linked Data?

Data on the Geo Web should be machine-readable to unlock the power of being a "web". Browsers should be able to understand content that is anchored to land in order to build user experiences on top of this data.

## JSON-LD and Ceramic

[Ceramic](https://www.ceramic.network) powers the content layer of the Geo Web. Most content is represented as a graph of JSON documents using the [Tile doctype](https://github.com/ceramicnetwork/CIP/blob/main/CIPs/CIP-8/CIP-8.md). All documents need a [JSON Schema](https://json-schema.org).

Certain documents in the Geo Web are also represented as JSON-LD types. It is still being determined how to define these types as JSON schemas in Ceramic. For now, schemas are manually created by choosing fields from schema.org. See [MediaGalleryItem](./media-gallery-item.md) as an example.
