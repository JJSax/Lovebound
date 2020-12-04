local keysystem = {}
keysystem.__index = keysystem

local keycombo = {}
keycombo.__index = keycombo

local function checkKey(key)
    if not pcall(love.keyboard.isDown, key) then
        error(("Not a valid key: %s"):format(key), 2)
    end
end

function keycombo.new(...)
    -- Something like
    -- keycombo.new({'lshift', 'rshift'}, {'lctrl', 'rctrl'})
    -- as a sequence of alternative keys
    local parts = {...}
    local k = {parts = {}}
    for _, p in ipairs(parts) do
        if type(p) == "string" then
            p = {p}
        elseif type(p) ~= "table" then
            error("Each combo part must be either a string or an array")
        end

        for _, choice in ipairs(parts) do
            checkKey(choice)
        end
        table.insert(k.parts, p)
    end

    return setmetatable(k, keycombo)
end

function keycombo:isActive(keystate)
    -- Check if all buttons for this combo are pressed
    for _, part in ipairs(self.parts) do
        local partSatisfied = false
        for _, alternative in ipairs(part) do
            if keystate[alternative] then
                partSatisfied = true
                break
            end
        end

        if not partSatisfied then
            return false
        end
    end
    return true
end

function keysystem:newSystem()
    local system = {}
    system.pressedKeys = {}
    system.keybinds = {}
    return setmetatable(system, keysystem)
end

function keysystem:newKeybind(info)
    assert(
        type(info) == "table",
        [[
            Passed payload needs to be a table. i.e.
            {
                -- keysystem = {}, -- TODO support multi-key binds
                -- exclusive = false,
                -- ordered = false,
                key = 'keyConstant',
                reqCombo = keycombo.new(),
                onPress = function() end,
                onRelease = function(ks, key) end
            }
        ]]
    )

    assert(type(info.key) == "string", "key must be a string")
    checkKey(info.key)

    local keybind = {
        -- keysystem = {},
        -- exclusive = false,
        -- ordered = false,
        reqCombo = keycombo.new(),
        onPress = function()
        end,
        onRelease = function()
        end
    }

    for k, v in pairs(info) do
        keybind[k] = v
    end

    table.insert(self.keybinds, keybind)

    -- require exclusive key hit aka no other buttons can be pushed.
    -- press/release/both --> ok
    -- keyCombination, order specific
end

function keysystem:keypressed(key)
    self.pressedKeys[key] = true
    for _, kb in ipairs(self.keybinds) do
        if kb.key == key and kb.reqCombo:isActive(self.pressedKeys) then
            kb.onPress()
        end
    end
end

function keysystem:keyreleased(key)
    self.pressedKeys[key] = false
    for _, kb in ipairs(self.keybinds) do
        if kb.key == key and kb.reqCombo:isActive(self.pressedKeys) then
            kb.onRelease()
        end
    end
end
