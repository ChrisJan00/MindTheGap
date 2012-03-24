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
	self.level = Level1(self)
	self.current = 1
	self.char = Character(self)
	self.simulating = false
end

function Editor:restart()
	self.level:restart()
end

function Editor:update(dt)
	if self.simulating then
		self.level:update(dt)
	end
end

function Editor:draw()
	self.level:draw()
end

function Editor:checkCharStatus( charPos, charSize )
	return self.level.poligons:checkCharStatus( charPos, charSize )
end


function Editor:keypressed(key)
	if key == "escape" then
		quit()
	end
	if key == "f2" then
		self.simulating = not self.simulating
	end
	if key == "f3" then
		self.level:restart()
	end
end


function Editor:keyreleased(key)
end

function Editor:mousepressed(x, y, button)

end

function Editor:mousereleased(x, y, button)

end

