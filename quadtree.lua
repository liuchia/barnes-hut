local quadtree = {};

local function new(x, y, sx, sy, depth)
	return setmetatable(
		{
			nw = nil; sw = nil;
			ne = nil; se = nil;
			x = x; y = y;
			sx = sx; sy = sy;
			p = {};
			depth = depth or 0;
			totalmass = 0;
			totalcom = {0, 0};
			com = {x = 0; y = 0};
			bodycount = 0;
		}, {
		__index = function(t, i)
			return quadtree[i];
		end}
	)
end

function quadtree:draw()
	love.graphics.setColor(200, 100, 100);
	love.graphics.rectangle("line", self.x, self.y, self.sx, self.sy);
	--love.graphics.circle("fill", self.com.x, self.com.y, 2);
	if self.nw then
		self.nw:draw();
		self.sw:draw();
		self.ne:draw();
		self.se:draw();
	end
end

function quadtree:insert(body)
	table.insert(self.p, body);
	self.totalmass = self.totalmass + body.m;
	self.totalcom[1] = self.totalcom[1] + body.x;
	self.totalcom[2] = self.totalcom[2] + body.y;
	self.bodycount = self.bodycount + 1;
	self.com.x = self.totalcom[1]/self.bodycount;
	self.com.y = self.totalcom[2]/self.bodycount;
end

function quadtree:subdivide()
	--[[
	local dir = (y < self.y and "n" or "s")..(x < self.x and "w" or "e");
	if self[dir] then
		self[dir]:insert(body);
	else
		
	end
	]]
	if #self.p > 1 and self.depth < 16 then
		local hx = self.sx/2;
		local hy = self.sy/2;
		self.nw = new(self.x, self.y, hx, hy, self.depth+1);
		self.sw = new(self.x, self.y+hy, hx, hy, self.depth+1);
		self.ne = new(self.x+hx, self.y, hx, hy, self.depth+1);
		self.se = new(self.x+hx, self.y+hy, hx, hy, self.depth+1);

		for i = 1, #self.p do
			local body = self.p[i];
			local x, y = body.x, body.y;
			local dir = (y < self.y+hy and "n" or "s")..(x < self.x+hx and "w" or "e");
			self[dir]:insert(body);
		end

		self.nw:subdivide();
		self.sw:subdivide();
		self.ne:subdivide();
		self.se:subdivide();
	end
end

return {
	new = new;
}