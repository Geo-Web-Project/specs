## Simple Summary

A **Media Gallery** is an ordered collection of [MediaGalleryItem](./media-gallery-item.md).

### Schema

**Deployment:** `ceramic://kjzl6cwe1jw1483jn4rtotafswobwy0qm25q7hmgpjenf9mbrqdpfsfqiodtayv`

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "MediaGallery",
  "type": "array",
  "items": {
    "type": "string",
    "maxLength": 150,
    "$ceramic": {
      "type": "tile",
      "schema": "kjzl6cwe1jw148ycjs9eijway3tyknr4pzuryabpw2wm8y6uokaxyd79d52i8yn"
    }
  }
}
```
