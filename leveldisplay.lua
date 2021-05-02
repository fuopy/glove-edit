local ser = require 'ser'

LevelDisplay = class("LevelDisplay")

function LevelDisplay:initialize()
	self.walls = {} -- max 16
	self.spawners = {} -- max 4
	self.exits = {} -- max 4
	self.starts = {} -- max 1
	self.keys = {} -- max 4
	self.treasures = {} -- max 3
	
	self.changesMade = false
	self.currentLevel = 0
	self.infoString = ""
	
	self.filename = "ENTER FILE NAME"
	self.speed = 100
	
	self.dragObj = nil
	
	self.xoffset = 70
	self.yoffset = 40
	
	self.scale = 2
	
	self.showGrid = true
	
	self.buttons = {}
	
	self.toolMode = "select"
	local gui = self
	
	local function resetButtons()
		for k,v in pairs(self.buttons) do
			v.highlighted = false
		end
	end
	
	table.insert(self.buttons, Button(0, 0, "Select", function(self)
		gui.infoString = "Select Tool\n\nUse the mouse to manipulate objects\nClick and drag an object to move it."
		gui.toolMode = "select"
		resetButtons()
		self.highlighted = true
	end))
	table.insert(self.buttons, Button(200, 0, "Wall", function(self)
		gui.infoString = "Add Wall\n\nClick to add a wall."
		gui.toolMode = "wall"
		resetButtons()
		self.highlighted = true
	end))
	table.insert(self.buttons, Button(300, 0, "Spawner", function(self)
	gui.infoString = "Add Spawner\n\nClick to add an enemy spawner."
		gui.toolMode = "spawner"
		resetButtons()
		self.highlighted = true
	end))
	table.insert(self.buttons, Button(400, 0, "Exit", function(self)
	gui.infoString = "Add Exit\n\nClick to add a level exit."
		gui.toolMode = "exit"
		resetButtons()
		self.highlighted = true
	end))
	table.insert(self.buttons, Button(500, 0, "Start", function(self)
	gui.infoString = "Add Start\n\nClick to add the level starting point."
		gui.toolMode = "start"
		resetButtons()
		self.highlighted = true
	end))
	table.insert(self.buttons, Button(600, 0, "Key", function(self)
	gui.infoString = "Add Key\n\nClick to add a key."
		gui.toolMode = "key"
		resetButtons()
		self.highlighted = true
	end))
	table.insert(self.buttons, Button(700, 0, "Treasure", function(self)
	gui.infoString = "Add Treasure\n\nClick to add treasure."
		gui.toolMode = "treasure"
		resetButtons()
		self.highlighted = true
	end))
	self.buttons[1].highlighted = true
	
	self:switchToLevel(0)
end

function LevelDisplay:update(dt)
	if self.dialog then
		if self.dialog.active then
			self.dialog:update(dt)
			return
		else
			if self.dialog.action == "save" then
				self:save(self.dialog.filename)
			elseif self.dialog.action == "load" then
				self:load(self.dialog.filename)
			elseif self.dialog.action == "export" then
				self:export(self.dialog.filename)
			end
			self.dialog = nil
		end
	end
	--[[
	if love.keyboard.isDown("down") then
		self.yoffset = self.yoffset - self.speed*dt
	elseif love.keyboard.isDown("up") then
		self.yoffset = self.yoffset + self.speed*dt
	end
	if love.keyboard.isDown("right") then
		self.xoffset = self.xoffset - self.speed*dt
	elseif love.keyboard.isDown("left") then
		self.xoffset = self.xoffset + self.speed*dt
	end
	]]
	
	if self.dragObj then
		local mx, my = self:getMouseTile()
		self.dragObj.x = mx
		self.dragObj.y = my
	end
end

