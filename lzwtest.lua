local lualzw = require "lib/lualzw"

local h = io.open("resources/recipes.json","r")

local string = h:read("*all")
h:close()


local compressed = lualzw.compress(string)

local f = io.open("output.json","w")
print(#compressed)
f:write(compressed)
f:close()

local json_str = lualzw.decompress(compressed)


print(#json_str)

-- basically just make it http get the resources file
-- then lzw uncompress it
-- then json decode it
-- tada