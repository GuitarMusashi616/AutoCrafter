local class = require "lib/class"
local List = require "lib/list"
local Set = require "lib/set"
local util = require "lib/util"

local Ouroboros = require "lib/ouroboros"
local json = require "lib/json"

local all, range, print, println = util.all, util.range, util.print, util.println


function file_to_json(filename)
  local h = io.open(filename)
  local string = h:read("*all")
  h:close()
  return json.decode(string)
end

--local recipes = file_to_json("resources/recipes.json")
--local tags = file_to_json("resources/tags.json")


local obj = file_to_json("resources/mirror.json")

print(obj)
