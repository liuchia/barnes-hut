local Logic = require("logic");
local WIDTH, HEIGHT = 800, 600;
-- screenshotting
local SCREENSHOT = false;
local screenshot_id = 0;
local screenshot_count = 0;
-- frame rate counting
local fps, fps_count, fps_temp = 0, 0, 0;

love.load = function()
	math.randomseed(os.time());
	love.window.setMode(WIDTH, HEIGHT, {resizable = false});
	if SCREENSHOT then love.filesystem.setIdentity('BarnesHutScreenshots') end
	Logic.load(WIDTH, HEIGHT);
end

love.draw = function()
	Logic.draw();
	love.graphics.setColor(20, 20, 40);
	love.graphics.print("FPS:\t\t"..fps, 30, 30);
	love.graphics.print("Bodies:\t"..Logic.bodycount(), 30, 45);

	if SCREENSHOT then
		screenshot_count = screenshot_count + 1;
		if screenshot_count == 25 then
			screenshot_count = 0;
			screenshot_id = screenshot_id + 1;
			local screenshot = love.graphics.newScreenshot();
		    screenshot:encode('png', string.format("%05d", screenshot_id) .. '.png');
		end
	end
end

love.update = function(dt)
	Logic.update(1/60);
	--fps counter logic
	fps_temp = fps_temp + 1;
	fps_count = fps_count + dt;
	if fps_count > 1 then
		fps_count = 0;
		fps = fps_temp;
		fps_temp = 0;
	end
end

love.mousepressed = function(x, y, b)
	Logic.mousepressed(x, y, b);
end

love.wheelmoved = function(x, y)
	Logic.wheelmoved(x, y);
end