local class = require "lib/class"
local json = require "lib/json"
local lzw = require "lib/lualzw"
local socket = require("socket")
local http = require("socket.http")

local Download = class()

function Download:__init()
  self.recipes_url = "https://raw.githubusercontent.com/GuitarMusashi616/AutoCrafter/compresstest/resources/recipes.lzw"
  self.tags_url = "https://raw.githubusercontent.com/GuitarMusashi616/AutoCrafter/compresstest/resources/tags.lzw"
end

function Download:get_string(url)
  local resp, err = http.get(url)
  if not resp then
    error(err, 0)
  end
  return resp:readAll()
end

function Download:lzw_json_as_tbl(url)
  local data_str = http.request(url)
  local json_str = lzw.decompress(data_str)
  return json.decode(json_str)
end

function Download:get_recipes()
  -- http get the resp
  -- resp read all
  -- decompress to json
  -- decode to tbl
  return self:lzw_json_as_tbl(self.recipes_url)
end

function Download:get_tags()
  return self:lzw_json_as_tbl(self.tags_url)
end

--return Download


dl = Download()

recipes = dl:get_recipes()

print(#recipes)
