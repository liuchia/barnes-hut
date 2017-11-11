local body = {};
local world;

local new = function(x, y, m, mode)
	-- use world to create a new box2d object
	local r = (m/math.pi)^0.5;
	local newbody = love.physics.newBody(world, x, y, "dynamic");
	local shape = love.physics.newCircleShape(r);
	return setmetatable({
		body = newbody;
		shape = shape;
		fix = love.physics.newFixture(newbody, shape);
		m = m; r = r;
		vx = 0; vy = 0;
	},{
	__index = function(t, i)
		if i == "x" then return t.body:getX() end
		if i == "y" then return t.body:getY() end
		return body[i];
	end})
end

--[[local wall = function(x, y, w, h)
	local body = love.physics.newBody(world, x, y, "static");
	local shape = love.physics.newRectangleShape(w, h);
	local fixture = love.physics.newFixture(body, shape);
	return {
		body = body;
		shape = shape;
		fixture = fixture;
	};
end]]

local load = function(w)
	world = w;
end

return {
	load = load;
	new = new;
	--wall = wall;
}