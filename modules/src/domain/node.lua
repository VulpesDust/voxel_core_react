local StyleParser = require('src/style_parser')

local Node = {}
Node.__index = Node

function Node:new()
    local node = {
        parent = nil,
        children = {},

        tag = nil,
        attributes = {},

        computed = {}
    }
    setmetatable(node, Node)
    return node
end

function Node:__tostring()
    local attrs = {}
    for k, v in pairs(self.attributes) do
        table.insert(attrs, string.format('%s="%s"', k, v))
    end

    if not self.selfclose then
        -- Преобразуем все дочерние элементы в строки
        local children_str = {}
        for _, child in ipairs(self.children) do
            if type(child) == "table" then
                table.insert(children_str, tostring(child)) -- Рекурсивно вызываем __tostring для узлов
            else
                -- table.insert(children_str, '\'start\'' .. child .. '\'end\'') -- Просто добавляем текст
                table.insert(children_str, child) -- Просто добавляем текст
            end
        end

        return string.format("<%s%s>%s</%s>", self.tag, #attrs > 0 and " " .. table.concat(attrs, " ") or "",
            table.concat(children_str), self.tag)
    else
        return string.format("<%s%s/>", self.tag, #attrs > 0 and " " .. table.concat(attrs, " ") or "")
    end
end


-- Функция для парсинга строки
local function parse_units(input)
    -- Таблица для хранения результатов
    local result = {}

    -- Удаляем лишние пробелы в начале и конце строки
    input = input:gsub("^%s*(.-)%s*$", "%1")

    -- Разделяем строку по пробелам
    for value, unit in input:gmatch("(%d+)(%a*%%?)") do
        -- Добавляем результат в таблицу
        table.insert(result, {tonumber(value), unit})
    end

    return result
end

local function unit_str2number(str)

    local unit_name_start, unit_name_end = str:find('px')
    
    return str:sub(0, unit_name_start - 1)

    -- return str
end


local function compute_transform(node, style_str)
    if not style_str then
        return
    end
    local style = StyleParser.parse(style_str)
    for _, v in pairs(style) do
        if v[1] == 'width' then

            
            for _, value in pairs(parse_units(v[2])) do
                print(value[1], value[2])
            end

            -- node.computed.width = unit_str2number(v[2]) -- TODO px to number
            -- print('node.computed.width', node.computed.width)
        elseif v[1] == 'height' then

            for _, value in pairs(parse_units(v[2])) do
                print(value[1], value[2])
            end

            -- node.computed.height = unit_str2number(v[2]) -- TODO px to number
            -- print('node.computed.height', node.computed.height)
        end
    end
end

local function compute(node)
    for _, child in pairs(node.children) do
        if type(child) == "table" then
            child.computed = {}
            compute_transform(child, child.attributes.style)
            compute(child)
        end
    end
end

function Node:compute(size)

    local computed = {
        width = size[1],
        height = size[2],
    }

    self.computed = {}

    compute(self)
end

return Node
