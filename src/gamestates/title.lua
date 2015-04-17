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
TITLE GAMESTATE
--]]------------------------------------------------------------

local state = GameState.new()

function state:init()
end

function state:enter()
	_visibility = 0
	do_distort = true

	babysitter.add(coroutine.create(function(dt)
   	local t = 0
   	while t < 1 do
   		t = math.min(1, t + dt*2)
   		MUSIC:setVolume(math.max(MUSIC:getVolume()), t*MUSIC_BASE_VOLUME)
   		_visibility = t
   		coroutine.yield()
   	end
 	end))
end


function state:leave()
end

function state:mousepressed(x, y, button)
	if button == "l" then
		GameState.switch(game)
	end
end

function state:keypressed(key, uni)
  
  if babysitter.isBusy() then
  	return
  end
  -- quit game
  if key=="escape" then
		babysitter.add(coroutine.create(function(dt)
	   	local t = 0
	   	while t < 1 do
	   		t = t + dt*2
	   		MUSIC:setVolume((1 - t)*MUSIC_BASE_VOLUME)
	   		_visibility = (1 - t)
	   		coroutine.yield()
	   	end
	   	love.event.push("quit")
	 	end))
  elseif key=="return" then
    GameState.switch(game)
  end
  
end

function state:update(dt)
	
end


function state:draw()

	local _t = 100*MUSIC:tell()/MUSIC_LENGTH*math.pi

	love.graphics.push()

		love.graphics.setColor(0, 255, 255, 255*_visibility)

		love.graphics.translate(DEFAULT_W*0.5, DEFAULT_H*0.5)

		love.graphics.rotate(_t)
		love.graphics.setLineWidth(8)
		love.graphics.rectangle("line",
			-DEFAULT_W*0.25*_visibility,
			-DEFAULT_H*0.25*_visibility,
			DEFAULT_W*0.5*_visibility,
			DEFAULT_H*0.5*_visibility)
		love.graphics.setLineWidth(1)



		love.graphics.setColor(255, 255, 255, 255*_visibility)
	love.graphics.pop()

	love.graphics.setFont(FONT_HUGE)
	love.graphics.printf(
		"DIVERGENCE", 
		DEFAULT_W*0.15, 
		DEFAULT_H*0.2, 
		DEFAULT_W*0.75, 
		"center")

	love.graphics.setFont(FONT_MEDIUM)
	love.graphics.printf(
		"@wilbefast", 
		DEFAULT_W*0.15, 
		DEFAULT_H*0.6, 
		DEFAULT_W*0.75, 
		"center")
	love.graphics.printf(
		"George Abitbol", 
		DEFAULT_W*0.15, 
		DEFAULT_H*0.75, 
		DEFAULT_W*0.75, 
		"center")
end


--[[------------------------------------------------------------
EXPORT
--]]------------------------------------------------------------

return state