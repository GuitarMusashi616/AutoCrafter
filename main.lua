local class = require "lib/class"
local util = require "lib/util"
local json = require "lib/json"
require "lib/turtle"

local all, range, print, println = util.all, util.range, util.print, util.println

local tArgs = {...}

function file_to_json(filename)
  local h = io.open(filename)
  local string = h:read("*all")
  h:close()
  return json.decode(string)
end

--local recipes = file_to_json("resources/recipes.json")
--local tags = file_to_json("resources/tags.json")


local obj = file_to_json("allthemodium.json")
local item_to_recipe = obj['item_to_recipe']
local tag_to_item = obj['tag_to_item']



function get_item(name, amount)
  local remaining = amount
  local chest = peripheral.call("top","list")
  for i,v in pairs(chest) do
    if v.name == name then
      peripheral.call("top","pushItems","bottom",i,remaining)
      turtle.suckDown()
      remaining = remaining - v.count
      if remaining <= 0 then
        return
      end
    end
  end
end

function to_item(i, recipe)
  local tag = recipe.ingredients[i].tag
  local item = recipe.ingredients[i].item
  if tag then
    return tag_to_item[tag]
  end
  if item then
    return item
  end
end

function craft(name)
  local n = 1
  local recipe = item_to_recipe[tArgs[1]]
  for i=1,recipe.height do
    for j=1,recipe.width do
      local slot = j+((i-1)*4)
      local item = to_item(n, recipe)
      turtle.select(slot)
      get_item(name,1)
      n = n + 1
    end
  end
  turtle.craft()
  turtle.select(1)
  turtle.dropUp()
end

if #tArgs == 0 or #tArgs > 2 then
  print("Usage: craft <item> [amount]")
elseif #tArgs == 1 then
  craft(tArgs[1],1)
else
  craft(tArgs[1],tonumber(tArgs[2]))
end




