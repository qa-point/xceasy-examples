#!/bin/sh
set -eu

repository_root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)

"$repository_root/scripts/check.sh"
"$repository_root/scripts/check-failures.sh"

report_dir="$repository_root/allure-results"
result_count=$(find "$report_dir" -maxdepth 1 -type f -name '*-result.json' | wc -l | tr -d ' ')
passed_count=$(jq -r '.status' "$report_dir"/*-result.json | grep -c '^passed$' || true)
failed_count=$(jq -r '.status' "$report_dir"/*-result.json | grep -c '^failed$' || true)

if [ "$result_count" -ne 56 ] || [ "$passed_count" -ne 46 ] || [ "$failed_count" -ne 10 ]; then
    echo "Unexpected combined report: results=$result_count passed=$passed_count failed=$failed_count" >&2
    exit 1
fi

echo "Combined Allure results: $report_dir (results=$result_count passed=$passed_count failed=$failed_count)"
