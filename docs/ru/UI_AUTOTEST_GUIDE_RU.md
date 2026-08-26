# Как писать UI-автотесты с XCEasy

Русский · [English](../en/UI_AUTOTEST_GUIDE_EN.md) · [README](../../README_RU.md)

Этот гайд описывает рекомендуемую архитектуру XCUITest-наборов на XCEasy. Примеры применимы и к UIKit, и к SwiftUI: UI-код и Page Objects остаются независимыми, а общими могут быть только нейтральные test data и инфраструктура.

## 1. Границы слоёв

```text
Test case          бизнес-сценарий, GWT, metadata и ожидаемый результат
    ↓
Page Object        доступные пользователю действия и явные бизнес-проверки
    ↓
Component          повторно используемая часть экрана
    ↓
XCEasyUIElement    locator, interaction, wait и низкоуровневая assertion
```

- Тест отвечает на вопрос «что проверяет пользовательский сценарий».
- POM скрывает accessibility identifiers, типы XCUI-элементов и техническую последовательность действий.
- Action-метод взаимодействует с UI, но не подтверждает ожидаемый результат сценария.
- Assertion-метод называется `assert*` и явно сообщает, что он проверяет.
- `waitFor*` используется только для синхронизации. Это не assertion: возвращённый `Bool` нельзя молча игнорировать, если состояние является обязательным результатом теста.

## 2. Структура файлов

Одна UI-фича должна соответствовать одному test class, один test class — одному файлу:

```text
UITests/
├── Core/
│   ├── ExampleTestCase.swift
│   └── PageObjectsProviding.swift
├── Screens/
│   ├── AuthorizationPOM.swift
│   ├── CatalogPOM.swift
│   └── Components/
│       └── ProductCardPOM.swift
├── TestData/
│   └── AuthorizationCase.swift
└── Tests/
    ├── AuthorizationTests.swift
    └── CatalogTests.swift
```

Не создавайте один глобальный `AppPOM`, который знает обо всех экранах и хранит изменяемое состояние. Provider с computed properties возвращает свежие ленивые POM и не читает accessibility tree:

```swift
protocol PageObjectsProviding {
    var home: HomePOM { get }
    var authorization: AuthorizationPOM { get }
}

extension PageObjectsProviding {
    var home: HomePOM { HomePOM() }
    var authorization: AuthorizationPOM { AuthorizationPOM() }
}
```

## 3. Правильный Page Object

POM должен быть `struct`, описывать корневой `element` и создавать только ленивые локаторы. Его initializer не должен обращаться к UI, проверять существование элемента или кешировать `XCUIElement`/index текущего дерева.

Секции каждого POM располагаются в строгом порядке: protocol setup (`XCEasyComponent` или `XCEasyIndexedComponent`), `Elements`, `Components`, `Component Collections`, `Actions`, `Assertions`, затем при необходимости private helpers. Пустые секции не добавляются.

```swift
struct AuthorizationPOM: XCEasyComponent {
    let componentName = "Authorization"

    var element: XCEasyUIElement {
        find(identifier: "Authorization.Screen", desc: componentName)
    }

    private var login: XCEasyUIElement {
        element.child(type: .textField, identifier: "Authorization.Login")
    }

    private var password: XCEasyUIElement {
        element.child(type: .secureTextField, identifier: "Authorization.Password")
    }

    private var submit: XCEasyUIElement {
        element.child(type: .button, identifier: "Authorization.Submit")
    }

    @discardableResult
    func signIn(login loginValue: String, password passwordValue: String) -> Self {
        step("Fill and submit credentials") {
            login.typeText(loginValue)
            password.typeText(passwordValue)
            submit.tap()
        }
        return self
    }

    @discardableResult
    func assertValidationError(_ message: String) -> Self {
        step("Check validation error") {
            element
                .child(identifier: "Authorization.Error")
                .child(type: .staticText, text: message)
                .assertIsDisplayed()
        }
        return self
    }
}
```

