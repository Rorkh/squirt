local squirt = {templates = {}}
	
local engine = require("aspect.template").new({
	cache = true,
	loader = function(name)
		-- TODO: Async?
		if not squirt.templates[name] then
			local file = io.open(name, "r")
			squirt.templates[name] = file:read("*a")
			file:close()
		end
	
		return squirt.templates[name]
	end
})

squirt.template = {
	render = function(filename, context)
		local content = engine:render(filename, context)
		return tostring(content)
	end
}

local route = require("squirt.route")
local turbo = require("turbo")

function squirt.Application()
	local application = {}
		application.routes = {}	
	
	function application:route(path)
		return route:new(self, path)
	end

	function application:static(path, file)
		table.insert(self.routes, {path, turbo.web.StaticFileHandler, file})
	end

	function application:serve(port)
		self.instance = turbo.web.Application(self.routes)
	
		self.instance:listen(port)
		turbo.ioloop.instance():start()
	end

	return application
end

return squirt
