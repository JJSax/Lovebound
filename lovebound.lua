local keys = {}
keys.__index = keys

keys.pressedKeys = {}
keys.context = "default"

function keys:newSystem()
	return setmetatable({}, keys)
end

function keys:newKeybind(info)
	assert(type(info) == "table", [[
		Passed payload needs to be a table. i.e.
		{
			keys = {},
			exclusive = false,
			ordered = false,
			context = "default"
		}
	]])
	local default = {
		keys = {},
		exclusive = false,
		ordered = false,
		context = "default"
	}

	for k,v in pairs(info) do
		default[k] = v
	end

	

	-- require exclusive key hit aka no other buttons can be pushed.
	-- press/release/both
	-- keyCombination, order specific
	-- context

end

-- context is what state
function keys:addContext(context)

end
function keys:removeContext(context)

end





function keys.keypressed(key)
	keys.pressedKeys[key] = true
end

function keys.keyreleased(key)
	keys.pressedKeys[key] = false
end

function keys.setContext(context)
	keys.context = context
end
