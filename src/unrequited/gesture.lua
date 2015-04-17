local _touching = false

local _dx, _dy = 0, 0

local _MIN_DIST = 32

local _update = function(dt)
	_x, _y = love.mouse.getPosition()
	if _touching then

		if _x > _start_x + _MIN_DIST then
			_dx = 1
		elseif _x < _start_x - _MIN_DIST then
			_dx = -1
		else
			_dx = 0
		end

		if _y > _start_y + _MIN_DIST then
			_dy = 1
		elseif _y < _start_y - _MIN_DIST then
			_dy = -1
		else
			_dy = 0
		end

		_start_x = useful.lerp(_start_x, _x, 10*dt)
		_start_y = useful.lerp(_start_y, _y, 10*dt)
	else
		_dx, _dy = 0, 0
	end
end

local _touch = function(x, y)
	_touching = true
	_x, _y = x, y
	_start_x, _start_y = x, y
end

local _release = function(x, y)
	_touching = false
end

local _direction = function()
	if _touching then
		return _dx, _dy
	else
		return 0, 0
	end
end

return {
	update = _update,
	touch = _touch,
	release = _release,
	direction = _direction
}