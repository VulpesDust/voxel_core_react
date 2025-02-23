local ReactParser = require('src/react_parser')

require('test/test_react_parser')

local react = {}

react.documents = {}

]]
function react.draw(react_doc)
    local path = react_doc.path
    local doc = react_doc.doc
    local App = react_doc.App
    -- doc.root:clear()

    local node_tree_root = ReactParser.parse(App, path)
    -- print(node_tree_root)
    node_tree_root:compute(doc.root.size)


    -- doc.root:add(rx)
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
