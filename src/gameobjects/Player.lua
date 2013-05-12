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

  init = function(self, x, y, dx, dy)
    GameObject.init(self, x, y, 32, 32)

    self.startX = x
    self.startY = y
    if dx and dy then
      self.dx = dx
      self.dy = dy
      self.targetX = x 
        + dx*GameObject.COLLISIONGRID.tilew
      self.targetY = y 
        + dy*GameObject.COLLISIONGRID.tileh
    else
      self.targetX = x
      self.targetY = y
    end
    self.universe = Player.next_universe
    Player.next_universe = Player.next_universe + 1
  end,
      
  ghostDisappearTimer = 1,
  progress = 0
}
Player:include(GameObject)

--[[------------------------------------------------------------
Collision
--]]--

function Player:collidesType(type)
  if type == GameObject.TYPE.Player then
    return true
  else
    return false
  end
end

function Player:eventCollision(other, level)
  
  if (self.targetX == other.targetX)
  and (self.targetY == other.targetY)
  and (self.universe > other.universe) then
    self.purge = true
  end
end

--[[------------------------------------------------------------
Game loop
--]]--

function Player:update(dt, level, view)
  
  -- cache
  local grid = GameObject.COLLISIONGRID
  local x, y = self:centreX(), self:centreY()
  local dx, dy = 0, 0
  if self.universe == 1 then
    dx, dy = input.x, input.y
  else
    dx, dy = self.dx, self.dy
  end
  local collisionX 
    = grid:pixelCollision(x + dx*self.w, y)
  local collisionY 
    = grid:pixelCollision(x, y + dy*self.h) 
    
  -- start turn
  if ((self.universe == 1) and (level.turnProgress == 0))
  or ((self.universe > 1) and self.turnQueued)  then

    -- consume turn token
    self.turnQueued = false
    
    -- reset start and end points
    self.x, self.y = self.targetX, self.targetY
    self.startX, self.startY = self.x, self.y

    -- clone creation function
    function spawnPlayer(dirx, diry)
      if not grid:pixelCollision(
        self.x + dirx*self.w, 
        self.y + diry*self.h) then
          Player(self.x, self.y, dirx, diry)
      end
    end
    
    -- start moving HORIZONTALLY
    if (math.abs(dx) > 0) and (not collisionX) then
      local f = useful.tri(dx > 0, useful.floor, useful.ceil)
      self.targetX = f(self.x, grid.tilew) + grid.tilew*dx
      level.turnProgress = level.turnProgress + dt
      
      -- queue new turn
      if self.universe == 1 then level:queueTurn() end
      
      -- spawn clones
      spawnPlayer(-dx, 0)
      spawnPlayer(0, -1)
      spawnPlayer(0, 1)
    -- start moving VERTICALLY
    elseif (math.abs(dy) > 0) and (not collisionY) then
      local f = useful.tri(dy > 0, useful.floor, useful.ceil)
      self.targetY = f(self.y, grid.tilew) + grid.tileh*dy
      level.turnProgress = level.turnProgress + dt
      
      -- queue new turn
      if self.universe == 1 then level:queueTurn() end
      
      -- spawn clones
      spawnPlayer(0, -dy)
      spawnPlayer(-1, 0)
      spawnPlayer(1, 0)
      
    elseif self.universe ~= 1 then
      self.purge = true
      -- spawn clones
      spawnPlayer(0, -1)
      spawnPlayer(-1, 0)
      spawnPlayer(1, 0)
      spawnPlayer(0, 1)
    end
  end

  self.x = useful.lerp(self.startX, self.targetX, 
                        level.turnProgress)
  self.y = useful.lerp(self.startY, self.targetY, 
                        level.turnProgress)
end

function Player:draw()
  if DEBUG then
    --GameObject.draw(self)
  end
    
  if self.universe == 1 then
    --love.graphics.setColor(255, 0, 0)
  elseif self.turnQueued then
    love.graphics.setColor(0, 0, 255)
  end
  love.graphics.rectangle("line", 
    self.x+4, self.y+4, self.w-8, self.h-8)
    --[[love.graphics.line(
      self.startX+self.w/2, self.startY+self.h/2, 
        self.targetX+self.w/2, self.targetY+self.h/2)--]]
  --love.graphics.print(self.universe, self.x+6, self.y+6)
  love.graphics.setColor(255, 255, 255)
  

  --[[love.graphics.setColor(255, 0, 0)
    love.graphics.rectangle("line", 
      self.startX, self.startY, self.w, self.h)
  love.graphics.setColor(0, 0, 255)
    love.graphics.rectangle("line", 
      self.targetX, self.targetY, self.w, self.h)
  love.graphics.setColor(255, 255, 255)--]]
  
end


--[[------------------------------------------------------------
EXPORT
--]]------------------------------------------------------------


return Player