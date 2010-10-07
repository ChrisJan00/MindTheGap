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

Platform = class(function(self)
	self.pos = Vector(200,200)
	self.points = { Vector(0,0), Vector(100,0), Vector(100,100), Vector(0,100) }
	self.minx = 0
	self.maxx = 100
	self.miny = 0
	self.maxy = 100
	self.dragging = false
	self.mouseDown = false
	self.transparent = false
end)

function Platform:set(ps)
	self.points = {}
	local n = math.floor(table.getn(ps)/2)
	self.minx = ps[1]
	self.maxx = ps[1]
	self.miny = ps[2]
	self.maxy = ps[2]
	local i=1
	while i<table.getn(ps) do
		local x,y = ps[i],ps[i+1]
		i = i+2
		table.insert(self.points, Vector(x,y))
		if self.minx>x then self.minx=x end
		if self.maxx<x then self.maxx=x end
		if self.miny>y then self.miny=y end
		if self.maxy<y then self.maxy=y end
	end
end

function Platform:draw()
	if self.dragging then
		love.graphics.setColor(255,55,55,128)
	else
		love.graphics.setColor(55,55,255)
	end
	love.graphics.setLineWidth(2)
	local poligonmatrix = {}
	for i=1,table.getn(self.points) do
		table.insert(poligonmatrix,self.points[i][1]+self.pos[1])
		table.insert(poligonmatrix,self.points[i][2]+self.pos[2])
	end
	love.graphics.polygon("fill",poligonmatrix)
end

function Platform:update(dt)
	local mx,my = love.mouse.getX(), love.mouse.getY()
	local md = love.mouse.isDown("l")
	if self.dragging then
		self.pos = Vector(self.origPos[1]+mx-self.dragPos[1], self.origPos[2]+my-self.dragPos[2])
		if not md then
			self:stopDrag()
		end
	else
		if (not self.mouseDown) and md and self:containsMouse() then
			self:startDrag()
		end
	end
	self.mouseDown = md
end

function Platform:containsMouse()
	local mx,my = love.mouse.getX(), love.mouse.getY()
	return self:collided({mx,my}, true)
end

function Platform:startDrag()
	self.dragPos = { love.mouse.getX(), love.mouse.getY() }
	self.origPos = self.pos
	self.dragging = true
	self.transparent = true
end

function Platform:stopDrag()
	self.dragging = false
end

--- collision: assume all platforms are rectangles by now
-- returns if the character collides with the platform
function Platform:collided(pos, mouse)
	if self.transparent and not mouse then return false end
	local mx,my = pos[1],pos[2]
	if mx<self.minx+self.pos[1] then return false end
	if mx>self.maxx+self.pos[1] then return false end
	if my<self.miny+self.pos[2] then return false end
	if my>self.maxy+self.pos[2] then return false end
	-- ToDo: refine this
	return true
end

-- returns the normal of the platform at position pos
function Platform:normal(pos)
	local mx,my = pos[1]-self.pos[1], pos[2]-self.pos[2]
	-- top border: 10 pixels tall
	if my<=self.miny+10 then
		return Vector(0,-1)
	end

	-- side borders
--~ 	local centerx = (self.maxx+self.minx)/2
--~ 	if mx>centerx then
--~ 		return Vector(1,0)
--~ 	else
--~ 		return Vector(-1,0)
--~ 	end
	if mx<=self.minx+10 then
		return Vector(-1,0)
	end

	if mx>=self.maxx-10 then
		return Vector(1,0)
	end

	return Vector(0,1)

--~ 	local x = (pos[1]-self.pos[1])/(self.maxx-self.minx) - 0.5
--~ 	local y = (pos[2]-self.pos[2])/(self.maxy-self.miny) - 0.5
--~ 	if math.abs(x)>math.abs(y) then
--~ 		return Vector(x/math.abs(x),0)
--~ 	else
--~ 		return Vector(0,y/math.abs(y))
--~ 	end
end

-- this function checks if pos collides with the platform
-- if it does, returns { true, newpos, normal }
-- if not, returns { false, pos, 00 }
function Platform:correctedPos( pos )
	if not self:collided( pos ) then
		if (not self.dragging) and (not self:collided( pos, true )) then
			self.transparent = false
		end
		return { false, pos, Vector(0,0) }
	else
		local n = self:normal( pos )
		local cp = Vector( pos[1], pos[2] )
		if n[1]==1 then
			cp[1] = self.maxx+self.pos[1]
		end
		if n[1]==-1 then
			cp[1] = self.minx+self.pos[1]
		end
		if n[2]==-1 then
			cp[2] = self.miny+self.pos[2]
		end
		if n[2]==1 then
			cp[2] = self.maxy+self.pos[2]
		end
		return { true, cp, n }
	end
end


--------------------------------------------------------------------------


PlatformList = class(function(self)
	self.list = List()
end)

function PlatformList:append(platform)
	self.list:pushBack(platform)
end

function PlatformList:draw()
	local elem = self.list:getFirst()
	while elem do
		elem:draw()
		elem = self.list:getNext()
	end
end

function PlatformList:update(dt)
	local elem = self.list:getFirst()
	while elem do
		elem:update(dt)
		elem = self.list:getNext()
	end
end

function PlatformList:checkCharStatus( pos )
	local elem = self.list:getFirst()
	local newpos = pos
	local result = {}
	local newnormal = Vector(0,0)
	local endres = false
	while elem do
		result = elem:correctedPos( newpos )
		if result[1] then
			newpos = result[2]
			newnormal = newnormal:add( result[3] )
			endres = true
--~ 			return elem:correctedPos( pos )
		end
		elem = self.list:getNext()
	end
	return {endres,newpos,newnormal}
end
