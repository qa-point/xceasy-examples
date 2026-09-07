#!/bin/sh
set -eu

repository_root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cd "$repository_root"
. "$repository_root/scripts/lib/environment.sh"

resolve_xcode_developer_dir

report_dir="$repository_root/allure-results"

reset_report_dir() {
    mkdir -p "$report_dir"
    find "$report_dir" -mindepth 1 -maxdepth 1 -delete
}

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

device_id=${XC_EASY_TEST_DEVICE_ID:-}
if [ -z "$device_id" ]; then
    device_id=$(xcrun simctl list devices available -j | jq -r '[.devices[][] | select(.name == "iPhone 17 Pro")][0].udid // empty')
fi
if [ -z "$device_id" ]; then
    echo "No available iPhone 17 Pro simulator" >&2
    exit 69
fi
ensure_simulator_booted "$device_id"

TUIST_XCEASY_USE_LOCAL_PACKAGE=${TUIST_XCEASY_USE_LOCAL_PACKAGE:-0} run_tuist generate --no-open

reset_report_dir

for scheme in UIKitExample SwiftUIExample; do
    case "$scheme" in
        UIKitExample)
            runner_bundle_id="com.qa-point.xceasy-examples.uikit-tests.xctrunner"
            test_target="UIKitExampleUITests"
            failure_prefix="UIKit"
            ;;
        SwiftUIExample)
            runner_bundle_id="com.qa-point.xceasy-examples.swiftui-tests.xctrunner"
            test_target="SwiftUIExampleUITests"
            failure_prefix="SwiftUI"
            ;;
    esac

    test_status=0
    xcodebuild test \
        -workspace XCEasyExamples.xcworkspace \
        -scheme "$scheme" \
        -destination "platform=iOS Simulator,id=$device_id" \
        -skip-testing:"$test_target/${failure_prefix}BasicFailureShowcaseTests" \
        -skip-testing:"$test_target/${failure_prefix}ListFailureShowcaseTests" \
        -skip-testing:"$test_target/${failure_prefix}ParameterizedFailureShowcaseTests" \
        || test_status=$?

    collect_allure_results "$runner_bundle_id"

    if [ "$test_status" -ne 0 ]; then
        exit "$test_status"
    fi
done

result_count=$(find "$report_dir" -maxdepth 1 -type f -name '*-result.json' | wc -l | tr -d ' ')
if [ "$result_count" -eq 0 ]; then
    echo "No Allure test results were exported to $report_dir" >&2
    exit 1
fi

echo "Allure results exported to $report_dir ($result_count test results)"
