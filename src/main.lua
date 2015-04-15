--[[
(C) Copyright 2013 William Dyce

All rights reserved. This program and the accompanying materials
are made available under the terms of the GNU Lesser General Public License
(LGPL) version 2.1 which accompanies this distribution, and is available at
http://www.gnu.org/licenses/lgpl-2.1.html

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License fzor more details.
--]]

--[[------------------------------------------------------------
IMPORTS
--]]------------------------------------------------------------

GameState = require("hump/gamestate")
Class = require("hump/class")
Camera = require("hump/camera")

useful = require("unrequited/useful")
audio = require("unrequited/audio")
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
Monster = require("gameobjects/Monster")
Player = require("gameobjects/Player")

Level = require("Level")

title = require("gamestates/title")
game = require("gamestates/game")


--[[------------------------------------------------------------
GLOBAL SETTINGS
--]]------------------------------------------------------------

DEBUG = false
audio.mute = DEBUG

DEFAULT_W = 512
DEFAULT_H = 512
WINDOW_W = 0
WINDOW_H = 0
VIEW_SCALE = 0
VIEW_W = 0
VIEW_H = 0

-- constants
ALL_UNIVERSES = 0
CREATE_CLONES = true
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

function love.conf(t)
  t.title = "Divergence" 
  t.author = "William J. Dyce"
  t.url = "http://wilbefast.com" 
end


IMG_MAN = love.graphics.newImage("assets/images/man.png")

local MUSIC = love.audio.newSource("assets/audio/music.ogg")
  MUSIC:setLooping(true)
  MUSIC:setVolume(0.8)
  MUSIC_LENGTH = love.sound.newSoundData(
  	"assets/audio/music.ogg"):getDuration()

function love.load(arg)
	-- resolution
	WINDOW_W, WINDOW_H = love.graphics.getWidth(), love.graphics.getHeight()
  while (VIEW_W < WINDOW_W) and (VIEW_H < WINDOW_H) do
    VIEW_SCALE = VIEW_SCALE + 0.00001
    VIEW_W = DEFAULT_W
    VIEW_H = DEFAULT_H*VIEW_SCALE
  end
  while (VIEW_W >= WINDOW_W) or (VIEW_H >= WINDOW_H) do
	  VIEW_SCALE = VIEW_SCALE - 0.00001
    VIEW_W = DEFAULT_W*VIEW_SCALE
    VIEW_H = DEFAULT_H*VIEW_SCALE
	end

  -- initialise random
  math.randomseed(os.time())
  
  -- pixelated :D
  love.graphics.setDefaultFilter("nearest", "nearest")
  love.graphics.setLineStyle("rough", 1)

  -- canvas
  canvas = love.graphics.newCanvas(DEFAULT_W, DEFAULT_H)

  -- no mouse
  love.mouse.setVisible(false)
  
  -- window title
  love.window.setTitle("Divergence")
  
  -- window icon
  love.window.setIcon(IMG_MAN:getData())  
  
  -- go to the initial gamestate
  GameState.switch(game)

  -- start the music !
  MUSIC:play()
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
MAX_DT = 1/30


function love.update(dt)

  dt = useful.clamp(dt, MIN_DT, MAX_DT)
  
  input:update(dt)
  GameState.update(dt)
end

local _t = 0
function love.draw()
	canvas:clear()
	love.graphics.setCanvas(canvas)
  	GameState.draw()
  love.graphics.setCanvas(nil)

  love.graphics.push()
  love.graphics.translate(WINDOW_W/2, WINDOW_H/2)
  love.graphics.scale(VIEW_SCALE, VIEW_SCALE)

	  local _t = 200*MUSIC:tell()/MUSIC_LENGTH

	  local x = math.cos(_t * math.pi*2)*8
	  local y = math.sin(_t * math.pi*2)*8
	  local w = 1 + 0.1*math.cos(_t)
	  local h = 1 + 0.1*math.sin(_t)
	  local r = _t*0.1*math.pi

	  love.graphics.draw(canvas, x, y, r, w, h, DEFAULT_W/2, DEFAULT_H/2)

	love.graphics.pop()
end
