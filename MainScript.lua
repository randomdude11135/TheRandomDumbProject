--// Wait Until game is loaded
repeat
	task.wait()
until game:IsLoaded() == true
print("Oh Em Ge")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
repeat task.wait(1) until LocalPlayer.Character ~= nil
local Character = LocalPlayer.Character or LocalPlayer.Character.CharacterAdded:Wait()

--// Synapse X Functions
local function IsBetterFile(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil
end

local function GetURL(scripturl)
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


local getasset = getsynasset or getcustomasset or function(location) return "rbxasset://".. location end
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

--// Main Varibles
local GuiLibrary = loadstring(GetURL("GuiLibrary.lua"))()


local checkpublicreponum = 0
local checkpublicrepo
local function checkpublicrepo(id)
    print("Getting module for game place id of" .. id )
	local suc, req = pcall(function()
		return requestfunc({
			Url = "https://raw.githubusercontent.com/randomdude11135/IClient/main/GameScripts/" .. id .. ".Lua",
			Method = "GET",
		})
	end)
	if not suc then
		checkpublicreponum = checkpublicreponum + 1
		task.spawn(function()
		end)
		task.wait(2)
		return checkpublicrepo(id)
	end
	if req.StatusCode == 200 then
		return req.Body
	end
	return nil
end

--// Check if script is supported
if not (getasset and requestfunc and queueteleport) then
	return
end

if shared.AlreadyExecuted then
	return
else
	shared.AlreadyExecuted = true
end

--// Create Folder
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
shared.IClientToggledProperty = {}
shared.GuiLibrary = GuiLibrary
shared.TabInGui = {}
shared.ButtonInGui = {}

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


LocalPlayer.OnTeleport:Connect(function(State)
	if State == Enum.TeleportState.Started then
		local teleportstr = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/randomdude11135/IClient/main/MainScript.lua", true))()'
        writefile(
			"IClient/Settings/"
				.. game.PlaceId
				.. "/"
				.. readfile("IClient/SettingsSelecting/" .. game.PlaceId .. ".txt")
				.. ".IClientSetting.txt",
			game:GetService("HttpService"):JSONEncode(shared.IClientToggledProperty)
		)
        queueteleport(teleportstr)
	end
end)

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


----// Non - Blantant Frame
local LiteFrame = LoadIClientUI.New({
	Title = "Non-Gaming chair",
})
shared.TabInGui["Non-Gaming chair"] = LiteFrame

----// Blantant Frame
local BlantantFrame = LoadIClientUI.New({
	Title = "Gaming Chair",
})
shared.TabInGui["Gaming chair"] = BlantantFrame

----// Cosmetics Frame
local CosmeticsFrame = LoadIClientUI.New({
	Title = "Cosmetics",
})
shared.TabInGui["Cosmetics"] = CosmeticsFrame

----// Animation Frame
local AnimationTab = LoadIClientUI.New({
	Title = "Animations",
})
shared.TabInGui["Animations"] = AnimationTab


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
loadstring(GetURL("GameScripts/Universal.Lua"))()
local publicrepo = checkpublicrepo(game.PlaceId)
if publicrepo then
	loadstring(publicrepo)()
end


--------------------------------------// Settings Tab
do
	local ProfileTable = {}
	local ProfileSetName = ""
	function refreshprofilelist()
		if listfiles then
			for i,v in pairs(listfiles("IClient/Settings/" .. game.PlaceId)) do

				local newstr = v:gsub("IClient/Settings/" .. game.PlaceId, ""):sub(2, v:len())
				local newstr2 = string.split(newstr,".")[1]
				if ProfileTable[newstr2] then
					ProfileTable[newstr2]:SetText("Load " .. newstr2 .. " Setting " .. (readfile("IClient/SettingsSelecting/" .. game.PlaceId..".txt") == newstr2 and "(Selected)" or ""))
				else
					ProfileTable[newstr2] = ProfileTab.Button({
						Text = "Load " .. newstr2 .. " Setting " .. (readfile("IClient/SettingsSelecting/" .. game.PlaceId..".txt") == newstr2 and "(Selected)" or ""),
						Callback = function(Value)

							--// Write Profile
							local success2, result2 = pcall(function()
								return game:GetService("HttpService"):JSONDecode(readfile("IClient/Settings/" .. game.PlaceId .. "/" .. newstr2 .. ".IClientSetting.txt"))
							end)


							if success2 and result2 then	
								warn("[IClient]: Loading " .. newstr2 .. " Settings")
								writefile("IClient/SettingsSelecting/" .. game.PlaceId..".txt",newstr2)

								refreshprofilelist()

								for x,z in pairs(shared.ButtonInGui) do
									pcall(function()
										z[1]:SetState(false)
									end)
									task.wait()
								end


								for list , newprop in pairs(result2) do
									shared.IClientToggledProperty[list] = newprop
								end


								wait(1)
								for x,z in pairs(shared.ButtonInGui) do
									pcall(function()
										z[1]:SetState(shared.IClientToggledProperty[z[2]])
									end)
								end
							end

						end,

						Menu = {
							["Delete Profile"] = function(self)

								if delfile then
									delfile("IClient/Settings/" .. game.PlaceId .. "/" ..  newstr2..".IClientSetting.txt")
									--ProfileTable[newstr2]:SetText("Load " .. newstr2 .. " Setting (Deleted)")
									ProfileTable[newstr2]:Remove()
								end		
							end
						}
					})
				end	
			end
		end

	end

	-----// Set Adding Profile Name
	local WiggleAnimationFrame = ProfileTab.TextField({
		Text = "Profile Name",
		Callback = function(Value)
			ProfileSetName = Value
		end,
	})

	----// Add Profile
	local WiggleAnimationFrame = ProfileTab.Button({
		Text = "Add Profile / Save Current Profile",
		Callback = function(Value)

			if ProfileSetName == "" then
				warn("[IClient]: Saving Current Profile")
				writefile("IClient/Settings/" .. game.PlaceId .. "/" .. readfile("IClient/SettingsSelecting/" .. game.PlaceId..".txt") ..".IClientSetting.txt", game:GetService("HttpService"):JSONEncode(shared.IClientToggledProperty))
			else		
				warn("[IClient]: Creating new profile")
				writefile("IClient/Settings/" .. game.PlaceId .. "/" ..  ProfileSetName..".IClientSetting.txt", game:GetService("HttpService"):JSONEncode(shared.IClientToggledProperty))
				writefile("IClient/SettingsSelecting/" .. game.PlaceId..".txt",ProfileSetName)
				ProfileSetName = ""		
				refreshprofilelist()
			end
		end,
	})

	refreshprofilelist()


end

--------------------------------------// Login Tab
local Logged = {}
local ChatTag = {}
local IsAlerted = false
local Found = false
local Loggined = false
local NextCheck = os.time()
local headers = {
	["content-type"] = "application/json"
}	
local WebRequest = {Url = "https://majestic-tidal-saguaro.glitch.me/GetPlayerUsingClient", Body = {}, Method = "GET", Headers = headers}

do

	local PasswordSet
	local LoginDebounce = os.time()
	-----// Set Adding Profile Name
	local WiggleAnimationFrame = LoginTab.TextField({
		Text = "Password",
		Callback = function(Value)
			PasswordSet = Value
		end,
	})

	----// Add Profile
	local WiggleAnimationFrame = LoginTab.Button({
		Text = "Login",
		Callback = function(Value)
			writefile("IClient/LoginSave.Txt", PasswordSet)
			if os.time() > LoginDebounce then
				warn("[IClient]:Setted your password")
				LoginDebounce = os.time() + 5
				PasswordSet = ""
				Loggined = false
				IsAlerted = false
				Found = false
				NextCheck = os.time()
			end
		end,
	})

	game:GetService("RunService").Heartbeat:Connect(function()

		WiggleAnimationFrame:SetText(os.time() > LoginDebounce and "Login" or "Login Again in " .. LoginDebounce - os.time() .. " seconds")

	end)
end

local oldchanneltab
local oldchannelfunc
local oldchanneltabs = {}

--// Chat Listener
for i,v in pairs(getconnections(ReplicatedStorage.DefaultChatSystemChatEvents.OnNewMessage.OnClientEvent)) do
	if v.Function and #debug.getupvalues(v.Function) > 0 and type(debug.getupvalues(v.Function)[1]) == "table" and getmetatable(debug.getupvalues(v.Function)[1]) and getmetatable(debug.getupvalues(v.Function)[1]).GetChannel then
		oldchanneltab = getmetatable(debug.getupvalues(v.Function)[1])
		oldchannelfunc = getmetatable(debug.getupvalues(v.Function)[1]).GetChannel
		getmetatable(debug.getupvalues(v.Function)[1]).GetChannel = function(Self, Name)
			local tab = oldchannelfunc(Self, Name)
			if tab and tab.AddMessageToChannel then
				local addmessage = tab.AddMessageToChannel
				if oldchanneltabs[tab] == nil then
					oldchanneltabs[tab] = tab.AddMessageToChannel
				end
				tab.AddMessageToChannel = function(Self2, MessageData)
					if MessageData.FromSpeaker and Players[MessageData.FromSpeaker] then
						if ChatTag[Players[MessageData.FromSpeaker].Name] then
							MessageData.ExtraData = {
								NameColor = Players[MessageData.FromSpeaker].Team == nil and Color3.new(0, 1, 1) or Players[MessageData.FromSpeaker].TeamColor.Color,
								Tags = {
									table.unpack(MessageData.ExtraData.Tags),
									{
										TagColor = ChatTag[Players[MessageData.FromSpeaker].Name].TagColor,
										TagText = ChatTag[Players[MessageData.FromSpeaker].Name].TagText
									}
								}
							}
						end
					end
					return addmessage(Self2, MessageData)
				end
			end
			return tab
		end
	end
end
--// Check Using Client
do
    
	game:GetService("RunService").Heartbeat:Connect(function()
		
		for i , v in pairs(game.Players:GetPlayers()) do
			
			if v.Character then
				if Logged[v.Name] then
					v.Character.Head.Nametag.TeamIndicator.Image = "rbxassetid://9432891155"
					v.Character.Head.Nametag.TeamIndicator.BackgroundTransparency = 1
				else
					v.Character.Head.Nametag.TeamIndicator.Image = ""
					v.Character.Head.Nametag.TeamIndicator.BackgroundTransparency = 0
				end
			end			
		end
	end)	
	
	
	game:GetService("RunService").Heartbeat:Connect(function()
		if NextCheck > os.time() then return end
		NextCheck = os.time() + (Loggined and 8 or 1)
		local RequestedInfo = requestfunc(WebRequest)
		local EncodedInfo = game:GetService("HttpService"):JSONDecode(RequestedInfo.Body)		

		for i , v in pairs(EncodedInfo) do

			if v.ChatTagInfo then
				if game.Players:FindFirstChild(v.UserHash)  then
					if  ChatTag[v.UserHash] == nil then
						local RealInfo = v.ChatTagInfo
						ChatTag[v.UserHash] = {TagText = tostring(RealInfo.TagName), TagColor = Color3.fromRGB(RealInfo.R, RealInfo.G, RealInfo.B)}
					end
				else
					ChatTag[v.UserHash] = nil
				end
			else
				if ChatTag[v.UserHash] then
				end
				ChatTag[v.UserHash] = nil
			end

			if v.UserHash ==  LocalPlayer.Name then
				if Loggined then
					Found = true			
				end
			else
				if not Logged[v.UserHash] and game.Players:FindFirstChild(v.UserHash) then
					Logged[v.UserHash] = true
					local playerlist = game:GetService("CoreGui"):FindFirstChild("PlayerList")
					if playerlist then
						pcall(function()
							local playerlistplayers = playerlist.PlayerListMaster.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame
							local targetedplr = playerlistplayers:FindFirstChild("p_"..game.Players:FindFirstChild(v.UserHash).UserId)
							if targetedplr then 
								targetedplr.ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerIcon.Image = "rbxassetid://9432891155"
								targetedplr.ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerIcon.ImageRectOffset = Vector2.new(0,0)
								targetedplr.ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerIcon.ImageRectSize = Vector2.new(0,0)
							end
						end)
					end
				end
			end
		end

		if not Found then
			if not Loggined then
				Loggined = true
				local PassWord = ""
				local success2, result2 = pcall(function()
					return readfile("IClient/LoginSave.Txt")
				end)
				if success2 and result2 then
					PassWord = result2
				end
				local WebBody =  game:GetService("HttpService"):JSONEncode({UserHash = LocalPlayer.Name,UserClientUsing = "IClient",LoginCode = PassWord})
				local WebSendInfo = {Url = "https://majestic-tidal-saguaro.glitch.me/SendUserInfo", Body = WebBody, Method = "POST", Headers = headers}
				local RequestedInfo = requestfunc(WebSendInfo)
			end

		else
			if not IsAlerted then
				if ChatTag[LocalPlayer.Name] then
				end
				IsAlerted = true
			end
		end
		task.wait()
	end)	
end

