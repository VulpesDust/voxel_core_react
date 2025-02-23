local ReactParser = require('src/react_parser')

local LEVELS_COLOR = {
    FATAL = 91,
    ERROR = 31,
    WARN = 33,
    INFO = 32,
    DEBUG = 36,
    TRACE = 90
}

local function print_test(text, type)
    if not type then
        type = LEVELS_COLOR.INFO
    end
    print(string.format('\x1b[%sm%s\x1b[0m', type, text))
end

local AppTestAttributes = {}

function AppTestAttributes.get_xml()
    return [[
        <div disabled class="header" >Привет, мир!</div>
        <div disabled class="header">Привет, мир!</div>
        <div class="header2" style="width: 100px; height: 100px"  >H2</div>
        <div class="header2" style="width: 100px; height: 100px">H2</div>
        <div>Это пример HTML-документа.</div>
        <div>
            <div>asdf</div>
            <div>asdf2</div>
        </div>
        <div>
            <div>asdf3</div>
            <div>asdf4</div>
        </div>
    ]]
end

local node_tree = ReactParser.parse(AppTestAttributes)

if tostring(node_tree) == '<root><div disabled="true" class="header">Привет, мир!</div><div disabled="true" class="header">Привет, мир!</div><div class="header2" style="width: 100px; height: 100px">H2</div><div class="header2" style="width: 100px; height: 100px">H2</div><div>Это пример HTML-документа.</div><div><div>asdf</div><div>asdf2</div></div><div><div>asdf3</div><div>asdf4</div></div></root>' then
    print_test('TEST OK ' .. 'AppTestAttributes')
else
    print_test('TEST WARN ' .. 'AppTestAttributes', LEVELS_COLOR.WARN)
end

