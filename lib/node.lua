local class = require "lib/class"
local util = require "lib/util"
local List = require "lib/list"

local format = util.format

local Node = class()
function Node:__init(recipe, inputs, requested_amount)
  self.output_item = recipe['outputName']
  self.output_amount = recipe['outputAmount']
  self.inputs = inputs
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

return Node