--[[
(C) Copyright 2013 William Dyce

All rights reserved. This program and the accompanying materials
are made available under the terms of the GNU Lesser General Public License
(LGPL) version 2.1 which accompanies this distribution, and is available at
http://www.gnu.org/licenses/lgpl-2.1.html

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License fDEFAULT_W, DEFAULT_H, zor more details.
--]]

--[[------------------------------------------------------------
IMPORTS
--]]------------------------------------------------------------

GameState = require("hump/gamestate")
Class = require("hump/class")
Camera = require("hump/camera")

useful = require("unrequited/useful")
audio = require("unrequited/audio")
scaling = require("unrequited/scaling")
input = require("unrequited/input")
GameObject = require("unrequited/GameObject")
Tile = require("unrequited/Tile")
CollisionGrid = require("unrequited/CollisionGrid")

Box = require("gameobjects/Box")
Key = require("gameobjects/Key")
PressurePlate = require("gameobjects/PressurePlate")
Door = require("gameobjects/Door")
Exit = require("gameobjects/Exit")
SpecialEffect = require("gameobjects/SpecialEffect")
Player = require("gameobjects/Player")

Level = require("Level")

title = require("gamestates/title")
game = require("gamestates/game")




--[[------------------------------------------------------------
GLOBAL SETTINGS
--]]------------------------------------------------------------

DEBUG = false
audio.mute = DEBUG

-- constants
ALL_UNIVERSES = 0
CREATE_CLONES = (not DEBUG)
CIRCUIT_COLOUR =
{
  function(a) love.graphics.setColor(0, 255, 255, a or 255) end,
  function(a) love.graphics.setColor(255, 255, 0, a or 255) end,
  function(a) love.graphics.setColor(255, 0, 255, a or 255) end
}
DEBUG_COLOUR = function(bool, a)
	a = (a or 255)
	if bool then
		love.graphics.setColor(0, 0, 255, a)
	else
		love.graphics.setColor(255, 0, 0, a)
	end
end

--[[------------------------------------------------------------
LOVE CALLBACKS
--]]------------------------------------------------------------

function love.load(arg)
    
  -- set up the screen resolution
  if (not scaling:setup(1280, 720, (not DEBUG))) then --FIXME
    print("Failed to set mode")
    love.event.push("quit")
  end

  -- initialise random
  math.randomseed(os.time())
  
  -- pixelated :D
  love.graphics.setDefaultImageFilter("nearest", "nearest")
  love.graphics.setLineStyle("rough", 1)

  -- go to the initial gamestate
  GameState.switch(game)
end

function love.focus(f)
  GameState.focus(f)
end

function love.quit()
  GameState.quit()
end

function love.keypressed(key, uni)
  GameState.keypressed(key, uni)
end

function keyreleased(key, uni)
  GameState.keyreleased(key)
end

MIN_DT = 1/60
MAX_DT = 1/10
function love.update(dt)
  dt = useful.clamp(dt, MIN_DT, MAX_DT)
  
  input:update(dt)
  GameState.update(dt)
end

function love.draw()
  GameState.draw()
end
