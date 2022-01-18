local class = require "lib/class"
local json = require "lib/json"
local List = require "lib/list"
local util = require "lib/util"

local print, println, range, all = util.print, util.println, util.range, util.all

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

function Prompt:list_options(options, start_i, end_i)
  for i,option in options(true) do
    if start_i <= i and i < end_i then
      println("{}) {}", i, option)
    end
  end
end

function Prompt:pick_choice(prompt, options, limit)
  limit = limit or 10
  local index = 0
  print("'next' for more options, 'q' to quit")
  self:list_options(options, index, index+limit-1)
  while true do
    io.write(prompt)
    local choice = io.read()
    assert(choice ~= 'q', 'quit')
    local num = tonumber(choice)
    if choice == 'next' or choice == 'n' then
      index = index + limit
      self:list_options(options, index, index+limit)
    elseif num and 0 <= num and num < #options then
      return options[num]
    else
      print("enter a number between 0 and "..tostring(#options-1))
    end
  end
end

return Prompt