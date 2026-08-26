# Каталог возможностей

Оба приложения реализуют одинаковые пользовательские сценарии разными UI-технологиями. Это позволяет сравнивать поведение XCUITest и XCEasy, не смешивая UIKit и SwiftUI в одном target.

## Ручная проверка

### Authorization

Откройте `Authorization` и проверьте четыре ветки:

1. Пустой login и заполненный password → `Enter your login.`
2. Заполненный login и пустой password → `Enter your password.`
3. Любая неверная пара → `Incorrect login or password.`
4. `admin` / `password` → button блокируется, loader остаётся на экране три секунды, затем появляется `Authorization successful`.

### Components

Поле принимает текст, checkbox меняет selected state, а выбор варианта снимает selection с предыдущего. Banner можно закрыть: он полностью удаляется из accessibility tree. После восстановления создаётся новый banner с теми же identifier и новым номером. Четыре строки позволяют проверять `XCEasyComponentCollection`, count, first и last.

### Dynamic content

До нажатия Load карточки нет в дереве. После нажатия появляется loader, через 1.5 секунды карточка анимированно входит на экран. Details можно показать и скрыть; Remove удаляет всю карточку, Restore создаёт её снова.

### Overlays

Экран открывает системный confirmation alert, modal sheet с отдельной кнопкой Close и toast, который автоматически удаляется из дерева через четыре секунды.

### Product catalog

Каталог содержит четыре товара с названием, ценой и доступностью. Все карточки и их дочерние поля используют одинаковые identifiers; тест сначала выбирает карточку по индексу, а затем ищет `name` и `details` только внутри неё. Поэтому проверка Sort фиксирует реальный визуальный порядок, а не просто наличие товара где-то на экране. Search фильтрует список и показывает empty state при отсутствии совпадений.

## Покрытие UI-тестами

В каждом target запускаются одинаковые 14 итераций, разделённые на шесть тестовых классов по
фичам: Home, Authorization, Components, Dynamic Content, Overlays и Catalog. Каждый сценарий
оформлен бизнес-шагами GWT, внутри которых находятся технические действия и проверки XCEasy:

- готовность home и всех navigation buttons;
- три параметризованных негативных случая Authorization;
- успешный вход и lifecycle loader;
- два параметризованных ввода данных;
- hard/soft assertions для selected state и collection;
- удаление и повторное создание banner через сохранённый ленивый POM;
- loader, animation, details, remove и restore динамической карточки;
- lifecycle alert, sheet и toast;
- count, данные внутри конкретной карточки, порядок до и после сортировки, фильтр и empty state.

Итого оба приложения дают 28 тестовых итераций. Оба target используют безопасную стандартную готовность action `.hittable`: XCEasy выполняет действие только после того, как XCTest подтвердил возможность взаимодействия с элементом.

## Контракт идентификаторов

Все UIKit identifiers начинаются с `UIKitExample.`, все SwiftUI identifiers — с `SwiftUIExample.`. Имя описывает экран и роль, например `SwiftUIExample.Authorization.LoginField`. Identifier не строится из локализованного текста и остаётся стабильным при изменении подписи.
