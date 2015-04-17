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
GAME GAMESTATE
--]]------------------------------------------------------------

local sound_change = love.audio.newSource("assets/audio/change_scene.wav", "static")

local state = GameState.new()

function state:reloadLevel()
  local mapfile = require(
    "assets/levels/level" .. self.level_number)
  Player.next_universe = 1
  self.level = Level(mapfile)
  
end

function state:init()
end

function state:enter()
  self.level_number = 1
  self:reloadLevel() 
end


function state:leave()
end

function state:next()
  if self.level.gameOver then
    self:reloadLevel()
  elseif self.level.start then
    self.level.start = false
    
  elseif self.level.victory then
    self.level_number = self.level_number + 1
    if self.level_number >= 4 then
      GameState.switch(title)
    else
    	self:reloadLevel()
    end
    sound_change:play()
  end
end

function state:mousepressed(x, y, button)
	if button == "l" then
		self:next()
 	end
end


function state:keypressed(key, uni)
  
  -- quit game
  if key=="escape" then
    GameState.switch(title)
  else
  	self:next()
  end
end

function state:update(dt)
  self.level:update(dt)

  do_distort = ((not self.level.victory) and (not self.level.gameOver))
end


function state:draw()
  self.level:draw()
end

return state