local treasureLayouts = {
	[0] = {{1}},
	[1] = {{1},{1}},
	[2] = {{1, 1}},
	[3] = {{1, 0},{0, 1}},
	[4] = {{0, 1},{1, 0}},
	[5] = {{1, 0, 0},{0, 0, 1}},
	[6] = {{1, 0},{0,0},{0,1}},
	[7] = {{0,1},{0,0},{1,0}},
	[8] = {{0,0,0},{1,0,0}},
	[9] = {{1,1,0},{0,0,1}},
	[10] = {{1,0,0},{0,1,0},{0,0,1}},
	[11] = {{1,0},{1,0},{0,1}},
	[12] = {{1},{},{1,0,1}},
	[13] = {{0,1},{},{1,0,1}},
	[14] = {{1,0,1},{},{0,1}},
	[15] = {{0,1},{1},{0,1}}
}

function LevelDisplay:draw()
	local ofx, ofy = self.xoffset, self.yoffset
	for k,v in pairs(self.buttons) do
		v:draw()
	end
	love.graphics.setColor(colors.white)
	
	--local changeMadeSymbol = self.changesMade and " (Modified)" or ""
	love.graphics.printf("Level " .. self.currentLevel, 0, 60, scrw, "center")
	
	love.graphics.push()
	love.graphics.scale(self.scale, self.scale)
	
	love.graphics.rectangle("line", ofx, ofy, 8*32, 8*16)
	
	if self.showGrid then
		love.graphics.setLineWidth(.5)
		love.graphics.line(ofx + 8*16, ofy, ofx + 8*16, ofy + 8*16)
		love.graphics.line(ofx, ofy + 8*8, ofx + 8*32, ofy + 8*8)
		love.graphics.setLineWidth(1)
	end
	
	local mtx, mty = self:getMouseTile()
	love.graphics.rectangle("line", mtx*8+ofx, mty*8+ofy, 8, 8)
	
	love.graphics.setColor(colors.white)
	for k,v in pairs(self.walls) do
		for x=0, v.w-1, 1 do
			for y=0, v.h-1, 1 do
				if v.style then
					love.graphics.draw(images.wallB, 8*v.x+8*x+ofx, 8*v.y+8*y+ofy)
				else
					love.graphics.draw(images.wall, 8*v.x+8*x+ofx, 8*v.y+8*y+ofy)
				end
			end
		end
	end
	for k,v in pairs(self.spawners) do
		love.graphics.draw(images.spawner, 8*v.x+ofx, 8*v.y+ofy)
	end
	for k,v in pairs(self.exits) do
		love.graphics.draw(images.exit, 8*v.x+ofx, 8*v.y+ofy)
	end
	for k,v in pairs(self.starts) do
		love.graphics.draw(images.start, 8*v.x+ofx, 8*v.y+ofy)
	end
	for k,v in pairs(self.keys) do
		love.graphics.draw(images.key, 8*v.x+ofx, 8*v.y+ofy)
	end
	for k,v in pairs(self.treasures) do
		local image = images.none
		if v.type == 1  then image = images.gold
		elseif v.type == 2 then	image = images.poo
		elseif v.type == 3 then image = images.cup
		elseif v.type == 4 then image = images.lemon
		end
		
		for y, row in ipairs(treasureLayouts[v.arrangement]) do
			for x, col in ipairs(row) do
				if col == 1 then
					love.graphics.draw(image, 8*(v.x+x-1)+ofx,  8*(v.y+y-1)+ofy)
				end
			end
		end
		--[[
		if v.arrangement == 0 then
			love.graphics.draw(image, 8*v.x+ofx,  8*v.y+ofy)
		elseif v.arrangement == 1 then
			love.graphics.draw(image, 8*v.x+ofx,  8*v.y+ofy)
			love.graphics.draw(image, 8*v.x+ofx,  8*(v.y+1)+ofy)
		elseif v.arrangement == 2 then
			love.graphics.draw(image, 8*v.x+ofx,  8*v.y+ofy)
			love.graphics.draw(image, 8*(v.x+1)+ofx,  8*v.y+ofy)
		elseif v.arrangement == 3 then
			love.graphics.draw(image, 8*v.x+ofx,  8*v.y+ofy)
			love.graphics.draw(image, 8*(v.x+1)+ofx,  8*(v.y+1)+ofy)
		elseif v.arrangement == 4 then
			love.graphics.draw(image, 8*v.x+ofx,  8*v.y+ofy)
			love.graphics.draw(image, 8*v.x+ofx,  8*(v.y+1)+ofy)
			love.graphics.draw(image, 8*v.x+ofx,  8*(v.y+2)+ofy)
		elseif v.arrangement == 5 then
			love.graphics.draw(image, 8*v.x+ofx,  8*v.y+ofy)
			love.graphics.draw(image, 8*(v.x+1)+ofx,  8*v.y+ofy)
			love.graphics.draw(image, 8*(v.x+2)+ofx,  8*v.y+ofy)
		elseif v.arrangement == 6 then
			love.graphics.draw(image, 8*v.x+ofx,  8*v.y+ofy)
			love.graphics.draw(image, 8*(v.x+1)+ofx,  8*(v.y+1)+ofy)
			love.graphics.draw(image, 8*(v.x+2)+ofx,  8*(v.y+2)+ofy)
		elseif v.arrangement == 7 then
			love.graphics.draw(image, 8*v.x+ofx,  8*v.y+ofy)
			love.graphics.draw(image, 8*(v.x+1)+ofx,  8*v.y+ofy)
			love.graphics.draw(image, 8*v.x+ofx,  8*(v.y+1)+ofy)
		end
		]]
	end
	
	love.graphics.pop()

	if self.dialog then self.dialog:draw(); return end
	love.graphics.rectangle("line", 100-4, 400-4, 600+8, 200-8)
	love.graphics.printf(self.infoString, 100, 400, 600, "left")
