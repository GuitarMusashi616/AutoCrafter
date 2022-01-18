local Set = require "lib/set"
local util = require "lib/util"
local List = require "lib/list"

local print, range, all = util.print, util.range, util.all


set = Set()
for i = 1,19 do
  set:add(math.random(1,10000))
end

for i = 1,20 do
  print(set:pop())
  print(#set)
  print(set)
end

local nbt = require "lib/nbt"


local Search = require "search"

ss = Search()

local function recipe_ingredients(recipe)
  local out = List()
  for k,v in pairs(recipe['ingredients']) do
    if v['tag'] then
      out:append("tag."..v['tag'])
    elseif v['item'] then
      out:append("item."..v['item'])
    end
  end
  return out.list
end

--ing = nbt.newCompound(ss.recipes_json[2]['ingredients'])

-- result = nbt.newCompound(ss.recipes_json[1])

-- result = nbt.newList(nbt.TAG_LIST, ss.recipes_json, "recipes")

function to_obj(recipe)
  local ing = recipe_ingredients(recipe)
  recipe['ingredients'] = nbt.newList(nbt.TAG_STRING, ing)
  local rec = nbt.newCompound(recipe)
  return rec
end

function create_nbt_file()
  local ls = {}
  local id = 0
  for i,recipe in pairs(ss.recipes_json) do
    recipe = to_obj(recipe)
    ls[tostring(id)] = recipe
    id = id + 1
  end
  --print(ing)

  local data = nbt.newCompound(ls)

  local h = io.open("recipes.nbt", "wb")
  local string = data:encode()

  for i in range(#string) do
    
    local byte = tonumber(string:sub(i,i))
    io.write(string:sub(i,i))
    io.write(" ")
    h:write(string:sub(i,i))
  end
  io.write("\n")

  h:close()
end





