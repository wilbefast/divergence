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

local IMG_MAN 
  = love.graphics.newImage("assets/images/man.png")

function drawAppear(self)
  love.graphics.setColor(0, 255, 255, self.life*255)
  
  love.graphics.draw(IMG_MAN, self.x+16, self.y+16, 
      0, 1 + 2*(1-self.life), 1 + 2*(1-self.life), 16, 16)
  love.graphics.setColor(255, 255, 255, 255)
end

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
      SpecialEffect(self.x, self.y, drawAppear)
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
  return ((type == GameObject.TYPE.Player)
      or (type == GameObject.TYPE.Exit))
end

function Player:eventCollision(other, level)
  
  if other.type == GameObject.TYPE.Player then
    if (self.x == other.x)
    and (self.y == other.y)
    and (self.universe > other.universe) 
    and (not level.turnQueued) then
      self.purge = true
    end
    
  elseif other.type == GameObject.TYPE.Exit then
    if self.universe == 1 then
      other.purge = true
    end
  end
end

--[[------------------------------------------------------------
Destroy
--]]--

function drawDisappear(self)
  
  love.graphics.setColor(255, 0, 0, self.life*128)
  love.graphics.draw(IMG_MAN, self.x, self.y)
  love.graphics.setColor(255, 255, 255, 255)
end

function Player:onPurge()
  SpecialEffect(self.x, self.y, drawDisappear)
end

--[[------------------------------------------------------------
Game loop
--]]--

function Player:update(dt, level, view)
  
  -- do nothing if it's game over
  if level.gameOver or level.start or level.victory then
    return
  end
  
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
    
  -- collision with a box
  local box = nil
  if collisionX then
    box = grid:pixelToTile(x + dx*self.w, y).contents
    if box then
      -- if box is present in a different universe
      if box.universe and (box.universe ~= self.universe) then
        -- pass through the box as though it doesn't exist
        box = nil
        collisionX = false
      -- if box is present in all universe or my universe
      -- and there is a free space behind it
      elseif not grid:pixelCollision(x + 2*dx*self.w, y) then
        if not box.universe then
          box = Box(box.x, box.y, self.universe)
        end
        collisionX = false
      end
    end
  end
  if collisionY then
    box = grid:pixelToTile(x, y + dy*self.h).contents
    if box then
      -- if box is present in a different universe
      if box.universe and (box.universe ~= self.universe) then
        -- pass through the box as though it doesn't exist
        box = nil
        collisionY = false
      -- if box is present in all universe or my universe
      -- and there is a free space behind it
      elseif not grid:pixelCollision(x, y + 2*dy*self.h) then
        if not box.universe then
          box = Box(box.x, box.y, self.universe)
        end
        collisionY = false
      end
    end
  end
  
  -- start turn
  if ((self.universe == 1) and (level.turnProgress == 0))
  or ((self.universe > 1) and self.turnQueued)  then

    -- consume turn token
    self.turnQueued = false
    
    -- reset start and end points
    self.x, self.y = self.targetX, self.targetY
    self.startX, self.startY = self.x, self.y
    
    -- push box
    if box then
      box.startX, box.startY = box.x, box.y
      if box.tile then
        box.tile:setType("EMPTY")
        box.tile.contents = nil
        box.targetX, box.targetY = box.x + dx*32, box.y + dy*32
        box.tile = level.collisiongrid:pixelToTile(
                  box.targetX + box.w/2, box.targetY + box.h/2)
        if box.tile:isType("EMPTY") then
          box.tile.contents = box
          box.tile:setType("BOX")
        else
          box.tile = nil
        end
      end
    end

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
      
      -- queue new turn
      if self.universe == 1 then level:queueTurn() end
      
      -- spawn clones
      spawnPlayer(0, -dy)
      spawnPlayer(-1, 0)
      spawnPlayer(1, 0)
      
    else
      -- moved into a wall
      if self.universe > 1 then
        -- destroy
        self.purge = true
        
        -- spawn clones
        spawnPlayer(0, -1)
        spawnPlayer(-1, 0)
        spawnPlayer(1, 0)
        spawnPlayer(0, 1)
        
      elseif collisionX or collisionY then
        -- game over!
        level.gameOver = true
        GameObject.mapToAll(function(o) 
        if (o.type == GameObject.TYPE.Player)
        and (o.universe > 1)then
          o.purge = true
        end
      end)
      end
    end
  end

  -- move the player
  self.x = useful.lerp(self.startX, self.targetX, 
                        level.turnProgress)
  self.y = useful.lerp(self.startY, self.targetY, 
                        level.turnProgress)
end

function Player:draw()
  if DEBUG then
   --GameObject.draw(self)
  end
  love.graphics.setColor(255, 255, 255, 200)
    love.graphics.draw(IMG_MAN, self.x, self.y)
  love.graphics.setColor(255, 255, 255, 255)
end


--[[------------------------------------------------------------
EXPORT
--]]------------------------------------------------------------


return Player