local json = require "json"

function combine(tbl, other)
  for k,v in pairs(other) do
    if tonumber(k) then
      tbl[#tbl+1] = v
    else
      tbl[k] = v
    end
  end
  return tbl
end

function test_combine()
  local result = {10,10,9,8}
  combine(result, {5,4,3,2,string="lol"})
  for k,v in pairs(result) do 
    print(k,v) 
  end
end

function get_recipes()
  local tbl = {}
  for i=0,14 do 
    local filename = "recipes_" .. tostring(i) .. ".json"
    shell.run("wget https://raw.githubusercontent.com/GuitarMusashi616/AutoCrafter/master/recipes/" .. filename)
    local obj = json.decode_from(filename)
    combine(tbl, obj)
    print(i, #obj)
    shell.run("rm "..filename)  
  end
  print(#tbl)
  return tbl
end

function get_tags()
  local tbl = {}
  for i=0,4 do
    local filename = "tags_" .. tostring(i) .. ".json"
    shell.run("wget https://raw.githubusercontent.com/GuitarMusashi616/AutoCrafter/master/tags/" .. filename)
    local obj = json.decode_from(filename)
    combine(tbl, obj)
    print(i, obj)
    shell.run("rm " .. filename)
  end
  print(tbl)
  return tbl
end