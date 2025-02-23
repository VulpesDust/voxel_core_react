local Node = {}
Node.__index = Node

function Node:new(tag, attributes, children)
    local node = {
        tag = tag,
        attributes = attributes or {},
        children = children or {}
    }
    setmetatable(node, Node)
    return node
end

function Node:__tostring()
    local attrs = {}
    for _, v in pairs(self.attributes) do
        table.insert(attrs, string.format('%s="%s"', v[1], v[2]))
    end

    -- Преобразуем все дочерние элементы в строки
    local children_str = {}
    for _, child in ipairs(self.children) do
        if type(child) == "table" then
            table.insert(children_str, tostring(child)) -- Рекурсивно вызываем __tostring для узлов
        else
            table.insert(children_str, '\'start\'' .. child .. '\'end\'') -- Просто добавляем текст
        end
    end

    return string.format("<%s%s>%s</%s>", self.tag, #attrs > 0 and " " .. table.concat(attrs, " ") or "",
        table.concat(children_str), self.tag)
end

local function parse_html(html)
    local stack = {}
    local root = Node:new("root")
    table.insert(stack, root)

    local i = 1
    while i <= #html do
        if html:sub(i, i) == "<" then
            if html:sub(i + 1, i + 1) == "/" then
                -- Закрывающий тег
                local j = html:find(">", i)
                local tag = html:sub(i + 2, j - 1)
                if stack[#stack].tag == tag then
                    table.remove(stack, #stack)
                end
                i = j + 1
            else
                -- Открывающий тег
                local j = html:find("[ >]", i)
                local tag = html:sub(i + 1, j - 1)
                local node = Node:new(tag)

                if html:sub(j, j) ~= '>' then
                    -- Парсинг атрибутов
                    local max_j = html:find('>', j)
                    while j < max_j do -- html:sub(j, j) ~= ">" do
                        local attr_start, attr_end = html:find('(%w+)=?', j)
                        if html:sub(attr_end, attr_end) ~= '=' then
                            -- node.attributes[html:sub(attr_start, attr_end)] = true
                            table.insert(node.attributes, {html:sub(attr_start, attr_end), true})
                            j = attr_end + 1
                        end

                        local attr_start, attr_end = html:find('(%w+)="([^"]*)"', j)
                        if attr_start then
                            local name, value = html:sub(attr_start, attr_end):match('([%w-]+)%s*=%s*["\'](.-)["\']')
                            table.insert(node.attributes, {name, value})
                            -- node.attributes[name] = value
                            j = attr_end + 1
                        else
                            break
                        end

                        j = html:find('%S', j)
                    end
                end

                table.insert(stack[#stack].children, node)
                table.insert(stack, node)
                i = html:find(">", i) + 1
            end
        else
            -- Текст между тегами
            local j = html:find("<", i)
            if j then
                local text = html:sub(i, j - 1)
                text = text:gsub("^%s*(.-)%s*$", "%1")
                if text ~= '' then
                    table.insert(stack[#stack].children, text)
                end
                i = j
            else
                break
            end
        end
    end

    return root
end

local ReactParser = {}

function ReactParser.parse_xml(xml) return parse_html(xml) end

function ReactParser.parse_app(App) return parse_html(App.get_xml()) end

return ReactParser
