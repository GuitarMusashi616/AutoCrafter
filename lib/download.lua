local class = require "lib/class"
local json = require "lib/json"
local lzw = require "lib/lualzw"


local Download = class()

function Download:_init()
  self.recipes_url = ""
  self.tags_url = ""
end

function Download:get_string(url)
end

function Download:get_recipes()
  -- http get the resp
  -- resp read all
  -- decompress to json
  -- decode to tbl
end

function Download:get_tags()
end

