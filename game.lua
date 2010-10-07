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

Game = class(function(g)
	g:load()
end)

function Game:load()

	self.level1 = Level1(self)
	self.level2 = Level2(self)
	self.level3 = Level3(self)
	self.level4 = Level4(self)
	self.currentlevel = self.level1
	self.char = Character(self)


end


function Game:update(dt)
	self.currentlevel.poligons:update(dt)
	self.char:update(dt)
	self.currentlevel:update(dt)

	if self.currentlevel:won(self.char.pos) then
		if self.currentlevel == self.level1 then
			self.currentlevel = self.level2
		elseif self.currentlevel == self.level2 then
			self.currentlevel = self.level3
		elseif self.currentlevel == self.level3 then
			self.currentlevel = self.level4
		end
		self.currentlevel:restart()
	end
end

function Game:draw()
	self.currentlevel:draw()
--~ 	self.char:draw()
--~ 	self.currentlevel.poligons:draw()

end

function Game:checkCharStatus( charPos )
	return self.currentlevel.poligons:checkCharStatus( charPos )
end


function Game:keypressed(key)
	if key == "escape" then
		quit()
	end

	if key == " " then
		self.currentlevel:restart()
	end

end


function Game:keyreleased(key)
end


function Game:mousepressed(x, y, button)

end



function Game:mousereleased(x, y, button)

end

