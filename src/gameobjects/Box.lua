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
    GameObject.init(self, x+8, y+8, 16, 16)
      self.startX = x
      self.startY = y
      self.targetX = x
      self.targetY = y
      self.universe = universe or 1
  end,
}
Box:include(GameObject)


--[[------------------------------------------------------------
Game loop
--]]--

function Box:update(dt, level, view)
  self.x = self.x or self.prevx
  self.y = self.y or self.prevy
  
  -- move the box
  self.x = useful.lerp(self.startX, self.targetX, 
                        level.turnProgress)
  self.y = useful.lerp(self.startY, self.targetY, 
                        level.turnProgress)
end

function Box:draw()
  love.graphics.setColor(255, 255, 0)
  love.graphics.rectangle(
    "fill", self.x + 4, self.y + 4, 24, 24)
  love.graphics.setColor(255, 255, 255)
end

--[[------------------------------------------------------------
EXPORT
--]]------------------------------------------------------------


return Box