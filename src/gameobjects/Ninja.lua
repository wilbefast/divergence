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
NINJA GAMEOBJECT
--]]------------------------------------------------------------

local Ninja = Class
{
  type = GameObject.TYPE.new("Ninja"),
      
  speed = 64,

  init = function(self, x, y)
    GameObject.init(self, x, y, 32, 32)
  end,
}
Ninja:include(GameObject)



function Ninja:update(dt)
  
  GameObject.update(self, dt)
  
  local dx, dy = love.joystick.getAxes(1)
  if dx and dy then
    self.x, self.y = self.x + dx*dt*self.speed, self.y + dy*dt*self.speed
  end
end


--[[------------------------------------------------------------
Export
--]]

return Ninja