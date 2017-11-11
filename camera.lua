local MIN_Z = 0.05;		--minimum zoom
local MAX_Z = 5;		--maximum zoom
local Z_SENS = 0.0025;	--sensitivity of scrolling

local camera = {};

function camera:push()
	love.graphics.push();
		love.graphics.scale(self.z, self.z);
		love.graphics.translate(self.x, self.y);
end

function camera:pop()
	love.graphics.pop();
end

-- centres camera on a coordinate
function camera:centre(x, y, w, h)
	self.x = w*0.5/self.z - x;
	self.y = h*0.5/self.z - y;
end

-- converts screen coordinate to actual coordinate
function camera:parse(x, y)
	return x/self.z - self.x, y/self.z - self.y;
end

function camera:add_zoom(dz)
	self.z = self.z + dz * Z_SENS;
	self.z = math.min(MAX_Z, math.max(MIN_Z, self.z));
end

local new = function()
	return setmetatable(
		{
			x = 0;	-- x coordinate of camera
			y = 0;	-- y coordinate of camera
			z = 1;	-- zoom level of camera
		},
		{
			__index = function(t, i)
				return camera[i];
			end;
		}
	)
end

return {
	new = new;
}