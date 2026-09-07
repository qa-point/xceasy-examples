#!/bin/sh
set -eu

repository_root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cd "$repository_root"
. "$repository_root/scripts/lib/environment.sh"

resolve_xcode_developer_dir

device_id=${XC_EASY_TEST_DEVICE_ID:-}
if [ -z "$device_id" ]; then
    device_id=$(xcrun simctl list devices available -j | jq -r '[.devices[][] | select(.name == "iPhone 17 Pro")][0].udid // empty')
fi
if [ -z "$device_id" ]; then
    echo "No available iPhone 17 Pro simulator" >&2
    exit 69
fi
ensure_simulator_booted "$device_id"

report_dir="$repository_root/allure-results"
mkdir -p "$report_dir"

initial_result_count=$(find "$report_dir" -maxdepth 1 -type f -name '*-result.json' | wc -l | tr -d ' ')
initial_failed_count=0
if [ "$initial_result_count" -gt 0 ]; then
    initial_failed_count=$(jq -r '.status' "$report_dir"/*-result.json | grep -c '^failed$' || true)
fi

collect_allure_results() {
    runner_bundle_id=$1
    ensure_simulator_booted "$device_id"
    runner_data_dir=$(xcrun simctl get_app_container "$device_id" "$runner_bundle_id" data)
    runner_report_dir="$runner_data_dir/Library/Caches/allure-results"

    if [ ! -d "$runner_report_dir" ]; then
        echo "Allure results not found for $runner_bundle_id at $runner_report_dir" >&2
        return 1
    fi

    cp -R "$runner_report_dir/." "$report_dir/"
}

TUIST_XCEASY_USE_LOCAL_PACKAGE=${TUIST_XCEASY_USE_LOCAL_PACKAGE:-0} run_tuist generate --no-open

for scheme in UIKitExample SwiftUIExample; do
    case "$scheme" in
        UIKitExample)
            test_target="UIKitExampleUITests"
            failure_prefix="UIKit"
            runner_bundle_id="com.qa-point.xceasy-examples.uikit-tests.xctrunner"
            ;;
        SwiftUIExample)
            test_target="SwiftUIExampleUITests"
            failure_prefix="SwiftUI"
            runner_bundle_id="com.qa-point.xceasy-examples.swiftui-tests.xctrunner"
            ;;
    esac

    test_status=0
    xcodebuild test \
        -workspace XCEasyExamples.xcworkspace \
        -scheme "$scheme" \
        -destination "platform=iOS Simulator,id=$device_id" \
        -only-testing:"$test_target/${failure_prefix}BasicFailureShowcaseTests" \
        -only-testing:"$test_target/${failure_prefix}ListFailureShowcaseTests" \
        -only-testing:"$test_target/${failure_prefix}ParameterizedFailureShowcaseTests" \
        || test_status=$?

    collect_allure_results "$runner_bundle_id"

    if [ "$test_status" -eq 0 ]; then
        echo "$scheme failure showcase unexpectedly passed" >&2
        exit 1
    fi
done

result_count=$(find "$report_dir" -maxdepth 1 -type f -name '*-result.json' | wc -l | tr -d ' ')
failed_count=$(jq -r '.status' "$report_dir"/*-result.json | grep -c '^failed$' || true)
expected_result_count=$((initial_result_count + 10))
expected_failed_count=$((initial_failed_count + 10))

if [ "$result_count" -ne "$expected_result_count" ] || [ "$failed_count" -ne "$expected_failed_count" ]; then
    echo "Unexpected failure showcase result: results=$result_count failed=$failed_count" >&2
    exit 1
fi

echo "Expected failure showcase appended to $report_dir (results=$result_count failed=$failed_count)"
