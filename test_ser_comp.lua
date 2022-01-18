local Set = require 'lib/set'
local util = require 'lib/util'
local List = require 'lib/list'

local print, println, range, all, len = util.print, util.println, util.range, util.all, util.len

local nbt = require 'lib/nbt'
local Search = require 'search'

local ss = Search()

local function recipe_ingredients(recipe)
  --List(recipe['ingredients']):map(
    if #v > 1 then
      return
    elseif #v == 1 then
      return
    else
      println("unaccounted for {}", v)
    end
end
--[[
local function recipe_ingredient(ing)
  
  

    if v['tag'] then
      out:append('0'..v['tag'])
    elseif v['item'] then
      out:append('1'..v['item'])
    elseif #v > 0 then
      println('no tag or item {}', v)
    end
  end
  
  
  local out = List()
  List(recipe['ingredients']):map(
    function(b)
      if b['tag'] then
        return '0'..v['tag']
      elseif b['item'] then
        
        
    end
  )
  
  for k,v in pairs(recipe['ingredients']) do
    if v['tag'] then
      out:append('0'..v['tag'])
    elseif v['item'] then
      out:append('1'..v['item'])
    elseif #v > 0 then
      println('no tag or item {}', v)
    end
  end
  return out
end
]]

function get_int_to_tag_or_item_dict(recipes_json)
  local int_to_tag_or_item = Set()
  local crafting_recipes = List(all(recipes_json)):filter(function(o) return o['type'] == 'crafting' end)
  
  
  for recipe in crafting_recipes() do
    local ing_list = recipe_ingredients(recipe)
    for ing in ing_list() do
      int_to_tag_or_item:add(ing)
    end
    int_to_tag_or_item:add('1'..recipe['outputName'])
  end
  return List(int_to_tag_or_item())
end

--[[
local int_to_tag_or_item = get_int_to_tag_or_item_dict(ss.recipes_json)
--local data = "1string12string23string3"  -- read numbers then letters then stop at number
for i,v in int_to_tag_or_item(true) do
  if v:sub(1,1) == '0' then
    
  elseif v:sub(1,1) == '1' then
    
  else
    println('not tag or item {}', v)
  end
end]]
t = require "lib/tbl"
local n = 0
-- show how many recipes have ings with inglist
--for i, obj in pairs(ss.recipes_json) do
--  if obj['type'] == 'crafting' then
--    local inglist = obj['ingredients']
--    for ing in all(inglist) do
--      if len(ing) > 1 then
--        print(inglist)
--        n = n + 1
--        break
--      end
--    end
--  end
--end

-- simplest is if its got more than option for ingredient then
-- take the first ingredient?

print(n, '/', len(ss.recipes_json))

-- print(recs_that_have_ing_with_options)





