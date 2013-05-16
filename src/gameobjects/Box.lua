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

--[[------------------------------------------------------------
BOX GAMEOBJECT
--]]------------------------------------------------------------

--[[------------------------------------------------------------
Initialisation
--]]--

local Box = Class
{
  type = GameObject.TYPE.new("Box"),
  init = function(self, x, y, universe)
    GameObject.init(self, x + 8, y + 8, 16, 16)
      self.startX = self.x
      self.startY = self.y
      self.targetX = self.x
      self.targetY = self.y
      self.universe = (universe or ALL_UNIVERSES)
  end,
}
Box:include(GameObject)

function Box:cloneToUniverse(universe)
  return Box(self.x - 8, self.y -8, universe)
end

--[[------------------------------------------------------------
Game loop
--]]--

function Box:update(dt, level, view)
  if level.turnProgress == 0 then
    self.x, self.y = self.targetX, self.targetY
    self.startX, self.startY = self.x, self.y

  else
    -- move the box
    self.x = useful.lerp(self.startX, self.targetX, 
                          level.turnProgress)
    self.y = useful.lerp(self.startY, self.targetY, 
                          level.turnProgress)
  end
end

function Box:draw()
  
  local alpha = 
    useful.tri(self.universe == ALL_UNIVERSES, 255, 100)
  
  love.graphics.setColor(255, 255, 0, alpha)
  love.graphics.rectangle(
    "fill", self.x - 4, self.y - 4, 24, 24)
  
  -- default
  GameObject.draw(self)
  
end

--[[------------------------------------------------------------
EXPORT
--]]------------------------------------------------------------


return Box