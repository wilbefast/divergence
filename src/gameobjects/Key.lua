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
KEY GAMEOBJECT
--]]------------------------------------------------------------

--[[------------------------------------------------------------
Initialisation
--]]--

local IMG_KEY
  = love.graphics.newImage("assets/images/key.png")

local Key = Class
{
  type = GameObject.TYPE.new("Key"),
  init = function(self, x, y)
    GameObject.init(self, x + 8, y + 8, 16, 16)
  end,
}
Key:include(GameObject)

--[[------------------------------------------------------------
Destroy
--]]--

function Key:onPurge()
  SpecialEffect(self.x, self.y, function(sfx)
    CIRCUIT_COLOUR[self.circuit](sfx.life*128)
    love.graphics.draw(IMG_KEY, sfx.x -8, sfx.y -8)
    love.graphics.setColor(255, 255, 255, 255)
  end)
end

--[[------------------------------------------------------------
Collision
--]]--

function Key:indexForPlayer(player)
  for i, required_key in 
  pairs(player.required_keys[self.circuit]) do
    if (required_key == self) then
      -- player has not yet picked up this key
      return i
    end
  end
  -- player already owns this key
  return nil
end

function Key:collidesType(type)
  return (type == GameObject.TYPE.Box)
end

function Key:eventCollision(other, level)
  if (other.type == GameObject.TYPE.Box) and (other.pusher) and (self:indexForPlayer(other.pusher)) then
    other.pusher:die(level)
  end
end

--[[------------------------------------------------------------
Game loop
--]]--

function Key:draw()
  CIRCUIT_COLOUR[self.circuit]()
  love.graphics.draw(IMG_KEY, self.x - 8, self.y - 8)
  love.graphics.setColor(255, 255, 255)
  
  -- default
  GameObject.draw(self)

  if DEBUG then
  	if not self:indexForPlayer(Player.real) then
	  	love.graphics.circle("fill", self.x, self.y, 16)
	  end
  end
end

--[[------------------------------------------------------------
EXPORT
--]]------------------------------------------------------------


return Key