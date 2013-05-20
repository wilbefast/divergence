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
    self.boxes = {} 
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
      or (type == GameObject.TYPE.Exit)
      or (type == GameObject.TYPE.Box))
end

function Player:eventCollision(other, level)
  
  if level.gameOver then
    return
  end
  
  -- Collision with player
  if other.type == GameObject.TYPE.Player then
    if (self.x == other.x)
    and (self.y == other.y)
    and (self.universe > other.universe) 
    and (not level.turnQueued) then
      self.purge = true
    end
    
  -- Collision with exit
  elseif other.type == GameObject.TYPE.Exit then
    if self.universe > 1 then
      self.purge = true
    elseif (self.x == self.targetX)
    and (self.y == self.targetY) then
      level.victory = true
      self:destroyClones()
    end
  
  -- Collision with box
  elseif other.type == GameObject.TYPE.Box then
    
    -- is this my universe's version of the box?
    if self.boxes[other.box_id] == other then
      
      -- push the box
      local dx, dy = other:centreX() - self:centreX(), 
                      other:centreY() - self:centreY()
      if math.abs(dx) < self.w/2 then
        dx = 0
      end
      if math.abs(dy) < self.h/2 then
        dy = 0
      end

      -- 'clone' boxes present in other universes
      if (other.targetX == other.x)
      and (other.targetY == other.y) then
        
        -- calculate new box position
        local bx = 
          self.targetX + 8 + useful.sign(dx)*self.w
        local by = 
          self.targetY + 8 + useful.sign(dy)*self.h
        
        
        if GameObject.COLLISIONGRID:collision(other, bx, by) then
          -- pushing a box into a wall results in DEATH :D
          self:collisionDeath(level, dx, dy)
        else
          other.reference_count = other.reference_count - 1
          
          local new_box = other:clone()
          self.boxes[new_box.box_id] = new_box
          new_box.reference_count = 1
          
          -- push the new box
          new_box.targetX, new_box.targetY = bx, by
        end
      end
    end
  end
end

--[[------------------------------------------------------------
Create
--]]--

function Player:cloneWithDirection(dx, dy)
  if CREATE_CLONES and 
  (not GameObject.COLLISIONGRID:pixelCollision(
    self.x + dx*self.w, self.y + dy*self.h)) 
  then
      local clone = Player(self.x, self.y, dx, dy)
      
      -- copy across boxes, updating reference counts
      for box_id, box in ipairs(self.boxes) do
        clone.boxes[box_id] = box
        box.reference_count = box.reference_count + 1
      end
      return clone
  end
end

--[[------------------------------------------------------------
Destroy
--]]--

function Player:destroyClones()
  -- destroy all others
  GameObject.mapToAll(function(o) 
    if o:isType("Player") then
      o.purge = (o.universe > 1)
    elseif o:isType("Box") then
      o.purge = (self.boxes[o.box_id] ~= o)
    end
  end)
end

function Player:collisionDeath(level, dx, dy)
  -- collision with a wall
  if self.universe > 1 then
    -- destroy
    self.purge = true
    -- decrement box reference counters
    for box_id, box in ipairs(self.boxes) do
      box.reference_count = box.reference_count - 1
    end
    -- spawn clones
    self:cloneWithDirection(-dx, -dy)
    self:cloneWithDirection(dy, -dx)
    self:cloneWithDirection(-dy, dx)

  else
    -- game over!
    level.gameOver = true
    -- jump back to start
    self.targetX, self.targetY = self.x, self.y
    self:destroyClones()
  end
end

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
  
  -- movement is either all horizontal or all vertical
  local x, y = self:centreX(), self:centreY()
  local dx, dy = 0, 0
  if self.universe == 1 then
    dx, dy = input.x, input.y
  else
    dx, dy = self.dx, self.dy
  end
  if dx ~= 0 then
    dy = 0
  end
  
  local collision
    = grid:pixelCollision(x + dx*self.w, y + dy*self.h)

  local fx, fy = useful.tri(dx > 0, useful.floor, useful.ceil),
                  useful.tri(dy > 0, useful.floor, useful.ceil)
  desiredX, desiredY = fx(self.x, grid.tilew) + grid.tilew*dx,
                       fy(self.y, grid.tileh) + grid.tileh*dy
  
  if (self.universe > 1) and collision then
    purge = true
  end
  
  -- start turn
  if ((self.universe == 1) and (level.turnProgress == 0))
  or ((self.universe > 1) and self.turnQueued)  then

    -- consume turn token
    self.turnQueued = false
    
    -- reset start and end points
    self.isMoving = false
    self.x, self.y = self.targetX, self.targetY
    self.startX, self.startY = self.x, self.y
    
    -- attempt to start moving
    if (dx ~= 0) or (dy ~= 0) then
      
      if not collision then
        -- move out!
        self.targetX, self.targetY = desiredX, desiredY
        -- queue new turn
        if self.universe == 1 then level:queueTurn() end
        self.isMoving = true
        -- spawn clones
        self:cloneWithDirection(-dx, -dy)
        self:cloneWithDirection(dy, -dx)
        self:cloneWithDirection(-dy, dx)
        
      else -- collision == true
        self:collisionDeath(level, dx, dy)
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
  love.graphics.setColor(255, 255, 255, 200)
    love.graphics.draw(IMG_MAN, self.x, self.y)
  love.graphics.setColor(255, 255, 255, 255)
  
  GameObject.draw(self)
end


--[[------------------------------------------------------------
EXPORT
--]]------------------------------------------------------------


return Player