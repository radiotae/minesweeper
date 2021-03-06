--This is where I pretty much store all the grid data, like where its located on the screen, what image it should have, etc.
--it kind of blows right now tbh
grid = {}
--self explanatory shit
WIDTH = 256
HEIGHT = 200
--y=1
--POSSIBLE USER INPUT LATER
SCALE = 3
cols = 13
rows = 9
bomblim = 10

--setting mouse properties here
mousex = nil
mousey = nil
mousexr = nil
mouseyr = nil
ldown = false

function love.load()
	--screen size
	love.graphics.setMode(WIDTH*SCALE, HEIGHT*SCALE, false, false)
	
	--looping through a col by row array, given the x and y values I put the image, x and y value locations in the array
	for x=1, cols, 1 do
		grid[x] = {}
		for y=1, rows, 1 do
			
			local state1 = love.graphics.newImage("/data/neutralState.png")
			
			grid[x][y] = {xVal = 27+((x-1)*55), yVal = 60+((y-1)*55), image = state1, bomb = false, check = false, warns = 0}
			
		end
	end
	
	--I set the bombs
	local bombs = 0
	while bombs < bomblim do
		local coordx = math.random(cols)
		local coordy = math.random(rows)
		
		if grid[coordx][coordy].bomb == false then
			grid[coordx][coordy].bomb = true
			bombs = bombs + 1
		end
	end
	--sets warn variable to show how many bombs are around said tile IF the tile isn't a bomb itself
	for x=1, cols, 1 do
		for y=1, rows, 1 do
			gr = grid[x][y]
			local warnings = 0
			if gr.bomb == false then
				if x-1 > 0 and
				y-1 > 0 and
				grid[x-1][y-1].bomb == true then
					warnings = warnings + 1
				end
				if y-1 > 0 and
				grid[x][y-1].bomb == true then
					warnings = warnings + 1
				end
				if x+1 <= cols and
				y-1 > 0 and
				grid[x+1][y-1].bomb == true then
					warnings = warnings + 1
				end
				if x-1 > 0 and
				grid[x-1][y].bomb == true then
					warnings = warnings + 1
				end
				if x+1 <= cols and
				grid[x+1][y].bomb == true then
					warnings = warnings + 1
				end
				if x-1 > 0 and
				y+1 <= rows and
				grid[x-1][y+1].bomb == true then
					warnings = warnings + 1
				end
				if y+1 <= rows and
				grid[x][y+1].bomb == true then
					warnings = warnings + 1
				end
				if x+1 <= cols and
				y+1 <= rows and
				grid[x+1][y+1].bomb == true then
					warnings = warnings + 1
				end
			end
			gr.warns = warnings
		end
	end
end

function love.update(dt)
--Checks to see if mouse is pressed and if it is pressed on a square. If so, change square to pressState
	if ldown == true then
		for x=1, cols, 1 do
			for y=1, rows, 1 do
				local gr = grid[x][y]
				if mousex >= gr.xVal and
				mousex <= gr.xVal + 50 and
				mousey >= gr.yVal and
				mousey <= gr.yVal + 50 and
				gr.check == false then
					gr.image = love.graphics.newImage("/data/pressState.png")
				end
			end
		end
	end
	
--Checks to see if mouse is released and if it is released on a square. If so, show square.
--If released not on square, changed pressState back into neutralState
	if ldown == false and
	mousexr ~= nil and
	mouseyr ~= nil then
		for x=1, cols, 1 do
			for y=1, rows, 1 do
				local gr = grid[x][y]
				
				if mousexr >= gr.xVal and
				mousexr <= gr.xVal + 50 and
				mouseyr >= gr.yVal and
				mouseyr <= gr.yVal + 50 then
					if gr.bomb == true then
						gr.image = love.graphics.newImage("/data/bombState.png")
					else
						local warnings = gr.warns
						gr.image = warnImage(warnings)
					end
					gr.check = true
				end
				if gr.check == false then
					gr.image = love.graphics.newImage("/data/neutralState.png")
				end
			end
		end
		mousexr = nil
		mouseyr = nil
	end
	
	--Checks the board to see if there are any empty tiles that have been checked on the board. If so, updates all the tiles around said tile.
	local check = true
	while check == true do
		check = emptyCheck(grid)
	end
	
