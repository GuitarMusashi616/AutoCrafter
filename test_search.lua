
local Planner = require "Planner"

local display_name = "Pulverizer"
local planner = Planner()

planner:plan(display_name)
planner:save(display_name:lower() .. ".plan")


