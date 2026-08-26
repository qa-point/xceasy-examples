# Расширенный setup тестов

Начинайте с `ExampleTestCase`. В его конфигурации есть только bundle identifier приложения и локализация — для example-тестов этого достаточно.

В репозитории есть отдельные справочные реализации для
[UIKit](../../UIKitExample/UITests/TestSupport/TestSetup/UIKitAdvancedExampleTestCase.swift) и
[SwiftUI](../../SwiftUIExample/UITests/TestSupport/TestSetup/SwiftUIAdvancedExampleTestCase.swift).
Существующие тесты от них не наследуются. Код намеренно продублирован, чтобы каждый UI-test target был полноценным самостоятельным примером. При внедрении скопируйте только нужные проекту настройки.

## Настройки

- `findTimeout` ограничивает время ожидания при поиске элемента.
- `actionTimeout` ограничивает синхронизацию перед действиями, например `tap`.
- `assertionTimeout` ограничивает polling внутри assertions.
- `localization` выбирает язык шагов и диагностических сообщений XCEasy.
- `printLogToConsole` дублирует отдельный test log в консоль Xcode. Это удобно при отладке, но увеличивает CI-вывод.
- `uiQueryEvidenceLevel: .detailed` сохраняет дополнительные данные о locator и найденных кандидатах.
- `performance.level: .detailed` включает подробные timings операций.
- `defaultBudgetMilliseconds` задаёт ожидаемую длительность операции, если отдельный бюджет не указан.
- `budgetPolicy: .warn` сообщает о превышении бюджета, но не роняет тест.
- `healing.mode: .suggest` записывает предложения по восстановлению locator, но никогда не изменяет исходный код теста.
- `minimumConfidence` отбрасывает слабые healing-кандидаты.
- `minimumScoreGap` требует, чтобы лучший кандидат заметно превосходил следующий.
- `diagnosticSnapshotByteLimit` ограничивает размер accessibility snapshot в диагностике.
- `XCEasyAllureConfig.apply` задаёт шаблоны ссылок для metadata `issue(...)` и `tms(...)`.

Используйте расширенный setup, когда подробная диагностика оправдывает более крупные artifacts и подробные логи. Для знакомства с проектом и небольших наборов тестов оставляйте минимальный setup.
