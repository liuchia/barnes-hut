local cos = math.cos;
local sin = math.sin;
local atan2 = math.atan2;

-- barnes hut
local Body = require("body");
local Stack = require("stack");
local Quadtree = require("quadtree");

local GRAV_CONSTANT = 1;
local BH_RATIO = 1;				-- larger value = more speed, lower = more accuracy
local DRAW_QUADS = false;

local bodies, walls = {}, {};
local width, height, world;
local quadtree = Quadtree.new(0, 0, width, height);

-- camera
local Camera = require("camera");
local camera = Camera.new();


local load = function(w, h)
	width, height = w, h;
	world = love.physics.newWorld(0, 0, true);
	Body.load(world);
	--[[Body.wall(width/2, -10, width, 20);
	Body.wall(-10, height/2, 20, height);
	Body.wall(width+10, height/2, 20, height);
	Body.wall(width/2, height+10, width, 20);]]

	table.insert(bodies, Body.new(w/2, h/2, 3000));
end

local draw = function()
	--centre camera on sun
	love.graphics.clear(240, 240, 220);
	camera:centre(bodies[1].x, bodies[1].y, width, height);
	camera:push();
		if #bodies > 0 and DRAW_QUADS then quadtree:draw(); end
		love.graphics.setColor(0, 0, 0);
		for i = 1, #bodies do
			local body = bodies[i];
			love.graphics.circle("fill", body.x, body.y, body.r);
			love.graphics.line(body.x, body.y, body.x - body.vx, body.y - body.vy); -- Drawing velocities
		end
	camera:pop();
end

local update = function(dt)
	local n = #bodies;
	if n > 0 then
		--calculate maximum boundaries of root quadtree
		local x1, x2, y1, y2 = bodies[1].x, bodies[1].x, bodies[1].y, bodies[1].y;
		for i = 2, n do
			local x, y = bodies[i].x, bodies[i].y;
			x1 = math.min(x1, x-1);
			x2 = math.max(x2, x+1);
			y1 = math.min(y1, y-1);
			y2 = math.max(y2, y+1);
		end

		--partition the bodies into a quadtree
		quadtree = Quadtree.new(x1, y1, x2 - x1, y2 - y1);
		for i = 1, n do
			quadtree:insert(bodies[i]);
		end
		quadtree:subdivide();

		--now that we have a quadtree structure, iterate through bodies
		for i = 1, n do
			local body = bodies[i];
			local ax = 0;
			local ay = 0;
			local quads = Stack.new();
			quads:push(quadtree);

			while quads.size > 0 do
				local quad = quads:pop();

				if quad.bodycount > 0 then
					local quadcom = quad.com;
					local dx = quadcom.x - body.x;
					local dy = quadcom.y - body.y;
					local dist = (dx*dx + dy*dy)^0.5;
					--[[if quad.sx/dist >= BH_RATIO or quad.bodycount == 1 or not quad.nw then
						if dist > 0 then
							local mass = quad.totalmass;
							local a = GRAV_CONSTANT*mass/(dist*dist);
							local angle = atan2(dy, dx);
							ax = ax + a * cos(angle);
							ay = ay + a * sin(angle);
						end]]
					if (quad.bodycount == 1 and quad.p[1] ~= body) or math.max(quad.sx, quad.sy)/dist <= BH_RATIO then
						local a = GRAV_CONSTANT*quad.totalmass/(dist*dist);
						local angle = atan2(dy, dx);
						ax = ax + a * cos(angle);
						ay = ay + a * sin(angle);
					else
						quads:push(quad.nw);
						quads:push(quad.ne);
						quads:push(quad.sw);
						quads:push(quad.se);
					end
				end
			end

			body.vx = body.vx + ax*dt;
			body.vy = body.vy + ay*dt;
			body.body:setLinearVelocity(body.vx, body.vy);
		end
	end

	world:update(dt);
end

local mousepressed = function(x, y, b)
	--time mouse pressed determines size of planet???
	local times = b == 1 and 1 or b == 2 and 25 or 0;
	for i = 1, times do
		local ox, oy = b == 1 and 0 or math.random(-50, 50), b == 1 and 0 or math.random(-50, 50);
		local rx, ry = camera:parse(x + ox, y + oy);
		local dx = rx - bodies[1].x;
		local dy = ry - bodies[1].y;
		local dist = (dx*dx + dy*dy)^0.5;
		local angle = atan2(dx, -dy);

		local orbital_velocity = math.sqrt(GRAV_CONSTANT * bodies[1].m / dist);

		local mass = math.random(16, 25);
		local new_body = Body.new(rx, ry, mass);
		new_body.vx = orbital_velocity * cos(angle);
		new_body.vy = orbital_velocity * sin(angle);
		table.insert(bodies, new_body);
	end
end

local wheelmoved = function(dx, dy)
	camera:add_zoom(dy);
end

return {
	load = load;
	draw = draw;
	update = update;
	mousepressed = mousepressed;
	wheelmoved = wheelmoved;
	bodycount = function() return #bodies end;
}

--[[
	todo :
	+ walls
	- barnes hut properties : com and total mass
		- incremental com addition
	- forces
	- pause
	- frame rate, other info
]]