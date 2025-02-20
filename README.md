# Мод для движка VoxelCore

Этот мод добавляет альтернативный способ рисованя интерфейсов на движке

**Версия движка:** v0.26.2

## Установка

1. Убедитесь, что у вас установлен движок VoxelCore ([github/MihailRis/VoxelEngine-Cpp](https://github.com/MihailRis/VoxelEngine-Cpp)).
2. Скопируйте файлы мода в соответствующую директорию вашего проекта (`./res/content`).

## Использование

Для использования 

файл layouts/layaout_xml_file_name.xml.lua
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

файл modules/**/App.lua
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

файл modules/**/components/Header/Header.lua
```lua
local this = {}

this.rx = function()
    return [[
        <label>header</label> 
    ]]
end

return this


```

файл modules/**/components/Footer/Footer.lua
```lua

local this = {}

this.rx = function()
    return [[
        <label>footer</label> 
    ]]
end

return this
```
