# Advanced test setup

Start with `ExampleTestCase`. Its configuration contains only the application bundle identifier and localization, which is enough for the example tests.

The repository contains separate reference implementations for
[UIKit](../../UIKitExample/UITests/TestSupport/TestSetup/UIKitAdvancedExampleTestCase.swift) and
[SwiftUI](../../SwiftUIExample/UITests/TestSupport/TestSetup/SwiftUIAdvancedExampleTestCase.swift).
No existing test inherits from them. They are duplicated intentionally so each UI-test target is a complete, standalone example. Copy only the settings required by your project.

## Configuration options

- `findTimeout` limits how long an element lookup may wait.
- `actionTimeout` limits synchronization before interactions such as `tap`.
- `assertionTimeout` limits assertion polling.
- `localization` selects XCEasy step and diagnostic messages.
- `printLogToConsole` mirrors the per-test log to the Xcode console. It is useful while debugging but makes CI output larger.
- `uiQueryEvidenceLevel: .detailed` records additional locator and candidate evidence for failure analysis.
- `performance.level: .detailed` records detailed operation timings.
- `defaultBudgetMilliseconds` defines the expected operation duration when no specific budget exists.
- `budgetPolicy: .warn` reports budget overruns without failing the test.
- `healing.mode: .suggest` records locator-repair suggestions but never edits test source code.
- `minimumConfidence` rejects weak healing candidates.
- `minimumScoreGap` requires the best healing candidate to be clearly better than the next one.
- `diagnosticSnapshotByteLimit` limits the accessibility snapshot stored in diagnostics.
- `XCEasyAllureConfig.apply` defines templates used by `issue(...)` and `tms(...)` metadata.

Use the advanced setup when richer diagnostics justify larger artifacts and more verbose logs. Keep the minimal setup for onboarding and small test suites.
