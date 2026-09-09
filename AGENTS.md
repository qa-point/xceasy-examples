# XCEasy examples agent instructions

These instructions apply to the entire repository.

- Keep `UIKitExample` and `SwiftUIExample` independent. Do not host one technology inside the other or introduce a shared tab application.
- UI implementation code must stay technology-specific. Share only neutral test data or infrastructure when sharing materially reduces duplication.
- Use stable accessibility identifiers and Page Objects. Creating a Page Object must not resolve UI state.
- Keep Page Object action methods free of assertions. Actions perform interactions; use `waitFor*`
  only when synchronization is required, and keep expected-result assertions in tests or explicit
  `assert*` Page Object methods.
- Keep one UI feature per test class and one test class per file. Express test scenarios with
  `given`, `when`, `then`, and `and`; keep technical actions and assertions nested under the
  corresponding business step.
- Every test must be isolated and must not depend on execution order or mutable state from another test.
- Preserve Allure, log, diagnostic, and parameterized-test behavior demonstrated by the examples.
- The supported consumer dependency is the released XCEasy Swift package. `TUIST_XCEASY_USE_LOCAL_PACKAGE=1` is only for adjacent local framework development.
- Never commit generated projects, workspaces, DerivedData, `.xcresult`, Allure output, or machine-specific files.
- Run both schemes before claiming the repository is healthy.

## Public distribution and diagnostics

- Follow `docs/en/SECURITY_EN.md`. Keep synthetic test data and useful UI trees/screenshots; do not add blanket masking or disable evidence as an unrelated security cleanup.
- Public XCEasy dependencies do not require a personal integration token in CI. Keep Actions pinned to commit SHAs and checkout credentials unpersisted.
- Runner installation instructions belong to `qa-point/xceasy-runner`, which also owns `Formula/xceasyctl.rb` and the Homebrew tap. Link there rather than creating a separate tap repository.
