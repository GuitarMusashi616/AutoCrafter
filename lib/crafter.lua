local class = require "lib/class"
local util = require "lib/util"
local json = require "lib/json"
local Backpack = require "lib/backpack"
local Set = require "lib/set"

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
  if amount > 64 then
    print("get_item amount max 64, called with amount: "..tostring(amount))
    error()
  end
  local remaining = amount
  local chest = peripheral.call("top","list")
  for i,v in pairs(chest) do
    if v.name == name then
      peripheral.call("top","pushItems","bottom",i,remaining)
      remaining = remaining - v.count
      if remaining <= 0 then
        turtle.suckDown()
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

function Crafter:find_slot(chest, name)
  for i,v in pairs(chest) do
    if v.name == name then
      return i
    end
  end
end

function Crafter:item_ings_min_stack_size(name)
  local recipe = self.item_to_recipe[name]
  local remaining = len(recipe['ingredients'])
  local min = 1/0
  local chest = peripheral.call("top","list")
  
  for i=1,remaining do
    local item = self:to_item(i, recipe)
    local slot = self:find_slot(chest, item)
    local max_stack_size = peripheral.call("top","getItemDetail",slot).maxCount
    if max_stack_size == 1 then
      return max_stack_size
    elseif max_stack_size < min then
      min = max_stack_size
    end
  end
  return min
end

function Crafter:craft_x_times(name, amount, amount_at_a_time)
  amount_at_a_time = amount_at_a_time or 64
  local min_stack_size = self:item_ings_min_stack_size(name)
  if min_stack_size < amount_at_a_time then
    amount_at_a_time = min_stack_size
  end
  local remaining = amount
  while remaining > amount_at_a_time do
    self:craft(name, amount_at_a_time)
    remaining = remaining - amount_at_a_time
  end
  if remaining > 0 then
    self:craft(name, remaining)
  end
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
      --print(item, x)
      missing:remove(item,x) -- remove all of the item from backpack or as many as are present in the chest
    end
  end
  return missing
end

return Crafter