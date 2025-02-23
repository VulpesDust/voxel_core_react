local StyleParser = {}

function StyleParser.parse(style_str)
    local styles = {}

    -- Разделяем строку по точкам с запятой
    for rule in style_str:gmatch("([^;]+)") do
        -- Убираем лишние пробелы в начале и конце
        rule = rule:match("^%s*(.-)%s*$")

        -- Разделяем правило на ключ и значение
        local key, value = rule:match("([^:]+):([^:]+)")

        if key and value then
            -- Убираем лишние пробелы в ключе и значении
            key = key:match("^%s*(.-)%s*$")
            value = value:match("^%s*(.-)%s*$")

            -- Добавляем в таблицу стилей
            table.insert(styles, {key, value})
        end
    end


    for _, v in pairs(styles) do
        print(v[1] .. " = " .. v[2])
    end

    return styles
end

return StyleParser
