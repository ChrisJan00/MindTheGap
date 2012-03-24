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

Editor = class(function(g)
	g:load()
end)

function Editor:load()
	self.levels = {
		Level1(self),
		Level2(self),
		Level3(self),
		Level4(self)
	}

	self.current = 1
	self.char = Character(self)
end


function Editor:update(dt)
	self.levels[self.current]:update(dt)
	if self.levels[self.current]:won(self.char.pos) then
		self.current=self.current+1
		self.levels[self.current]:restart()
	end

end

function Editor:draw()
	self.levels[self.current]:draw()
end

function Editor:checkCharStatus( charPos, charSize )
	return self.levels[self.current].poligons:checkCharStatus( charPos, charSize )
end


function Editor:keypressed(key)
	if key == "escape" then
		quit()
	end

	if key == " " then
		self.levels[self.current]:restart()
	end

end


function Editor:keyreleased(key)
end


function Editor:mousepressed(x, y, button)

end



function Editor:mousereleased(x, y, button)

end

