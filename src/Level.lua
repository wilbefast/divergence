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
LEVEL CLASS
--]]------------------------------------------------------------

--[[------------------------------------------------------------
Initialisation
--]]--

local Level = Class
{
  -- constructor
  init = function(self, levelfile)
  
    -- load collision-grid
    self.collisiongrid = CollisionGrid(levelfile)
    
    -- clear gameobject
    GameObject.purgeAll()
    GameObject.COLLISIONGRID = self.collisiongrid
    
    -- point camera at centre of collision-grid
    self.camera = Camera(0, 0)
    self.camera:lookAt(self.collisiongrid:centrePixel())
    self.camera:zoom(scaling.SCALE_MAX)
    
    -- parse objects from levelfile
    for _, layer in ipairs(levelfile.layers) do
      
      function parse_objects(objects, constructor)
        for i, object in ipairs(objects) do
          self.player = constructor(object.x, object.y)
        end
      end
      if layer.type == "objectgroup" then
        parse_objects(Player)
        if layer.name == "player" then
          parse_objects(layer.objects, Player)
        elseif layer.name == "exit" then
          parse_objects(layer.objects, Exit)
        elseif layer.name == "boxes" then
          parse_objects(layer.objects, Box)
        elseif layer.name == "plates" then
          parse_objects(layer.objects, PressurePlate)
        elseif layer.name == "doors" then
          parse_objects(layer.objects, Door)
        end
      end
    end
    
    -- save the player object
    self.player = GameObject.get("Player")
    
    -- all boxes are in the player's universe
    GameObject.mapToType("Box", function(box)
      self.player.boxes[box.box_id] = box
      box.reference_count = 1
    end)
    
    -- don't immediately accept input
    self.start = true
    
    -- pseudo-turn-based game
    self.turnProgress = 0
  end,
}
  
--[[------------------------------------------------------------
Game loop
--]]--
  
function Level:queueTurn()
  GameObject.mapToType("Player", function(o) 
      o.turnQueued = true
  end)
  self.turnQueued = true
end

function Level:update(dt)

  
  if (self.turnProgress > 0) or self.turnQueued then
    self.turnQueued = false
    self.turnProgress = self.turnProgress + dt
    if self.turnProgress > 1 then
      
      -- end of current turn
      self.turnProgress = 0
        
      GameObject.mapToType("Player", function(o) 
        o.turnQueued = false 
        o.x, o.y = o.targetX, o.targetY
        o.startX, o.startY = o.x, o.y
    end)
    end
  end
  
  GameObject.updateAll(dt, self)
end

function Level:draw()
  self.camera:attach()
    if self.gameOver then
      love.graphics.setColor(255, 0, 0)
    elseif self.victory then
      love.graphics.setColor(0, 255, 0)
    elseif self.start then
      --love.graphics.setColor(128, 128, 255)
    end
    self.collisiongrid:draw()
    love.graphics.setColor(255, 255, 255)
    GameObject.drawAll()
  self.camera:detach()
end

--[[------------------------------------------------------------
EXPORT
--]]------------------------------------------------------------

return Level
