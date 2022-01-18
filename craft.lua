local class = require "lib/class"
local util = require "lib/util"
local json = require "lib/json"
require "lib/turtle"

local all, range, print, println = util.all, util.range, util.print, util.println

local tArgs = {...}

if #tArgs == 0 then
  print("Usage: craft <filename> <item> [amount]")
  error()
end

local obj = json.decode_from(tArgs[1])
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

function craft(name, amount)
  local n = 1
  local recipe = item_to_recipe[tArgs[2]]
  for i=1,recipe.height do
    for j=1,recipe.width do
      local slot = j+((i-1)*4)
      local item = to_item(n, recipe)
      turtle.select(slot)
      get_item(name, amount)
      n = n + 1
    end
  end
  turtle.craft()
  turtle.dropUp()
  clear_inv()
end

function clear_inv()
  for i=1,16 do
    if turtle.getItemCount(i) > 0 then
      turtle.select(i)
      turtle.dropUp()
    end
  end
end

function craft_x_times(name, amount)
  local remaining = amount
  while remaining > 64 do
    craft(name, 64)
    remaining = remaining - 64
  end
  craft(name, remaining)
end

if #tArgs == 2 then
  craft_x_times(tArgs[2],1)
elseif #tArgs == 3 then
  craft_x_times(tArgs[2],tonumber(tArgs[3]))
end




