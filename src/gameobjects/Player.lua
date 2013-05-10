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
  
  next_universe = 1,

  init = function(self, x, y)
    GameObject.init(self, x, y, 30, 30)
    self.targetX = x
    self.targetY = y
    self.universe = Player.next_universe
    Player.next_universe = Player.next_universe + 1
  end,
}
Player:include(GameObject)


--[[------------------------------------------------------------
Game loop
--]]--

function Player:update(dt)
  -- default update
  GameObject.update(self, dt)

  -- cache
  local grid = GameObject.COLLISIONGRID
  
  -- only the original universe player is controlled
  local dx, dy = 0, 0
  if self.universe == 1 then
    dx, dy = input.x, input.y
  else
  end
  
  -- HORIZONTAL MOVEMENT
  ---------------------------------------------------------
  -- local variables
  local overShotX 
    = ((self.targetX - self.x)*self.dx < 0)
  local collisionX 
    = grid:collision(self, 
        self.x + dx*grid.tilew/2, self.y)
  -- starting moving
  if (math.abs(dx) > 0) and (not collisionX) 
  and (self.dy == 0) then
    if overShotX then
      -- create alternate version
      Player(self.targetX, self.targetY)
      -- reset target
      local f = useful.tri(dx > 0, 
                useful.floor, useful.ceil)
      self.targetX = f(self.x, grid.tilew) 
                    + grid.tilew*dx

    end
    self.dx = dx * self.speed
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
        self.x, self.y + dy*grid.tileh/2)
  -- starting moving
  if (math.abs(dy) > 0) and (not collisionY)
  and (self.dx == 0) then
    if overShotY then
      -- create alternate version
      Player(self.targetX, self.targetY)
      -- reset target
      local f = useful.tri(dy > 0, 
                useful.floor, useful.ceil)
      self.targetY = f(self.y, grid.tilew) 
                    + grid.tileh*dy
    end
    self.dy = dy * self.speed
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
end


--[[------------------------------------------------------------
EXPORT
--]]------------------------------------------------------------


return Player