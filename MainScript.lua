--// Wait Until game is loaded
repeat
	task.wait()
until game:IsLoaded() == true

warn("[IClient]: Game Loaded")

--// Synapse X Functions
function IsFileBetter(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil
end

function GetURL(scripturl)
	if shared.IClientDev then
		if not betterisfile("IClient/" .. scripturl) then
			error("File not found : IClient/" .. scripturl)
		end
		return readfile("IClient/" .. scripturl)
	else
		local res = game:HttpGet("https://raw.githubusercontent.com/randomdude11135/IClient/main/" .. scripturl, true)
		assert(res ~= "404: Not Found", "File not found")
		return res
	end
end

--// Main Varibles
warn("[IClient]: Indexing GuiLibrary")
local GuiLibrary = loadstring(GetURL("GuiLbrary.lua"))()

local checkpublicreponum = 0
local checkpublicrepo
function checkpublicrepo(id)
	local suc, req = pcall(function()
		return requestfunc({
			Url = "https://raw.githubusercontent.com/randomdude11135/IClient/main/GameScripts/" .. id .. ".lua",
			Method = "GET",
		})
	end)
	if not suc then
		checkpublicreponum = checkpublicreponum + 1
		task.spawn(function()
            warn("[IClient]:Loading CustomModule Failed!, Attempts: " .. checkpublicreponum )
		end)
		task.wait(2)
		return checkpublicrepo(id)
	end
	if req.StatusCode == 200 then
		return req.Body
	end
	return nil
end

local getasset = getsynasset or getcustomasset or function(location)
	return "rbxasset://" .. location
end
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport or function() end

local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request or function(tab)
		if tab.Method == "GET" then
			return {
				Body = game:HttpGet(tab.Url, true),
				Headers = {},
				StatusCode = 200,
			}
		else
			return {
				Body = "bad exploit",
				Headers = {},
				StatusCode = 404,
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
	return readfile("IClient/SettingsSelecting/" .. game.PlaceId .. ".txt")
end)

if not success2 or not result2 then
	writefile("IClient/SettingsSelecting/" .. game.PlaceId .. ".txt", "MainSetting")
end

--// Set Shared Info
shared.GuiLibrary = GuiLibrary
shared.IClientToggledProperty = {}

warn("[IClient]: Loading Settngs")

--// Write Profile
local success2, result2 = pcall(function()
	return game:GetService("HttpService"):JSONDecode(
		readfile(
			"IClient/Settings/"
				.. game.PlaceId
				.. "/"
				.. readfile("IClient/SettingsSelecting/" .. game.PlaceId .. ".txt")
				.. ".IClientSetting.txt"
		)
	)
end)

if success2 and result2 then
	warn("[IClient]: Data Found! Rewriting the configuration")
	for i, v in pairs(result2) do
		shared.IClientToggledProperty[i] = v
	end
else
	warn("[IClient]: Data not found! Creating setting file")
	writefile(
		"IClient/Settings/"
			.. game.PlaceId
			.. "/"
			.. readfile("IClient/SettingsSelecting/" .. game.PlaceId .. ".txt")
			.. ".IClientSetting.txt",
		game:GetService("HttpService"):JSONEncode(shared.IClientToggledProperty)
	)
end

game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
	if State == Enum.TeleportState.Started then
		writefile(
			"IClient/Settings/"
				.. game.PlaceId
				.. "/"
				.. readfile("IClient/SettingsSelecting/" .. game.PlaceId .. ".txt")
				.. ".IClientSetting.txt",
			game:GetService("HttpService"):JSONEncode(shared.IClientToggledProperty)
		)
	end
end)

warn("[IClient]: Generating User Interface")
-------// Load UI
local LoadIClientUI = GuiLibrary.Load({
	Title = "IClient",
	Style = 3,
	SizeX = 500,
	SizeY = 350,
	Theme = "Dark",

	ColorOverrides = {
		MainFrame = Color3.fromRGB(0, 0, 0),
	},
})

local ButtonInGui = {}

----// Non - Blantant Frame
local LiteFrame = LoadIClientUI.New({
	Title = "Non-Gaming chair",
})

----// Blantant Frame
local BlantantFrame = LoadIClientUI.New({
	Title = "Gaming Chair",
})

----// Cosmetics Frame
local CosmeticsFrame = LoadIClientUI.New({
	Title = "Cosmetics",
})

----// Animation Frame
local AnimationTab = LoadIClientUI.New({
	Title = "Animations",
})

----// Profile Frame
local ProfileTab = LoadIClientUI.New({
	Title = "Load Settings",
})

----// Login Frame
local LoginTab = LoadIClientUI.New({
	Title = "Login",
})

warn("[IClient]: Successfully Generated Interface")
warn("[IClient]: Now loading universal place")
