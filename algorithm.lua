local class = require 'lib/class'
local util = require 'lib/util'
local json = require 'lib/json'

local Set = require 'lib/set'
local Backpack = require 'lib/backpack'
local List = require 'lib/list'
local Ouroboros = require 'lib/ouroboros'
local Node = require 'Node'

local print, println, range, all, len, format = util.print, util.println, util.range, util.all, util.len, util.format

local Algorithm = class()
function Algorithm:__init(filename, count)
  self.filename = filename
  self.plan = json.decode_from(filename)
  self.count = count
  self.graph = nil
  self.material_counts = nil
  self.nodes = nil
  self.solved = false
end

function Algorithm:get_recipe(item)
  if type(item) == "table" and item['ingredients'] then
    return item
  end
  local recipe = self.plan.item_to_recipe[item]
  if not recipe then
    print(tostring(item) .. " not found in recipes")
    error()
  end
  return recipe
end

function Algorithm:get_item(tag)
  local item = self.plan.tag_to_item[tag]
  if not item then
    print(tostring(item) .. " not in item_to_tag")
    error()
  end
  return item
end

function Algorithm:get_inputs(recipe)
  local inputs = Backpack()
  for i,obj in pairs(recipe['ingredients']) do
    if obj['tag'] then
      inputs:add(self:get_item(obj['tag']))
    elseif obj['item'] then
      inputs:add(obj['item'])
    end
  end
  return inputs
end

function Algorithm:is_raw(item)
  return self.plan.raw_materials[item]
end

function Algorithm:item_name_to_node(item_name)
  if not self.solved then
    print("must solve algorithm first")
    error()
  end
  local sel_node
  
  for node in self.nodes() do
    sel_node = node
    if node.output_item == item_name then
      return node.craft_x_times 
    end
  end
  println("{} does not have {}",sel_node,item_name)
end

function Algorithm:solve()
  --print(self:get_inputs(self.plan.target_recipe))
  --print(self.plan.target_recipe)

  local stack = List(List(self.plan.target_recipe, self.count))
  local material_counts = Backpack()
  local nodes = List()
  local graph = Ouroboros.new()
  -- get the nodes neighbors, add them to stack
  while #stack > 0 do
    local new_ls = stack:pop()
    local new_item, new_required = new_ls[0], new_ls[1]
    if self:is_raw(new_item) then
      material_counts:add(new_item, new_required)
    else
      local recipe = self:get_recipe(new_item)
      local inputs = self:get_inputs(recipe)
      local node = Node(recipe, inputs, new_required)
      node:connect_edges(graph)
      nodes:append(node)
      local needed = node:calculate_required_items()
      stack = stack + needed
    end
  end
  
  self.material_counts = material_counts
  self.graph = graph
  self.nodes = nodes
  self.solved = true
end

function Algorithm:save(backpack, prompt)
  prompt = prompt or ""
  backpack = backpack or self.material_counts
  local h = io.open("materials_needed.txt","w")
  local string = prompt
  local sort = List()

  for item, count in backpack() do
    sort:append(List(item, count))
  end
  
  sort:sort(function(a,b) return a[1] > b[1] end)
  
  for ls in sort() do
    local item, count = ls[0],ls[1]
    string = string .. format("{}x\t{}\n", count, item)
  end
  
  h:write(string)
  h:close()
end

function Algorithm:get_order()
  return self.graph:sort()
end

function Algorithm:get_recipe_and_craft_x_times_in_order()
  if not self.solved then
    print("must solve algorithm first")
    error()
  end
  local i = 0
  local order = self.graph:sort()
  return function()
    i = i + 1
    if i > #order then
      return
    end
    local item = order[i]
    while self:is_raw(item) do
      i = i + 1
      item = order[i]
    end
    return item, self:item_name_to_node(item, self.nodes)
  end
end

function Algorithm:__call()
  return self:get_recipe_and_craft_x_times_in_order()
end

return Algorithm


--[[
for i,item_name in ipairs(sorted) do
  if not is_raw(item_name) then
    --print(item_name, item_name_to_node(item_name,nodes))
    crafter:craft_x_times(item_name, item_name_to_node(item_name, nodes))
  end
end
]]
--print(nodes)
--print(plan.target_recipe)