Предпочитайте `element.child(...)`, когда элемент принадлежит конкретному экрану или компоненту. Глобальный `find(...)` оставляйте для системных alert, keyboard и объектов, которые действительно находятся вне контейнера экрана.

Не добавляйте отдельный `waitForHittable()` перед каждым `tap()`: action сам ждёт необходимое состояние. Явный wait нужен только когда тест синхронизируется с самостоятельным переходным состоянием.

## 4. Actions и assertions

Хорошие action-методы:

```swift
func openCatalog()
func search(for query: String)
func selectSort(_ order: SortOrder)
func dismiss()
```

Хорошие assertion-методы:

```swift
func assertIsReady()
func assertValidationError(_ message: String)
func assertProduct(name: String, price: String)
func assertEmptyState()
```

Избегайте методов вроде `loginAndAssertSuccess()`: действие и ожидаемый результат должны оставаться разными шагами сценария. Не прячьте assertion внутри `open*`, `tap*`, `enter*` или `select*`.

Низкоуровневые элементы можно оставлять публичными в учебных примерах, демонстрирующих API XCEasy. В продуктовом наборе лучше сначала дать тесту доменный метод, а прямой доступ к элементу использовать только когда он делает сценарий яснее, а не раскрывает технические детали.

## 5. Компоненты и коллекции

Повторяющийся блок оформляйте отдельным `XCEasyComponent`. Динамический список — через `XCEasyIndexedComponent` и `XCEasyComponentCollection`, а не через сохранённый массив элементов.

```swift
struct ProductCardPOM: XCEasyIndexedComponent {
    static var collection: XCEasyUIElement {
        find(identifier: "Catalog.Product", desc: "Products")
    }

    private let position: XCEasyComponentPosition
    let componentName: String

    init(position: XCEasyComponentPosition, componentName: String?) {
        self.position = position
        self.componentName = componentName ?? Self.defaultComponentName(for: position)
    }

    var element: XCEasyUIElement {
        Self.collection.element(at: position, desc: componentName)
    }
}
```

`first`, `last` и `get(index:)` остаются ленивыми и заново разрешают текущий UI. Это позволяет безопасно хранить POM, удалить компонент, создать его снова и использовать тот же POM для replacement.

Если `componentName` не задан явно, XCEasy сформирует человекочитаемое имя с учётом позиции: `First ProductCardPOM`, `Last ProductCardPOM` или `ProductCardPOM at index 2`. Доменное имя по-прежнему можно передать явно, когда оно делает отчёт понятнее.

Если один компонент коллекции используется в нескольких проверках, вынесите ленивый POM в локальную переменную с предметным названием. Не называйте такие переменные `first`, `item` или `element`: имя должно объяснять роль объекта на экране. Получение POM не разрешает accessibility tree, поэтому такая переменная сохраняет ленивое поведение коллекции.

Прямой единичный вызов у простого receiver оставляйте в одной строке. Если вызов идёт через элемент или компонент либо цепочка содержит несколько операций, переносите последнее звено на следующую строку. Так простой вызов не растягивается, а составной путь остаётся визуально читаемым:

```swift
home.openCatalog()

let firstProduct = productCatalog.productCards
    .get(index: 0)

firstProduct.nameLabel
    .assertLabel(value: "Mouse")
firstProduct.detailsLabel
    .assertLabel(value: "$49 · In stock")
```

Если компонент используется один раз, локальная переменная не обязательна. Не создавайте переменную и не переносите вызов только ради форматирования одной простой операции.

## 6. Структура теста

Каждый тест должен иметь один понятный сценарий и выражать его через `given`, `when`, `then`, `and`. Технические вызовы находятся внутри соответствующего бизнес-шага:

После первого `then` не выполняйте новые действия. Допустимы только дополнительные проверки через `and`. Если после проверки требуется ещё один `when`, это обычно отдельный test case: подготовьте необходимое состояние в `given`, выполните одно проверяемое действие в `when` и завершите тест ожидаемым результатом в `then`/`and`. Исключение должно быть осознанным и отражать один неделимый бизнес-сценарий.

