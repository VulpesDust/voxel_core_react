local Node = require('src/domain/node')

local function parse_recursively(html)
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
                -- Открывающий тег или самозакрывающийся тег
                local j = html:find("[ >]", i)
                local tag = html:sub(i + 1, j - 1)
                local end_tag = html:find('>', j)
                local selfclose = html:sub(end_tag - 1, end_tag) == '/>' -- Проверяем, является ли тег самозакрывающимся
                if selfclose then
                    tag = html:sub(i + 1, j - 2)
                end
                local node = Node:new(tag)
                node.selfclose = selfclose

                if html:sub(j, j) ~= '>' then
                    -- Парсинг атрибутов
                    local end_tag = html:find('>', j)
                    while j < end_tag do -- html:sub(j, j) ~= ">" do
                        local attr_start, attr_end = html:find('(%w+)=?', j)
                        if html:sub(attr_end, attr_end) ~= '=' then
                            node.attributes[html:sub(attr_start, attr_end)] = true
                            j = attr_end + 1
                        end

                        local attr_start, attr_end = html:find('(%w+)="([^"]*)"', j)
                        if attr_start then
                            local name, value = html:sub(attr_start, attr_end):match('([%w-]+)%s*=%s*["\'](.-)["\']')
                            node.attributes[name] = value
                            j = attr_end + 1
                        else
                            break
                        end

                        j = html:find('%S', j)
                    end
                end

                table.insert(stack[#stack].children, node)
                node.parent = stack[#stack]
                if not selfclose then
                    table.insert(stack, node)
                end
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

function ReactParser.parse(App, path)
    return parse_recursively(App.get_xml(), path)
end

return ReactParser
