local class = require 'lib/class'
local util = require 'lib/util'
local json = require 'lib/json'

local Set = require 'lib/set'
local Backpack = require 'lib/backpack'
local List = require 'lib/list'
local Ouroboros = require 'lib/ouroboros'


local print, println, range, all, len, format = util.print, util.println, util.range, util.all, util.len, util.format

local tArgs = {...}
if #tArgs == 0 then
  print("Usage: craft <filename> [count]")
  error()
end

local filename = tArgs[1]
local count = tonumber(tArgs[2]) or 1

local plan = json.decode_from(filename)

local ItemStack = class()
function ItemStack:__init(item, count)
  self.item = item
  self.count = count
end

local Node = class()
function Node:__init(item_or_recipe, requested_amount)
  local recipe = get_recipe(item_or_recipe)
  self.output_item = recipe['outputName']
  self.output_amount = recipe['outputAmount']
  self.inputs = get_inputs(recipe)
  self.craft_x_times = math.ceil(requested_amount/self.output_amount)
end

function Node:__tostring()
  return format("{}x {} -> {}", self.craft_x_times, self.output_item, self.craft_x_times * self.output_amount)
end

function Node:calculate_required_items()
  local needed = List()
  for item, amount in self.inputs() do
    needed:append(List(item, amount*self.craft_x_times))
  end
  return needed
end

function Node:connect_edges(graph)
  for item, amount in self.inputs() do
    graph:add(item, self.output_item)
  end
end

function get_recipe(item)
  if type(item) == "table" and item['ingredients'] then
    return item
  end
  local recipe = plan.item_to_recipe[item]
  if not recipe then
    print(tostring(item) .. " not found in recipes")
    error()
  end
  return recipe
end

function get_item(tag)
  local item = plan.tag_to_item[tag]
  if not item then
    print(tostring(item) .. " not in item_to_tag")
    error()
  end
  return item
end

function get_inputs(recipe)
  local inputs = Backpack()
  for i,obj in pairs(recipe['ingredients']) do
    if obj['tag'] then
      inputs:add(get_item(obj['tag']))
    elseif obj['item'] then
      inputs:add(obj['item'])
    end
  end
  return inputs
end

function is_raw(item)
  return plan.raw_materials[item]
end

print(get_inputs(plan.target_recipe))
print(plan.target_recipe)

local stack = List(List(plan.target_recipe, count))
local material_counts = Backpack()
local nodes = List()
local graph = Ouroboros.new()
-- get the nodes neighbors, add them to stack
while #stack > 0 do
  local new_ls = stack:pop()
  local new_item, new_required = new_ls[0], new_ls[1]
  if is_raw(new_item) then
    material_counts:add(new_item, new_required)
  else
    local node = Node(new_item, new_required)
    node:connect_edges(graph)
    nodes:append(node)
    local needed = node:calculate_required_items()
    stack = stack + needed
  end
end

print("\nRAW_MATS")
print(material_counts)

print("\nCRAFT_X_TIMES")
print(nodes)

print("\nORDER_OF_CRAFTING")
print(graph:sort())


--print(plan.target_recipe)


