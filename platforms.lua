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

-- solid platform: you can't even move platforms across it

StaticPlatform = class(function(self)
    self.pos = Vector(200, 200)
    self.size = Vector(100, 100)
end)

function StaticPlatform:set(ps)
    self.pos = Vector(ps[1], ps[2])
    self.size = Vector(ps[3], ps[4])
end

function StaticPlatform:draw()
    love.graphics.setLineWidth(2)
    love.graphics.setColor(155, 55, 255)
    love.graphics.rectangle("fill", self.pos[1], self.pos[2], self.size[1], self.size[2])
end

function StaticPlatform:update(dt)
    -- nothing
end

function StaticPlatform:collidedBase(pos, size)
    if pos[1]+size[1] < self.pos[1] then return false end
    if pos[1] > self.size[1]+self.pos[1] then return false end
    if pos[2]+size[2] < self.pos[2] then return false end
    if pos[2] > self.size[2]+self.pos[2] then return false end
    return true
end

-- returns the normal of the platform at position pos
function StaticPlatform:normal(pos)
    local mx,my = pos[1], pos[2]
    -- top border: 10 pixels tall
    if my<=self.pos[2]+10 then
	return Vector(0,-1)
    end
    -- side borders
    if mx<=self.pos[1]+10 then
	return Vector(-1,0)
    end
    if mx>=self.pos[1]+self.size[1]-10 then
	return Vector(1,0)
    end
    return Vector(0,1)
end

-- this function checks if pos collides with the platform
-- if it does, returns { true, newpos, normal }
-- if not, returns { false, pos, 00 }
function StaticPlatform:correctedPos( pos, size )
    if not self:collidedBase( pos, size ) then
	return { false, pos, Vector(0,0) }
    else
        local n = self:normal( pos )
	local cp = Vector( pos[1], pos[2] )
	if n[1]==1 then
	    cp[1] = self.pos[1]+self.size[1]
	end
	if n[1]==-1 then
	    cp[1] = self.pos[1]-size[1]
	end
	if n[2]==-1 then
	    cp[2] = self.pos[2]-size[2]
	end
	if n[2]==1 then
	    cp[2] = self.size[2]+self.pos[2]
	end
	return { true, cp, n }
    end
end

function StaticPlatform:moved()
    return false
end

function StaticPlatform:resetMoved()
    -- nothing
end

function StaticPlatform:isKill()
    return false
end

-- TODO
function StaticPlatform:registerGrid(grid)
    self.grid = grid
end

--------------------------------------------------------------------------

KillPlatform = class(StaticPlatform, function(self) 
    self._base.init(self)
end)

function KillPlatform:draw()
    love.graphics.setLineWidth(2)
    love.graphics.setColor(255, 155, 55)
    love.graphics.rectangle("fill", self.pos[1], self.pos[2], self.size[1], self.size[2])
end

function KillPlatform:isKill()
    return true
end

--------------------------------------------------------------------------

MovablePlatform = class(StaticPlatform, function(self)
    self._base.init(self)
    self.currentPos = Vector(200, 200)
    self.dragging = false
    self.mouseDown = false
    self.transparent = false
    self.wasMoved = false
end)

function MovablePlatform:set(ps)
    self._base:set(ps)
    self.pos = self._base.pos
    self.size = self._base.size
    self.currentPos = Vector(ps[1], ps[2])
end

function MovablePlatform:draw()
    love.graphics.setLineWidth(2)
    if self.dragging then
	love.graphics.setColor(255, 55, 55, 128)
	love.graphics.rectangle("fill", self.pos[1], self.pos[2], self.size[1], self.size[2])
	love.graphics.setColor(55, 55, 255, 128)
	love.graphics.rectangle("fill", self.currentPos[1], self.currentPos[2], self.size[1], self.size[2])
    else
	love.graphics.setColor(55, 55, 255)
	love.graphics.rectangle("fill", self.pos[1], self.pos[2], self.size[1], self.size[2])
    end
end

function MovablePlatform:update(dt)
    local mx,my = love.mouse.getX(), love.mouse.getY()
    local md = love.mouse.isDown("l")
    if self.dragging then
	self.currentPos = Vector(self.pos[1]+mx-self.dragPos[1], self.pos[2]+my-self.dragPos[2])
	if not md then
	    self:stopDrag()
	    self.pos = Vector(self.currentPos[1], self.currentPos[2]);
	end
    else
	if (not self.mouseDown) and md and self:containsMouse() then
	    self:startDrag()
	end
    end
    self.mouseDown = md
end

function MovablePlatform:containsMouse()
	local mx,my = love.mouse.getX(), love.mouse.getY()
	return self:collidedCurrent({mx,my})
end

function MovablePlatform:startDrag()
	self.dragPos = { love.mouse.getX(), love.mouse.getY() }
	self.dragging = true
	self.transparent = true
end

function MovablePlatform:stopDrag()
	self.dragging = false
	self.wasMoved = true
end

--- collision: assume all platforms are rectangles by now
-- returns if the character collides with the platform
function MovablePlatform:collidedCurrent(pos)
    local mx,my = pos[1],pos[2]
    if mx < self.currentPos[1] then return false end
    if mx > self.size[1]+self.currentPos[1] then return false end
    if my < self.currentPos[2] then return false end
    if my > self.size[2]+self.currentPos[2] then return false end
    return true
end

function MovablePlatform:moved()
    return self.wasMoved
end

function MovablePlatform:resetMoved()
    self.wasMoved = false
end

-- TODO
function MovablePlatform:moveInGrid(newPos)
    
end

--------------------------------------------------------------------------
-- TODOs

-- graphics for the character and the goal
-- choose colors

-- opti: use grid for platform collisions instead of list

-- When that is done I will need a (simple) level editor
-- and to choose the colors better
-- and a background?
-- and music?

--------------------------------------------------------------------------


MovablePlatformList = class(function(self)
	self.list = List()
end)

function MovablePlatformList:append(platform)
	self.list:pushBack(platform)
end

function MovablePlatformList:draw()
	local elem = self.list:getFirst()
	while elem do
		elem:draw()
		elem = self.list:getNext()
	end
end

function MovablePlatformList:update(dt)
	local elem = self.list:getFirst()
	while elem do
		elem:update(dt)
		elem = self.list:getNext()
	end
end

function MovablePlatformList:checkCharStatus( pos, size )
    local elem = self.list:getFirst()
    local newpos = pos
    local result = {}
    local newnormal = Vector(0,0)
    local endres = false
    local lastStandingPlatform = nil
    local isKill = false
    while elem do
	result = elem:correctedPos( newpos, size )
	if result[1] then
	    newpos = result[2]
	    if result[3][1]==0 and result[3][2]==-1 then
		lastStandingPlatform = elem
	    end
	    newnormal = newnormal:add( result[3] )
	    endres = true
	    
	    if elem:isKill() then
		isKill = true
	    end
--~ 	return elem:correctedPos( pos )
	end
	elem = self.list:getNext()
    end
    return {endres, newpos, newnormal, lastStandingPlatform, isKill}
end
