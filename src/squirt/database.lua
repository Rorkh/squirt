local database = {}

local model = require("squirt.database.model")
local sqlite = require("lsqlite3complete")
local querygen = require("squirt.database.querygen")

function database:new(filename)
	local obj = {}
		self.models = {}
		obj.filename = filename
		obj.field = require("squirt.database.fields")
	
	function obj:instance()
		return sqlite.open(self.filename)
	end

	function obj:model(name, struct)
		table.insert(self.models, name)
		self[name] = model:instance(self, name, struct)
	end

	function obj:register()
		local database = sqlite.open(self.filename)
		
		for _, name in ipairs(self.models) do
			database:exec(querygen.new_table(name, self[name].struct))
		end

		database:close()
	end

	setmetatable(obj, self)
	self.__index = self

	return obj
end

return database
