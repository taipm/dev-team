# Text Post Template

## Variables
- `{message}`: Main content (required)
- `{hashtags}`: Optional hashtags

## Template

```
{message}

{hashtags}
```

## Example

```
Chúng tôi vui mừng thông báo đã phục vụ hơn 10,000 khách hàng!

Cảm ơn quý khách đã tin tưởng và đồng hành cùng chúng tôi trong suốt thời gian qua.

#milestone #thankyou #10kyears
```

## API Call

```bash
curl -X POST "https://graph.facebook.com/v22.0/${FB_PAGE_ID}/feed" \
  -d "message=${message}" \
  -d "access_token=${FB_PAGE_TOKEN}"
```
