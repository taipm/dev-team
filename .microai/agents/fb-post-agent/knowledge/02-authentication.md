# Facebook Authentication Guide

> Token management for Facebook Graph API

---

## Token Types

### 1. User Access Token
- **Duration**: ~1 hour (short-lived)
- **Use**: Initial OAuth authentication
- **Can exchange**: For long-lived token

### 2. Long-Lived User Access Token
- **Duration**: ~60 days
- **Use**: Backend applications
- **Can generate**: Page access tokens

### 3. Page Access Token
- **Duration**: Non-expiring (when from long-lived user token)
- **Use**: Posting to pages
- **Requirement**: User must be page admin

---

## Getting Page Access Token

### Method 1: Graph API Explorer (Quick)

1. Go to https://developers.facebook.com/tools/explorer/
2. Select your Facebook App
3. Click "Get Token" > "Get User Access Token"
4. Select permissions:
   - `pages_show_list`
   - `pages_manage_posts`
   - `pages_read_engagement`
5. Click "Generate Access Token"
6. Select Page from dropdown
7. Copy the Page Access Token

### Method 2: OAuth Flow (Production)

**Step 1: Get User Access Token**
```
https://www.facebook.com/v22.0/dialog/oauth?
  client_id={app-id}&
  redirect_uri={redirect-uri}&
  scope=pages_show_list,pages_manage_posts,pages_read_engagement
```

**Step 2: Exchange for Long-Lived Token**
```bash
curl "https://graph.facebook.com/v22.0/oauth/access_token?
  grant_type=fb_exchange_token&
  client_id={app-id}&
  client_secret={app-secret}&
  fb_exchange_token={short-lived-token}"
```

**Step 3: Get Page Access Token**
```bash
curl "https://graph.facebook.com/v22.0/me/accounts?access_token={long-lived-user-token}"
```

Response:
```json
{
  "data": [
    {
      "access_token": "PAGE_ACCESS_TOKEN_HERE",
      "id": "123456789",
      "name": "My Page"
    }
  ]
}
```

---

## Required Permissions

| Permission | Purpose | Required |
|------------|---------|----------|
| `pages_show_list` | List user's pages | Yes |
| `pages_manage_posts` | Create posts | Yes |
| `pages_read_engagement` | Read post metrics | Recommended |
| `pages_read_user_content` | Read user comments | Optional |

---

## Token Validation

### Check if token is valid
```bash
curl "https://graph.facebook.com/v22.0/me?access_token={token}"
```

**Valid response**:
```json
{
  "name": "My Page",
  "id": "123456789"
}
```

**Invalid response**:
```json
{
  "error": {
    "message": "Error validating access token",
    "type": "OAuthException",
    "code": 190
  }
}
```

### Debug token details
```bash
curl "https://graph.facebook.com/debug_token?
  input_token={token}&
  access_token={app_id}|{app_secret}"
```

Response:
```json
{
  "data": {
    "app_id": "123456",
    "type": "PAGE",
    "is_valid": true,
    "expires_at": 0,
    "scopes": ["pages_show_list", "pages_manage_posts"]
  }
}
```

---

## Environment Setup

### Option 1: Export variables
```bash
export FB_PAGE_TOKEN="your_page_access_token"
export FB_PAGE_ID="your_page_id"
```

### Option 2: Use .env file
```
# .env
FB_PAGE_TOKEN=your_page_access_token
FB_PAGE_ID=your_page_id
```

### Option 3: Config file
```yaml
# config/facebook.yaml
page_token: ${FB_PAGE_TOKEN}
page_id: ${FB_PAGE_ID}
api_version: v22.0
```

---

## Token Security Best Practices

1. **Never commit tokens** to version control
2. **Use environment variables** or secret managers
3. **Rotate tokens** periodically
4. **Minimal scopes** - only request what you need
5. **Monitor usage** for unusual activity
6. **Revoke immediately** if compromised

---

## Token Refresh Flow

Page access tokens derived from long-lived user tokens don't expire, but user tokens need refresh:

```
User token expires (60 days)
     │
     ▼
Prompt user to re-authenticate
     │
     ▼
Get new user access token
     │
     ▼
Exchange for long-lived token
     │
     ▼
Get new page access token
     │
     ▼
Update stored token
```

---

## Troubleshooting

### Error: "Session has expired"
- Token has expired
- Re-authenticate to get new token

### Error: "Error validating access token"
- Token is invalid or revoked
- User may have changed password
- App permissions may have been revoked

### Error: "OAuthException" code 200
- Missing required permissions
- Re-request with correct scopes

### Error: Page not in list
- User is not admin of the page
- Ensure correct page permissions granted
