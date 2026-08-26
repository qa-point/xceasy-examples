# Reports and diagnostics

The examples use the default XCEasy diagnostic settings so that the initial test setup stays small. Every test still demonstrates evidence that XCEasy leaves for human and automated diagnosis.

## Evidence to inspect

- Allure result JSON contains status, labels, parameters, steps, and attachment references.
- The human-readable test log shows business and technical step order.
- Structured events expose stable code, status, duration, and locator context to AI without parsing incidental prose.
- Query evidence explains the search, candidate count, and action or assertion failure reason.
- Screenshots and accessibility snapshots preserve failure-time UI state.
- Performance summaries compare find, action, assertion, and user-step durations between runs.

For example, the catalog scenario appears as a nested sequence:

```text
SwiftUI product catalog: Open product catalog
└── Tap "Product Catalog"
Check products sorted from highest to lowest price
├── Create locator for component at index [0]
├── Check [Product at index 0: name] label is [Monitor]
├── Create locator for component at index [1]
└── Check [Product at index 1: name] label is [Keyboard]
```

Titles may be localized through XCEasy configuration, while stable operation codes (`ui.tap`, `component.collection.select_index`) and the complete `Product[index] → Product.Name` locator chain remain machine-readable.

Artifacts are isolated per test. Parallel tests must not append to another test's log or lifecycle. Send secrets as masked or excluded Allure parameters; the example always masks passwords.

The examples collect `allure-results`, but do not generate HTML or upload to TestOps. Publishing remains a separate user or CI operation.
