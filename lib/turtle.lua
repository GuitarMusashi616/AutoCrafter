turtle = {}

function turtle.craft()
  print("craft")
end

function turtle.select()
  print("select")
end

function turtle.dropUp()
  print("dropUp")
end

function turtle.suckDown()
  print("suckDown")
end

function turtle.getItemCount(i)
  print("getItemCount")
  return 0
end

peripheral = {}

function peripheral.call()
  print("call")
  return {{name="minecraft:iron_ingot",count=64}, {name="minecraft:glass",count=64}}
end