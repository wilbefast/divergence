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
  self.level_number = 1
  self:reloadLevel()
end

function state:enter()
  
end


function state:leave()
end


function state:keypressed(key, uni)
  
  -- quit game
  if key=="escape" then
    GameState.switch(title)
  else
    if self.level.gameOver then
      self:reloadLevel()
    elseif self.level.start then
      self.level.start = false
      
    elseif self.level.victory then
      self.level_number = self.level_number + 1
      if self.level_number >= 5 then
        self.level_number = 1
      end
      sound_change:play()
      self:reloadLevel()
    end
  end
end

function state:update(dt)
  self.level:update(dt)
end


function state:draw()
  self.level:draw()
end

return state