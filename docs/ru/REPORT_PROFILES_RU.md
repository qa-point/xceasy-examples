# Отчёты и диагностика

Examples используют стандартные настройки диагностики XCEasy, чтобы первоначальный setup оставался небольшим. При этом каждый test показывает данные, которые XCEasy оставляет человеку и автоматизированным инструментам для разбора ошибок.

## Что искать в результатах

- Allure result JSON хранит статус, labels, parameters, steps и ссылки на attachments.
- Человекочитаемый test log показывает последовательность business- и technical steps.
- Structured events дают ИИ стабильные code, status, duration и locator context без парсинга случайного текста.
- Query evidence объясняет, что искали, сколько кандидатов найдено и почему действие или assertion не прошло.
- Screenshot и accessibility snapshot фиксируют фактическое состояние экрана при ошибке.
- Performance summary помогает сравнивать длительность поиска, actions, assertions и пользовательских steps между прогонами.

Например, сценарий каталога будет читаться как вложенная последовательность:

```text
SwiftUI product catalog: Open product catalog
└── Tap "Product Catalog"
Check products sorted from highest to lowest price
├── Create locator for component at index [0]
├── Check [Product at index 0: name] label is [Monitor]
├── Create locator for component at index [1]
└── Check [Product at index 1: name] label is [Keyboard]
```

Названия могут быть локализованы настройкой XCEasy, но stable operation codes (`ui.tap`, `component.collection.select_index`) и полная locator-chain `Product[index] → Product.Name` остаются машиночитаемыми.

Артефакты каждого теста изолированы. Параллельные тесты не должны дописывать один log или переиспользовать lifecycle другого теста. Секретные значения передавайте как masked/excluded Allure parameters — в примере password всегда masked.

Examples собирают `allure-results`, но не генерируют HTML и не загружают данные в TestOps. Публикация — отдельный пользовательский или CI-шаг.
