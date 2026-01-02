# Facebook Graph API Reference

> Quick reference for Facebook Page posting endpoints (API v22.0)

---

## Base URL

```
https://graph.facebook.com/v22.0
```

---

## Endpoints

### 1. Post to Page Feed

**Endpoint**: `POST /{page-id}/feed`

**Parameters**:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `message` | string | One of these | Text content |
| `link` | string | One of these | URL to share |
| `picture` | string | One of these | Image URL |
| `attached_media` | array | No | For multi-photo posts |
| `access_token` | string | Yes | Page access token |

**Example**:
```bash
curl -X POST "https://graph.facebook.com/v22.0/{page-id}/feed" \
  -d "message=Hello World!" \
  -d "access_token={token}"
```

**Response**:
```json
{
  "id": "{page-id}_{post-id}"
}
```

---

### 2. Upload Photo

**Endpoint**: `POST /{page-id}/photos`

**Parameters**:
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `url` | string | One of these | Remote image URL |
| `source` | file | One of these | Local file upload |
| `message` | string | No | Photo caption |
| `published` | boolean | No | false for unpublished (multi-photo) |
| `access_token` | string | Yes | Page access token |

**Example (URL)**:
```bash
curl -X POST "https://graph.facebook.com/v22.0/{page-id}/photos" \
  -d "url=https://example.com/image.jpg" \
  -d "message=Photo caption" \
  -d "access_token={token}"
```

**Example (File upload)**:
```bash
curl -X POST "https://graph.facebook.com/v22.0/{page-id}/photos" \
  -F "source=@/path/to/image.jpg" \
  -F "message=Photo caption" \
  -F "access_token={token}"
```

---

### 3. Multi-Photo Post

**Workflow**:
1. Upload each photo with `published=false`
2. Create feed post with `attached_media` array

**Step 1 - Upload photos**:
```bash
# Photo 1
curl -s -X POST "https://graph.facebook.com/v22.0/{page-id}/photos" \
  -d "url=https://example.com/image1.jpg" \
  -d "published=false" \
  -d "access_token={token}"
# Returns: {"id": "photo_id_1"}

# Photo 2
curl -s -X POST "https://graph.facebook.com/v22.0/{page-id}/photos" \
  -d "url=https://example.com/image2.jpg" \
  -d "published=false" \
  -d "access_token={token}"
# Returns: {"id": "photo_id_2"}
```

**Step 2 - Create post**:
```bash
curl -X POST "https://graph.facebook.com/v22.0/{page-id}/feed" \
  -d "message=Multi-photo post!" \
  -d 'attached_media[0]={"media_fbid":"photo_id_1"}' \
  -d 'attached_media[1]={"media_fbid":"photo_id_2"}' \
  -d "access_token={token}"
```

---

### 4. Get Page Info

**Endpoint**: `GET /me/accounts`

**Response**:
```json
{
  "data": [
    {
      "access_token": "page_access_token",
      "category": "Business",
      "name": "My Page",
      "id": "123456789",
      "tasks": ["MANAGE", "CREATE_CONTENT", "MODERATE"]
    }
  ]
}
```

---

### 5. Validate Token

**Endpoint**: `GET /debug_token`

**Parameters**:
| Parameter | Type | Description |
|-----------|------|-------------|
| `input_token` | string | Token to validate |
| `access_token` | string | App access token |

**Example**:
```bash
curl "https://graph.facebook.com/v22.0/debug_token?input_token={token}&access_token={app_token}"
```

---

## Supported Image Formats

- PNG
- JPEG
- BMP
- GIF
- TIFF

**Recommended dimensions**:
- Feed images: 1200 x 630 px
- Square images: 1080 x 1080 px
- Max file size: 4MB

---

## Rate Limits

| Limit Type | Value |
|------------|-------|
| Per user per hour | 200 calls |
| Per app per minute | 600 calls |

**Headers to monitor**:
```
X-RateLimit-Limit: 200
X-RateLimit-Remaining: 150
X-RateLimit-Reset: 1640000000
```

---

## API Versioning

Current: **v22.0**

Version deprecation:
- v15: Removed Nov 2024
- v16: Removed May 2025

Always use the latest stable version.
