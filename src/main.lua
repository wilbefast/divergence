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

log = require("unrequited/log")
useful = require("unrequited/useful")
audio = require("unrequited/audio")
input = require("unrequited/input")
babysitter = require("unrequited/babysitter")
gesture = require("unrequited/gesture")
GameObject = require("unrequited/GameObject")
Tile = require("unrequited/Tile")
CollisionGrid = require("unrequited/CollisionGrid")

--[[------------------------------------------------------------
GLOBAL SETTINGS
--]]------------------------------------------------------------

DEBUG = false
audio.mute = DEBUG

DEFAULT_W = 320
DEFAULT_H = 320
WINDOW_W = 0
WINDOW_H = 0
VIEW_SCALE = 0
VIEW_W = 0
VIEW_H = 0

MUSIC_BASE_VOLUME = 0.8

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
  IMG_MAN = love.graphics.newImage("assets/images/man.png")
  love.window.setIcon(IMG_MAN:getData())  

  -- font
	FONT_HUGE = love.graphics.newFont("assets/ttf/Romulus_by_pix3m.ttf", 64)
	FONT_MEDIUM = love.graphics.newFont("assets/ttf/Romulus_by_pix3m.ttf", 32)
	love.graphics.setFont(FONT_MEDIUM)

	-- load sound and music
	MUSIC = love.audio.newSource("assets/audio/music.ogg")
	  MUSIC:setLooping(true)
	  MUSIC:setVolume(MUSIC_BASE_VOLUME)
	  MUSIC_LENGTH = love.sound.newSoundData(
	  	"assets/audio/music.ogg"):getDuration()
	sound_fail = love.audio.newSource("assets/audio/fail.ogg", "static")
	sound_fail:setVolume(0.5)
	sound_victory = love.audio.newSource("assets/audio/positive.ogg", "static")
	sound_victory:setVolume(0.5)

  -- start the music !
  MUSIC:play()

  -- gameplay includes
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

  -- go to the initial gamestate
  GameState.switch(title) 
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

function love.mousepressed(x, y, button)
	if button == "l" then
		gesture.touch(x, y)
	end
	GameState.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	if button == "l" then
		gesture.release(x, y)
	end
	GameState.mousereleased(x, y, button)
end

MIN_DT = 1/60
MAX_DT = 1/30

local _distortion = 1
do_distort = true

local _t = 0

function love.update(dt)

	_t = _t + dt
	if _t > 1000 then
		_t = _t - 1000
	end

	if do_distort then
		_distortion = math.min(1, _distortion + 4*dt)
	else
		_distortion = math.max(0, _distortion - 4*dt)
	end
	MUSIC:setVolume(_distortion * MUSIC_BASE_VOLUME)

  dt = useful.clamp(dt, MIN_DT, MAX_DT)
  
  input:update(dt)
  GameState.update(dt)
  babysitter.update(dt)
  gesture.update(dt)
end

function love.draw()
	canvas:clear()
	love.graphics.setCanvas(canvas)
  	GameState.draw()
  love.graphics.setCanvas(nil)

  love.graphics.push()
  love.graphics.translate(WINDOW_W/2, WINDOW_H/2)
  love.graphics.scale(VIEW_SCALE, VIEW_SCALE)

	  local t = _t

	  local x = math.cos(0.1*t * math.pi*2)*64*_distortion
	  local y = math.cos(2 * t * math.pi*2)*8*_distortion
	  local w = 1 + 0.1*math.cos(t)*_distortion
	  local h = 1 + 0.1*math.sin(t)*_distortion
	  local r = math.pi*0.05*math.sin(t*0.2*math.pi)*_distortion

	  love.graphics.draw(canvas, x, y, r, w, h, DEFAULT_W/2, DEFAULT_H/2)

	love.graphics.pop()

	if DEBUG then
		log:draw(32, 32)
	end
end
