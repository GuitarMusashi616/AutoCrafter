local class = require "lib/class"
local json = require "lib/json"
local util = require "lib/util"
local List = require "lib/list"
local Backpack = require "lib/backpack"
local Download = require "lib/download"

local print, range, all = util.print, util.range, util.all
local dl = Download()

local Search = class()

function Search:__init(no_internet)
  if no_internet then
    self.recipes_json = json.decode_from("resources/recipes.json")
    self.tags_json = json.decode_from("resources/tags.json")
  else
    self.recipes_json = dl:get_recipes()
    self.tags_json = dl:get_tags()
  end
end

function Search:load_json(filename)
  local h = io.open(filename)
  local string = h:read("*all")
  h:close()
  return json.decode(string)
end

function Search:base_search(key, val, verbose)
  verbose = verbose or false
  local output = List()
  for i,obj in pairs(self.recipes_json) do
    if obj[key] == val then
      output:append(obj)
    end
  end
  if verbose then
    print(output)
  end
  return output
end

function Search:search_display_name(displayName, skip_non_crafting)
  skip_non_crafting = skip_non_crafting or false
  
  local out = self:base_search("outputDisplayName", displayName, verbose)
  if skip_non_crafting then
    out = out:filter(function(x) return x['type'] == 'crafting' end)
  end
  
  return out
end

function Search:search_item(name, skip_non_crafting)
  skip_non_crafting = skip_non_crafting or false
  local out = self:base_search("outputName", name, verbose)
  if skip_non_crafting then
    out = out:filter(function(x) return x['type'] == 'crafting' end)
  end
  return out
end

function Search:search_tag(tag)
  return List(all(self.tags_json[tag]))
end

function Search:get_backpack_from(recipe)
  local inputs = Backpack()
  for i,obj in pairs(recipe['ingredients']) do
    if obj['tag'] then
      inputs:add(obj['tag'])
    elseif obj['item'] then
      inputs:add(obj['item'])
    end
  end
  return inputs
end

function Search:get_backpack_list_from(recipes)
  local backpack_list = List()
  for recipe in recipes() do
    backpack_list:append(self:get_backpack_from(recipe))
  end
  return backpack_list
end

return Search