end

function love.mousepressed(x, y, button)
	--when mouse is pressed it just saves the location and checks makes ldown true
	if button == 'l' then
		mousex = x
		mousey = y
		ldown = true;
	end
end

function love.mousereleased(x, y, button)
	--saves location values and sets ldown false
	if button == 'l' then
		ldown = false
		mousexr = x
		mouseyr = y
	end
end

function love.draw()
--updates the board
	for x=1, cols, 1 do
		for y=1, rows, 1 do
			local gr = grid[x][y]
			love.graphics.draw(gr.image, gr.xVal, gr.yVal)
		end
	end
end

--Given x, returns image of correct number tile
function warnImage(x)
	if x == 0 then
		return love.graphics.newImage("/data/nobombState.png")
	end
	if x == 1 then
		return love.graphics.newImage("/data/warn1State.png")
	end
	if x == 2 then
		return love.graphics.newImage("/data/warn2State.png")
	end
	if x == 3 then
		return love.graphics.newImage("/data/warn3State.png")
	end
	if x == 4 then
		return love.graphics.newImage("/data/warn4State.png")
	end
	if x == 5 then
		return love.graphics.newImage("/data/warn5State.png")
	end
	if x == 6 then
		return love.graphics.newImage("/data/warn6State.png")
	end
	if x == 7 then
		return love.graphics.newImage("/data/warn7State.png")
	end
	if x == 8 then
		return love.graphics.newImage("/data/warn8State.png")
	end
	
end

function emptyCheck(grid)
	emptyStates = false
	for x=1,cols,1 do
		for y=1, rows, 1 do
			gr = grid[x][y]
			if gr.warns == 0 and gr.check == true and
			gr.bomb == false then
				if x-1 > 0 and
				y-1 > 0 then
					warnings = grid[x-1][y-1].warns
					grid[x-1][y-1].image = warnImage(warnings)
					grid[x-1][y-1].check = true
					if warnings == 0 then
						emptyStates = true
					end
				end
				if y-1 > 0 then
					warnings = grid[x][y-1].warns
					grid[x][y-1].image = warnImage(warnings)
					grid[x][y-1].check = true
					if warnings == 0 then
						emptyStates = true
					end
				end
				if x+1 <= cols and y-1 > 0 then
					warnings = grid[x+1][y-1].warns
					grid[x+1][y-1].image = warnImage(warnings)
					grid[x+1][y-1].check = true
					if warnings == 0 then
						emptyStates = true
					end
				end
				if x-1 > 0 then
					warnings = grid[x-1][y].warns
					grid[x-1][y].image = warnImage(warnings)
					grid[x-1][y].check = true
					if warnings == 0 then
						emptyStates = true
					end
				end
				if x+1 <= cols then
					warnings = grid[x+1][y].warns
					grid[x+1][y].image = warnImage(warnings)
					grid[x+1][y].check = true
					if warnings == 0 then
						emptyStates = true
					end
				end
				if x-1 > 0 and y+1 <= rows then
					warnings = grid[x-1][y+1].warns
					grid[x-1][y+1].image = warnImage(warnings)
					grid[x-1][y+1].check = true
					if warnings == 0 then
						emptyStates = true
					end
				end
				if y+1 <= rows then
					warnings = grid[x][y+1].warns
					grid[x][y+1].image = warnImage(warnings)
					grid[x][y+1].check = true
					if warnings == 0 then
						emptyStates = true
					end
				end
				if x+1 <= cols and y+1 <= rows then
					warnings = grid[x+1][y+1].warns
					grid[x+1][y+1].image = warnImage(warnings)
					grid[x+1][y+1].check = true
					if warnings == 0 then
						emptyStates = true
					end
				end
			end
		end
	end
	return emptyStates
end
