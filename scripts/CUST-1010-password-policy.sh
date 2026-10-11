#!/bin/sh
# Custom Lynis Test CUST-1010
# Purpose: Check the system-wide password maximum age policy.

CONFIG="/etc/login.defs"
MAX_DAYS=$(awk '$1=="PASS_MAX_DAYS" {print $2; exit}' "$CONFIG" 2>/dev/null)

echo "Test CUST-1010: Password Policy Audit"

if [ ! -f "$CONFIG" ]; then
    echo "RESULT: REVIEW - $CONFIG not found"
elif ! echo "$MAX_DAYS" | grep -Eq '^[0-9]+$'; then
    echo "RESULT: WARNING - PASS_MAX_DAYS is missing or invalid"
elif [ "$MAX_DAYS" -ge 1 ] && [ "$MAX_DAYS" -le 90 ]; then
    echo "RESULT: PASS - PASS_MAX_DAYS=$MAX_DAYS"
else
    echo "RESULT: WARNING - PASS_MAX_DAYS=$MAX_DAYS; review the policy"
fi
