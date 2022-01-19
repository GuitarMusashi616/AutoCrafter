local Algorithm = require "lib/algorithm"
local Crafter = require "lib/crafter"
local util = require "lib/util"

local print, println, format = util.print, util.println, util.format

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
--print("SORTED")
--print(alg:get_order())
--print()

local missing = crafter:supply_chest_contains(alg.material_counts)
-- if its not empty then print out whats still required otherwise just craft everything
if not missing:is_empty() then
  local string = "Not enough items!\nPlease collect the following...\n"
  alg:save(missing, string)
  shell.run("edit materials_needed.txt")
  error()
end

print("All materials accounted for...")
local tr = alg.plan['target_recipe']
println("Preparing to craft {}x {}...", tr['outputAmount']*times, tr['outputDisplayName'])
for recipe, craft_x_times in alg() do
  println("crafting {} recipe {} times", recipe, craft_x_times)
  crafter:craft_x_times(recipe, craft_x_times)
end