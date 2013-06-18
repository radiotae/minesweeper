--This is where I pretty much store all the grid data, like where its located on the screen, what image it should have, etc.
--it kind of blows right now tbh, there's an extra click state that makes shit confusing in the draw function
grid = {}
--self explanatory shit
WIDTH = 256
HEIGHT = 200
--y=1
SCALE = 3

--setting mouse properties here
mousex = nil
mousey = nil
mousexr = nil
mouseyr = nil
ldown = false

function love.load()
	--screen size
	love.graphics.setMode(WIDTH*SCALE, HEIGHT*SCALE, false, false)
	
	--looping through a 5 by 5 array, given the x and y values I put the image, x and y value locations in the array
	for x=1, 5, 1 do
		grid[x] = {}
		for y=1, 5, 1 do
			
			local state1 = love.graphics.newImage("/data/neutralState.png")
			local state2 = love.graphics.newImage("/data/pressState.png")
			--grid[x][y] = { xVal = 128*x, yVal = 100*y, image = test}
			--grid[x] = {}
			--grid[x][y] = { xVal = 128*x, yVal = 100*y, image = test}
			
			--local gr = grid[x][y]
			--love.graphics.draw(grid[x][y].image, gr.xVal, gr.yVal)
			
			grid[x][y] = {xVal = 128*x, yVal = 100*y, image = state1, click = state2, bomb = false, check = false}
			
		end
	end
	
	--I set the bombs
	local bombs = 0
	
	while bombs < 5 do
		for x=1, 5, 1 do
			for y=1, 5, 1 do
				if grid[x][y].bomb == false then
					bombo = math.random(2)
					--bombo = 1
					if bombo == 1 then
						grid[x][y].bomb = true
						bombs = bombs + 1
					end
				end
				
				if bombs == 5 then
					break
				end
				
			end
			
			if bombs == 5 then
				break
			end
			
		end
	end
	
end

function love.update(dt)
	if ldown == true then
		for x=1, 5, 1 do
			for y=1, 5, 1 do
				local gr = grid[x][y]
				if mousex >= gr.xVal and
				mousex <= gr.xVal + 50 and
				mousey >= gr.yVal and
				mousey <= gr.yVal + 50 then
					gr.image = love.graphics.newImage("/data/pressState.png")
				end
			end
		end
	else if ldown == false and
	mousexr ~= nil and
	mouseyr ~= nil then
		for x=1, 5, 1 do
			for y=1, 5, 1 do
				local gr = grid[x][y]
				
				if mousexr >= gr.xVal and
				mousexr <= gr.xVal + 50 and
				mouseyr >= gr.yVal and
				mouseyr <= gr.yVal + 50 then
					if gr.bomb == true then
						gr.image = love.graphics.newImage("/data/bombState.png")
					else
						gr.image = love.graphics.newImage("/data/nobombState.png")
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
	else
	end
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
	for x=1, 5, 1 do
		for y=1, 5, 1 do
			local gr = grid[x][y]
			love.graphics.draw(gr.image, gr.xVal, gr.yVal)
		end
	end
end