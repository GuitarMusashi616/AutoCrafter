local class = require "lib/class"
local util = require "lib/util"
local json = require "lib/json"

local all, range, print, println = util.all, util.range, util.print, util.println

local Craft = class()

function Craft:__init(filename)
  local obj = json.decode_from(filename)
  self.item_to_recipe = obj['item_to_recipe']
  self.tag_to_item = obj['tag_to_item']
end

function Craft:get_item(name, amount)
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

function Craft:to_item(i, recipe)
  local tag = recipe.ingredients[i].tag
  local item = recipe.ingredients[i].item
  if tag then
    return self.tag_to_item[tag]
  end
  if item then
    return item
  end
end

function Craft:craft(name, amount)
  if amount > 64 then
    error("use craft_x_times to craft more than 64")
  end
  local n = 1
  local recipe = self.item_to_recipe[name]
  for i=1,recipe.height do
    for j=1,recipe.width do
      local slot = j+((i-1)*4)
      local item = self:to_item(n, recipe)
      turtle.select(slot)
      self:get_item(item, amount)
      n = n + 1
    end
  end
  turtle.craft()
  turtle.dropUp()
  self:clear_inv()
end

function Craft:clear_inv()
  for i=1,16 do
    if turtle.getItemCount(i) > 0 then
      turtle.select(i)
      turtle.dropUp()
    end
  end
end

function Craft:craft_x_times(name, amount)
  local remaining = amount
  while remaining > 64 do
    self:craft(name, 64)
    remaining = remaining - 64
  end
  self:craft(name, remaining)
end

return Craft