```swift
@Epic("Checkout")
@Feature("Authorization")
@Story("Successful authorization")
@Marker("Smoke")
final class AuthorizationTests: ExampleTestCase {
    func testValidCredentialsOpenAccount() {
        given("the authorization screen is open") {
            home.openAuthorization()
            authorization.assertIsDisplayed()
        }

        when("the user signs in with valid credentials") {
            authorization.signIn(login: "admin", password: "password")
        }

        then("the account screen is displayed") {
            account.assertIsReady()
        }
    }
}
```

Не используйте `sleep`. Для обязательного результата вызывайте assertion с осмысленным timeout. Если нужен только synchronization branch, обработайте результат wait явно:

```swift
guard loader.waitForDisplayed(timeout: 1) else {
    // Ветка допустима только если loader действительно необязателен.
    return
}
```

Если loader является частью контракта, используйте `loader.assertIsDisplayed(timeout: 1)`.

## 7. Изоляция и lifecycle

- Каждый test method получает новое приложение и execution-scoped XCEasy state.
- Начальное состояние задавайте launch arguments/environment либо детерминированным setup API.
- Не полагайтесь на порядок тестов, singleton с изменяемым состоянием или результат предыдущего test method.
- Конфигурацию задавайте в `configuration()`, общую metadata/preconditions — в `beforeTest()`, очистку при живом приложении — в `afterTest()`.
- Всегда вызывайте соответствующий `super` согласно lifecycle XCEasy.
- Не переопределяйте `setUpWithError()` и `tearDownWithError()` без инфраструктурной необходимости.

## 8. Параметризация, metadata и секреты

Параметризуйте один и тот же сценарий с разными данными, а не разные бизнес-потоки. У case должен быть стабильный читаемый `id`; чувствительные значения передавайте в Allure как `.masked` или `.hidden`.

```swift
parameter("login", value: data.login)
parameter("password", value: data.password, mode: .masked)
```

Markers должны описывать устойчивые признаки отбора (`Smoke`, `Regression`, платформа или функциональная область), потому что runner использует их для selection и sharding. Не кодируйте в marker временные статусы и порядок запуска.

## 9. Soft assertions

`softly` полезен для нескольких независимых характеристик одного уже открытого состояния, например label, selected state и наличие соседних элементов. Не объединяйте soft assertions с действиями и не продолжайте через них сценарий, если следующему шагу требуется успешно выполненная проверка.

## 10. Что проверять перед merge

1. Accessibility identifiers стабильны, уникальны в нужном scope и не зависят от локализованного текста.
2. Создание POM/collection не разрешает UI и не выполняет assertions.
3. Action-методы не содержат expected-result assertions.
4. Expected result находится в `then`/`and` или явном `assert*` POM-методе.
5. Результаты обязательных `waitFor*` не игнорируются.
6. В тестах нет `sleep`, зависимости от порядка и общего изменяемого состояния.
7. Секреты маскируются в parameters и диагностике.
8. Один test class покрывает одну feature и находится в отдельном файле.
9. Проверены Allure result/container, events, log и вложения для успешного и намеренно упавшего теста.
10. Последовательно запущены обе схемы:

```bash
./scripts/check.sh
```

Для разработки соседнего checkout фреймворка используется `TUIST_XCEASY_USE_LOCAL_PACKAGE=1`; потребительский контракт дополнительно проверяется с выпущенной версией Swift package.

Намеренно падающие showcase-тесты не входят в обычный зелёный regression run. Для ручной проверки используется `./scripts/check-all.sh`: он сначала собирает зелёный regression, затем добавляет в тот же `allure-results` ожидаемые basic, list/soft и parameterized failures. Итоговый единый отчёт содержит 46 `passed` и 10 `failed` результатов.
