## Simple Summary

A **Media Gallery Item** is a JSON-LD representation of a [MediaObject](https://schema.org/MediaObject).

### Schema

See schema.org [MediaObject](https://schema.org/MediaObject) for a full list of fields. The following table lists the most common fields relevant to the Geo Web.

| Property         | Description                                                                 | Value                | Required | Example                               |
| ---------------- | --------------------------------------------------------------------------- | -------------------- | -------- | ------------------------------------- |
| `@type`          | Used to set the data type of a node or typed value.                         | string               | required | 3DModel                               |
| `name`           | The name of the item.                                                       | string               | optional | Astronaut                             |
| `contentUrl`     | Actual bytes of the media object, for example the image file or video file. | URI string           | optional | (ipfs://, ipns://, http://, https://) |
| `contentSize`    | File size in bytes.                                                         | string               | optional | 1024                                  |
| `encodingFormat` | Media type typically expressed using a MIME format.                         | string               | optional | model/gltf-binary                     |
| `encoding`       | A media object that encodes this MediaObject.                               | array of MediaObject | optional | [...]                                 |
| `metadata`       | Metadata object attributes of this MediaObject.                               | array of Metadata Object | optional | ["scale": "1,1,1", "color": "#ff0000,#00ff00,#0000ff", "position": "1,1,1"]                                 |

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "MediaGalleryItem",
  "type": "object",
  "properties": {
    "@type": {
      "description": "Used to set the data type of a node or typed value.",
      "type": "string",
      "enum": [ "3DModel", "ImageObject", "VideoObject", "AudioObject"]
    },
    "name": {
      "type": "string",
      "description": "The name of the item."
    },
    "contentUrl": {
      "type": "string",
      "format": "uri",
      "description": "Actual bytes of the media object, for example the image file or video file."
    },
    "contentSize": {
      "type": "string",
      "description": "File size in bytes."
    },
    "encodingFormat": {
      "type": "string",
      "description": "Media type typically expressed using a MIME format."
    },
    "encoding": {
      "type": "array",
      "description": "A media object that encodes this MediaObject.",
      "items": {
        "$ref": "#"
      }
    },
    "metadata": {
      "type": "object",
      "description": "An object that contains the Metadata associated.",
      "default": {},
      "required": [],
      "additionalProperties": true
    }
  }
}
```
