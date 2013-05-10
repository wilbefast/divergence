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
  

  -- HORIZONTAL MOVEMENT
  ---------------------------------------------------------
  -- local variables
  local overShotX 
    = ((self.targetX - self.x)*self.dx < 0)
  local collisionX 
    = grid:collision(self, self.x + input.x, self.y)
  -- starting moving
  if (math.abs(input.x) > 0) and (not collisionX) 
  and (self.y == self.targetY) then
    if overShotX then
      local f = useful.tri(input.x > 0, 
                useful.floor, useful.ceil)
      self.targetX = f(self.x, grid.tilew) 
                    + grid.tilew*input.x
    end
    self.dx = input.x * self.speed
  elseif overShotX then
    self.x = self.targetX
    self.dx = 0
  end
  -- stop at destination
  if self.dx == 0 then
    self.x = self.targetX
  end

  -- VERTICAL MOVEMENT
  ---------------------------------------------------------
  -- local variables
  local overShotY
    = ((self.targetY - self.y)*self.dy < 0)
  local collisionY 
    = grid:collision(self, self.x, self.y + input.y)
  -- starting moving
  if (math.abs(input.y) > 0) and (not collisionY)
  and (self.x == self.targetX) then
    if overShotY then
      local f = useful.tri(input.y > 0, 
                useful.floor, useful.ceil)
      self.targetY = f(self.y, grid.tilew) 
                    + grid.tileh*input.y
    end
    self.dy = input.y * self.speed
  elseif overShotY then
    self.y = self.targetY
    self.dy = 0
  end
  -- stop at destination
  if self.dy == 0 then
    self.y = self.targetY
  end
end

function Player:draw()
  if DEBUG then
    GameObject.draw(self)
  end
  
  love.graphics.setColor(255, 0, 0)
  love.graphics.rectangle("line", self.targetX, self.targetY, self.w, self.h)
  love.graphics.setColor(255, 255, 255)
end


--[[------------------------------------------------------------
EXPORT
--]]------------------------------------------------------------


return Player