local json = require "lib/json"
local Backpack = require "lib/backpack"
local util = require "lib/util"


local print, println, format = util.print, util.println, util.format


function get_recipes()
  local h = io.open("resources/recipes.json")
  local string = h:read("*all")

  h:close()

  local tbl = json.decode(string)
  return tbl
end


function get_types()
  local tbl = get_recipes()
  print(#tbl)
  local bp = Backpack()
  for i,v in pairs(tbl) do
    bp:add(v['type'])
  end
  bp:display()
end


function crafting_recipe_diffs()
  local tbl = get_recipes()
  local bp = Backpack()
  local weird_ings = {}
  for i,v in pairs(tbl) do
    
    if v['type'] == 'crafting' then
      
      for _, ing in pairs(v['ingredients']) do
        local len = 0
        local has_item = false
        local has_tag = false
        for item,name in pairs(ing) do
          len = len + 1
          if item == 'item' then
            has_item = true
          end
          if item == 'tag' then
            has_tag = true
          end
        end
        if (len==1 and has_item or has_tag) or (len==0) then
          
        else
          weird_ings[v['outputDisplayName']] = v
        end
      end
    end
  end
  print(util.len(weird_ings))
  for k,v in pairs(weird_ings) do
    print(k)
  end


  for k,v in pairs(weird_ings) do
    print(k,v)
  end
end

get_types()
--[[
local tbl = get_recipes()
local bp = Backpack()
for k,v in pairs(tbl) do
  if v['outputDisplayName'] == "Allthemodium Solar Panel" then
    print(v)
    print()
    print()
  end
end

]]

-- return an iterate that goes through it sorted


--bp:sort(function(a,b) return a[2] < b[2] end)




-- see if making a sep dict of item display name is worth it
function is_display_name_dict_worth()
-- total recipe count
-- #tbl
-- total unique displayName to itemName count
  local tbl = get_recipes()
  
  local dn2in = {}
  for i,v in pairs(tbl) do
    dn2in[v['outputDisplayName']] = v['outputName']
  end
  
  println("#recipes: {} B vs #displayNames: {} B", #tbl*40, util.len(dn2in)*40)
  
end
-- want to see if ingredients are similar for all crafting

--is_display_name_dict_worth()