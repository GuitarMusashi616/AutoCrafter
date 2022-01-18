local Algorithm = require "algorithm"
local Crafter = require "crafter"
local util = require "lib/util"

local print = util.print

local tArgs = {...}
if #tArgs == 0 then
  print("Usage: craft <filename> [times]")
  error()
end

local plan_file = tArgs[1]
local times = tonumber(tArgs[2]) or 1
local alg = Algorithm(plan_file, times)

alg:solve()
alg:save()

local crafter = Crafter(plan_file)
print("SORTED")
print(alg:get_order())
print()
for recipe, craft_x_times in alg() do
  print(recipe, craft_x_times)
end