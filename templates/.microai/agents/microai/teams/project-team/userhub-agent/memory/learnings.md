# UserHub Agent - Learnings

## Patterns Discovered

### 1. Entitlements API Response Pattern (2025-12-30)

Khi check entitlements, response có 2 trường quan trọng:
- `allowed`: boolean - user có được phép không
- `in_catalog`: boolean - software có trong approved catalog không

**Decision matrix:**
| allowed | in_catalog | Meaning |
|---------|------------|---------|
| true | true | User has permission |
| false | true | User denied by policy |
| false | false | Software not in catalog |

### 2. Rule Matched Object

Khi `allowed=true`, response bao gồm `rule_matched`:
```json
{
  "rule_matched": {
    "id": "694e4c49104fadb5d838df2e",
    "name": "Group 2 - Microsoft Office Access",
    "priority": 100,
    "actions": ["allow"],
    "allowed_actions": ["install", "remove"]
  }
}
```

## Gotchas

### 1. Password với special characters (2025-12-30)

Khi test với cURL, passwords có ký tự đặc biệt (`!`, `@`, `*`) cần escape.

**Solution:** Dùng JSON file thay vì inline:
```bash
cat > /tmp/login.json << 'EOF'
{"username":"user","password":"P@ss!word*"}
EOF
curl -d @/tmp/login.json ...
```

### 2. software_names case-sensitive

Software name trong check-bulk phải match **chính xác** với catalog:
- "Microsoft Office 365" - Works
- "microsoft office 365" - May not work

## Best Practices

1. Always use `doAPIRequest` helper for UserHub API calls
2. Log API call duration for performance monitoring
3. Mask sensitive data (passwords) in logs
4. Handle all HTTP status codes explicitly
5. Use mocks for unit tests, staging for integration tests
6. **Batch entitlement checks**: Recommend 10-20 items per request
7. **Check both fields**: Always check `allowed` AND `in_catalog` for full understanding
8. **Use `allowed_actions`**: When allowed, check what actions user can perform (install/remove)

## Code Snippets

### cURL: Test check-bulk endpoint

```bash
# Step 1: Login (handle special chars in password)
cat > /tmp/login.json << 'EOF'
{"username":"thanhnq2_ad_test","password":"M!@nnam*2o25"}
EOF

TOKEN=$(curl -s -X POST http://localhost:8099/auth/v1/auth/login \
  -H "Content-Type: application/json" \
  -d @/tmp/login.json | jq -r '.data.token')

# Step 2: Check bulk entitlements
curl -s -X POST http://localhost:8099/api/v1/entitlements/check-bulk \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "username": "thanhnq2_ad_test",
    "software_names": ["AutoCAD 2024", "Microsoft Office 365"]
  }' | jq .
```

### Example Response Analysis

```bash
# Get only allowed software
curl ... | jq '.results[] | select(.allowed == true) | .software_name'

# Get summary
curl ... | jq '.summary'

# Get denied reasons
curl ... | jq '.results[] | select(.allowed == false) | {name: .software_name, reason: .reason}'
```

---

*Last updated: 2025-12-30*
