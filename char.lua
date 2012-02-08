-- Mind The Gap
-- Copyright 2010 John McLaughlin, Christiaan Janssen, October 2010
--
-- This file is part of Mind The Gap
--
--     Mind The Gap is free software: you can redistribute it and/or modify
--     it under the terms of the GNU General Public License as published by
--     the Free Software Foundation, either version 3 of the License, or
--     (at your option) any later version.
--
--     Mind The Gap is distributed in the hope that it will be useful,
--     but WITHOUT ANY WARRANTY; without even the implied warranty of
--     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--     GNU General Public License for more details.
--
--     You should have received a copy of the GNU General Public License
--     along with Mind The Gap  If not, see <http://www.gnu.org/licenses/>.

Character = class(function(self, game)
	self.pos = Vector(100,0)
	self.dir = Vector(1,0)
	self.speed = 100
	self.game = game
	self.grav = 2
	self.jump = -1
	self.standing = false
end)

function Character:restart()
	self.pos = self.startpos
	self.dir = Vector(1,0)
end

function Character:draw()
	love.graphics.setColor(128,255,11)
	love.graphics.rectangle("fill",self.pos[1], self.pos[2], 10, 10)
end

function Character:update(dt)
	-- movement
	self.pos = self.pos:add(self.dir:smul(self.speed * dt))

	local colRes = self.game:checkCharStatus( self.pos, {10, 10} )
	-- jump?
	self.lastStandingPlatform = self.standingPlatform
	self.standingPlatform = colRes[4]
	if not colRes[1] and self.standing and self.lastStandingPlatform then
	    if self.lastStandingPlatform:moved() then
		self.lastStandingPlatform:resetMoved()
	    else
		self.dir[2] = self.jump
	    end
	end
	
	if self.standingPlatform and self.standingPlatform ~= self.lastStandingPlatform and self.standingPlatform:moved() then
	    self.standingPlatform:resetMoved()
	end
	
	-- correct position on collision
	if colRes[1] then
		self.pos = colRes[2]
		if colRes[3][2] ~= 1 then
		    self.standing = true
		end
	else
		self.standing = false
	end

	-- stop by the floor
	if colRes[1] and colRes[3][2]~=0 then
	    self.dir[2] = 0
	end

	-- freefall
	if not standing then
		self.dir[2] = self.dir[2]+self.grav*dt
	end

	-- bounce against walls
	if colRes[3][1]==1 then
		self.dir[1]=1
	elseif colRes[3][1]==-1 then
		self.dir[1]=-1
	end


	-- if i fall away from the screen, restart
	if self.pos[2]>screensize[2] or self.pos[1]<0 or self.pos[1]>screensize[1] then
		self.game.levels[self.game.current]:restart()
	end
end
