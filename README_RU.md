# XCEasy Examples

Два независимых демонстрационных iOS-приложения для изучения XCEasy и проверки реальных UI-сценариев:

```text
XCEasyExamples
├── UIKitExample ─── UIKit-приложение + UIKitExampleUITests
└── SwiftUIExample ─ SwiftUI-приложение + SwiftUIExampleUITests
```

Это не гибридное приложение и не два target одного интерфейса. У каждого example собственные lifecycle, UI-код, bundle ID, Page Objects и UI-test target. Идентификаторы начинаются с `UIKitExample.` или `SwiftUIExample.`, поэтому не пересекаются.

## Что можно посмотреть

Главный экран каждого приложения указывает UI-фреймворк и ведёт к пяти независимым примерам:

| Экран | Состояния и компоненты |
|---|---|
| Authorization | поля login/password, три ошибки, disabled button, трёхсекундный loader, успешный переход |
| Components | text field, switch/checkbox, выбор одного варианта, удаляемый banner, коллекция повторяющихся элементов |
| Dynamic content | отложенная загрузка, animation, появление деталей, удаление и восстановление карточки |
| Overlays | системный alert, modal sheet, временный toast |
| Product catalog | данные, доступность товара, поиск, пустое состояние, сортировка, коллекция карточек |

Полный перечень ручных сценариев и соответствующих тестов: [Каталог возможностей](docs/ru/FEATURE_CATALOG_RU.md).

## Требования

- технический минимум: Xcode 15 и Swift 5.9 (нужны для package manifest и macros);
- проверенная и поддерживаемая сейчас matrix: Xcode 26.5 и Swift 6.3.2;
- Tuist 4.203.3;
- deployment target iOS 15.0; проверенный simulator runtime — iOS 26.5.

Версия Tuist закреплена в `mise.toml`. Установите её из корня репозитория:

```bash
mise install
```

Скрипты запускают Tuist через mise и сами выбирают полноценный `Xcode.app`, если системный `xcode-select` указывает только на Command Line Tools. Для нестандартного расположения Xcode передайте `DEVELOPER_DIR`; для CI также доступен явный `TUIST_BIN`.

Версии Xcode 15–26.4 технически могут собрать package, но пока не входят в CI matrix и поэтому не заявлены как гарантированно поддерживаемые.

## Открыть и посмотреть приложение

Сгенерируйте workspace:

```bash
mise exec -- tuist generate
```

В Xcode выберите схему `UIKitExample` или `SwiftUIExample`, любой доступный iPhone Simulator и нажмите Run. Для экрана Authorization действительные данные: `admin` / `password`.

Можно собрать и открыть приложение одной командой без ручной работы в Xcode:

```bash
./scripts/run-app.sh UIKitExample
./scripts/run-app.sh SwiftUIExample
```

По умолчанию examples используют выпущенный пакет XCEasy. Для разработки с соседним локальным checkout:

```bash
TUIST_XCEASY_USE_LOCAL_PACKAGE=1 mise exec -- tuist generate --no-open
```

## Запустить UI-тесты

Production-пример конфигурации XCEasy Runner, Xcode test plans, mixed simulator/physical matrix, signing и быстрый reset state описаны в [гайде по Runner](docs/ru/XCEASY_RUNNER_RU.md).

```bash
xcodebuild test \
  -workspace XCEasyExamples.xcworkspace \
  -scheme UIKitExample \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

Замените scheme на `SwiftUIExample` для второго приложения. Полная последовательная проверка обоих targets (без одновременной нагрузки на компьютер):

```bash
./scripts/check.sh
```

UI-тесты находятся только в этом репозитории. Они показывают parameterized XCTest, Allure metadata, обычные и soft assertions, ленивые Page Objects, collections, ожидания, отрицательные проверки и повторное разрешение элемента после его удаления и создания заново.

## Отчёты, диагностика и AI-логи

Каждый тест создаёт изолированные raw-results, структурированные события, обычный log и диагностические вложения. После последовательного прогона `scripts/check.sh` собирает результаты обеих UI-test schemes в общую директорию `allure-results` в корне репозитория. HTML не генерируется и данные не отправляются в TestOps автоматически.

Example намеренно использует стандартные настройки диагностики XCEasy. Состав
создаваемых артефактов описан в документе [Отчёты и диагностика](docs/ru/REPORT_PROFILES_RU.md).

Намеренно неуспешные примеры не входят в обычный зелёный `scripts/check.sh`. Для ручной проверки Allure единый запуск собирает 46 успешных и 10 ожидаемо неуспешных результатов в общей директории `allure-results`:

```bash
./scripts/check-all.sh
allure serve allure-results
```

## Непрерывная интеграция

Добавленный [CI workflow](.github/workflows/ci.yml) устанавливает версии из `mise.toml`, запускает
SwiftLint, генерирует workspace и собирает обе application schemes. Hosted CI намеренно не запускает
UI-тесты: simulator acceptance и проверка Allure выполняются локально командами `scripts/check.sh`
или `scripts/check-all.sh` выше. CI-сборка использует релизную версию Swift package XCEasy, поэтому
token для приватного репозитория ей не нужен.

Та же облегчённая проверка локально:

```bash
./scripts/check-ci.sh
```

## Полезные документы

- [Гайд по архитектуре UI-автотестов и Page Objects](docs/ru/UI_AUTOTEST_GUIDE_RU.md)
- [Каталог экранов и тестовых сценариев](docs/ru/FEATURE_CATALOG_RU.md)
- [Отчёты и диагностика](docs/ru/REPORT_PROFILES_RU.md)
- [Расширенный setup тестов](docs/ru/ADVANCED_TEST_SETUP_RU.md)
- [Запуск через XCEasy Runner](docs/ru/XCEASY_RUNNER_RU.md)
- [English README](README.md)
