local function inherit(cls, ...)
  local bases = {...}
  -- copy base class contents into the new class
  for i, base in ipairs(bases) do
    for k, v in pairs(base) do
      cls[k] = v
    end
  end
  -- you can do an "instance of" check using my_instance.is_a[MyClass]
  cls.__index, cls.is_a = cls, {[cls] = true}
  for i, base in ipairs(bases) do
    for c in pairs(base.is_a) do
      cls.is_a[c] = true
    end
    cls.is_a[base] = true
  end
end

local function constructor(c,...)
  local instance = setmetatable({}, c)
  local init = instance.__init
  if init then 
    init(instance, ...) 
  end
  return instance
end

local function class(...)
  local cls = {}
  inherit(cls, ...)
  return setmetatable(cls, {__call = constructor})
end

return class

