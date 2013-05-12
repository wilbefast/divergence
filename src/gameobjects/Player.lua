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

  init = function(self, x, y, ghostX, ghostY)
    GameObject.init(self, x, y, 32, 32)

    if ghostX and ghostY then
      self.ghostInputX = ghostX
      self.ghostInputY = ghostY
      self.targetX = x 
        + ghostX*GameObject.COLLISIONGRID.tilew
      self.targetY = y 
        + ghostY*GameObject.COLLISIONGRID.tileh
    else
      self.targetX = x
      self.targetY = y
    end
    self.universe = Player.next_universe
    Player.next_universe = Player.next_universe + 1
  end,
      
  ghostDisappearTimer = 1
}
Player:include(GameObject)


--[[------------------------------------------------------------
Game loop
--]]--

function Player:update(dt, level, view)
  -- default update
  GameObject.update(self, dt, level, view)

  -- cache
  local grid = GameObject.COLLISIONGRID
  local x, y = self:centreX(), self:centreY()
  
  -- only the original universe player is controlled
  local dx, dy = 0, 0
  if self.universe == 1 then
    dx, dy = input.x, input.y
  else
    dx, dy = self.ghostInputX, self.ghostInputY
  end
  
  local endTurn =  false
  
  -- HORIZONTAL MOVEMENT
  ---------------------------------------------------------
  -- local variables
  local overShotX 
    = ((self.targetX - self.x)*self.dx < 0)
  local collisionX 
    = grid:pixelCollision(x + dx*grid.tilew/2, y)
  -- starting moving
  if (math.abs(dx) > 0) and (not collisionX) 
  and (self.dy == 0) then
    if overShotX then
      endTurn = true
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
    = grid:pixelCollision(x, y + dy*grid.tileh/2)
  -- starting moving
  if (math.abs(dy) > 0) and (not collisionY)
  and (self.dx == 0) then
    if overShotY then
      endTurn = true
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
  
  
  -- destory clones
  if (self.universe ~= 1) 
  and (self.dx == 0) and (self.dy == 0) then
    self.ghostDisappearTimer = self.ghostDisappearTimer - dt
    if self.ghostDisappearTimer < 0 then
      self.purge = true
    end
  end
  
  -- end of turn: create clones
  if endTurn then
    
    function spawnPlayer(dirx, diry)
      if not grid:pixelCollision(
        self.x + dirx*grid.tilew/2, 
        self.y + diry*grid.tileh/2) then
          Player(self.x, self.y, dirx, diry)
      end
    end

    if input.x ~= 0 then
      spawnPlayer(-input.x, 0)
      spawnPlayer(0, -1)
      spawnPlayer(0, 1)
    else
      spawnPlayer(0, -input.y)
      spawnPlayer(-1, 0)
      spawnPlayer(1, 0)
    end
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