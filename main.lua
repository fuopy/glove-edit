require "middleclass"
require "middleclass-commons"

require "assets"
require "button"

require "leveldisplay"

scrw, scrh = love.window.getMode()

lvldisp = LevelDisplay()

function love.load()
	love.graphics.setLineStyle("rough")
end

function love.update(dt)
	lvldisp:update(dt)
end

function love.draw()
	lvldisp:draw()
end

function love.mousepressed(x, y, button)
	lvldisp:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	lvldisp:mousereleased(x, y, button)
end

function love.keypressed(key, isRepeat)
	lvldisp:keypressed(key, isRepeat)
end

function love.textinput(t)
	lvldisp:textinput(t)
end

function love.mousemoved(x, y, dx, dy)
	lvldisp:mousemoved(x, y, dx, dy)
end

function love.wheelmoved(x, y)
	local xm, ym = love.mouse.getPosition()
	if y < 0 then
		lvldisp:mousepressed(xm, ym, "wd")
	elseif y > 0 then
		lvldisp:mousepressed(xm, ym, "wu")
	end
end
