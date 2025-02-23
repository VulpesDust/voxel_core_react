local ReactParser = require('src/react_parser')

-- require('test/test_react_parser')

local react = {}

--[[
    [path] = react_doc = {
        path: string,
        doc: document,
        App: table,
        draw: func,
    }
]]
react.documents = {}

--[[
TODO переводит подобие react в дерево, а потом дерево в xml строку
]]
function react.draw(react_doc)
    local path = react_doc.path
    local doc = react_doc.doc
    local App = react_doc.App
    doc.rroot:clear()

    local rx = App.rx()
    local cc = App.children_components
    if cc then
        for k, v in pairs(cc) do
            local start_pos, end_pos = string.find(rx, k)
            if start_pos ~= nil then
                local component = require(path .. '/components/' .. v)
                rx = string.gsub(rx, '<'..k..'/>', component.rx())
            end
        end
    end

    -- print(rx)
    if rx ~= '' then
        doc.rroot:add(rx)
    end
end

-- path - path to components - путь до компонентов
-- document - встроенная библиотека document
-- root - елемент с id 
function react.init(path, document, App)
    local react_doc = {
        path = path,
        doc = document,
        App = App,
    }
    react_doc.draw = function() react.draw(react_doc) end
    react.documents[path] = react_doc
    return react_doc
end

return react
