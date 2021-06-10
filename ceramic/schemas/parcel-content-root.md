## Simple Summary

The **Parcel Content Root** is the root document tied to a Geo Web Parcel.

### Schema

| Property       | Description                                                          | Value        | Max Size | Required | Example                                                         |
| -------------- | -------------------------------------------------------------------- | ------------ | -------- | -------- | --------------------------------------------------------------- |
| `name`         | a name                                                               | string       | 150 char | optional | Mary Smith                                                      |
| `webContent`   | URI pointing to some web content                                     | URI string   | 150 char | optional | (ipfs://, ipns://, http://, https://)                           |
| `mediaGallery` | An ordered collection of [MediaGalleryItem](./media-gallery-item.md) | docId string | 150 char | optional | kjzl6cwe1jw1483jn4rtotafswobwy0qm25q7hmgpjenf9mbrqdpfsfqiodtayv |

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "ParcelContentRoot",
  "type": "object",
  "properties": {
    "name": {
      "type": "string",
      "maxLength": 150
    },
    "webContent": {
      "type": "string",
      "format": "uri",
      "maxLength": 150
    },
    "mediaGallery": {
      "type": "string",
      "maxLength": 150
    }
  }
}
```
