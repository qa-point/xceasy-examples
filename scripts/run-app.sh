#!/bin/sh
set -eu

repository_root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cd "$repository_root"
. "$repository_root/scripts/lib/environment.sh"

scheme=${1:-}
case "$scheme" in
    UIKitExample) bundle_id=com.qa-point.xceasy-examples.uikit ;;
    SwiftUIExample) bundle_id=com.qa-point.xceasy-examples.swiftui ;;
    *) echo "Usage: $0 UIKitExample|SwiftUIExample" >&2; exit 64 ;;
esac

resolve_xcode_developer_dir

device_id=${XC_EASY_TEST_DEVICE_ID:-}
if [ -z "$device_id" ]; then
    device_id=$(xcrun simctl list devices available -j | jq -r '[.devices[][] | select(.name == "iPhone 17 Pro")][0].udid // [.devices[][] | select(.name | startswith("iPhone"))][0].udid // empty')
fi
if [ -z "$device_id" ]; then
    echo "No available iPhone Simulator" >&2
    exit 69
fi

TUIST_XCEASY_USE_LOCAL_PACKAGE=${TUIST_XCEASY_USE_LOCAL_PACKAGE:-0} run_tuist generate --no-open
xcrun simctl boot "$device_id" >/dev/null 2>&1 || true
open -a Simulator
xcrun simctl bootstatus "$device_id" -b

derived_path="$repository_root/Derived/Manual"
xcodebuild build \
    -workspace XCEasyExamples.xcworkspace \
    -scheme "$scheme" \
    -destination "platform=iOS Simulator,id=$device_id" \
    -derivedDataPath "$derived_path"

app_path="$derived_path/Build/Products/Debug-iphonesimulator/$scheme.app"
xcrun simctl install "$device_id" "$app_path"
xcrun simctl launch "$device_id" "$bundle_id"
