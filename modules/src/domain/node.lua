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

return Node
