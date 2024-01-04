local class = require "lib/class"
local util = require "lib/util"
local json = require "lib/json"
local tbl = require "lib/tbl"
local List =  require "lib/list"
local Set = require "lib/set"
local Search = require "lib/search"
local Prompt = require "lib/prompt"

local search_inst = Search()
local prompt_inst = Prompt()

local print, println, all, range, format = util.print, util.println, util.all, util.range, util.format

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
  local options = func(search_inst, name, skip_non_crafting)
  
  local options_to_display = search_inst:get_backpack_list_from(options)
  
  if skip_solo_recipes and #options == 1 and options[0]['type'] == 'crafting' then
    println("picked {}", options_to_display[0])
    return options[0]
  end
  
  return prompt_inst:pick_choice("\npick a recipe: ", options, options_to_display)
end

function Planner:ask_which_item(tag, skip_solo_tags)
  skip_solo_tags = skip_solo_tags or true
  println("which item for {}?", tag)
  options = search_inst:search_tag(tag)
  if skip_solo_tags and #options == 1 then
    println("picked {}", options[0])
    return options[0]
  end
  
  return prompt_inst:pick_choice("\npick a tag: ", options)
end

function Planner:ask_if_raw(unique_item, skip_no_recipe_items)
  skip_no_recipe_items = skip_no_recipe_items or true
  if skip_no_recipe_items and #search_inst:search_item(unique_item) == 0 then
    self.raw_materials:add(unique_item)
    print("added "..tostring(unique_item) .." as a raw material")
    return
  end
  
  if prompt_inst:get_yes_no("\ncount " .. tostring(unique_item) .. " as a raw material (y/n)? ") then
    self.raw_materials:add(unique_item)
  else
    local recipe = self:ask_which_recipe(unique_item)
    self.item_to_recipe[unique_item] = recipe
    self:add_new_ingredients(recipe)
  end
end

function Planner:add_new_ingredients(recipe)
  for i,ing in pairs(recipe['ingredients']) do
    local length = tbl.len(ing)
    if length > 1 then
      error("more than 1 ing {}", ing)
    elseif length == 1 then
      self:add_new_ingredient(ing)
    end
  end
end

function Planner:add_new_ingredient(ing)
  if ing['item'] then
    local item = ing['item']
    if not self.item_to_recipe[item] and not self.raw_materials:contains(item) then
      self.unique_items:add(item)
    end
  elseif ing['tag'] then
    local tag = ing['tag']
    if not self.tag_to_item[tag] then
      self.unique_tags:add(tag)
    end
  else
    println("could not add {}", ing)
  end
end

function Planner:plan(display_name)
  self:prompt_link_recipe(display_name)
  
  while #self.unique_items > 0 or #self.unique_tags > 0 do
    local item
    if #self.unique_items > 0 then
      item = self.unique_items:pop()
    else
      local tag = self.unique_tags:pop()
      if self.tag_to_item[tag] then
        
      else
        item = self:ask_which_item(tag)
        self.tag_to_item[tag] = item
      end
    end
    
    if item and not self.raw_materials:contains(item) then
      self:ask_if_raw(item)
    end
  end
end

function Planner:save(filename)
  local h = io.open(filename, "w")
  local obj = {}
  obj.item_to_recipe = self.item_to_recipe
  obj.tag_to_item = self.tag_to_item
  obj.raw_materials = self.raw_materials:to_table()
  obj.target_recipe = self.target_recipe
  
  h:write(json.encode(obj))
  h:close()
end

function Planner:__tostring()
  return format("{}\n{}x {}\n\n{}\n{}\n\n{}", self.raw_materials, self.target_amount, self.target_recipe, self.unique_items, self.unique_tags, self.item_to_recipe)
end


return Planner

