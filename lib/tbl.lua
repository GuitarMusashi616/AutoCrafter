local t = {}

function t.len(tbl)
  local i = 0
  for _,_ in pairs(tbl) do
    i = i + 1
  end
  return i
end

function t.copy(tbl)
  --works with nested tables, not with metatables ie classes
  local copy = {}
  for k,v in pairs(tbl) do
    if type(v) == "table" then
      v = tcopy(v)
    end
    --assert(type(v) ~= "table", "copy table does not work with nested tables")
    copy[k] = v
  end
  return copy
end

function t.equal(tbl,u)
  assert(type(tbl) == "table" and type(u) == "table", "table expected, got "..type(tbl).." and "..type(u))
  if tlen(tbl) ~= tlen(u) then
    return false
  end
  for k,_ in pairs(tbl) do
    if type(tbl[k]) == "table" and type(u[k]) == "table" then
      if not tequal(tbl[k], u[k]) then
        return false
      end
    else
      if tbl[k] ~= u[k] then
        return false
      end
    end
  end
  return true
end

function t.val_to_str( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and t.str( v ) or
      tostring( v )
  end
end

function t.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. t.val_to_str( k ) .. "]"
  end
end

function t.str( tbl )
  if type(tbl) ~= "table" or tbl.is_a then
    return tostring(tbl)
  end
  
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, t.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        t.key_to_str( k ) .. "=" .. t.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, ", " ) .. "}"
end

function t.slice(tbl, i, j)
  local res = {}
  local count = 0
  for k,v in pairs(tbl) do
    count = count + 1
    if i <= count and count < j then
      res[k]=v
    end
  end
  return res
end

function t.print( tbl )
  print(t.str(tbl))
end

return t