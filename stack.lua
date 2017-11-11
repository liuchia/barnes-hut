local stack = {};

function stack:push(x)
	if x then
		self.size = self.size + 1;
		self[self.size] = x;
	end
end

function stack:pop()
	local value = self[self.size];
	self.size = self.size - 1;
	return value;
end

local new = function()
	return setmetatable(
		{
			size = 0;
		},
		{
			__index = function(t, i)
				return stack[i];
			end;
		}
	);
end

return {
	new = new;
}