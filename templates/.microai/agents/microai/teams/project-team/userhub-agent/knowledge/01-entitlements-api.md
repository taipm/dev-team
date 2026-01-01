# Entitlements API Reference

> Knowledge file cho UserHub Agent - Entitlements endpoints

---

## Endpoint: `/api/v1/entitlements/check-bulk`

### Overview

| Property | Value |
|----------|-------|
| **Path** | `/api/v1/entitlements/check-bulk` |
| **Method** | POST |
| **Auth** | Required (JWT Bearer Token) |
| **Handler** | `EntitlementHandler.CheckBulkEntitlements` |
| **Service** | `EntitlementService.CheckBulkEntitlements` |

### Request

```json
{
  "username": "string (required)",
  "software_names": ["string", "string", "..."]
}
```

**Notes:**
- `username`: Username cần check entitlements
- `software_names`: List các tên software cần check (recommend 10-20 items per request)
- UserHub có thể có max limit cho `software_names` - cần batch nếu list lớn

### Response (Success - HTTP 200)

```json
{
  "username": "thanhnq2_ad_test",
  "results": [
    {
      "software_name": "Microsoft Office 365",
      "software_id": "694e4c41104fadb5d838df1e",
      "allowed": true,
      "reason": "Direct approval for user: thanhnq2_ad_test",
      "rule_matched": {
        "id": "694e4c49104fadb5d838df2e",
        "name": "Group 2 - Microsoft Office Access",
        "priority": 100,
        "actions": ["allow"],
        "allowed_actions": ["install", "remove"]
      },
      "already_installed": false,
      "in_catalog": true
    },
    {
      "software_name": "AutoCAD 2024",
      "allowed": false,
      "reason": "Software not found in approved catalog",
      "already_installed": false,
      "in_catalog": false
    }
  ],
  "summary": {
    "total": 2,
    "allowed": 1,
    "denied": 1,
    "already_installed": 0,
    "not_in_catalog": 1
  },
  "checked_at": "2025-12-30T17:15:03Z"
}
```

### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `username` | string | Username được check |
| `results` | array | Kết quả cho từng software |
| `results[].software_name` | string | Tên software đã check |
| `results[].software_id` | string | ID trong catalog (nếu có) |
| `results[].allowed` | bool | `true` = được phép, `false` = bị từ chối |
| `results[].reason` | string | Lý do allow/deny |
| `results[].rule_matched` | object | Rule đã match (chỉ khi allowed=true) |
| `results[].rule_matched.id` | string | Rule ID |
| `results[].rule_matched.name` | string | Rule name |
| `results[].rule_matched.priority` | int | Rule priority |
| `results[].rule_matched.actions` | array | Actions của rule |
| `results[].rule_matched.allowed_actions` | array | Actions user được phép (install, remove) |
| `results[].already_installed` | bool | Software đã được cài đặt chưa |
| `results[].in_catalog` | bool | Software có trong approved catalog không |
| `summary.total` | int | Tổng số software đã check |
| `summary.allowed` | int | Số được phép |
| `summary.denied` | int | Số bị từ chối |
| `summary.already_installed` | int | Số đã cài đặt |
| `summary.not_in_catalog` | int | Số không có trong catalog |
| `checked_at` | datetime | Thời điểm check (ISO 8601) |

### Error Responses

| Status | Code | Description |
|--------|------|-------------|
| 400 | `INVALID_REQUEST` | Request body invalid hoặc thiếu fields |
| 401 | `UNAUTHORIZED` | Missing/invalid JWT token |
| 500 | `INTERNAL_ERROR` | Service error |

---

## Testing với cURL

### Step 1: Login lấy token

```bash
# Lưu credentials vào file (tránh escape issues)
cat > /tmp/login.json << 'EOF'
{"username":"thanhnq2_ad_test","password":"M!@nnam*2o25"}
EOF

# Login
TOKEN=$(curl -s -X POST http://localhost:8099/auth/v1/auth/login \
  -H "Content-Type: application/json" \
  -d @/tmp/login.json | jq -r '.data.token')
```

### Step 2: Check bulk entitlements

```bash
curl -s -X POST http://localhost:8099/api/v1/entitlements/check-bulk \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "username": "thanhnq2_ad_test",
    "software_names": ["AutoCAD 2024", "Microsoft Office 365", "Visual Studio 2022"]
  }' | jq .
```

---

## Key Files

| File | Purpose |
|------|---------|
| `gateway-server/handlers/entitlement_handler.go` | HTTP handler |
| `gateway-server/services/entitlement_service.go` | Business logic & types |
| `gateway-server/main.go` | Route registration |

---

## Common Scenarios

### 1. Software Allowed

```json
{
  "software_name": "Microsoft Office 365",
  "software_id": "694e4c41104fadb5d838df1e",
  "allowed": true,
  "reason": "Direct approval for user: thanhnq2_ad_test",
  "rule_matched": { ... },
  "in_catalog": true
}
```

### 2. Software Not in Catalog

```json
{
  "software_name": "AutoCAD 2024",
  "allowed": false,
  "reason": "Software not found in approved catalog",
  "in_catalog": false
}
```

### 3. Software Denied by Rule

```json
{
  "software_name": "Some Software",
  "allowed": false,
  "reason": "Denied by policy: No license available",
  "in_catalog": true
}
```

---

## Best Practices

1. **Batch requests**: Nếu check nhiều software, chia thành batches 10-20 items
2. **Cache results**: Entitlement results có thể cache trong thời gian ngắn
3. **Handle all cases**: Check cả `allowed` và `in_catalog` để hiểu đúng reason
4. **Use `rule_matched`**: Khi `allowed=true`, `rule_matched` cho biết rule nào đã match

---

## Related Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/v1/entitlements/check` | POST | Check single software |
| `/api/v1/entitled-software` | GET | Get full entitled list với credentials |

---

*Last updated: 2025-12-30*
