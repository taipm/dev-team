# Error Handling Guide

> Common errors and recovery strategies for Facebook Graph API

---

## Error Response Format

```json
{
  "error": {
    "message": "Human-readable error message",
    "type": "OAuthException",
    "code": 190,
    "error_subcode": 460,
    "fbtrace_id": "AbCdEfGhIjK"
  }
}
```

---

## Authentication Errors (1xx)

### Error 190: Invalid Access Token

**Message**: "Error validating access token"

**Causes**:
- Token expired
- Token revoked
- User changed password
- App deauthorized

**Solution**:
```
1. Check token with debug endpoint
2. If expired → Get new token
3. If revoked → Re-authenticate user
4. Update stored token
```

**Recovery code**:
```bash
# Check if token is valid
curl -s "https://graph.facebook.com/v22.0/debug_token?
  input_token=${FB_PAGE_TOKEN}&
  access_token=${APP_ID}|${APP_SECRET}"

# If invalid, prompt user to re-authenticate
```

---

### Error 102: Session Expired

**Message**: "Session has expired"

**Solution**: Same as Error 190 - get new token

---

## Permission Errors (2xx)

### Error 200: Permissions Error

**Message**: "Permissions error" or "Missing permissions"

**Causes**:
- App lacks required permissions
- User didn't grant all scopes
- Permission was revoked

**Solution**:
```
1. Check granted permissions via /me/permissions
2. Request missing scopes
3. Re-authenticate with full scope list
```

**Check permissions**:
```bash
curl "https://graph.facebook.com/v22.0/me/permissions?access_token=${TOKEN}"
```

**Required scopes for posting**:
- `pages_show_list`
- `pages_manage_posts`
- `pages_read_engagement`

---

### Error 220: Album/Photo Permissions

**Message**: "Photo album does not exist or is not visible"

**Solution**: Check photo permissions and album settings

---

## Rate Limiting Errors (4)

### Error 4: Rate Limit Reached

**Message**: "Application request limit reached"

**Headers**:
```
X-RateLimit-Limit: 200
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1640000000
```

**Solution - Exponential Backoff**:
```bash
retry_count=0
max_retries=5
base_delay=1

while [ $retry_count -lt $max_retries ]; do
    response=$(curl -s -w "%{http_code}" ...)

    if [ "${response: -3}" != "400" ]; then
        break
    fi

    # Exponential backoff with jitter
    delay=$((base_delay * 2**retry_count + RANDOM % 1000 / 1000))
    echo "Rate limited. Waiting ${delay}s..."
    sleep $delay

    ((retry_count++))
done
```

**Prevention**:
- Monitor X-RateLimit-Remaining header
- Queue requests during peak times
- Batch operations when possible

---

### Error 17: User Request Limit

**Message**: "User request limit reached"

**Solution**: Wait 1 hour or reduce request frequency per user

---

## Parameter Errors (100)

### Error 100: Invalid Parameter

**Message**: "Invalid parameter"

**Common causes**:
- Missing required field
- Invalid URL format
- Malformed JSON
- Invalid media_fbid

**Validation before request**:
```bash
# Validate message is not empty
if [ -z "$message" ]; then
    echo "Error: Message cannot be empty"
    exit 1
fi

# Validate URL format
if ! [[ "$link" =~ ^https?:// ]]; then
    echo "Error: Invalid URL format"
    exit 1
fi
```

---

## Content Policy Errors (368)

### Error 368: Blocked Content

**Message**: "The content cannot be shared"

**Causes**:
- Link is on blocklist
- Content violates community standards
- Spam detection triggered

**Solution**:
- Review content for policy violations
- Check if link domain is blocked
- Reduce posting frequency
- Remove flagged content

---

## Media Errors

### Error 324: Missing Photo

**Message**: "Requires upload file"

**Solution**: Ensure file is properly attached

### Error 386: Invalid Image

**Message**: "Could not process image"

**Solution**:
- Check image format (PNG, JPG, GIF)
- Ensure file size < 4MB
- Verify image URL is accessible
- Try different image

---

## Server Errors (5xx)

### Error 1 or 2: Internal Error

**Message**: "An unknown error has occurred"

**Solution**:
- Retry after short delay
- Check Facebook Platform Status
- Contact support if persistent

**Status page**: https://developers.facebook.com/status/

---

## Error Handling Best Practices

### 1. Always Check Response
```bash
response=$(curl -s -w "\n%{http_code}" "$url")
http_code=$(echo "$response" | tail -n 1)
body=$(echo "$response" | sed '$d')

if [ "$http_code" != "200" ]; then
    error_code=$(echo "$body" | jq -r '.error.code')
    error_msg=$(echo "$body" | jq -r '.error.message')
    handle_error "$error_code" "$error_msg"
fi
```

### 2. Log Errors for Debugging
```bash
log_error() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] ERROR $1: $2" >> ./logs/fb-api-errors.log
}
```

### 3. User-Friendly Messages
```bash
get_user_message() {
    case $1 in
        190) echo "Token đã hết hạn. Vui lòng tạo token mới." ;;
        200) echo "Thiếu quyền. Vui lòng cấp quyền pages_manage_posts." ;;
        4)   echo "Đã đạt giới hạn. Vui lòng đợi 1 phút." ;;
        100) echo "Dữ liệu không hợp lệ. Kiểm tra lại nội dung." ;;
        368) echo "Nội dung bị chặn. Vui lòng chỉnh sửa bài viết." ;;
        *)   echo "Lỗi không xác định. Vui lòng thử lại." ;;
    esac
}
```

### 4. Retry Strategy
```
Error Type          | Retry? | Delay
--------------------|--------|--------
Rate limit (4)      | Yes    | Exponential
Server error (1,2)  | Yes    | 5-30s
Auth error (190)    | No     | N/A
Permission (200)    | No     | N/A
Invalid param (100) | No     | N/A
Content (368)       | No     | N/A
```

---

## Monitoring & Alerting

### Key Metrics to Track
- Error rate (errors/total requests)
- Error types distribution
- Rate limit hits
- Token expiration warnings

### Alert Thresholds
- Error rate > 5%: Warning
- Error rate > 10%: Critical
- Rate limit remaining < 20: Warning
- Token expires in < 7 days: Warning
