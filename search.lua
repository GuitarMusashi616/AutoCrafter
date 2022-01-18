local class = require "lib/class"
local json = require "lib/json"
local List = require "lib/list"
local util = require "lib/util"
require "rollup"

local print, range, all = util.print, util.range, util.all

local Search = class()

function Search:__init()
  self.recipes_json = get_recipes()
  self.tags_json = get_tags()
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

function Search:search_display_name(displayName, verbose)
  verbose = verbose or false
  return self:base_search("outputDisplayName", displayName, verbose)
end

function Search:search_item(name, verbose)
  verbose = verbose or false
  return self:base_search("outputName", name, verbose)
end

function Search:search_tag(tag, verbose)
  verbose = verbose or false
  if verbose then
    print(self.tags_json[tag])
  end
  return List(all(self.tags_json[tag]))
end

return Search