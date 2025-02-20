local this = {}

--[[
Утилита для работы с атрибутами.
Предоставляет функции для преобразования атрибутов между строковым и табличным форматами,
а также для объединения атрибутов.
]]

--[[
Преобразует строку атрибутов в таблицу.
@param str (string) Строка атрибутов в формате key1="value1" key2="value2".
@return (table) Таблица с атрибутами, где ключи — имена атрибутов, а значения — их значения.
]]
local function str2table(str)
    local t = {}
    if str then
        for key, value in str:gmatch('(%w+)="([^"]*)"') do
            t[key] = value
        end
    end
    return t
end

--[[
Преобразует атрибуты в строковый формат.
@param a (table|string) Атрибуты в виде таблицы или строки.
@return (string) Строка атрибутов в формате key1="value1" key2="value2".
]]
function this.any2str(a)
    if not a then
        return ''
    end
    if type(a) == "table" then
        local xml = ''
        for k, v in pairs(a) do
            xml = xml .. ' ' .. k .. '="' .. v .. '"'
        end
        return xml
    end
    if type(a) == "string" then
        return a
    end
    return ''
end

--[[
Преобразует атрибуты в табличный формат.
@param a (string|table) Атрибуты в виде строки или таблицы.
@return (table) Таблица с атрибутами, где ключи — имена атрибутов, а значения — их значения.
]]
function this.any2table(a)
    if not a then
        return {}
    end
    if type(a) == "string" then
        return str2table(a)
    end
    if type(a) == "table" then
        return a
    end
    return {}
end

--[[
Объединяет два набора атрибутов.
Если атрибуты присутствуют в обоих наборах, приоритет отдается второму набору (customAttributes).
@param defaultAttributes (table) Набор атрибутов по умолчанию.
@param customAttributes (table) Набор атрибутов, который имеет приоритет над defaultAttributes.
@return (table) Объединенная таблица атрибутов.
]]
function this.concat(defaultAttributes, customAttributes)
    if not customAttributes then
        return defaultAttributes
    end
    if not defaultAttributes then
        return customAttributes
    end

    local mergedAttributes = this.any2table(defaultAttributes)
    local customAttributesTable = this.any2table(customAttributes)

    for key, value in pairs(customAttributesTable) do
        mergedAttributes[key] = value
    end

    return mergedAttributes
end

return this
