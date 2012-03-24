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
function love.filesystem.require(filename)
	local g = love.filesystem.load(filename)
	g()
end

function quit()
	love.event.push('q')
end

function love.load()

	-- Dependencies
	love.filesystem.require("class.lua")
	love.filesystem.require("linkedlists.lua")
	love.filesystem.require("vectors.lua")
	love.filesystem.require("platforms.lua")
	love.filesystem.require("char.lua")
	love.filesystem.require("level.lua")
	love.filesystem.require("game.lua")
	love.filesystem.require("editor.lua")


	-- Initialization
	start_time = love.timer.getTime()

	math.randomseed(os.time())

	-- Init graphics mode
--~        screensize = { 640, 480 }
	screensize = { 800,600 }
	if not love.graphics.setMode( screensize[1], screensize[2], false, true, 0 ) then
		quit()
	end

	love.graphics.setBackgroundColor(0,0,0)
	love.graphics.setColor(255,255,255)
	love.graphics.setLine(1)

	-- Audio system
	--love.audio.setChannels(16)
	love.audio.setVolume(.3)

	-- Text
--~ 	love.graphics.setFont("default")
	love.graphics.setFont(16)
--~ 	love.graphics.setFont(love.graphics.newImageFont("computerliebe.png",
--~ 	"!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~ ") )

	editorEnabled = true
	
	game = Game()
	game:load()

	editor = Editor()
	editor:load()
end

function love.update(dt)

	if editorEnabled then
	    editor:update(dt)
	else
	    game:update(dt)
	end
end


function love.draw()
	if editorEnabled then
	    editor:draw()
	else 
	    game:draw()
	end
	--love.graphics.setColorMode("modulate")
end


function love.keypressed(key)
	if editorEnabled then
	    editor:keypressed(key)
	else
	    game:keypressed(key)
	end
end


function love.keyreleased(key)
    if editorEnabled then
        editor:keyreleased(key)
    else
        game:keyreleased(key)
    end
end


function love.mousepressed(x, y, button)
    if editorEnabled then
	editor:mousepressed(x,y,button)
    else
	game:mousepressed(x,y,button)
    end
end



function love.mousereleased(x, y, button)
    if editorEnabled then
	editor:mousereleased(x,y, button)
    else
	game:mousereleased(x,y, button)
    end
end



