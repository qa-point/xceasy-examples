# XCEasy Examples

[Русская версия](README_RU.md)

Two independent iOS applications for exploring XCEasy and exercising realistic UI scenarios:

```text
XCEasyExamples
├── UIKitExample ─── UIKit app + UIKitExampleUITests
└── SwiftUIExample ─ SwiftUI app + SwiftUIExampleUITests
```

This is neither a hybrid app nor two targets sharing one interface. Each example has its own lifecycle, UI implementation, bundle ID, Page Objects, and UI-test target. Accessibility identifiers start with `UIKitExample.` or `SwiftUIExample.`, so they cannot overlap.

## What is included

Each home screen names its UI framework and links to five independent examples:

| Screen | States and components |
|---|---|
| Authorization | login/password fields, three validation errors, disabled button, a three-second loader, success transition |
| Components | text field, switch/checkbox, single selection, removable banner, repeated-element collection |
| Dynamic content | delayed loading, animation, expandable details, card removal and restoration |
| Overlays | system alert, modal sheet, temporary toast |
| Product catalog | displayed data, availability, search, empty state, sorting, product collection |

See [Feature catalog](docs/en/FEATURE_CATALOG_EN.md) for complete manual flows and matching tests.

## Requirements

- technical minimum: Xcode 15 and Swift 5.9 for the package manifest and macros;
- currently verified and supported matrix: Xcode 26.5 and Swift 6.3.2;
- Tuist 4.203.3;
- iOS 15.0 deployment target; iOS 26.5 is the verified simulator runtime.

The Tuist version is pinned in `mise.toml`. Install it from the repository root:

```bash
mise install
```

The scripts run Tuist through mise and resolve a full `Xcode.app` automatically when the system `xcode-select` points only to Command Line Tools. Set `DEVELOPER_DIR` for a non-standard Xcode location; CI may also provide an explicit `TUIST_BIN`.

Xcode 15–26.4 may technically build the package, but those versions are not yet in the CI matrix and are therefore not guaranteed.

## Open and explore an app

Generate the workspace:

```bash
mise exec -- tuist generate
```

In Xcode, select `UIKitExample` or `SwiftUIExample`, choose any available iPhone Simulator, and press Run. Valid Authorization credentials are `admin` / `password`.

To build and open an app without operating Xcode manually:

```bash
./scripts/run-app.sh UIKitExample
./scripts/run-app.sh SwiftUIExample
```

The examples consume the released XCEasy package by default. For adjacent local framework development:

```bash
TUIST_XCEASY_USE_LOCAL_PACKAGE=1 mise exec -- tuist generate --no-open
```

## Run UI tests

See the [XCEasy Runner guide](docs/en/XCEASY_RUNNER_EN.md) for production configs, Xcode test plans, mixed simulator/physical matrices, signing, and fast state reset.

```bash
xcodebuild test \
  -workspace XCEasyExamples.xcworkspace \
  -scheme UIKitExample \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

Use the `SwiftUIExample` scheme for the other app. Run both targets sequentially to avoid unnecessary host load:

```bash
./scripts/check.sh
```

All example UI tests live in this repository. They demonstrate parameterized XCTest, Allure metadata, hard and soft assertions, lazy Page Objects, collections, waits, negative assertions, and resolving a replacement element through a previously created POM.

## Reports, diagnostics, and AI logs

Every test creates isolated raw results, structured events, a human-readable log, and diagnostic attachments. After the sequential run, `scripts/check.sh` collects results from both UI-test schemes into the repository-root `allure-results` directory. The examples neither generate HTML nor upload results to TestOps.

The example intentionally uses the default XCEasy diagnostic settings. See
[Reports and diagnostics](docs/en/REPORT_PROFILES_EN.md) for the generated artifacts.

Intentionally failing examples are excluded from the regular green `scripts/check.sh` run. For manual Allure review, a combined run collects 46 passed and 10 expected failed results in the shared `allure-results` directory:

```bash
./scripts/check-all.sh
allure serve allure-results
```

## Continuous integration

The committed [CI workflow](.github/workflows/ci.yml) checks out this repository and the adjacent
private `qa-point/xceasy` repository, installs the Tuist version pinned by `mise.toml`, and runs
`./scripts/check-all.sh`. The workflow is successful only when the combined report contains exactly
46 passed tests and 10 intentionally failed showcase tests.

Create the repository secret before enabling CI:

```bash
gh secret set XC_EASY_INTEGRATION_TOKEN --repo qa-point/xceasy-examples
```

Use a fine-grained token with read-only Contents access to `qa-point/xceasy`. Organization policy
may require an administrator to approve the token. Never place the token in a file, command-line
argument, log, or committed configuration. The workflow uses it only to check out the private
framework repository.

## More documentation

- [Screen and test scenario catalog](docs/en/FEATURE_CATALOG_EN.md)
- [Reports and diagnostics](docs/en/REPORT_PROFILES_EN.md)
- [Advanced test setup](docs/en/ADVANCED_TEST_SETUP_EN.md)
- [UI-test architecture and Page Object guide](docs/en/UI_AUTOTEST_GUIDE_EN.md)
- [Running through XCEasy Runner](docs/en/XCEASY_RUNNER_EN.md)
- [Русская документация](README_RU.md)
