--[[
(C) Copyright 2013 William

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
PLAYER GAMEOBJECT
--]]------------------------------------------------------------

--[[------------------------------------------------------------
Initialisation
--]]--

local Player = Class
{
  type = GameObject.TYPE.new("Player"),
      
  speed = 64,

  init = function(self, x, y)
    GameObject.init(self, x, y, 32, 32)
    self.targetX = x
    self.targetY = y
  end,
}
Player:include(GameObject)


--[[------------------------------------------------------------
Game loop
--]]--

function Player:update(dt)
  -- default update
  GameObject.update(self, dt)
  
  local grid = GameObject.COLLISIONGRID
  
  -- is the player snapped to this grid?
  local isSnappedX = (math.floor(self.x) % grid.tilew == 0)
  local isSnappedY = (math.floor(self.y) % grid.tileh == 0)
    
  -- move snapped to grid
  -- ...horizontally
  if (math.abs(input.x) ~= 0) 
  and isSnappedY 
  and (not grid:pixelCollision(self.x + input.x, self.y)) 
  then
    self.dx = input.x*self.speed
    self.maxX = self.x 
  elseif isSnappedX then
    self.dx = 0
  end
  -- ...vertically
  if (math.abs(input.y) ~= 0) 
  and isSnappedX 
  and (not grid:pixelCollision(self.x, self.y + input.y))
  then
    self.dy = input.y*self.speed
  elseif isSnappedY then
    self.dy = 0
  end
end

function Player:draw()
  if DEBUG then
    GameObject.draw(self)
  end
end


--[[------------------------------------------------------------
EXPORT
--]]------------------------------------------------------------


return Player