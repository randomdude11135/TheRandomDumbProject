--// Wait Until game is loaded
repeat task.wait() until game:IsLoaded() == true

local betterisfile = function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end
