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
EXIT GAMEOBJECT
--]]------------------------------------------------------------

--[[------------------------------------------------------------
Initialisation
--]]--

local Exit = Class
{
  type = GameObject.TYPE.new("Exit"),
  init = function(self, x, y)
    GameObject.init(self, x, y, 32, 32)
    self.x = x
    self.y = y
  end,
}
Exit:include(GameObject)


--[[------------------------------------------------------------
Game loop
--]]--

function Exit:update()
  self.x = self.x or self.prevx
  self.y = self.y or self.prevy
end

function Exit:draw()
  love.graphics.setColor(0, 255, 0)
  love.graphics.rectangle(
    "fill", self.x + 4, self.y + 4, 24, 24)
  love.graphics.setColor(255, 255, 255)
end

--[[------------------------------------------------------------
EXPORT
--]]------------------------------------------------------------


return Exit