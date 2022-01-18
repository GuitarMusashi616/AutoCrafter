local zzlib = require "lib/zzlib"
local json = require "lib/json"
local List = require "lib/list"
local util = require "lib/util"

local all, print = util.all, util.print

function file_to_string(filename, mode)
  mode = mode or "r"
  local h = io.open(filename, mode)
  local string = h:read("*all")
  h:close()
  return string
end

function file_to_table(filename)
  local string = file_to_string(filename, "rb")
  local out = zzlib.unzip(string, "tags.json")
  print(#out)

  local obj = json.decode(out)
  return obj
end

function len(table)
  local sum = 0
  for i,v in pairs(table) do
    sum = sum + 1
  end
  return sum
end

function new_table(table, i, j)
  local count = 0
  local out = {}
  for k,v in pairs(table) do
    if i <= count and count <= j then
      out[k] = v
    end
    count = count + 1
  end
  return out
end

function split_table(tbl, n)
  local partitions = {}
  local length = len(tbl)
  local inc = math.ceil(length/n)
  
  local start_i = 0
  local end_i = inc-1
  
  for i = 1,n do
    partitions[#partitions+1] = new_table(tbl, start_i, end_i)
    start_i = start_i + inc
    end_i = end_i + inc
  end
  
  return partitions
end


function tbl_to_json(tbl, filename)
  local string = json.encode(tbl)
  local h = io.open(filename,"w")
  h:write(string)
  h:close()
end

function split_up_json(filename, n)
  -- given that filename is json, will split it into n json files
  local string = file_to_string(filename)
  local tbl = json.decode(string)
  
  local parts = split_table(tbl,n)
  for i,part in ipairs(parts) do
    tbl_to_json(part, filename:sub(1,#filename-4) .. i .. ".json")
  end
end


--tab = {10,4,2,3,5,1,"hello","yo",12,15,2,2,1}
--print(split_table(tab,4))

-- local obj = file_to_table("resources/tags.zip")

--print(obj["forge:dusts/iron"])


split_up_json("resources/recipes.json", 15)