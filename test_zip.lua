local zzlib = require "lib/zzlib"
local json = require "lib/json"
local util = require "lib/util"

print = util.print

function file_to_table(filename)
  local h = io.open(filename,"rb")
  local string = h:read("*all")
  h:close()
  local out = zzlib.unzip(string, "tags.json")
  print(#out)

  local obj = json.decode(out)
  return obj
end

local obj = file_to_table("resources/tags.zip")

print(obj["forge:dusts/iron"])