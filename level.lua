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

Goal = class(function(self)
	self.x = 700
	self.y = 30
	self.width = 50
	self.height = 50
end)

function Goal:draw()
	love.graphics.setColor(200,200,88)
	love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)
end

function Goal:update(dt)
end

function Goal:crossed( pos )
	if pos[1]<self.x then return false end
	if pos[1]>self.x+self.width then return false end
	if pos[2]<self.y then return false end
	if pos[2]>self.y+self.height then return false end
	return true
end

Level = class(function(self,game)
	self.goal = Goal()
	self.initpos = Vector(100,0)
	self.dir = Vector(1,0)
	self.game = game
	self.poligons = MovablePlatformList()
	self.fixedPlatforms = MovablePlatformList()
end)

function Level:restart()
	self.game.char.pos = self.initpos
	self.game.char.dir = Vector(1,0)
end

function Level:draw()
	self.goal:draw()
	self.game.char:draw()
	self.poligons:draw()
end

function Level:update(dt)
	self.poligons:update(dt)
	self.game.char:update(dt)
end

function Level:won( pos )
	if self.goal:crossed( pos ) then
		return true
	else
		return false
	end
end

Level1 = class(Level,function(self, game)
	self._base.init(self,game)
--~ 	self.poligons = MovablePlatformList()

    self.poligons:append(MovablePlatform())

	local tt = MovablePlatform()
	tt:set({0,400,200,20})
	self.poligons:append(tt)

	local t2 = MovablePlatform()
	t2:set({400,455,300,30})
	self.poligons:append(t2)

	local t3 = MovablePlatform()
	t3:set({0,0,40,140})
	self.poligons:append(t3)
	
	local t4 = StaticPlatform()
	t4:set({100,450,200,40})
	self.poligons:append(t4)
	
	local t5 = StaticPlatform()
	t5:set({300,200,40,40})
	self.poligons:append(t5)
	self.fixedPlatforms:append(t5)
end)


Level2 = class(Level,function(self, game)
	self._base.init(self,game)
	self.initpos = Vector(10,400)
	self.goal.x = 100
--~ 	self.poligons = MovablePlatformList()

    self.poligons:append(MovablePlatform())

	local tt = MovablePlatform()
	tt:set({0,400,200,20})
	self.poligons:append(tt)

	local t2 = MovablePlatform()
	t2:set({400,455,300,30})
	self.poligons:append(t2)

	local t3 = MovablePlatform()
	t3:set({0,0,140,40})
	self.poligons:append(t3)
end)


Level3 = class(Level,function(self, game)
	self._base.init(self,game)
	self.initpos = Vector(500,200)

	local t1 = MovablePlatform()
	t1:set({0,0,80,250})
        self.poligons:append(t1)

	local t3 = MovablePlatform()
	t3:set({0,0,40,140})
	self.poligons:append(t3)
end)

Level4 = class(Level,function(self, game)
	self._base.init(self,game)
end)

function Level4:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.print("You won",100,100)
end
