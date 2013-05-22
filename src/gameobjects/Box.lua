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


local IMG_BOX 
  = love.graphics.newImage("assets/images/crate.png")

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

function Box:onPurge()
  SpecialEffect(self.x, self.y, function(sfx)
    love.graphics.setColor(255, 128, 0, sfx.life*128)
    love.graphics.draw(IMG_BOX, sfx.x -8, sfx.y -8)
    love.graphics.setColor(255, 255, 255, 255)
  end)
end

--[[------------------------------------------------------------
Collisions
--]]--

function Box:existsForPlayer(player)
  return (player.boxes[self.box_id] == self)
end



--[[------------------------------------------------------------
Game loop
--]]--

function Box:update(dt, level, view)
  
  -- destroy if all players in my universe are dead
  if self.reference_count < 1 then
    self.purge = true
  end
  
  -- do nothing if it's game over
  if level.gameOver or level.start or level.victory then
    return
  end
  
  -- update position
  if level.turnProgress == 0 then
    -- snap to destination
    self.x, self.y = self.targetX, self.targetY
    self.startX, self.startY = self.x, self.y
    self.pusher = nil

  else
    -- move the box
    self.x = useful.lerp(self.startX, self.targetX, 
                          level.turnProgress)
    self.y = useful.lerp(self.startY, self.targetY, 
                          level.turnProgress)
  end
end

function Box:draw()
  
  love.graphics.setColor(255, 255, 255,
      useful.tri(self.new, 255, 200))
  love.graphics.draw(IMG_BOX, self.x - 8, self.y - 8)
  
  -- default
  GameObject.draw(self)
  
end

--[[------------------------------------------------------------
EXPORT
--]]------------------------------------------------------------


return Box