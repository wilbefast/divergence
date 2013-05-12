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
PLAYER GAMEOBJECT
--]]------------------------------------------------------------

--[[------------------------------------------------------------
Initialisation
--]]--

local SpecialEffect = Class
{
  type = GameObject.TYPE.new("SpecialEffect"),
  init = function(self, x, y, drawf)
    GameObject.init(self, x, y)
    self.x = x
    self.y = y
    self.draw = drawf
  end,
      
  life = 1,
}
SpecialEffect:include(GameObject)


--[[------------------------------------------------------------
Game loop
--]]--

function SpecialEffect:update(dt)
  self.life = self.life - dt
  if self.life < 0 then
    self.purge = true
  end
  self.x = self.x or self.prevx
  self.y = self.y or self.prevy
end

--[[------------------------------------------------------------
EXPORT
--]]------------------------------------------------------------


return SpecialEffect