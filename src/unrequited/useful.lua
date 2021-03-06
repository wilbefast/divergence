--[[
(C) Copyright 2013 William Dyce

All rights reserved. This program and the accompanying materials
are made available under the terms of the GNU Lesser General Public License
(LGPL) version 2.1 which accompanies this distribution, and is available at
http://www.gnu.org/licenses/lgpl-2.1.html

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License for more details.
--]]

local useful = { }

-- map a set of functions to a set of objects
function useful.map(objects, ...)
  local args = useful.packArgs(...)
  local oi = 1
  -- for each object...
  while oi <= #objects do
    local obj = objects[oi]
    -- check if the object needs to be removed
    if obj.purge then
      if obj.onPurge then
        obj:onPurge()
      end
      table.remove(objects, oi)
    else
      -- for each function...
      for fi, func in ipairs(args) do
        -- map function to object
        if type(func)=="function" then -- Make sure it's a function, because, the 1st arguement is an object
          func(obj, oi, objects)
        end
      end -- for fi, func in ipairs(arg)
      -- next object
      oi = oi + 1
    end -- if obj.purge
  end -- while oi <= #objects
end -- useful.map(objects, functions)


-- Because Love2D implementation of args is different?
function useful.packArgs(a, ...)
  if a then
    local ret = useful.packArgs(...)
    table.insert(ret,1,a)
    return ret
  else
    return {}
  end
end

-- trinary operator
function useful.tri(cond, a, b)
  if cond then 
    return a
  else
    return b
  end
end

-- reduce the absolute value of something
function useful.absminus(v, minus)
  if v > 0 then
    return math.max(0, v - minus)
  else
    return math.min(0, v + minus)
  end
end

-- function missing from math
function useful.round(x, n) 
  if n then
    -- round to nearest n
    return useful.round(x / n) * n
  else
    -- round to nearest integer
    local floor = math.floor(x)
    if (x - floor) > 0.5 then
      return floor
    else
      return math.ceil(x)
    end
  end
end

function useful.floor(x, n)
  if n then
    -- floor to nearest n
    return math.floor(x / n) * n
  else
    -- floor to nearest integer
    return math.floor(x)
  end
end

function useful.ceil(x, n)
  if n then
    -- ceil to nearest n
    return math.ceil(x / n) * n
  else
    -- ceil to nearest integer
    return math.ceil(x)
  end
end

-- sign of a number: -1, 0 or 1
function useful.sign(x)
  if x > 0 then 
    return 1 
  elseif x < 0 then 
    return -1
  else
    return 0
  end
end

-- square a number
function useful.sqr(x)
  return x*x
end

-- square distance between 2 points
function useful.dist2(x1, y1, x2, y2)
  local dx, dy = x1-x2, y1-y2
  return (dx*dx + dy*dy)
end

-- two-directional look-up
function useful.bind(table, a, b)
  table[a] = b
  table[b] = a
end

function useful.signedRand(value)
  local r = math.random()
  return useful.tri(r < 0.5, value*2*r, -value*2*(r-0.5))
end

function useful.iSignedRand(value)
  local r = math.random()
  return math.floor(useful.tri(r < 0.5, value*2*r, value*2*(r-0.5)))
end

function useful.randBool(chance_of_truth)
  chance_of_truth = 
    useful.clamp((chance_of_truth or 0.5), 0, 1)
  return (math.random() < chance_of_truth)
end

function useful.clamp(val, lower_bound, upper_bound)
  return math.max(lower_bound, math.min(upper_bound, val))
end

function useful.randIn(table)
  return table[math.random(#table)]
end

function useful.lerp(a, b, inter)
  inter = useful.clamp(inter, 0, 1)
  return ((1-inter)*a + inter*b)
end

function useful.copyContents(source, dest)
  for i, v in pairs(source) do
    dest[i] = v
  end
end

return useful