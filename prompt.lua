local class = require "lib/class"
local json = require "lib/json"
local List = require "lib/list"
local util = require "lib/util"

local print, range, all = util.print, util.range, util.all

local Prompt = class()

function Prompt:get_int(prompt, not_valid)
  local choice = "invalid"
  while true do
    io.write(prompt)
    choice = io.read()
    assert(choice ~= 'q', 'quit')
    if not tonumber(choice) then
      print(not_valid)
    else
      return tonumber(choice)
    end
  end
end

function Prompt:get_yes_no(prompt, not_valid)
  not_valid = not_valid or "type a y or n"
  
  local choice = "invalid"
  local loop_count = 0
  while choice ~= 'y' and choice ~= 'n' do
    if loop_count > 0 then
      print(not_valid)
    end
    io.write(prompt)
    choice = io.read()
    assert(choice ~= 'q', 'quit')
    loop_count = loop_count + 1
  end
  return choice == 'y'
end

function Prompt:pick_choice(prompt, options)
  local choice = self:get_int(prompt, "enter a number between 0 and "..tostring(#options-1))
  return options[choice]
end

return Prompt