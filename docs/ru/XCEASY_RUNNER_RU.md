# Запуск examples через XCEasy Runner

Русский · [English](../en/XCEASY_RUNNER_EN.md) · [README](../../README_RU.md)

## Подготовка

Установите закреплённый Tuist и сгенерируйте workspace:

```bash
mise install
mise exec -- tuist generate --no-open
```

Добавьте runner в `PATH` либо вызывайте его абсолютным путём:

```bash
export PATH="/path/to/xceasy-runner/bin:$PATH"
xceasyctl validate-config xceasy-runner.json
xceasyctl test --config xceasy-runner.json --plan-only
xceasyctl test --config xceasy-runner.json
```

Готовый `xceasy-runner.json` запускает `UIKitExampleTestPlan`, configuration `English`, зелёный UIKit-набор и исключает marker `FailureShowcase`. Для `SwiftUIExampleTestPlan` используйте `xceasy-runner-swiftui.json`. Каждый запуск создаёт `runner-artifacts/run-*`; итоговый Allure input находится в его `allure-results`.

## Поля example-конфигурации

Оба добавленных JSON-файла используют runner schema `1.0.0`. Они отличаются только scheme,
test target, test plan и bundle identifier тестового runner-приложения.

| Поле | Значение в example |
|---|---|
| `schema_version` | Версия валидируемого контракта runner-конфигурации. |
| `mode` | `shard` выполняет каждый выбранный тест один раз и распределяет тесты по устройствам. |
| `retry_missing_tests` | Повторяет только тесты, пропавшие после инфраструктурного сбоя. |
| `max_recovery_attempts` | Максимальное количество recovery-раундов для пропавших тестов. |
| `require_all_devices` | Останавливает preflight вместо незаметного сокращения запрошенной matrix. |
| `workspace` | Generated `XCEasyExamples.xcworkspace`; путь разрешается от директории config. |
| `scheme` | Scheme приложения/UI-тестов: `UIKitExample` или `SwiftUIExample`. |
| `test_target` | XCTest bundle target, из которого перечисляются Swift test methods. |
| `test_plan` | Xcode test plan для сборки и выполнения. |
| `test_configuration` | Ровно одна configuration из выбранного test plan. |
| `runner_bundle_id` | UI-test runner application, из которой экспортируются XCEasy Allure results. |
| `output_directory` | Корень изолированных артефактов `run-*`. |
| `devices` | Simulator, physical-device или mixed execution matrix. |
| `state_isolation` | `app_reset_hook` запрашивает быстрый opt-in reset приложения перед каждым тестом. |
| `selection` | Include-any, include-all и exclude правила markers; пустые include выбирают все тесты. |
| `performance_environment_key` | Стабильная идентичность окружения для сравнимых performance evidence. |

Полная schema и все optional-возможности описаны в
[репозитории XCEasy Runner](https://github.com/qa-point/xceasy-runner). Эти два файла намеренно
остаются минимальными запускаемыми examples, а не копией всех опций runner.

## Test plans

В репозитории лежат настоящие планы [UIKitExampleTestPlan.xctestplan](../../TestPlans/UIKitExampleTestPlan.xctestplan) и [SwiftUIExampleTestPlan.xctestplan](../../TestPlans/SwiftUIExampleTestPlan.xctestplan). Config schema 1.0.0 выбирает plan и одну configuration:

```json
"test_plan": "UIKitExampleTestPlan",
"test_configuration": "English"
```

То же самое можно переопределить в CLI:

```bash
xceasyctl test \
  --config xceasy-runner.json \
  --test-plan UIKitExampleTestPlan \
  --test-configuration English
```

Для нескольких локалей добавьте configurations в `.xctestplan` и запускайте отдельную CI matrix job для каждой. Один runner launch намеренно не смешивает повторные executions разных configurations в одном shard/recovery отчёте.

## Устройства

Selector по имени удобен локально:

```json
{"type": "simulator", "name": "iPhone 17 Pro"}
```

Для CI предпочтителен точный ID. Физический device должен быть подключён, trusted, включён для development и виден в `xcrun devicectl list devices`:

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

Runner собирает simulator и physical products отдельно, но агрегирует их в один отчёт. Signing лучше заранее настроить в Xcode/CI; provisioning-флаги включайте только осознанно. Реальный device path этого example не проверялся из-за отсутствия устройства, но покрыт контрактными fake-тестами runner.

## Быстрая изоляция state

Конфиги examples используют `"state_isolation": "app_reset_hook"`. Runner передаёт режим в UI-test process, test setup добавляет `XC_EASY_RESET_APP_STATE=1` в launch environment, а приложение перед построением UI очищает UserDefaults, Keychain, Application Support, Caches и Documents.

Это не переустановка и обычно занимает миллисекунды. Системные privacy permissions так не сбрасываются: iOS не предоставляет быстрого универсального аналога Android `pm clear`. Если тест проверяет системный permission flow, используйте отдельный simulator/fixture или явно подготовленное состояние.

Перед копированием hook в production-приложение обязательно оставьте строгую opt-in проверку environment и согласуйте, какие хранилища допустимо очищать.

## Production checklist

- храните config и schema version в Git;
- не храните UDID персонального устройства и signing secrets в публичном config;
- исключайте `runner-artifacts`, `.xcresult`, generated workspace и Allure output через `.gitignore`;
- запускайте `xceasyctl validate-config` и `--plan-only` до полного прогона;
- сохраняйте весь `run-*` как CI artifact, а не только `allure-results`;
- используйте `require_all_devices: true`, если сокращённая matrix недопустима.
