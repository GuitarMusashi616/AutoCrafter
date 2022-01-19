local class = require "lib/class"
local util = require "lib/util"
local json = require "lib/json"
local Backpack = require "lib/backpack"


local all, range, len, print, println = util.all, util.range, util.len, util.print, util.println

local Crafter = class()

function Crafter:__init(filename)
  local obj = json.decode_from(filename)
  local output_recipe = obj["target_recipe"]
  local output_name = output_recipe["outputName"]
  
  self.item_to_recipe = obj['item_to_recipe']
  self.item_to_recipe[output_name] = output_recipe
  
  self.tag_to_item = obj['tag_to_item']
end

function Crafter:get_item(name, amount)
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

function Crafter:to_item(i, recipe)
  local tag = recipe.ingredients[i].tag
  local item = recipe.ingredients[i].item
  if tag then
    return self.tag_to_item[tag]
  end
  if item then
    return item
  end
end

function Crafter:place_recipe_into_grid(recipe, amount)
  local n = 1
  local remaining = len(recipe['ingredients'])
  for i=1,recipe.height do
    for j=1,recipe.width do
      local slot = j+((i-1)*4)
      local item = self:to_item(n, recipe)
      turtle.select(slot)
      self:get_item(item, amount)
      remaining = remaining - 1
      if remaining <= 0 then
        return
      end
      n = n + 1
    end
  end
end

function Crafter:craft(name, amount)
  if amount > 64 then
    error("use craft_x_times to craft more than 64")
  end
  local recipe = self.item_to_recipe[name]
  self:place_recipe_into_grid(recipe, amount)
  turtle.craft()
  --turtle.dropUp()
  self:clear_inv()
end

function Crafter:clear_inv()
  for i=1,16 do
    if turtle.getItemCount(i) > 0 then
      turtle.select(i)
      turtle.dropUp()
    end
  end
end

function Crafter:craft_x_times(name, amount)
  local remaining = amount
  while remaining > 64 do
    self:craft(name, 64)
    remaining = remaining - 64
  end
  self:craft(name, remaining)
end

function Crafter:supply_chest_contains(backpack)
  -- checks chest above if it contains materials in backpack
  local missing = Backpack()
  for item, count in backpack() do
    missing:add(item, count)
  end
  
  local chest = peripheral.call("top","list")
  -- for chest item that is needed remove from backpack, if backpack aint empty thats whats still needed
  local bchest = Backpack()
  for slot, item in pairs(chest) do
    bchest:add(item.name, item.count)
  end
  
  for item, count in bchest() do
    if missing:contains(item) then
      local x = math.min(missing:get_count(item), count)
      print(item, x)
      missing:remove(item,x) -- remove all of the item from backpack or as many as are present in the chest
    end
  end
  return missing
end

return Crafter