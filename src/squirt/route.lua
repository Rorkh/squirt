local route = {}

local turbo = require("turbo")

function route:new(app, path)
	local obj = {}
		obj.application = app
		obj.path = path
		-- TODO: better naming 
		obj.handler = class("Class" .. math.random(1,10000000), turbo.web.RequestHandler)

	function obj:register()
		table.insert(obj.application.routes, {obj.path, obj.handler})
	end

	setmetatable(obj, self)
	self.__index = self
	self.__newindex = function(table, key, value)
		obj.handler[key] = function(rhandler)
			rhandler:write(value(nil, rhandler))
		end
	end

	return obj
end

return route
