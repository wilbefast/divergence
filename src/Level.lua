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
  init = function(self, mapfile)
    self.collisiongrid = CollisionGrid(mapfile)
    GameObject.COLLISIONGRID = self.collisiongrid
    
    self.camera = Camera(0, 0)
    self.camera:lookAt(self.collisiongrid:centrePixel())
    self.camera:zoom(scaling.SCALE_MAX)
    
    self.player = Player(100, 100) -- FIXME create based on map
  end,
}
  
--[[------------------------------------------------------------
Game loop
--]]--

function Level:update(dt)
  GameObject.updateAll(dt)
end

function Level:draw()
  self.camera:attach()
    self.collisiongrid:draw()
    GameObject.drawAll()
  self.camera:detach()
end
  
--[[------------------------------------------------------------
EXPORT
--]]------------------------------------------------------------

return Level
