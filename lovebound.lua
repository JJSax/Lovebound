local keys = {}
keys.__index = keys

function keys:newSystem()
    local system = {}
    system.pressedKeys = {}
    system.keybinds = {}
    return setmetatable(system, keys)
end

function keys:newKeybind(info)
    assert(
        type(info) == "table",
        [[
            Passed payload needs to be a table. i.e.
            {
                -- keys = {}, -- TODO support multi-key binds
                -- exclusive = false,
                -- ordered = false,
                key = 'keyConstant',
                onPress = function() end,
                onRelease = function() end
            }
        ]]
    )

    assert(type(info.key) == "string", "key must be a string")
    -- TODO assert key is a valid keycode

    local keybind = {
        -- keys = {},
        -- exclusive = false,
        -- ordered = false,
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

function keys:keypressed(key)
    self.pressedKeys[key] = true
end

function keys:keyreleased(key)
    self.pressedKeys[key] = false
end
