local class = require "lib/class"
local util = require "lib/util"
local Backpack = require "lib/backpack"

local PICKUP_CHEST = "ironchest:obsidian_chest_0"

local all = util.all

local silo = {
  dict = {},
  chest_names = {},
}

local function beginsWith(string, beginning)
  return string:sub(1,#beginning) == beginning
end

function silo.find_chests()
  silo.chest_names = {}
  for name in all(peripheral.getNames()) do
    if beginsWith(name, "minecraft:chest") then
      table.insert(silo.chest_names, name)
    end
  end
end

function silo.grab(chest_name, slot, stack_size)
  peripheral.call(PICKUP_CHEST, "pullItems", chest_name, slot, stack_size)
end

function silo.get_item(item_name, count)
  local rem = count
  for chest_name in all(silo.chest_names) do
    local items = peripheral.call(chest_name, "list")
    for i,item in pairs(items) do
      if item.name == item_name then
        local amount = math.min(64, rem)
        silo.grab(chest_name, i, amount)
        rem = rem - amount
        if rem <= 0 then
          return
        end
      end
    end
  end
end

function silo.get_from(backpack)
  -- will remove from backpack
  silo.find_chests()
  if #silo.chest_names == 0 then
    return false
  end
  
  for item, count in backpack() do
    silo.get_item(item, count)
  end
  
  return true
end

return silo