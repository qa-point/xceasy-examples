#!/bin/sh
set -eu

repository_root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cd "$repository_root"
. "$repository_root/scripts/lib/environment.sh"

resolve_xcode_developer_dir
"$repository_root/scripts/lint-swift.sh"
run_tuist generate --no-open

for scheme in UIKitExample SwiftUIExample; do
    xcodebuild build \
        -workspace XCEasyExamples.xcworkspace \
        -scheme "$scheme" \
        -destination 'generic/platform=iOS Simulator'
done

echo "UIKitExample and SwiftUIExample builds passed"
