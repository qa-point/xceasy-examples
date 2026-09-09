# XCEasy Examples 0.1.1 release readiness

English · [Русский](../ru/RELEASE_READINESS_RU.md)

Date: 2026-09-09. Release set: Examples 0.1.1, XCEasy 0.1.3, Runner 0.1.3.

## Verified checks

- Full `TUIST_XCEASY_USE_LOCAL_PACKAGE=1 ./scripts/check-all.sh` against the
  XCEasy 0.1.3 candidate sources passed for both schemes: 56 Allure results,
  46 passed and 10 intentional failure-showcase results. No unexpected failures.
- After XCEasy publication, `./scripts/check-ci.sh` passed without a local
  dependency override: SwiftLint, generation, and UIKitExample/SwiftUIExample
  Debug builds resolved the public XCEasy package at exact tag 0.1.3.
- The public dependency requires no personal integration token.
- Installed Runner acceptance through PATH and on two simulators belongs to
  its release process. Version 0.1.3 fixes runtime discovery when launched by
  bare command name, found during installation verification.

## Verification boundaries

- Intentional failures demonstrate diagnostic artifacts and are not hidden.
- Automated Canvas JIT rendering verification was not performed.
- A new machine may need to approve XCEasyMacroPlugin in Xcode.
- Generated workspaces, reports, and machine-local files are not released.
