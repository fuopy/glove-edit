Button = class("Button")

function Button:initialize(x, y, label, func)
	self.x = x
	self.y = y
	
	self.w = 100
	self.h = 20
	
	self.label = label
	self.func = func
end

function Button:update(dt)
	
end

function Button:draw()
	if self.highlighted then
		love.graphics.setColor(colors.white)
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
		love.graphics.setColor(colors.black)
		love.graphics.printf(self.label, self.x, self.y+4, self.w, "center")
	else
		love.graphics.setColor(colors.white)
		love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
		love.graphics.printf(self.label, self.x, self.y+4, self.w, "center")
	end
end

function Button:mousepressed(x, y, button)
	if x > self.x and x < self.x + self.w and y > self.y and y < self.y + self.h then
		self:func()
		return true
	end
end