
local ROOT   = "https://raw.githubusercontent.com/"
local USER   = "GuitarMusashi616/"
local REPO   = "AutoCrafter/"
local BRANCH = "compresstest/"

shell.run("mkdir lib")
shell.run("cd lib")
shell.run("wget "..ROOT..USER..REPO..BRANCH.."lib/class.lua")
shell.run("wget "..ROOT..USER..REPO..BRANCH.."lib/json.lua")
shell.run("wget "..ROOT..USER..REPO..BRANCH.."lib/list.lua")
shell.run("wget "..ROOT..USER..REPO..BRANCH.."lib/util.lua")
shell.run("wget "..ROOT..USER..REPO..BRANCH.."lib/tbl.lua")
shell.run("wget "..ROOT..USER..REPO..BRANCH.."lib/ouroboros.lua")
shell.run("wget "..ROOT..USER..REPO..BRANCH.."lib/set.lua")
shell.run("wget "..ROOT..USER..REPO..BRANCH.."lib/backpack.lua")
shell.run("wget "..ROOT..USER..REPO..BRANCH.."lib/crafter.lua")
shell.run("wget "..ROOT..USER..REPO..BRANCH.."lib/rollup.lua")
shell.run("wget "..ROOT..USER..REPO..BRANCH.."lib/planner.lua")
shell.run("wget "..ROOT..USER..REPO..BRANCH.."lib/prompt.lua")
shell.run("wget "..ROOT..USER..REPO..BRANCH.."lib/search.lua")
shell.run("wget "..ROOT..USER..REPO..BRANCH.."lib/algorithm.lua")
shell.run("wget "..ROOT..USER..REPO..BRANCH.."lib/node.lua")
shell.run("wget "..ROOT..USER..REPO..BRANCH.."lib/silo.lua")
shell.run("wget "..ROOT..USER..REPO..BRANCH.."lib/lualzw.lua")
shell.run("wget "..ROOT..USER..REPO..BRANCH.."lib/silo.lua")
shell.run("cd ..")


shell.run("wget "..ROOT..USER..REPO..BRANCH.."plan.lua")
shell.run("wget "..ROOT..USER..REPO..BRANCH.."craft.lua")