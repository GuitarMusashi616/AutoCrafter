
local tArgs = {...}
if #tArgs == 0 then
  print('Usage: plan <item>')
  print('Ex: plan Allthemodium Solar Panel')
  error()
end

local display_name = table.concat(tArgs, " ")
local filename = table.concat(tArgs, "_"):lower().. ".plan"

local Planner = require "Planner"
local planner = Planner()

planner:plan(display_name)
planner:save(filename)
print(filename .. " saved...") 
print("run 'craft "..filename.." [count]' to craft it")
