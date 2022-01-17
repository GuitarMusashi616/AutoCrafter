local class = require "lib/class"
local json = require "lib/json"
local List = require "lib/list"
local util = require "lib/util"

local print, range, all = util.print, util.range, util.all

local Search = class()

function Search:__init()
  self.recipes_json = self:load_json("resources/recipes.json")
  self.tags_json = self:load_json("resources/tags.json")
end

function Search:load_json(filename)
  local h = io.open(filename)
  local string = h:read("*all")
  h:close()
  return json.decode(string)
end

function Search:base_search(key, val, verbose)
  verbose = verbose or true
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
  verbose = verbose or true
  return self:base_search("outputDisplayName", displayName, verbose)
end

function Search:search_item(name, verbose)
  verbose = verbose or true
  return self:base_search("outputName", name, verbose)
end

function Search:search_tag(tag, verbose)
  verbose = verbose or true
  if verbose then
    print(self.tags_json[tag])
  end
  return self.tags_json[tag]
end

return Search