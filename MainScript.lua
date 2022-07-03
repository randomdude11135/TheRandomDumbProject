--// Wait Until game is loaded
repeat task.wait() until game:IsLoaded() == true

--// Synapse X Functions
local IsFileBetter = function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end

local function GetURL(scripturl)
	if shared.VapeDeveloper then
		if not betterisfile("vape/"..scripturl) then
			error("File not found : vape/"..scripturl)
		end
		return readfile("vape/"..scripturl)
	else
		local res = game:HttpGet("https://raw.githubusercontent.com/randomdude11135/IClient/main/"..scripturl, true)
		assert(res ~= "404: Not Found", "File not found")
		return res
	end
end


local getasset = getsynasset or getcustomasset or function(location) return "rbxasset://"..location end
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport or function() end
local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request or function(tab)
	if tab.Method == "GET" then
		return {
			Body = game:HttpGet(tab.Url, true),
			Headers = {},
			StatusCode = 200
		}
	else
		return {
			Body = "bad exploit",
			Headers = {},
			StatusCode = 404
		}
	end
end 

--// Check if script is supported
if not (getasset and requestfunc and queueteleport) then
	warn("[IClient]:IClient is not support with your executor haha")
	return
end

if shared.AlreadyExecuted then
	warn("[IClient]:IClient is already running.")
	return
else
	shared.AlreadyExecuted = true
end

--// Create Folder
warn("[IClient]: Checking / Creating Folder")
if isfolder("IClient") == false then
	makefolder("IClient")
end

if isfolder("IClient/Settings") == false then
	makefolder("IClient/Settings")
end

if isfolder("IClient/Settings/" .. game.PlaceId) == false then
	makefolder("IClient/Settings/" .. game.PlaceId)
end


if isfolder("IClient/SettingsSelecting") == false then
	makefolder("IClient/SettingsSelecting")
end

local success2, result2 = pcall(function()
	return readfile("IClient/SettingsSelecting/" .. game.PlaceId..".txt")
end)

if not success2 or not result2 then
	writefile("IClient/SettingsSelecting/" .. game.PlaceId..".txt", "MainSetting")
end


--// Main Varibles
local GuiLibrary = loadstring(GetURL("GuiLbrary.lua"))()


--// Set Shared Info
shared.GuiLibrary = GuiLibrary
shared.IClientToggledProperty = {}


