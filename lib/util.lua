local t = require "lib/tbl"
local util = {}

function util.all(tbl)
  local prev_k = nil
  return function()
    local k,v = next(tbl, prev_k)
    prev_k = k
    return v
  end
end

function util.len(tbl)
  return t.len(tbl)
end

function util.assertEqual(expected, actual)
  assert(expected == actual, "Expected: "..tostring(expected)..", Actual: "..tostring(actual))
end

function util.assertRaises(exception, callable, ...)
  local status, err = pcall(callable, ...)
  assert(not status, "Exception not raised")
  --local last_err = err:sub(#err-#exception,#err-#exception)
  --assert(last_err==exception, "Expected: "..tostring(exception)..", Actual:"..tostring(last_err))
end

util.aliases = {
  ["notnil"]=function(a) return a~=nil end,
  ["number?"]=function(a) return a==nil or type(a)=="number" end,
  ["function?"]=function(a) return a==nil or type(a)=="function" end,
  ["bool?"]=function(a) return a==nil or type(a)=="bool" end,
  ["string?"]=function(a) return a==nil or type(a)=="string" end,
}

function util.is_of_type(var, typ)
  if type(var) == "table" and var.is_a then
    return var.is_a[typ]
  end
  
  if type(var) == typ then
    return true
  end
  
  if util.aliases[typ] then
    if util.aliases[typ](var) then
      return true
    end
  end
  return false
end

function util.args(...)
  local tArgs = {...}
  assert(#tArgs%2==0, "must pass a type for each arg")
  for i=1,#tArgs,2 do
    local var = tArgs[i]
    local typ = tArgs[i+1]
    
    assert(util.is_of_type(var, typ), "var with incorrect type passed to function")
  end
end

function util.zip(tbl, oth)
  local prev_tbl_k = nil
  local prev_oth_k = nil
  return function()
    local tbl_k, tbl_val = next(tbl,prev_tbl_k)
    local oth_k, oth_val = next(oth,prev_oth_k)
    prev_tbl_k = tbl_k
    prev_oth_k = oth_k
    return tbl_val, oth_val
  end
end

function util.izip(tbl, oth)
  local i=0
  return function()
    i = i + 1
    return tbl[i], oth[i]
  end
end

function util.range(start, stop, inc)
  assert(type(start)=="number", "range() expected one number argument")
  inc = inc or 1
  if not stop then
    stop = start
    start = 0
  end
  stop = inc > 0 and stop - 1 or stop + 1
  return coroutine.wrap(function()
    for i=start,stop,inc do
      coroutine.yield(i)
    end
  end)
end

function util.format(str, ...)
  local i = 0
  local args = {...}
  str = str:gsub("{}", function() i = i + 1 return t.str(args[i]) end)
  return str
end

function util.println(str,...)
  local i = 0
  local args = {...}
  str = str:gsub("{}", function() i = i + 1 return t.str(args[i]) end)
  print(str)
end

function util.print(...)
  local values = {...}
  local i = 0
  for k,v in pairs(values) do
    i = i + 1
    io.write(t.str(v))
    if i < #values then
      io.write("\t")
    end
  end
  io.write("\n")
end

--util.println("{} and a {} or a {} like a {}", 5, "str", function()end, {1,2,3,key=5,count=2})

--util.print("hello", "stuff", 5, {1,2,3,4}, function()end, {{innie=5,1,4,6},st=function(a,b)return a+b end,2,5,key=print})
return util