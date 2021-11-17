## Simple Summary

A **Media Gallery** is an ordered collection of [MediaGalleryItem](./media-gallery-item.md).

### Schema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "MediaGallery",
  "type": "object",
  "properties": {
    "mediaGalleryItems": {
      "type": "array",
      "items": {
        "type": "string",
        "maxLength": 150
      }
    }
  }
}
```
