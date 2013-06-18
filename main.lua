grid = {}
WIDTH = 256
HEIGHT = 200
--y=1
SCALE = 3

mousex = nil
mousey = nil
mousexr = nil
mouseyr = nil
ldown = false

function love.load()
	love.graphics.setMode(WIDTH*SCALE, HEIGHT*SCALE, false, false)
	
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
			
			grid[x][y] = {xVal = 128*x, yVal = 100*y, image = state1, click = state2, bomb = false}
			
		end
	end
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
	
end

function love.mousepressed(x, y, button)
	if button == 'l' then
		mousex = x
		mousey = y
		ldown = true;
	end
end

function love.mousereleased(x, y, button)
	if button == 'l' then
		ldown = false
		mousexr = x
		mouseyr = y
	end
end

function love.draw()
	--love.graphics.setColor(255,255,255,255)
	--EH WHATEVER
	--love.graphics.rectangle("fill",128,100,20,10)
	--local image = love.graphics.newImage("/data/neutralState.png")
	--love.graphics.draw(image, 128, 100)

	for x=1, 5, 1 do
		for y=1, 5, 1 do
			
			--local test = love.graphics.newImage("/data/neutralState.png")
			--grid[x][y] = { xVal = 128*x, yVal = 100*y, image = test}
			local gr = grid[x][y]
			--love.graphics.draw(grid[x]["image"], grid[x][y]["xVal"], grid[x][y]["yVal"])
			if mousex ~= nil and mousey ~= nil and
			mousex >= gr.xVal and
			mousex <= gr.xVal + 50 and
			mousey >= gr.yVal and
			mousey <= gr.yVal + 50 and
			ldown == true then
				love.graphics.draw(gr.click, gr.xVal, gr.yVal)
			else		
				love.graphics.draw(gr.image, gr.xVal, gr.yVal)
			end
			if mousexr ~= nil and mouseyr ~= nil and
			mousexr >= gr.xVal and
			mousexr <= gr.xVal + 50 and
			mouseyr >= gr.yVal and
			mouseyr <= gr.yVal + 50 and
			ldown == false then
				if gr.bomb == true then
					gr.image = love.graphics.newImage("/data/bombState.png")
				else if gr.bomb == false then
					gr.image = love.graphics.newImage("/data/nobombState.png")
				end
			end
			
		end
	end
	
end

end
