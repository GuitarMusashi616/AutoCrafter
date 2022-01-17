-- ask user about each tag
-- ask user about each 

-- ing -> tag, item, list<ing>
-- tag -> list<item>
-- item -> recipe

-- recipe -> list<ing>

local class = require "lib/class"
local util = require "lib/util"
local json = require "lib/json"
require "lib/turtle"
local List =  require "lib/list"
local Set = require "lib/set"

local all, range, print, println = util.all, util.range, util.print, util.println

local tArgs = {...}

function file_to_json(filename)
  local h = io.open(filename)
  local string = h:read("*all")
  h:close()
  return json.decode(string)
end


local recipes = file_to_json("resources/recipes.json")
local tags = file_to_json("resources/tags.json")

local sArg = ...

local Tag = class()

local DisplayName = class()
function DisplayName:__init(name)
  self.name = name
end

-- construct a subset of item_to_recipe -> 
-- create a preferences file for each recipe and tag

local queue = List(DisplayName(sArg))
local visited = Set(DisplayName(sArg))
local tag_to_item = {}
local item_to_recipe = {}


print(queue)
local query = queue.pop()
-- if its a tag turn it into an item
-- if its an item turn it into a recipe
-- if its already a recipe then add its ingredients to the queue


-- for each thing in the queue simplify it down to a specific recipe

local Ingredient = class()
function Ingredient:__init(obj)
  if obj["tag"] then
    self.typ = "tag"
    self.name = obj["tag"]
  elseif obj["item"] then
    self.typ = "item"
    self.name = obj["item"]
  end
end

function Ingredient()
end

local RecipeWrapper = class()
function RecipeWrapper:__init(recipe)
  self.recipe = recipe
end

function RecipeWrapper:get_ingredients()
  return self.recipe['ingredients']
end

function determineRecipe(name)
  
  
  
end


function recipe_to_stuff(recipe)
  -- recipe:get_ingredients
  -- for each ingredient get_tag get_item get_recipe/raw_material
  local queue = List(sArg)
  local query = queue:pop()
  recipe = query:get_recipe_or_raw_material()
  recipe
  
  
  
  
  
  
end






