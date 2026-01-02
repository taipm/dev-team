# Link Post Template

## Variables
- `{message}`: Intro text (required)
- `{link}`: URL to share (required)
- `{hashtags}`: Optional hashtags

## Template

```
{message}

👉 {link}

{hashtags}
```

## Example

```
Đọc ngay bài viết mới nhất của chúng tôi về xu hướng công nghệ 2026!

👉 https://example.com/tech-trends-2026

#technology #trends #2026
```

## API Call

```bash
curl -X POST "https://graph.facebook.com/v22.0/${FB_PAGE_ID}/feed" \
  -d "message=${message}" \
  -d "link=${link}" \
  -d "access_token=${FB_PAGE_TOKEN}"
```

## Notes
- Facebook will automatically fetch Open Graph metadata from the URL
- Link preview shows title, description, and image from the page
- Can override with `name`, `caption`, `description` parameters (deprecated in newer versions)
