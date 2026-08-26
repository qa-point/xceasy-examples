# Running the examples with XCEasy Runner

English · [Русский](../ru/XCEASY_RUNNER_RU.md) · [README](../../README.md)

## Setup

Install the pinned Tuist version and generate the workspace:

```bash
mise install
mise exec -- tuist generate --no-open
```

Add the runner to `PATH`, or invoke it by absolute path:

```bash
export PATH="/path/to/xceasy-runner/bin:$PATH"
xceasyctl validate-config xceasy-runner.json
xceasyctl test --config xceasy-runner.json --plan-only
xceasyctl test --config xceasy-runner.json
```

The committed `xceasy-runner.json` runs `UIKitExampleTestPlan`, configuration `English`, and excludes the `FailureShowcase` marker. Use `xceasy-runner-swiftui.json` for `SwiftUIExampleTestPlan`. Every run creates `runner-artifacts/run-*`; its `allure-results` directory is the final Allure input.

## Example configuration fields

Both committed JSON files use runner schema `1.0.0`. They differ only in the scheme, test target,
test plan, and runner bundle identifier.

| Field | Example meaning |
|---|---|
| `schema_version` | Version of the validated runner configuration contract. |
| `mode` | `shard` executes every selected test once and distributes tests across devices. |
| `retry_missing_tests` | Retries only tests missing after an infrastructure interruption. |
| `max_recovery_attempts` | Maximum number of missing-test recovery rounds. |
| `require_all_devices` | Fails preflight instead of silently shrinking the requested matrix. |
| `workspace` | Generated `XCEasyExamples.xcworkspace`, resolved from the config directory. |
| `scheme` | Application/UI-test scheme: `UIKitExample` or `SwiftUIExample`. |
| `test_target` | XCTest bundle target whose Swift test methods are enumerated. |
| `test_plan` | Xcode test plan used for build and execution. |
| `test_configuration` | Exactly one configuration from the selected test plan. |
| `runner_bundle_id` | UI-test runner application used to export XCEasy Allure results. |
| `output_directory` | Root for isolated `run-*` artifacts. |
| `devices` | Simulator, physical-device, or mixed execution matrix. |
| `state_isolation` | `app_reset_hook` requests the fast opt-in application reset before each test. |
| `selection` | Marker include-any, include-all, and exclude rules; empty includes select all tests. |
| `performance_environment_key` | Stable environment identity used for comparable performance evidence. |

The complete schema and every optional runner capability are documented in the
[XCEasy Runner repository](https://github.com/qa-point/xceasy-runner). These two files intentionally
remain minimal runnable examples rather than copies of every runner option.

## Test plans

The repository contains real [UIKitExampleTestPlan.xctestplan](../../TestPlans/UIKitExampleTestPlan.xctestplan) and [SwiftUIExampleTestPlan.xctestplan](../../TestPlans/SwiftUIExampleTestPlan.xctestplan) files. Config schema 1.0.0 selects a plan and one configuration:

```json
"test_plan": "UIKitExampleTestPlan",
"test_configuration": "English"
```

The same values can be overridden through CLI:

```bash
xceasyctl test \
  --config xceasy-runner.json \
  --test-plan UIKitExampleTestPlan \
  --test-configuration English
```

For multiple locales, add configurations to the `.xctestplan` and run a separate CI matrix job for each. One runner invocation deliberately avoids mixing repeated executions from different configurations in a single shard/recovery report.

## Devices

A name selector is convenient locally:

```json
{"type": "simulator", "name": "iPhone 17 Pro"}
```

Prefer exact IDs in CI. A physical device must be connected, trusted, enabled for development, and visible in `xcrun devicectl list devices`:

```json
"devices": [
  {"type": "simulator", "id": "SIMULATOR-UDID"},
  {"type": "physical", "id": "DEVICE-UDID"}
],
"physical_device": {
  "development_team": "YOUR_TEAM_ID",
  "allow_provisioning_updates": false,
  "allow_device_registration": false
}
```

The runner builds simulator and physical products separately but aggregates one report. Configure signing in Xcode/CI first and enable provisioning flags deliberately. This example's real-device path could not be exercised without hardware; runner fake contract tests cover the path.

## Fast state isolation

The example configs use `"state_isolation": "app_reset_hook"`. The runner passes the mode to the UI-test process, test setup forwards `XC_EASY_RESET_APP_STATE=1`, and the app clears UserDefaults, Keychain, Application Support, Caches, and Documents before constructing its UI.

This does not reinstall the app and normally takes milliseconds. It cannot reset system privacy permissions: iOS has no fast universal equivalent of Android `pm clear`. Use a dedicated simulator/fixture or explicitly prepared state for system-permission flows.

Keep the environment check strictly opt-in when adapting this hook for a production application, and explicitly review which stores may be cleared.

## Production checklist

- version the config and schema in Git;
- never commit personal device IDs or signing secrets to a public config;
- ignore runner artifacts, `.xcresult`, generated workspaces, and Allure output;
- run `xceasyctl validate-config` and `--plan-only` before a full execution;
- retain the complete `run-*` directory as a CI artifact;
- use `require_all_devices: true` when a reduced matrix is unacceptable.
