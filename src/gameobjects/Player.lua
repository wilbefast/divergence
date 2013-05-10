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
    GameObject.init(self, x, y, 30, 30)
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
    = grid:collision(self, 
        self.x + input.x*grid.tilew/2, self.y)
  -- starting moving
  if (math.abs(input.x) > 0) and (not collisionX) 
  and (self.dy == 0) then
    if overShotX then
      local f = useful.tri(input.x > 0, 
                useful.floor, useful.ceil)
      self.targetX = f(self.x, grid.tilew) 
                    + grid.tilew*input.x
    end
    self.dx = input.x * self.speed
  -- stop at destination
  elseif overShotX then
    self.x = self.targetX
    self.dx = 0
  end

  -- VERTICAL MOVEMENT
  ---------------------------------------------------------
  -- local variables
  local overShotY
    = ((self.targetY - self.y)*self.dy < 0)
  local collisionY 
    = grid:collision(self, 
        self.x, self.y + input.y*grid.tileh/2)
  -- starting moving
  if (math.abs(input.y) > 0) and (not collisionY)
  and (self.dx == 0) then
    if overShotY then
      local f = useful.tri(input.y > 0, 
                useful.floor, useful.ceil)
      self.targetY = f(self.y, grid.tilew) 
                    + grid.tileh*input.y
    end
    self.dy = input.y * self.speed
  -- stop at destination
  elseif overShotY then
    self.y = self.targetY
    self.dy = 0
  end
end

function Player:draw()
  if DEBUG then
    GameObject.draw(self)
  end
  
  local grid = GameObject.COLLISIONGRID
  local bink = grid:collision(self)
  
  love.graphics.setColor(255, 0, 0)
  love.graphics.rectangle(useful.tri(bink, "fill", "line"), self.targetX, self.targetY, self.w, self.h)
  love.graphics.setColor(255, 255, 255)
end


--[[------------------------------------------------------------
EXPORT
--]]------------------------------------------------------------


return Player