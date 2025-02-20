<img src="icon.png">

# Мод для движка VoxelCore

Этот мод предоставляет альтернативный способ создания и отрисовки интерфейсов на движке VoxelCore

**Версия движка:** v0.26.2

## Установка

1. Убедитесь, что у вас установлен движок VoxelCore ([github/MihailRis/VoxelEngine-Cpp](https://github.com/MihailRis/VoxelEngine-Cpp)).
2. Скопируйте файлы мода в соответствующую директорию вашего проекта (`./res/content`).

## Использование

Ниже приведены примеры использования.

### Основной файл инициализации

Создайте файл `layouts/layout_xml_file_name.xml.lua` для инициализации и отрисовки интерфейса:
```lua
local react = require('vcr_0_1_0:react')
local App = require('mod_name:path_to_src/App')

local inited = false

events.on('prefix:event_name__draw', function ()
    Doc.draw()
end)

function on_open()
    if not inited then
        Doc = react.init('mod_name:path_to_src', document, App)
        inited = true
    end
    Doc.draw()
end
```

### Основной компонент приложения

Создайте файл `modules/**/App.lua`, который будет корневым компонентом вашего интерфейса:
```lua

local this = {}

this.children_components = {
    Header = 'Header/Header',
    Footer = 'Footer/Footer'
}

this.rx = function()

    return [[
        <panel>
            <Header/>
            <label>label</label>
            <Footer/>
        </panel>
    ]]
end

return this

```

### Компонент Header
Создайте файл `modules/**/components/Header/Header.lua` для реализации компонента заголовка:
```lua
local this = {}

this.rx = function()
    return [[
        <label>header</label> 
    ]]
end

return this


```
### Компонент Footer
Создайте файл `modules/**/components/Footer/Footer.lua` для реализации компонента заголовка:
```lua

local this = {}

this.rx = function()
    return [[
        <label>footer</label> 
    ]]
end

return this
```

## Как это работает

1. <b>Инициализация:</b> В файле layouts/layout_xml_file_name.xml.lua происходит инициализация React-подобной системы и отрисовка корневого компонента.

2. <b>Компоненты:</b> Компоненты (Header, Footer) определяются в отдельных файлах и могут быть вложены в другие компоненты.

3. <b>Декларативный синтаксис:</b> Интерфейс описывается с помощью XML-подобного синтаксиса, что делает код более читаемым и удобным для разработки.

## Цель

Цель - написать максимально похожую на react библиотеку для движка VoxelCore

## Лицензия
Этот мод распространяется под лицензией MIT. Подробнее см. в файле [LICENSE](LICENSE).
