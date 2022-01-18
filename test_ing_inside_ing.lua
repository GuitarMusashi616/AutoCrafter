local Set = require 'lib/set'
local util = require 'lib/util'
local List = require 'lib/list'

local print, println, range, all, len = util.print, util.println, util.range, util.all, util.len

local nbt = require 'lib/nbt'
local Search = require 'search'

local tags_or_options = Set()

-- so go through each recipe and whenever ing has list of ing add that to the tags

local ss = Search()

function if_list_ing_in_ings_add_to_set(recipe)
  for i,v in pairs(recipe['ingredients']) do
    if len(v) > 1 then
      print(recipe)
      print()
    elseif len(v) == 1 then
      
    end
  end
end


for i,obj in pairs(ss.recipes_json) do
  if_list_ing_in_ings_add_to_set(obj)
end