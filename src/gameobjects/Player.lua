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
    self.required_keys = {}
    Player.next_universe = Player.next_universe + 1
  end,
      
  ghostDisappearTimer = 1,
  progress = 0
}
Player:include(GameObject)

function Player:initInLevel(level)
  
  -- method should only be called for the "real" player
  self.new = true
  
  -- all boxes are in the player's universe
  GameObject.mapToType("Box", function(box)
    self.boxes[box.box_id] = box
    box.reference_count = 1
    box.new = true
  end)
   
  -- how many keys are there to collect?
  for i = 1, 3 do 
    self.required_keys[i] = GameObject.getSuchThat(
      function(key) return (key.circuit == i) end, "Key")
    
  end
   
end

--[[------------------------------------------------------------
Collision
--]]--

function Player:collidesType(type)
  return ((type == GameObject.TYPE.Player)
      or (type == GameObject.TYPE.Exit)
      or (type == GameObject.TYPE.Box)
      or (type == GameObject.TYPE.Door)
      or (type == GameObject.TYPE.Key))
end

function Player:hasBoxInUniverse(box)
  return (self.boxes[box.box_id] == box)
end

function Player:keyIndexInUniverse(key)
  for i, universe_key in 
  pairs(self.required_keys[key.circuit]) do
    if (key == universe_key) then
      return i
    end
  end
  return nil
end

function Player:isUniverseCollision(x, y)
  return 
  (
    GameObject.COLLISIONGRID:pixelCollision(x, y)
    
  or
    
    GameObject.trueForAny("Box", 
      function(b) 
        return (self:hasBoxInUniverse(b) 
          and b:isCollidingPoint(x, y)) 
      end)
      
  or 
      
    GameObject.trueForAny("Door", 
      function(d) 
        return ((#(self.required_keys[d.circuit]) > 0)
        and d:isCollidingPoint(x, y))
      end)
  )
end

function Player:eventCollision(other, level)
  
  if level.gameOver then
    return
  end
  
  -- deduce direction
  local dx, dy = other:centreX() - self:centreX(), 
                other:centreY() - self:centreY()
  
  -- Collision with player
  if other.type == GameObject.TYPE.Player then
    if (self.x == other.x)
    and (self.y == other.y)
    and (not level.turnQueued) then
      -- never destroy the controlled player!
      if self.universe == 1 then
        other.purge = true
      elseif other.universe == 1 then
        self.purge = true
      -- toss a coin to see who dies :D
      elseif useful.randBool() then
        other.purge = true
      else
        self.purge = true
      end
    end
    
  elseif other.type == GameObject.TYPE.Door then
    self:dieAndClone(level, dx, dy)
    
  -- Collision with exit
  elseif other.type == GameObject.TYPE.Exit then
    if self.universe > 1 then
      self.purge = true
    elseif (self.x == self.targetX)
    and (self.y == self.targetY) then
      level.victory = true
      self:destroyClones()
    end
    
  -- Collision with key
  elseif other.type == GameObject.TYPE.Key then
    -- has the key already been picked up?
    local key_i = self:keyIndexInUniverse(other)
    if key_i then
      -- pick it up, cross it off the checklist!
      self.required_keys[other.circuit][key_i] = nil
    end
    
  
  -- Collision with box
  elseif other.type == GameObject.TYPE.Box then
    
    -- is this my universe's version of the box?
    if (self:hasBoxInUniverse(other)) then
      
      -- push the box
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
        
        -- if there already a box at (bx, by) ? 
        if self:isUniverseCollision(bx, by) then
          -- pushing a box into a wall results in DEATH :D
          self:dieAndClone(level, dx, dy)
        else
          other.reference_count = other.reference_count - 1
          
          local new_box = other:clone()
          self.boxes[new_box.box_id] = new_box
          new_box.reference_count = 1
          
          -- push the new box
          new_box.targetX, new_box.targetY = bx, by
          new_box.pusher = self
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
      
      -- copy across required keys
      useful.copyContents(self.required_keys, 
          clone.required_keys)
      
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
      if (o.universe > 1) then
        o.purge = true
      end
    elseif o:isType("Box") then
      if (self.boxes[o.box_id] ~= o) then
        o.purge = true
      end
    elseif o:isType("Key") then
      if (not self:keyIndexInUniverse(o)) then
        o.purge = true
      end
    end
    
    if not o.purge then o.new = true end
      
  end)
end

function Player:die(level)
  if self.universe > 1 then
    -- destroy
    self.purge = true
  else
    -- game over!
    level.gameOver = true
    -- jump back to start
    self.targetX, self.targetY = self.x, self.y
    self:destroyClones()
  end
end

function Player:dieAndClone(level, dx, dy)
  
  self:die(level)

  if self.universe > 1 then
    
    dx = (dx or useful.sign(self.targetX - self.startX))
    dy = (dy or useful.sign(self.targetY - self.startY))
    
    self:cloneWithDirection(-dx, -dy)
    self:cloneWithDirection(dy, -dx)
    self:cloneWithDirection(-dy, dx)
  end
end

function drawDisappear(self)
  
  love.graphics.setColor(255, 0, 0, self.life*128)
  love.graphics.draw(IMG_MAN, self.x, self.y)
  love.graphics.setColor(255, 255, 255, 255)
end

function Player:onPurge()
  SpecialEffect(self.x, self.y, drawDisappear)
  -- decrement box reference counters
  for box_id, box in ipairs(self.boxes) do
    box.reference_count = box.reference_count - 1
  end
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
      
      self.new = false
      
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
        self:dieAndClone(level, dx, dy)
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
  love.graphics.setColor(255, 255, 255, 
      useful.tri(self.new, 255, 200))
    love.graphics.draw(IMG_MAN, self.x, self.y)
  love.graphics.setColor(255, 255, 255, 255)
  
  GameObject.draw(self)
end


--[[------------------------------------------------------------
EXPORT
--]]------------------------------------------------------------


return Player