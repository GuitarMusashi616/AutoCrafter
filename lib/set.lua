local class = require "lib/class"
local t = require "lib/tbl"

local Set = class()

function Set:__init(...)
  self.set = {}
  for i,v in pairs({...}) do
    self:add(v)
  end
end

function Set:__len()
  --args(self, List)
  return #self.set
end

function Set:__tostring()
  --args(self, List)
  local string = "{"
  for i,v in pairs(self.set) do
    string = string..t.str(i)
    string = string..", "
  end
  string = string:sub(0,#string-2)
  string = string.."}"
  return string
end

function Set:__call() -- returns iterator
  --args(self, List, enumerate, "bool?")
  -- return everything in list except the final
  local key = nil
  return function()
    key = next(self.set, key)
    if key then
      return key
    end
  end
end

function Set:__add(o)
  --args(self, Set, o, Set)
  local new_set = getmetatable(self)()
  for val in self() do
    new_set:add(val)
  end
  for val in o() do
    new_set:add(val)
  end
  return new_set
end

function Set:add(item)
  self.set[item] = true
end

function Set:pop(item)
  self.set[item] = nil
end

function Set:clear()
  self.set = {}
end

function Set:contains(item)
  if self.set[item] then
    return true
  end
  return false
end

return Set