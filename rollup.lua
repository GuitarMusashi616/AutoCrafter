local class = require "lib/class"
local json = require "lib/json"

local Rollup = class()

function Rollup:__init()
  self.tags_http_dir = "https://raw.githubusercontent.com/GuitarMusashi616/AutoCrafter/master/tags/"
  self.tags_start = 0
  self.tags_end = 4
  
  self.recipes_http_dir = "https://raw.githubusercontent.com/GuitarMusashi616/AutoCrafter/master/recipes/"
  self.recipes_start = 0
  self.recipes_end = 14
end

function Rollup:combine(tbl, other)
  for k,v in pairs(other) do
    if tonumber(k) then
      tbl[#tbl+1] = v
    else
      tbl[k] = v
    end
  end
  return tbl
end

function Rollup:test_combine()
  local result = {10,10,9,8}
  self:combine(result, {5,4,3,2,string="lol"})
  for k,v in pairs(result) do 
    print(k,v) 
  end
end

function Rollup:get_recipes()
  local tbl = {}
  for i=self.recipes_start, self.recipes_end do 
    local filename = "recipes_" .. tostring(i) .. ".json"
    shell.run("wget " .. self.recipes_http_dir .. filename)
    local obj = json.decode_from(filename)
    self:combine(tbl, obj)
    print(i, #obj)
    shell.run("rm "..filename)  
  end
  print(#tbl)
  return tbl
end

function Rollup:get_tags()
  local tbl = {}
  for i=self.tags_start, self.tags_end do
    local filename = "tags_" .. tostring(i) .. ".json"
    shell.run("wget " .. self.tags_http_dir .. filename)
    local obj = json.decode_from(filename)
    self:combine(tbl, obj)
    print(i, obj)
    shell.run("rm " .. filename)
  end
  print(tbl)
  return tbl
end

return Rollup