end

function LevelDisplay:getMouseTile()
	local x, y = love.mouse:getPosition()
	local mx, my = math.floor((x-(self.xoffset*self.scale))/(8*self.scale)), math.floor((y-(self.yoffset*self.scale))/(8*self.scale))
	
	mx = (mx < 0) and 0 or mx
	mx = (mx > 31) and 31 or mx
	
	my = (my < 0) and 0 or my
	my = (my > 15) and 15 or my
	
	return mx, my
end

function LevelDisplay:mousemoved(x, y, dx, dy)
	if love.mouse.isDown(1) then return end
	self:drawTileInfo()
end

function LevelDisplay:drawTileInfo()
	if self.toolMode ~= "select" then return end
	local x, y = self:getMouseTile()
	local found, foundObj = self:getTileAt(x, y)
	
	if found then
		local str = "Object Info:"
		str = str .. "\n" .. found
		if found == "wall" then
			str = str .. string.format(" (%d / 16 placed)", #self.walls)
			str = str .. "\n\nPlayers and enemies can't pass through this!\nUse Mouse Wheel to change length, right-click to rotate, space to change style.\n"
		elseif found == "exit" then
			str = str .. string.format(" (%d / 4 placed)", #self.exits)
			str = str .. "\n\nTouch this to clear the level. It can take the player to any level, or just the next level (level 0).\nUse Mouse Wheel to change destination level.\n"
		elseif found == "key" then
			str = str .. string.format(" (%d / 4 placed)", #self.keys)
			str = str .. "\n\nTouching this will make the target wall disappear.\nUse Mouse Wheel to change target wall to delete when key is collected.\n"
		elseif found == "spawner" then
			str = str .. string.format(" (%d / 4 placed)", #self.spawners)
			str = str .. "\n\nEnemies spawn from this at regular intervals.\n"
		elseif found == "start" then
			str = str .. string.format(" (%d / 1 placed)", #self.starts)
			str = str .. "\n\nThis is the initial spawning location of the player.\n"
		elseif found == "treasure" then
			str = str .. string.format(" (%d / 3 placed)", #self.treasures)
			str = str .. "\n\nTouching this gives a bonus.\nLemons recover 200 health, Chalice is worth 6pts, Gold is worth 10pts, Poo kills all the badguys.\nUse Mouse Wheel to change arrangement, right click to cycle type.\n"
		end
		str = str .. "\nID: " .. foundObj.id
		str = str .. "\nX: " .. foundObj.x
		str = str .. "\nY: " .. foundObj.y
		if foundObj.dest then str = str .. "\nDestination: " .. foundObj.dest end
		if foundObj.target then str = str .. "\nTarget: " .. foundObj.target end
		if foundObj.type then str = str .. "\nType: " .. foundObj.type end
		if foundObj.arrangement then str = str .. "\nArrangement: " .. foundObj.arrangement end
		if foundObj.w then str = str .. "\nWidth: " .. foundObj.w end
		if foundObj.h then str = str .. "\nHeight: " .. foundObj.h end
		self.infoString = str
	else
		self.infoString = [[Editor Instructions:
		
Click an object type at the top to create a new object.
Move an object by dragging its anchor tile. In the case of a wall, that would be the top left tile.
The Level format requires the maximum number of each type of object is placed in the map.
Objects may overlap! Any object sharing a space with a wall will be hidden by the wall.
Hit backspace or delete to delete an object.

Keyboard Shortcuts:
LeftArrow to save and go to previous level
RightArrow to save and go to next level
Ctrl+Enter to export
F3 to toggle grid
]]
	end
end

function LevelDisplay:getTileAt(x, y)
	local found, foundObj
	for k,v in pairs(self.walls) do if v.x == x and v.y == y then found = "wall"; foundObj = v; break end end
	for k,v in pairs(self.spawners) do if v.x == x and v.y == y then found = "spawner"; foundObj = v; break end end
	for k,v in pairs(self.starts) do if v.x == x and v.y == y then found = "start"; foundObj = v; break end end
	for k,v in pairs(self.exits) do if v.x == x and v.y == y then found = "exit"; foundObj = v; break end end
	for k,v in pairs(self.keys) do if v.x == x and v.y == y then found = "key"; foundObj = v; break end end
	for k,v in pairs(self.treasures) do if v.x == x and v.y == y then found = "treasure"; foundObj = v; break end end
	return found, foundObj
end

function LevelDisplay:mousepressed(x, y, button)
	if self.dialog then self.dialog:mousepressed(x, y, button); return end
	local buttonHit = false
	for k,v in pairs(self.buttons) do
		buttonHit = v:mousepressed(x, y, button)
		if buttonHit then return end
	end
	local mx, my = self:getMouseTile()
	self:clickTile(mx, my, button)
	--self:clickTile((x-(self.xoffset*self.scale))/(8*self.scale), (y-(self.yoffset*self.scale))/(8*self.scale), button)
	self:drawTileInfo()
end

function LevelDisplay:addTo(tab, limit, obj)
	self.changesMade = true
	for i=1, limit, 1 do
		if tab[i] == nil then
			tab[i] = obj
			return i-1
		end
	end
	return false
end

function LevelDisplay:clickTile(x, y, button)
	self.changesMade = true
	if self.toolMode == "wall" then
		local newObj = {x=x, y=y, w=2, h=1, style=false}
		newObj.id = self:addTo(self.walls, 16, newObj)
		self.buttons[1]:func()
	elseif self.toolMode == "spawner" then
		local newObj = {x=x, y=y}
		newObj.id = self:addTo(self.spawners, 4, newObj)
		self.buttons[1]:func()
	elseif self.toolMode == "exit" then
		local newObj = {x=x, y=y, dest=0}
		newObj.id = self:addTo(self.exits, 4, newObj)
		self.buttons[1]:func()
	elseif self.toolMode == "start" then
		local newObj = {x=x, y=y}
		newObj.id = self:addTo(self.starts, 1, newObj)
		self.buttons[1]:func()
	elseif self.toolMode == "key" then
		local newObj = {x=x, y=y, target=0}
		newObj.id = self:addTo(self.keys, 4, newObj)
		self.buttons[1]:func()
	elseif self.toolMode == "treasure" then
		local newObj = {x=x, y=y, type=1, arrangement=0}
		newObj.id = self:addTo(self.treasures, 3, newObj)
		self.buttons[1]:func()
	elseif self.toolMode == "select" then
		tiletype, tileobj = self:getTileAt(x, y)
		if button == 1 then
			if not self.dragObj then
				self.dragObj = tileobj
			end
		elseif tiletype == "wall" then
			local dimension = (tileobj.w == 1) and "h" or "w"
			if button == "wu" then
				tileobj[dimension] = tileobj[dimension] + 1
				tileobj[dimension] = (tileobj[dimension] > 32) and 32 or tileobj[dimension]
			elseif button == "wd" then
				tileobj[dimension] = tileobj[dimension] - 1
				tileobj[dimension] = (tileobj[dimension] < 1) and 1 or tileobj[dimension]
			elseif button == 2 then
				local temp = tileobj.h
				tileobj.h = tileobj.w
				tileobj.w = temp
			end
		elseif tiletype == "exit" then
			if button == "wu" then
				tileobj.dest = tileobj.dest + 1
				tileobj.dest = (tileobj.dest > 127) and 127 or tileobj.dest
			elseif button == "wd" then
				tileobj.dest = tileobj.dest - 1
				tileobj.dest = (tileobj.dest < 0) and 0 or tileobj.dest
			end
		elseif tiletype == "key" then
			if button == "wu" then
				tileobj.target = tileobj.target + 1
				tileobj.target = (tileobj.target > 15) and 15 or tileobj.target
			elseif button == "wd" then
				tileobj.target = tileobj.target - 1
				tileobj.target = (tileobj.target < 0) and 0 or tileobj.target
			end
		elseif tiletype == "treasure" then
			if button == "wu" then
				tileobj.arrangement = tileobj.arrangement + 1
				tileobj.arrangement = (tileobj.arrangement > 15) and 15 or tileobj.arrangement
			elseif button == "wd" then
				tileobj.arrangement = tileobj.arrangement - 1
				tileobj.arrangement = (tileobj.arrangement < 0) and 0 or tileobj.arrangement
			elseif button == 2 then
				tileobj.type = tileobj.type + 1
				tileobj.type = (tileobj.type > 4) and 0 or tileobj.type
			end
		end
	end
end

function LevelDisplay:newLevel()
	self.walls = {}
	self.spawners = {}
	self.exits = {}
	self.starts = {} 
	self.keys = {}
	self.treasures = {}
end

function LevelDisplay:mousereleased(x, y, button)
	if self.dialog then self.dialog:mousereleased(x, y, button); return end
	self.dragObj = nil
end

function LevelDisplay:keypressed(key, isRepeat)
	if self.dialog then self.dialog:keypressed(key, isRepeat); return end
	if key == "delete" or key == "backspace" then
		tiletype, tileobj = self:getTileAt(self:getMouseTile())
		if tiletype == "wall" then
			self.walls[tileobj.id+1] = nil
		elseif tiletype == "exit" then
			self.exits[tileobj.id+1] = nil
		elseif tiletype == "spawner" then
			self.spawners[tileobj.id+1] = nil
		elseif tiletype == "key" then
			self.keys[tileobj.id+1] = nil
		elseif tiletype == "start" then
			self.starts[tileobj.id+1] = nil
		elseif tiletype == "treasure" then
			self.treasures[tileobj.id+1] = nil
		end
	end
	if key == "s" and love.keyboard.isDown("lctrl") then
		self:saveCurrentLevel()
		--self:showSaveDialog()
	elseif key == "o" and love.keyboard.isDown("lctrl") then
		--self:showLoadDialog()
	elseif key == "return" and love.keyboard.isDown("lctrl") then
		--self:showExportDialog()
		self:exportAll()
	elseif key == "n" and love.keyboard.isDown("lctrl") then
		self:newLevel()
	elseif key == " " then
		tiletype, tileobj = self:getTileAt(self:getMouseTile())
		if tiletype == "wall" then
			self.changesMade = true
			tileobj.style = not tileobj.style
		end
	elseif key == "f3" then
		self.showGrid = not self.showGrid
	elseif key == "f1" then
        love.system.openURL("file://"..love.filesystem.getSaveDirectory())
	end
	if key == "right" then
		self:nextLevel()
	elseif key == "left" then
		self:previousLevel()
	end
end

function LevelDisplay:nextLevel()
	if self.currentLevel < 50 then
		self:switchToLevel(self.currentLevel + 1)
	end
end

function LevelDisplay:previousLevel()
	if self.currentLevel > 0 then
		self:switchToLevel(self.currentLevel - 1)
	end
end

function LevelDisplay:switchToLevel(level)
	if self.changesMade then
		self:saveCurrentLevel()
		self.changesMade = false
	end
	self.currentLevel = level
	if not self:load(tostring(level) .. ".lua") then
		self:newLevel()
		return false
	end
	return true
end

function LevelDisplay:showSaveDialog()
	self.dialog = SaveDialog()
end
function LevelDisplay:showLoadDialog()
	self.dialog = LoadDialog()
end
function LevelDisplay:showExportDialog()
	self.dialog = ExportDialog()
end

function LevelDisplay:textinput(t)
	if self.dialog then self.dialog:textinput(t) end
end

function LevelDisplay:load(filename)
	if love.filesystem.exists(filename) then
		local func = love.filesystem.load(filename)
		local obj = func()
		self.walls = obj.walls
		self.exits = obj.exits
		self.keys = obj.keys
		self.spawners = obj.spawners
		self.starts = obj.starts
		self.treasures = obj.treasures
		return true
	end
	return false
end

function LevelDisplay:exportAll()
	local levelStrings = {
		"/* Level Data Generated with GloveEdit 0.4 */\n",
    "/* Paste into data.h */\n"
	}
	table.insert(levelStrings, "\nconst unsigned short levelData[] PROGMEM = {")
	
	local levelCount = 0
	for i=0, 30, 1 do
		if self:switchToLevel(i) then
			levelCount = levelCount + 1
			table.insert(levelStrings, self:export())
		else
			break
		end
	end
  
	table.insert(levelStrings, "};")
	
	--[[
	table.insert(levelStrings, "\nextern const unsigned short* const levelData[] PROGMEM = {")
	
	for i=0,levelCount-1, 1 do
		table.insert(levelStrings, "\n\tlevelData_" .. tostring(i) .. ",")
	end
	
	table.insert(levelStrings, "\n};\n\nextern const unsigned char numLevels = " .. levelCount .. ";\n")
	]]
	table.insert(levelStrings, "\n\nconst unsigned char numLevels = " .. levelCount .. ";\n")
	
	local finalStr = table.concat(levelStrings)
	
	love.filesystem.write("levels.h", finalStr)
end

function LevelDisplay:export()
	--local filestr = string.sub(filename, 1, -3)
	--local outStr = "extern const unsigned short level_" .. filestr .. "[] PROGMEM = {\n\t"
	local outStr = "\n\t" --\n\t" .. tostring(self.currentLevel) .. "\n\n" --"extern const unsigned short levelData_" .. tostring(self.currentLevel) .. "[] PROGMEM = {\n\t"
	--local outStr = "\t"
	
	-- Each element is 2 bytes
	
	-- First, the walls.
	for k,v in ipairs(self.walls) do
		local wallbyte = 0
		local direction = v.w == 1 and 1 or 0
		local width = (direction == 1) and v.h or v.w
		
		wallbyte = wallbyte + bit.lshift(bit.band(v.x, 31), 11)
		wallbyte = wallbyte + bit.lshift(bit.band(v.y, 15), 7)
		wallbyte = wallbyte + bit.lshift(bit.band(width-1, 31), 2)
		wallbyte = wallbyte + (v.style and 2 or 0)
		wallbyte = wallbyte + direction
		
		local nextLine = (k==8 or k==16) and "\n\t" or ""
		
		outStr = outStr .. ("0x" .. bit.tohex(wallbyte, 4) .. ", " .. nextLine)
	end
	
	-- Next the Spawners
	for k,v in ipairs(self.spawners) do
		local wallbyte = 0
		
		wallbyte = wallbyte + bit.lshift(bit.band(v.x, 31), 11)
		wallbyte = wallbyte + bit.lshift(bit.band(v.y, 15), 7)
		
		outStr = outStr .. ("0x" .. bit.tohex(wallbyte, 4) .. ", ")
	end
	
	-- Next the keys.
	for k,v in ipairs(self.keys) do
		local wallbyte = 0
		
		wallbyte = wallbyte + bit.lshift(bit.band(v.x, 31), 11)
		wallbyte = wallbyte + bit.lshift(bit.band(v.y, 15), 7)
		wallbyte = wallbyte + bit.lshift(bit.band(v.target, 15), 3)
		
		local nextLine = (k==4) and "\n\t" or ""
		
		outStr = outStr .. ("0x" .. bit.tohex(wallbyte, 4) .. ", " .. nextLine)
	end
	
	-- Next the Starts
	for k,v in ipairs(self.starts) do
		local wallbyte = 0
		
		wallbyte = wallbyte + bit.lshift(bit.band(v.x, 31), 11)
		wallbyte = wallbyte + bit.lshift(bit.band(v.y, 15), 7)
		
		outStr = outStr .. ("0x" .. bit.tohex(wallbyte, 4) .. ", ")
	end
	
	-- Finally the exits.
	for k,v in ipairs(self.exits) do
		local wallbyte = 0
		
		wallbyte = wallbyte + bit.lshift(bit.band(v.x, 31), 11)
		wallbyte = wallbyte + bit.lshift(bit.band(v.y, 15), 7)
		wallbyte = wallbyte + bit.band(v.dest, 127)
		
		outStr = outStr .. ("0x" .. bit.tohex(wallbyte, 4) .. ", ")
	end
	
	-- The Treasures!
	for k,v in ipairs(self.treasures) do
		local wallbyte = 0
		
		wallbyte = wallbyte + bit.lshift(bit.band(v.x, 31), 11)
		wallbyte = wallbyte + bit.lshift(bit.band(v.y, 15), 7)
		wallbyte = wallbyte + bit.lshift(bit.band(v.type, 7), 4)
		wallbyte = wallbyte + bit.band(v.arrangement, 15)
		
		outStr = outStr .. ("0x" .. bit.tohex(wallbyte, 4) .. ", ")
	end
	
	outStr = outStr .. "\n"
	--outStr = outStr .. "\n\n"
	
	return outStr
	
	--print(outStr)
	
	--love.filesystem.write(filename, outStr)
end

function LevelDisplay:saveCurrentLevel()
	self:save(tostring(self.currentLevel) .. ".lua")
	self.changesMade = false
end

function LevelDisplay:save(filename)
	local data = {
		walls = self.walls,
		spawners = self.spawners,
		exits = self.exits,
		starts = self.starts,
		keys = self.keys,
		treasures = self.treasures
	}
	
	love.filesystem.write(filename, ser(data))
end

LoadDialog = class("LoadDialog")
function LoadDialog:initialize()
	self.w = 400
	self.h = 300
	
	self.x = love.window.getWidth()/2 - self.w/2
	self.y = love.window.getHeight()/2 - self.h/2
	
	self.filename = lvldisp.filename
	
	self.active = true
end

function LoadDialog:update(dt)
	
end

function LoadDialog:draw()
	love.graphics.setColor(colors.black)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	love.graphics.setColor(colors.white)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
	
	love.graphics.printf("Load File..", self.x, self.y + 20, self.w, "center")
	love.graphics.printf("> " .. self.filename .. ".lua <", self.x, self.y + 100, self.w, "center")
	love.graphics.printf("Hit ENTER to load\nHit ESCAPE to cancel", self.x, self.y + 200, self.w, "center")
end

function LoadDialog:keypressed(key, isRepeat)
	if key == "escape" then self.active = false end
	if key == "backspace" then
		if love.keyboard.isDown("lctrl") then self.filename = ""
		else self.filename = string.sub(self.filename, 1, -2) end
	end
	if key == "return" then
		self.action = "load"
		lvldisp.filename = self.filename
		self.filename = self.filename .. ".lua"
		self.active = false
	end
end

function LoadDialog:textinput(t)
	if self.filename == "ENTER FILE NAME" then self.filename = "" end
	self.filename = self.filename .. t
end

function LoadDialog:mousepressed(x, y, button) end
function LoadDialog:mousereleased(x, y, button) end
function LoadDialog:keyreleased(key) end



SaveDialog = class("SaveDialog")
function SaveDialog:initialize()
	self.w = 400
	self.h = 300
	
	self.x = love.window.getWidth()/2 - self.w/2
	self.y = love.window.getHeight()/2 - self.h/2
	
	self.filename = lvldisp.filename
	self.areYouSure = false
	
	self.active = true
end

function SaveDialog:update(dt)
	
end

function SaveDialog:draw()
	love.graphics.setColor(colors.black)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	love.graphics.setColor(colors.white)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
	
	love.graphics.printf("Save As..", self.x, self.y + 20, self.w, "center")
	love.graphics.printf("> " .. self.filename .. ".lua <", self.x, self.y + 100, self.w, "center")
	love.graphics.printf("Hit ENTER to save\nHit ESCAPE to cancel", self.x, self.y + 200, self.w, "center")
	
	if self.areYouSure then
		love.graphics.printf("ARE YOU SURE YOU WANNA REPLACE IT!?", self.x, self.y + 150, self.w, "center")
	end
end

function SaveDialog:keypressed(key, isRepeat)
	if key == "escape" then
		if self.areYouSure then
			self.areYouSure = false
		else
			self.active = false
		end
	end
	if key == "backspace" then
		if love.keyboard.isDown("lctrl") then self.filename = ""
		else self.filename = string.sub(self.filename, 1, -2) end
	end
	if key == "return" then
		if self.areYouSure or not love.filesystem.exists(self.filename .. ".lua") then
			self.action = "save"
			lvldisp.filename = self.filename
			self.filename = self.filename .. ".lua"
			self.active = false
		end
		if love.filesystem.exists(self.filename .. ".lua") then
			self.areYouSure = true
		end
	end
end

function SaveDialog:textinput(t)
	if self.filename == "ENTER FILE NAME" then self.filename = "" end
	self.filename = self.filename .. t
end

function SaveDialog:mousepressed(x, y, button) end
function SaveDialog:mousereleased(x, y, button) end
function SaveDialog:keyreleased(key) end


ExportDialog = class("ExportDialog")
function ExportDialog:initialize()
	self.w = 400
	self.h = 300
	
	self.x = love.window.getWidth()/2 - self.w/2
	self.y = love.window.getHeight()/2 - self.h/2
	
	self.filename = lvldisp.filename
	
	self.active = true
end

function ExportDialog:update(dt)
	
end

function ExportDialog:draw()
	love.graphics.setColor(colors.black)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	love.graphics.setColor(colors.white)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
	
	love.graphics.printf("Export As..", self.x, self.y + 20, self.w, "center")
	love.graphics.printf("> " .. self.filename .. ".h <", self.x, self.y + 100, self.w, "center")
	love.graphics.printf("Hit ENTER to save\nHit ESCAPE to cancel", self.x, self.y + 200, self.w, "center")
end

function ExportDialog:keypressed(key, isRepeat)
	if key == "escape" then self.active = false end
	if key == "backspace" then
		if love.keyboard.isDown("lctrl") then self.filename = ""
		else self.filename = string.sub(self.filename, 1, -2) end
	end
	if key == "return" then
		self.action = "export"
		lvldisp.filename = self.filename
		self.filename = self.filename .. ".h"
		self.active = false
	end
end

function ExportDialog:textinput(t)
	if self.filename == "ENTER FILE NAME" then self.filename = "" end
	self.filename = self.filename .. t
end

function ExportDialog:mousepressed(x, y, button) end
function ExportDialog:mousereleased(x, y, button) end
function ExportDialog:keyreleased(key) end