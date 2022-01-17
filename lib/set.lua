local class = require "lib/class"
local t = require "lib/tbl"

local Set = class()

function Set:__init(...)
  self.set = {}
  self.n = 0
  for i,v in pairs({...}) do
    self:add(v)
  end
end

function Set:__len()
  --args(self, List)
  return self.n
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
  if self.set[item] then
    return
  end
  self.set[item] = true
  self.n = self.n + 1
end

function Set:pop(item)
  if item == nil then
    for k,v in pairs(self.set) do
      self.set[k] = nil
      self.n = self.n-1
      return k
    end
  else
    self.set[item] = nil
    self.n = self.n - 1
  end
end

function Set:clear()
  self.set = {}
  self.n = 0
end

function Set:contains(item)
  if self.set[item] then
    return true
  end
  return false
end

function Set:to_table()
  return self.set
end

return Set