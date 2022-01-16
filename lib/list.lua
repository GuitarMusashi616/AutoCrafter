-- python list class for lua
local class = require "lib/class"
local util = require "lib/util"
local t = require "lib/tbl"
local List = class()

local args, all, izip, range = util.args, util.all, util.izip, util.range

function List:__init(iter_tbl_or_item, ...)
  --args(self, List)
  local list = {}
  if type(iter_tbl_or_item) == "function" then
    local iter = iter_tbl_or_item
    for v in iter do
      table.insert(list, v)
    end
  else
    list = {iter_tbl_or_item, ...}
  end
  self.list = list
end

function List.__index(table, key)
  --args(key, "notnil")
  if tonumber(key) then
    key = table:get_1_based_given_0_based(key)
    return table.list[key]
  end
  return List[key]
end

function List.__newindex(table, key, value)
  --args(key, "notnil")
  if tonumber(key) then
    key = table:get_1_based_given_0_based(key)
    table.list[key] = value
    return
  end
  rawset(table, tostring(key), value)
end

function List:__len()
  --args(self, List)
  return #self.list
end

function List:__tostring()
  --args(self, List)
  local string = "["
  for i,v in ipairs(self.list) do
    string = string..t.str(v)
    if i < #self.list then
      string = string..", "
    end
  end
  string = string.."]"
  return string
end

function List:__call(enumerate) -- returns iterator
  --args(self, List, enumerate, "bool?")
  -- return everything in list except the final
  if enumerate then
    local i = 0
    return function()
      i = i + 1
      local item = self.list[i]
      if item then
        return i-1, item
      end
    end
  end
  return all(self.list)
end

function List:__add(o)
  --args(self, List, o, List)
  local new_list = getmetatable(self)()
  for num in self() do
    new_list:append(num)
  end
  for num in o() do
    new_list:append(num)
  end
  return new_list
end

function List:__mul(o)
  --args(self, List, o, "number")
  local new_list = getmetatable(self)()
  for i=1,o do
    for k,v in pairs(self.list) do
      new_list:append(v)
    end
  end
  return new_list
end

function List:__eq(o)
  --args(self, List, o, List)
  if #self.list ~= #o.list then
    return false
  end
  for a,b in izip(self.list, o.list) do
    if a ~= b then
      return false
    end
  end
  return true
end

function List:__lt(o)
  --args(self, List, o, List)
  return #self.list < #o.list
end

function List:__le(o)
  --args(self, List, o, List)
  return #self.list <= #o.list
end

function List:get_1_based_given_0_based(key, bounds)
  args(key, "notnil", bounds, "number?")
  bounds = bounds or 0
  assert(type(key)=="number", "list key "..tostring(key).. " must be a number")
  --assert(((-#self.list)-bounds <= key) and key < (#self.list+bounds), "list key "..tostring(key).." out of range")
  
  if key < 0 then
    return key+1+#self.list -- -1 return 4, -4 returns 1
  end
  
  return key+1
end

function List:append(item,...)
  --args(self, List, item, "notnil")
  assert(not ..., "append() takes exactly 1 argument")
  self.list[#self.list+1] = item
end

function List:pop(index)
  --args(self, List, index, "number?")
  index = index or #self.list-1
  index = self:get_1_based_given_0_based(index)
  return table.remove(self.list, index)
end

function List:insert(index, item)
  --args(self, List, index, "number", item, "notnil")
  assert(self and index and item, "insert() takes exactly 2 arguments")
  index = self:get_1_based_given_0_based(index, 1)
  table.insert(self.list, index, item)
end

function List:filter(callable, enumerate)
  --args(self, List, callable, "function", enumerate, "bool?")
  local res = List()
  for i,v in ipairs(self.list) do
    if (enumerate and callable(i-1,v)) or (not enumerate and callable(v)) then
      res:append(v)
    end
  end
  return res
end

function List:find(callable)
  --args(self, List, callable, "function")
  for i,v in ipairs(self.list) do
    if callable(v) then
      return v
    end
  end
end

function List:map(callable)
  --args(self, List, callable, "function")
  local res = List()
  for i,v in ipairs(self.list) do
    res:append(callable(v))
  end
  return res
end

function List:reduce(callable, start_val)
  --args(self, List, callable, "function", start_val, "number?")
  local acc_val = start_val or self.list[1]
  local start_i = start_val and 1 or 2
  for i=start_i,#self.list do
    acc_val = callable(acc_val, self.list[i])
  end
  return acc_val
end

function List:every(callable)
  --args(self, List, callable, "function")
  for i,v in ipairs(self.list) do
    if not callable(v) then
      return false
    end
  end
  return true
end

function List:some(callable)
  --args(self, List, callable, "function")
  for i,v in ipairs(self.list) do
    if callable(v) then
      return true
    end
  end
  return false
end

function List:contains(item)
  for i,v in ipairs(self.list) do
    if v == item then
      return true
    end
  end
end

function List:slice(start, stop, inc)
  --args(self, List, start, "number?", stop, "number?", inc, "number?")
  inc = inc or 1
  if not start then
    start = inc > 0 and 0 or #self.list-1
  end
  
  if not stop then
    stop = inc > 0 and #self.list or -(#self.list+1)
  end
  
  if start < 0 then
    start = start + #self.list
  end
  if stop < 0 then
    stop = stop + #self.list
  end
  
  
  local res = List()
  for i in range(start, stop, inc) do
    res:append(self[i])
  end
  return res
end

function List:sort(callable)
  --args(self, List, callable, "function?")
  table.sort(self.list, callable)
end

local function zeroes(ls,N,...)
  --args(ls, List, N, "number?")
  for i in range(N) do
    if ... then
      ls:append(List())
      zeroes(ls[i],...)
    else
      ls:append(0)
    end
  end
  return ls
end

function List:zeroes(...)
  return zeroes(List(), ...)
end

return List