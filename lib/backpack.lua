local class = require 'lib/class'
local Set = require 'lib/set'
local util = require 'lib/util'
local List = require 'lib/list'
local json = require 'lib/json'


local Backpack = class()

function Backpack:__init(...)
  self.backpack = {}
  for i,v in pairs({...}) do
    self:add(v)
  end
end

function Backpack:add(item, count)
  count = count or 1
  if not self.backpack[item] then
    self.backpack[item] = 0
  end
  self.backpack[item] = self.backpack[item] + count
end

function Backpack:remove(item, count)
  assert(self.backpack[item], tostring(item) .. " not in backpack")
  assert(self.backpack[item] >= count, "not enough " .. tostring(item) .. " in backpack")
  self.backpack[item] = self.backpack[item] - 1
end

function Backpack:__eq(other)
  local k = nil
  local l = nil
  
  repeat
    k = next(self.backpack, k)
    l = next(other.backpack, l)
    if k ~= l then
      return false
    end
  until k == nil or j == nil

  return true
end

function Backpack:__call()
  return pairs(self.backpack)
end

function Backpack:__tostring()
  local string = ""
  for k,v in pairs(self.backpack) do
    string = string .. util.format("{}x {}, ", v, k)
  end
  return string:sub(1,#string-2)
end

return Backpack

--print(Backpack(5,5,7,8) == Backpack(7,8,5,5))