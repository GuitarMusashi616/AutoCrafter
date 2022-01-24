local class = require "lib/class"
local json = require "lib/json"

local Download = class()

function Download:get_json(url)
  local string, err = http.get(url)
  if err then
    error(err, 0)
  end
  return json.decode(string)  
end

