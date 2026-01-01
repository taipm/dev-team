#!/bin/bash
# ============================================================================
# MicroAI Hook: Protect Sensitive Files
# Type: PreToolUse
# Matcher: Write|Edit
# Description: Prevents modification of sensitive files (env, credentials, secrets)
# ============================================================================

# Read tool input from stdin
INPUT=$(cat)

# Extract file path from tool input
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

# If no file path, allow
if [ -z "$FILE_PATH" ]; then
    exit 0
fi

# Get just the filename for pattern matching
FILENAME=$(basename "$FILE_PATH")

# ============================================================================
# Sensitive file patterns to protect
# ============================================================================

# Pattern 1: Environment files
if echo "$FILENAME" | grep -qE '^\.env($|\..*)'; then
    echo "BLOCKED: Cannot modify environment file: $FILENAME" >&2
    echo "Tip: Use .env.example for templates" >&2
    exit 1
fi

# Pattern 2: Credential files
if echo "$FILENAME" | grep -qiE '(credentials|secrets?|password|private.*key|\.pem$|\.key$)'; then
    echo "BLOCKED: Cannot modify credential file: $FILENAME" >&2
    exit 1
fi

# Pattern 3: Token files
if echo "$FILENAME" | grep -qiE '(token|api.?key|auth.?key)'; then
    echo "BLOCKED: Cannot modify token/API key file: $FILENAME" >&2
    exit 1
fi

# Pattern 4: SSH keys
if echo "$FILE_PATH" | grep -qE '\.ssh/(id_|known_hosts|authorized_keys)'; then
    echo "BLOCKED: Cannot modify SSH configuration" >&2
    exit 1
fi

# Pattern 5: AWS/Cloud credentials
if echo "$FILE_PATH" | grep -qE '\.(aws|gcloud|azure)/'; then
    echo "BLOCKED: Cannot modify cloud provider credentials" >&2
    exit 1
fi

# Pattern 6: npmrc with tokens
if echo "$FILENAME" | grep -qE '^\.(npmrc|yarnrc)$'; then
    # Check if file might contain tokens
    if [ -f "$FILE_PATH" ] && grep -qE '(authToken|_auth|token)' "$FILE_PATH" 2>/dev/null; then
        echo "BLOCKED: Cannot modify package manager auth file" >&2
        exit 1
    fi
fi

# Pattern 7: Keychain/Keystore files
if echo "$FILENAME" | grep -qiE '(keychain|keystore|\.jks$|\.p12$|\.pfx$)'; then
    echo "BLOCKED: Cannot modify keychain/keystore files" >&2
    exit 1
fi

# All checks passed, allow modification
exit 0
