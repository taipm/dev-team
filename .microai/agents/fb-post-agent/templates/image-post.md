# Image Post Template

## Variables
- `{message}`: Caption (required)
- `{image_url}`: Direct URL to image (required)
- `{hashtags}`: Optional hashtags

## Template

```
{message}

{hashtags}
```

## Example

```
Sản phẩm mới đã có mặt tại showroom!

✨ Thiết kế hiện đại
✨ Chất liệu cao cấp
✨ Giá ưu đãi đặc biệt

Ghé thăm ngay hôm nay!

#newproduct #sale #showroom
```

## API Call - URL Method

```bash
curl -X POST "https://graph.facebook.com/v22.0/${FB_PAGE_ID}/photos" \
  -d "message=${message}" \
  -d "url=${image_url}" \
  -d "access_token=${FB_PAGE_TOKEN}"
```

## API Call - File Upload Method

```bash
curl -X POST "https://graph.facebook.com/v22.0/${FB_PAGE_ID}/photos" \
  -F "message=${message}" \
  -F "source=@${local_file_path}" \
  -F "access_token=${FB_PAGE_TOKEN}"
```

## Image Requirements
- Format: PNG, JPEG, GIF, BMP, TIFF
- Max size: 4MB
- Recommended: 1200 x 630 px (landscape) or 1080 x 1080 px (square)
- Aspect ratio: 1.91:1 (landscape) or 1:1 (square)
