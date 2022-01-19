
--local Planner = require "Planner"
local Algorithm = require "algorithm"

local display_name = "Allthemodium Solar Panel"
--local planner = Planner()

--planner:plan(display_name)
--planner:save(display_name:lower() .. ".plan")


local alg = Algorithm("allthemodium_solar_panel.plan")

alg:solve()