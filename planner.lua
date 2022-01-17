local class = require "lib/class"
local util = require "lib/util"
local json = require "lib/json"
local List =  require "lib/list"
local Set = require "lib/set"
local Search = require "search"
local Prompt = require "prompt"

local search_inst = Search()
local prompt_inst = Prompt()

local print, println, all, range = util.print, util.println, util.all, util.range

local Planner = class()

function Planner:__init()
  self.raw_materials = Set()
  self.unique_items = Set()
  self.unique_tags = Set()
  self.target_recipe = nil
  self.target_amount = 1
  self.item_to_recipe = {}
  self.tag_to_item = {}
end

function Planner:prompt_link_recipe(display_name)
  self.target_recipe = self:ask_which_recipe(display_name)
  self:add_new_ingredients(self.target_recipe)
end

function Planner:ask_which_recipe(name, skip_solo_recipes, skip_non_crafting)
  skip_solo_recipes = skip_solo_recipes or true
  skip_non_crafting = skip_non_crafting or true
  
  println("which recipe for {}",name)
  local func = Search.search_item
  if name:find("%u") then
    func = Search.search_display_name
  end
  local options = func(name, false)
  
  if skip_non_crafting then
    options = options:filter(function(x) x['type'] == 'crafting')
  end
  
  if skip_solo_recipes then and #options == 1 and options[0]['type'] == 'crafting' then
    println("picked {}", options[0]['ingredients'])
    return options[0]
  end
  
  for i, option in options(true) do
    println("{}) {} {}", i, option['type'], option['ingredients'])
  end
  
  return prompt_inst:pick_choice("\npick a recipe: ", options)
end

function Planner:ask_which_item(tag, skip_solo_tags)
  skip_solo_tags = skip_solo_tags or true
  println("which item for {}?", tag)
  options = search_inst:search_tag(tag, false)
  if skip_solo_tags
  
end




