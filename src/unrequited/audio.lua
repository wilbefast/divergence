--[[
"Unrequited", a Löve 2D extension library
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

local useful = require("unrequited/useful")

local audio = { filenames = {} }


--[[---------------------------------------------------------------------------
LOADING
--]]--

function audio:load(filename, type)
  local filepath = ("assets/audio/" .. filename .. ".ogg")
  return love.audio.newSource(filepath, type)
end

function audio:load_sound(filename, volume, n_sources)
  n_sources = (n_sources or 1)
  self[filename] = {}
  for i = 1, n_sources do 
    local new_source = self:load(filename, "static") 
    new_source:setVolume(volume or 1)
    self[filename][i] = new_source
  end
end

function audio:load_sounds(base_filename, n_files, volume, n_sources)
  n_sources = (n_sources or 1)
  local filenames = {}
  for f = 1, n_files do
    local name = string.format("%s%02d", base_filename, f)
    self:load_sound(name, volume, n_sources)
    table.insert(filenames, name)
  end
  self.filenames[base_filename] = filenames
end


function audio:load_music(filename)
  self[filename] = self:load(filename, "stream")
end


--[[---------------------------------------------------------------------------
PLAYING
--]]--

function audio:play_music(name, volume, loop)
  if loop == nil then loop = true end
  local new_music = self[name]
  if new_music ~= self.music then
    if self.music then
      self.music:stop()
    end
    new_music:setLooping(loop)
    if not self.mute and not self.mute_music then
      new_music:setVolume(volume or 1)
      new_music:play()
    end
    self.music = new_music
  end
end

function audio:play_sound(name, pitch_shift, x, y, fixed_pitch)
  if not name then 
    return 
  end

  if self.filenames[name] then
    self:play_sound(useful.randIn(self.filenames[name]))
    return
  end

  for _, src in ipairs(self[name]) do
    if src:isStopped() then
      
      -- shift the pitch
      if pitch_shift and (pitch_shift ~= 0) then
        src:setPitch(1 + useful.signedRand(pitch_shift))
      elseif fixed_pitch then
        src:setPitch(fixed_pitch)
      end
      
      -- use 3D sound
      if x and y then
        src:setPosition(x, y, 0)
      end
      
      if not self.mute and not self.mute_sound then
        src:play()
      end
      
      return src
    end
  end
end


--[[---------------------------------------------------------------------------
MUTE
--]]--

function audio:toggle_music()
  if not self.music then
    return
  elseif self.music:isPaused() then
    self.music:resume()
  else
    self.music:pause()
  end
end


--[[---------------------------------------------------------------------------
PLAYLISTS
--]]--

function audio:add_to_playlist(filename, volume)
  self:load_music(filename)
  if not self.playlist then self.playlist = {} end
  table.insert(self.playlist, { name = filename, volume = volume })
end


--[[---------------------------------------------------------------------------
ACTIVE WAIT
--]]--

function audio:update(dt)
  if (not self.music) or self.music:isStopped() then
    if self.playlist then
      local song = useful.randIn(self.playlist)
      self:play_music(song.name, song.volume, false)
    end
  end
end

--[[---------------------------------------------------------------------------
EXPORT
--]]--
return audio