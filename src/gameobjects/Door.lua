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
DOOR GAMEOBJECT
--]]------------------------------------------------------------

--[[------------------------------------------------------------
Initialisation
--]]--

local IMG_DOOR
  = love.graphics.newImage("assets/images/lock.png")

local Door = Class
{
  type = GameObject.TYPE.new("Door"),
  init = function(self, x, y)
    GameObject.init(self, x + 8, y + 8, 16, 16)
  end,
}
Door:include(GameObject)

--[[------------------------------------------------------------
Destroy
--]]--

function Key:onPurge()
  SpecialEffect(self.x, self.y, function(sfx)
    CIRCUIT_COLOUR[self.circuit](sfx.life*128)
    love.graphics.draw(IMG_DOOR, sfx.x -8, sfx.y -8)
    love.graphics.setColor(255, 255, 255, 255)
  end)
end

--[[------------------------------------------------------------
Collisions
--]]--

function Door:openForPlayer(player)
  return (#player.required_keys[self.circuit] == 0)
end


--[[------------------------------------------------------------
Game loop
--]]--

function Door:draw()
  CIRCUIT_COLOUR[self.circuit]()
  love.graphics.draw(IMG_DOOR, self.x - 8, self.y - 8)
  love.graphics.setColor(255, 255, 255)
  
  -- default
  GameObject.draw(self)
end

--[[------------------------------------------------------------
EXPORT
--]]------------------------------------------------------------


return Door