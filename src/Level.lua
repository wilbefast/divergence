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
      --! GENERATE *COLLISION* GRID
      if layer.type == "objectgroup" then
        if layer.name == "player" then
          for i, object in ipairs(layer.objects) do
            self.player = Player(object.x, object.y)
          end
        end
      end
    end
    
    -- pseudo-turn-based game
    self.turnProgress = 0
  end,
}
  
--[[------------------------------------------------------------
Game loop
--]]--
  
function Level:queueTurn()
  GameObject.mapToAll(function(o) 
    if o.type == GameObject.TYPE.Player then
      o.turnQueued = true
    end
  end)
  self.turnQueued = true
end

function Level:update(dt)
  if (self.turnProgress > 0) or self.turnQueued then
    self.turnQueued = false
    self.turnProgress = self.turnProgress + dt
    if self.turnProgress > 1 then
      self.turnProgress = 0
      GameObject.mapToAll(function(o) 
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
    end
    self.collisiongrid:draw()
    if self.gameOver then
      love.graphics.setColor(255, 255, 255)
    end
    GameObject.drawAll()
  self.camera:detach()
end

--[[------------------------------------------------------------
EXPORT
--]]------------------------------------------------------------

return Level
