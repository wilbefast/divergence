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

local Player = Class
{
  type = GameObject.TYPE.new("Player"),
      
  speed = 64,

  init = function(self, x, y)
    GameObject.init(self, x, y, 32, 32)
  end,
}
Player:include(GameObject)



function Player:update(dt)
  
  GameObject.update(self, dt)
  
  if math.abs(input.x) ~= 0 then
    self.dx = input.x*self.speed
  elseif math.floor(self.x) % GameObject.COLLISIONGRID.tilew == 0 then
    self.dx = 0
  end
  
  if math.abs(input.y) ~= 0 then
    self.dy = input.y*self.speed
  elseif math.floor(self.y) % GameObject.COLLISIONGRID.tileh == 0 then
    self.dy = 0
  end
  
end


--[[------------------------------------------------------------
Export
--]]

return Player