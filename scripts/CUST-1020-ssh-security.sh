#!/bin/sh
# Custom Lynis Test CUST-1020
# Purpose: Review effective SSH root-login and password-authentication settings.

echo "Test CUST-1020: SSH Security Audit"

if ! command -v sshd >/dev/null 2>&1; then
    echo "RESULT: NOT CHECKED - sshd is not installed"
    exit 0
fi

if [ "$(id -u)" -eq 0 ]; then
    EFFECTIVE=$(sshd -T 2>/dev/null)
elif command -v sudo >/dev/null 2>&1; then
    EFFECTIVE=$(sudo sshd -T 2>/dev/null)
else
    echo "RESULT: NOT CHECKED - administrator privileges are required"
    exit 0
fi

if [ -z "$EFFECTIVE" ]; then
    echo "RESULT: NOT CHECKED - unable to obtain effective SSH settings"
    exit 0
fi

ROOT_SETTING=$(printf '%s\n' "$EFFECTIVE" | awk '$1=="permitrootlogin" {print $2; exit}')
PASS_SETTING=$(printf '%s\n' "$EFFECTIVE" | awk '$1=="passwordauthentication" {print $2; exit}')

if [ "$ROOT_SETTING" = "no" ]; then
    echo "RESULT: PASS - permitrootlogin is no"
else
    echo "RESULT: WARNING - permitrootlogin is $ROOT_SETTING"
fi

if [ "$PASS_SETTING" = "no" ]; then
    echo "RESULT: PASS - passwordauthentication is no"
else
    echo "RESULT: REVIEW - passwordauthentication is $PASS_SETTING"
fi
