grid = {}
WIDTH = 256
HEIGHT = 200

SCALE = 3

function love.load()
	love.graphics.setMode(WIDTH*SCALE, HEIGHT*SCALE, false, false)
end

function love.update(dt)

end

function love.draw()
	love.graphics.setColor(255,255,255,255)
	
	--EH WHATEVER
	love.graphics.rectangle("fill",128,100,10,10)
end

