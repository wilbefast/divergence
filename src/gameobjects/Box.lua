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
  init = function(self, x, y, box_id)
    GameObject.init(self, x + 8, y + 8, 16, 16)
    self.startX = self.x
    self.startY = self.y
    self.targetX = self.x
    self.targetY = self.y
    self.box_id = (box_id or GameObject.count("Box"))
    self.reference_count = 0
  end,
}
Box:include(GameObject)

--[[------------------------------------------------------------
Create
--]]--

function Box:clone()
  return Box(self.x - 8, self.y -8, self.box_id)
end

--[[------------------------------------------------------------
Destroy
--]]--

function drawDisappear(self)
  

end

function Box:onPurge()
  SpecialEffect(self.x, self.y, function(sfx)
    love.graphics.setColor(255, 255, 0, sfx.life*128)
    love.graphics.rectangle("fill", 
        sfx.x - 4 + (1 - sfx.life)*12, 
        sfx.y - 4 + (1 - sfx.life)*12, 
        sfx.life*24, sfx.life*24)
    love.graphics.setColor(255, 255, 255, 255)
  end)
end


--[[------------------------------------------------------------
Game loop
--]]--

function Box:update(dt, level, view)
  
  -- destroy if all players in my universe are dead
  if self.reference_count < 1 then
    self.purge = true
  end
  
  -- update position
  if level.turnProgress == 0 then
    -- snap to destination
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
  
  love.graphics.setColor(255, 255, 0, 150)
  love.graphics.rectangle(
    "fill", self.x - 4, self.y - 4, 24, 24)
  
  -- default
  GameObject.draw(self)
  
end

--[[------------------------------------------------------------
EXPORT
--]]------------------------------------------------------------


return Box