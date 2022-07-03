--// Main Varibles
warn("[IClient]: Running bedwar main Module")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local WORKSPACE = game:GetService("Workspace")
local PLAYERS = game:GetService("Players")
local HTTPSERVICE = game:GetService("HttpService")
local COLLECTION = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lplr = PLAYERS.LocalPlayer
local PlayerCharacter = lplr.Character or lplr.CharacterAdded:Wait()
local GamePlaceId = game.PlaceId
local mouse = lplr:GetMouse()
local cam = WORKSPACE.CurrentCamera

--// Folder
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESPFolder"	
ESPFolder.Parent = workspace

--// Bindable
local updateitem = Instance.new("BindableEvent")

--// Bedwar var
local bedwars = {} 
local bedwarsblocks = {}
local SavedAnimation = {}
local oldcloneroot
local blockraycast = RaycastParams.new()
blockraycast.FilterType = Enum.RaycastFilterType.Whitelist
local setc0
local oldchar
local CanBeChangeToggle = true
local CurrentAnimation = nil
local connectionstodisconnect = {}
local disabletpcheck = false
local anticheatfunnyyes = false
local savedc0 = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Viewmodel"):WaitForChild("RightHand"):WaitForChild("RightWrist").C0
local oldisnetworkowner = isnetworkowner
local networkownerfunc = isnetworkowner
local isnetworkowner = isnetworkowner or function() return true end
local printtable = printtable or print
local speedsettings = {
	factor = 5.37,  
	velocitydivfactor = 2.9,
	wsvalue = 22.5
}

local AnticheatBypassNumbers = {
	TPSpeed = 0.1,
	TPCombat = 0.3,
	TPLerp = 0.39,
	TPCheck = 15
}
--// Functions
local HeartbeatTable = {}
local RenderStepTable = {}
local SteppedTable = {}
local function isAlive(plr)
	local plr = plr or lplr
	if plr and plr.Character and ((plr.Character:FindFirstChild("Humanoid")) and (plr.Character:FindFirstChild("Humanoid").Health > 0) and (plr.Character:FindFirstChild("HumanoidRootPart")) and (plr.Character:FindFirstChild("Head"))) then
		return true
	end
end

local function isNotHoveringOverGui()
	local mousepos = UIS:GetMouseLocation() - Vector2.new(0, 36)
	for i,v in pairs(lplr.PlayerGui:GetGuiObjectsAtPosition(mousepos.X, mousepos.Y)) do 
		if v.Active then
			return false
		end
	end
	for i,v in pairs(game:GetService("CoreGui"):GetGuiObjectsAtPosition(mousepos.X, mousepos.Y)) do 
		if v.Active then
			return false
		end
	end
	return true
end

function PlayFunction()

	if  IClientToggleProperty.CurrentPickAnimationId <= 200 then
		CurrentAnimation = bedwars["GameAnimationUtil"].playAnimation(lplr.Character, IClientToggleProperty.CurrentPickAnimationId)

		if IClientToggleProperty.CurrentPickAnimationId == 34 then
			task.wait(1)
			CurrentAnimation:AdjustSpeed(0)
		elseif IClientToggleProperty.CurrentPickAnimationId == 42 then
			CurrentAnimation.Looped = true
		end
	else
		if not SavedAnimation[IClientToggleProperty.CurrentPickAnimationId] then
			local anim2 = Instance.new("Animation")
			anim2.Name = "Cower"
			anim2.AnimationId = "http://www.roblox.com/asset/?id=" .. IClientToggleProperty.CurrentPickAnimationId
			ContentProvider:PreloadAsync({anim2,"http://www.roblox.com/asset/?id=" .. IClientToggleProperty.CurrentPickAnimationId})

			SavedAnimation[IClientToggleProperty.CurrentPickAnimationId] = anim2
		end
		CurrentAnimation = lplr.Character.Humanoid:LoadAnimation(SavedAnimation[IClientToggleProperty.CurrentPickAnimationId])
		CurrentAnimation.Priority = Enum.AnimationPriority.Action
		task.wait()
		CurrentAnimation:Play()
		repeat wait() until CurrentAnimation.Length > 0
		if IClientToggleProperty.CurrentPickAnimationId == 3338010159 then
			CurrentAnimation:AdjustSpeed(5)
			task.wait(0.25)
			CurrentAnimation:AdjustSpeed(0)
		end
	end
end

local function addvectortocframe(cframe, vec)
	local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cframe:GetComponents()
	return CFrame.new(x + vec.X, y + vec.Y, z + vec.Z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
end

local function IsToggleAble(Value,Gateway)
	return Value
end

local function addvectortocframe2(cframe, newylevel)
	local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = cframe:GetComponents()
	return CFrame.new(x, newylevel, z, R00, R01, R02, R10, R11, R12, R20, R21, R22)
end

local function BindToHeartbeat(name, func)
	if HeartbeatTable[name] == nil then
		HeartbeatTable[name] = game:GetService("RunService").Heartbeat:connect(func)
	end
end

local function aimpos(vec, multiplier)
	local newvec = (vec - UIS:GetMouseLocation() - Vector2.new(0, 36)) * tonumber(multiplier)
	mousemoverel(newvec.X, newvec.Y)
end


local function UnbindFromHeartbeat(name)
	if HeartbeatTable[name] then
		HeartbeatTable[name]:Disconnect()
		HeartbeatTable[name] = nil
	end
end

local function BindToRenderStep(name, func)
	if RenderStepTable[name] == nil then
		RenderStepTable[name] = game:GetService("RunService").RenderStepped:connect(func)
	end
end

local function UnbindFromRenderStep(name)
	if RenderStepTable[name] then
		RenderStepTable[name]:Disconnect()
		RenderStepTable[name] = nil
	end
end

local function BindToStepped(name, func)
	if SteppedTable[name] == nil then
		SteppedTable[name] = game:GetService("RunService").Stepped:connect(func)
	end
end

local function UnbindFromStepped(name)
	if SteppedTable[name] then
		SteppedTable[name]:Disconnect()
		SteppedTable[name] = nil
	end
end

local function skipFrame() 
	return game:GetService("RunService").Heartbeat:Wait()
end

local function betterfind(tab, obj)
	for i,v in pairs(tab) do
		if v == obj then
			return i
		end
	end
	return nil
end

local function canBeTargeted(plr, doTeamCheck) 
	if plr and plr.Team then
		return not (plr.Team.Name == lplr.Team.Name)
	end
end

local function getColorFromPlayer(v) 
	if v.Team ~= nil then return v.TeamColor.Color end
end

local function getremote(t)
	for i,v in next, t do 
		if v == "Client" then 
			return t[i+1]
		end
	end
end

local function getPlrNear(max)
	local returning, nearestnum = nil,max
	for i,v in next, PLAYERS:GetPlayers() do 
		if isAlive(v) and v~=lplr then 
			local diff = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
			if diff < nearestnum then 
				nearestnum = diff 
				nearestval = v
			end
		end
	end
	return returning
end

local function getPlrNearMouse(max)
	local max = max or 99999999999999
	local nearestval, nearestnum = nil,max
	for i,v in next, PLAYERS:GetPlayers() do 
		if isAlive(v) and v~=lplr then 
			local pos, vis = WORKSPACE.CurrentCamera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
			if vis and pos then 
				local diff = (UIS:GetMouseLocation() - Vector2.new(pos.X, pos.Y)).Magnitude
				if diff < nearestnum then 
					nearestnum = diff 
					nearestval = v
				end
			end
		end
	end
	return nearestval
end

local function getAllPlrsNear(max)
	if not isAlive() then return {} end
	local t = {}
	for i,v in next, PLAYERS:GetPlayers() do 
		if isAlive(v) and v~=lplr then 
			if v.Character.HumanoidRootPart and (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude <= max then 
				table.insert(t, v)
			end
		end
	end
	return t
end

local function getMoveDirection(plr) 
	if not isAlive(plr) then return Vector3.new() end
	local velocity = plr.Character.HumanoidRootPart:GetVelocityAtPosition(plr.Character.HumanoidRootPart.Position)
	local velocityDirection = velocity.Magnitude > 0 and velocity.Unit or Vector3.new()
	return velocityDirection
end

local function getwool()
	for i5, v5 in pairs(bedwars["getInventory"](lplr)["items"]) do
		if v5.itemType:match("wool") then
			return v5.itemType, v5.amount
		end
	end	
	return nil
end

local function getwoolamt()
	for i5, v5 in pairs(bedwars["getInventory"](lplr)["items"]) do
		if v5.itemType:match("wool") then
			return v5.amount
		end
	end	
	return 0
end

local function getblockitem() 
	for i5, v5 in pairs(bedwars.getInventory(lplr).items) do
		if v5.itemType:match("wool") or v5.itemType:match("grass") or v5.itemType:match("stone_brick") or v5.itemType:match("wood_plank") or v5.itemType:match("stone") or v5.itemType:match("bedrock") then
			return v5.itemType, v5.amount
		end
	end	
	return nil
end

local function getItem(itemName)
	for i5, v5 in pairs(bedwars["getInventory"](lplr)["items"]) do
		if v5.itemType == itemName then
			return v5, i5
		end
	end
	return nil
end

local function getItemAmt(itemName)
	for i5, v5 in pairs(bedwars["getInventory"](lplr)["items"]) do
		if v5.itemType == itemName then
			return v5.amount
		end
	end
	return 0
end

local function getEquipped()
	local typetext = ""
	local obj = bedwars["getInventory"](lplr).hand
	if obj then
		if bedwars["ItemTable"][obj.itemType]["sword"] then
			typetext = "sword"
		end
		if obj.itemType:find("wool") or bedwars["ItemTable"][obj.itemType]["block"] then
			typetext = "block"
		end
		if obj.itemType:find("bow") then
			typetext = "bow"
		end
	end
	return {["Object"] = obj and obj.tool, ["Type"] = typetext}
end

local function hashvector(vec)
	return {
		value = vec
	}
end

local function targetCheck(plr)
	return plr and plr.Humanoid and plr.Humanoid.Health > 0 and plr.Character:FindFirstChild("ForceField") == nil
end


local function GetNearestHumanoidToPosition(player, distance, overridepos)
	local closest, returnedplayer = distance, nil
	if lplr.isAlive then
		for i, v in pairs(lplr.entityList) do
			if v.Targetable and targetCheck(v) then
				local mag = (lplr.character.HumanoidRootPart.Position - v.RootPart.Position).magnitude
				if overridepos and mag > distance then 
					mag = (overridepos - v.RootPart.Position).magnitude
				end
				if mag <= closest then
					closest = mag
					returnedplayer = v
				end
			end
		end
	end
	return returnedplayer
end

--// Framework
warn("[IClient]: Getting Framework")
local Flamework = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@flamework"].core.out).Flamework
repeat task.wait() until Flamework.isInitialized
local KnitClient = debug.getupvalue(require(lplr.PlayerScripts.TS.controllers.game["block-break-controller"]).BlockBreakController.onEnable, 1)
local Client = require(game:GetService("ReplicatedStorage").TS.remotes).default.Client
local InventoryUtil = require(game:GetService("ReplicatedStorage").TS.inventory["inventory-util"]).InventoryUtil
local OldClientGet = getmetatable(Client).Get
local OldClientWaitFor = getmetatable(Client).WaitFor
getmetatable(Client).Get = function(Self, remotename)
	if remotename == bedwars["AttackRemote"] then
		local res = OldClientGet(Self, remotename)
		return {
			["instance"] = res["instance"],
			["CallServer"] = function(Self, tab)
				local suc, plr = pcall(function() return PLAYERS:GetPlayerFromCharacter(tab.entityInstance) end)
				if suc and plr then
					if plr and (bedwars["CheckWhitelisted"](plr) and bedwars["CheckWhitelisted"](lplr) == nil) then
						return nil
					end
				end
				return res:CallServer(tab)
			end
		}
	end
	return OldClientGet(Self, remotename)
end

bedwars = {
	["CheckWhitelisted"] = function(plr, ownercheck)
		local plrstr = bedwars["HashFunction"](plr.Name..plr.UserId)
		local localstr = bedwars["HashFunction"](lplr.Name..lplr.UserId)
		return false
	end,
	["CheckPlayerType"] = function(plr)
		local plrstr = bedwars["HashFunction"](plr.Name..plr.UserId)
		local playertype = "DEFAULT"
		return playertype
	end,
	["HashFunction"] = function(str)
		return  nil
	end,
	["IsPrivateIngame"] = function()
		for i,v in pairs(PLAYERS:GetChildren()) do 
			if bedwars["CheckPlayerType"](v) ~= "DEFAULT" then 
				return true
			end
		end
		return false
	end,

	["AnimationUtil"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out["shared"].util["animation-util"]).AnimationUtil,
	["AngelUtil"] = require(game:GetService("ReplicatedStorage").TS.games.bedwars.kit.kits.angel["angel-kit"]),
	["AppController"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out.client.controllers["app-controller"]).AppController,
	["BalloonController"] = KnitClient.Controllers.BalloonController,
	["BlockController"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out).BlockEngine,
	["BlockController2"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.client.placement["block-placer"]).BlockPlacer,
	["BlockTryController"] = getrenv()._G[game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.client.placement["block-placer"]],
	["BlockEngine"] = require(lplr.PlayerScripts.TS.lib["block-engine"]["client-block-engine"]).ClientBlockEngine,
	["BlockEngineClientEvents"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.client["block-engine-client-events"]).BlockEngineClientEvents,
	["BlockPlacementController"] = KnitClient.Controllers.BlockPlacementController,
	["BedwarsKits"] = require(game:GetService("ReplicatedStorage").TS.games.bedwars.kit["bedwars-kit-shop"]).BedwarsKitShop,
	["BlockBreaker"] = KnitClient.Controllers.BlockBreakController.blockBreaker,
	["ProjectileController"] = KnitClient.Controllers.ProjectileController,
	["ChestController"] = KnitClient.Controllers.ChestController,
	["ClickHold"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out.client.ui.lib.util["click-hold"]).ClickHold,
	["ClientHandler"] = Client,
	["ClientHandlerDamageBlock"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.remotes).BlockEngineRemotes.Client,
	["ClientStoreHandler"] = require(game.Players.LocalPlayer.PlayerScripts.TS.ui.store).ClientStore,
	["ClientHandlerSyncEvents"] = require(lplr.PlayerScripts.TS["client-sync-events"]).ClientSyncEvents,
	["CombatConstant"] = require(game:GetService("ReplicatedStorage").TS.combat["combat-constant"]).CombatConstant,
	["CombatController"] = KnitClient.Controllers.CombatController,
	["ConsumeSoulRemote"] = getremote(debug.getconstants(KnitClient.Controllers.GrimReaperController.consumeSoul)),
	["ConstantManager"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out["shared"].constant["constant-manager"]).ConstantManager,
	["CooldownController"] = KnitClient.Controllers.CooldownController,
	["damageTable"] = KnitClient.Controllers.DamageController,
	["DetonateRavenRemote"] = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.RavenController).detonateRaven)),
	["DropItem"] = getmetatable(KnitClient.Controllers.ItemDropController).dropItemInHand,
	["DropItemRemote"] = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.ItemDropController).dropItemInHand)),
	["EatRemote"] = getremote(debug.getconstants(debug.getproto(getmetatable(KnitClient.Controllers.ConsumeController).onEnable, 1))),
	["EquipItemRemote"] = getremote(debug.getconstants(debug.getprotos(shared.oldequipitem or require(game:GetService("ReplicatedStorage").TS.entity.entities["inventory-entity"]).InventoryEntity.equipItem)[3])),
	["FishermanTable"] = KnitClient.Controllers.FishermanController,
	["GameAnimationUtil"] = require(game:GetService("ReplicatedStorage").TS.animation["animation-util"]).GameAnimationUtil,
	["GamePlayerUtil"] = require(game:GetService("ReplicatedStorage").TS.player["player-util"]).GamePlayerUtil,
	["getEntityTable"] = require(game:GetService("ReplicatedStorage").TS.entity["entity-util"]).EntityUtil,
	["getIcon"] = function(item, showinv)
		local itemmeta = bedwars["getItemMetadata"](item.itemType)
		if itemmeta and showinv then
			return itemmeta.image
		end
		return ""
	end,
	["getInventory"] = function(plr)
		local plr = plr or lplr
		local suc, result = pcall(function() return InventoryUtil.getInventory(plr) end)
		return (suc and result or {
			["items"] = {},
			["armor"] = {},
			["hand"] = nil
		})
	end,
	["getItemMetadata"] = require(game:GetService("ReplicatedStorage").TS.item["item-meta"]).getItemMeta,
	["GrimReaperController"] = KnitClient.Controllers.GrimReaperController,
	["GuitarHealRemote"] = getremote(debug.getconstants(KnitClient.Controllers.GuitarController.performHeal)),
	["HighlightController"] = KnitClient.Controllers.EntityHighlightController,
	["ItemTable"] = debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.item["item-meta"]).getItemMeta, 1),
	["JuggernautRemote"] = getremote(debug.getconstants(debug.getprotos(debug.getprotos(KnitClient.Controllers.JuggernautController.KnitStart)[1])[4])),
	["KatanaController"] = KnitClient.Controllers.DaoController,
	["KatanaRemote"] = getremote(debug.getconstants(debug.getproto(KnitClient.Controllers.DaoController.onEnable, 4))),
	["KnockbackTable"] = debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil.calculateKnockbackVelocity, 1),
	["KnockbackTable2"] = require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil,
	["LobbyClientEvents"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"].lobby.out.client.events).LobbyClientEvents,
	["MissileController"] = KnitClient.Controllers.GuidedProjectileController,
	["MinerRemote"] = getremote(debug.getconstants(debug.getprotos(debug.getproto(getmetatable(KnitClient.Controllers.MinerController).onKitEnabled, 1))[2])),
	["MinerController"] = KnitClient.Controllers.MinerController,
	["PickupRemote"] = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.ItemDropController).checkForPickup)),
	["PlayerUtil"] = require(game:GetService("ReplicatedStorage").TS.player["player-util"]).GamePlayerUtil,
	["ProjectileMeta"] = require(game:GetService("ReplicatedStorage").TS.projectile["projectile-meta"]).ProjectileMeta,
	["QueueMeta"] = require(game:GetService("ReplicatedStorage").TS.game["queue-meta"]).QueueMeta,
	["QueryUtil"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out).GameQueryUtil,
	["prepareHashing"] = require(game:GetService("ReplicatedStorage").TS["remote-hash"]["remote-hash-util"]).RemoteHashUtil.prepareHashVector3,
	["ProjectileRemote"] = getremote(debug.getconstants(debug.getupvalues(getmetatable(KnitClient.Controllers.ProjectileController)["launchProjectileWithValues"])[2])),
	["RavenTable"] = KnitClient.Controllers.RavenController,
	["RespawnController"] = KnitClient.Controllers.BedwarsRespawnController,
	["RespawnTimer"] = require(lplr.PlayerScripts.TS.controllers.games.bedwars.respawn.ui["respawn-timer"]).RespawnTimerWrapper,
	["ResetRemote"] = getremote(debug.getconstants(debug.getproto(KnitClient.Controllers.ResetController.createBindable, 1))),
	["Roact"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["roact"].src),
	["RuntimeLib"] = require(game:GetService("ReplicatedStorage")["rbxts_include"].RuntimeLib),
	["Shop"] = require(game:GetService("ReplicatedStorage").TS.games.bedwars.shop["bedwars-shop"]).BedwarsShop,
	["TeamUpgrades"] = require(game:GetService("ReplicatedStorage").TS.games.bedwars.shop["bedwars-shop"]).BedwarsShop.TeamUpgrades,
	["ShopItems"] = debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.games.bedwars.shop["bedwars-shop"]).BedwarsShop.getShopItem, 2),
	["ShopRight"] = require(lplr.PlayerScripts.TS.controllers.games.bedwars.shop.ui["item-shop"]["shop-left"]["shop-left"]).BedwarsItemShopLeft,
	["SpawnRavenRemote"] = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.RavenController).spawnRaven)),
	["SoundManager"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out).SoundManager,
	["SoundList"] = require(game:GetService("ReplicatedStorage").TS.sound["game-sound"]).GameSound,
	["sprintTable"] = KnitClient.Controllers.SprintController,
	["StopwatchController"] = KnitClient.Controllers.StopwatchController,
	["SwingSword"] = getmetatable(KnitClient.Controllers.SwordController).swingSwordAtMouse,
	["SwingSwordRegion"] = getmetatable(KnitClient.Controllers.SwordController).swingSwordInRegion,
	["SwordController"] = KnitClient.Controllers.SwordController,
	["TreeRemote"] = getremote(debug.getconstants(debug.getprotos(debug.getprotos(KnitClient.Controllers.BigmanController.KnitStart)[2])[1])),
	["TrinityRemote"] = getremote(debug.getconstants(debug.getproto(getmetatable(KnitClient.Controllers.AngelController).onKitEnabled, 1))),
	["VictoryScreen"] = require(lplr.PlayerScripts.TS.controllers["game"].match.ui["victory-section"]).VictorySection,
	["ViewmodelController"] = KnitClient.Controllers.ViewmodelController,
	["WeldTable"] = require(game:GetService("ReplicatedStorage").TS.util["weld-util"]).WeldUtil,
	["AttackRemote"] = getremote(debug.getconstants(getmetatable(KnitClient.Controllers.SwordController)["attackEntity"])),
	["VelocityUtil"]  = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out["shared"].util["velocity-util"]).VelocityUtil, 
	["ItemMeta"] = debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.item["item-meta"]).getItemMeta, 1),
	["PlayerVacuumRemote"] = getremote(debug.getconstants(debug.getproto(KnitClient.Controllers.PlayerVacuumController.onEnable, 4))),
	["PingController"] = require(lplr.PlayerScripts.TS.controllers.game.ping["ping-controller"]).PingController,
	["RaiseShieldRemote"] = getremote(debug.getconstants(KnitClient.Controllers.InfernalShieldController.constructor)),
}


local clientstorestate = bedwars["ClientStoreHandler"]:getState()
matchState = clientstorestate.Game.matchState or 0
kit = clientstorestate.Bedwars.kit or ""
queueType = clientstorestate.Game.queueType or "bedwars_test"

--// Framework functions
local function getblock(pos)
	return bedwars["BlockController"]:getStore():getBlockAt(bedwars["BlockController"]:getBlockPosition(pos)), bedwars["BlockController"]:getBlockPosition(pos)
end

do
	local inputobj = nil
	local tempconnection
	tempconnection = UIS.InputBegan:connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			inputobj = input
			tempconnection:Disconnect()
		end
	end)
	connectionstodisconnect[#connectionstodisconnect + 1] = updateitem.Event:connect(function(inputObj)
		if UIS:IsMouseButtonPressed(0) then
			game:GetService("ContextActionService"):CallFunction("block-break", Enum.UserInputState.Begin, inputobj)
		end
	end)
end

for i,v in pairs(debug.getupvalues(getmetatable(KnitClient.Controllers.SwordController)["attackEntity"])) do
	if tostring(v) == "AC" then
		bedwars["AttackHashTable"] = v
		for i2,v2 in pairs(v) do
			if i2:find("constructor") == nil and i2:find("__index") == nil and i2:find("new") == nil then
				bedwars["AttackHashFunction"] = v2
				bedwars["AttachHashText"] = i2
			end
		end
	end
end

local blocktable = bedwars["BlockController2"].new(bedwars["BlockEngine"], getwool())

bedwars["placeBlock"] = function(newpos, customblock)
	local placeblocktype = (customblock or getwool())
	blocktable.blockType = placeblocktype
	if bedwars["BlockController"]:isAllowedPlacement(lplr, placeblocktype, Vector3.new(newpos.X/3, newpos.Y/3, newpos.Z/3)) and getItem(placeblocktype) then
		return blocktable:placeBlock(Vector3.new(newpos.X/3, newpos.Y/3, newpos.Z/3))
	end
end

local function getHotbarSlot(itemName)
	for i5, v5 in pairs(bedwars["ClientStoreHandler"]:getState().Inventory.observedInventory.hotbar) do
		if v5["item"] and v5["item"].itemType == itemName then
			return i5 - 1
		end
	end
	return nil
end

local function switchItem(tool, legit)
	if legit then
		bedwars["ClientStoreHandler"]:dispatch({
			type = "InventorySelectHotbarSlot", 
			slot = getHotbarSlot(tool.Name)
		})
	end
	pcall(function()
		lplr.Character.HandInvItem.Value = tool
	end)
	bedwars["ClientHandler"]:Get(bedwars["EquipItemRemote"]):CallServerAsync({
		hand = tool
	})
end

local function getBestTool(block)
	local tool = nil
	local toolnum = 0
	local blockmeta = bedwars["getItemMetadata"](block)
	local blockType = ""
	if blockmeta["block"] and blockmeta["block"]["breakType"] then
		blockType = blockmeta["block"]["breakType"]
	end
	for i,v in pairs(bedwars["getInventory"](lplr)["items"]) do
		local meta = bedwars["getItemMetadata"](v.itemType)
		if meta["breakBlock"] and meta["breakBlock"][blockType] then
			tool = v
			break
		end
	end
	return tool
end


local oldpos = Vector3.zero
local oldpos2 = Vector3.zero

local function getScaffold(vec, diagonaltoggle)
	local realvec = Vector3.new(math.floor((vec.X / 3) + 0.5) * 3, math.floor((vec.Y / 3) + 0.5) * 3, math.floor((vec.Z / 3) + 0.5) * 3) 
	local newpos = (oldpos - realvec)
	local returedpos = realvec
	if lplr.isAlive then
		local angle = math.deg(math.atan2(-lplr.character.Humanoid.MoveDirection.X, -lplr.character.Humanoid.MoveDirection.Z))
		local goingdiagonal = (angle >= 130 and angle <= 150) or (angle <= -35 and angle >= -50) or (angle >= 35 and angle <= 50) or (angle <= -130 and angle >= -150)
		if goingdiagonal and ((newpos.X == 0 and newpos.Z ~= 0) or (newpos.X ~= 0 and newpos.Z == 0)) and diagonaltoggle then
			return oldpos
		end
	end
	return realvec
end

local function switchToAndUseTool(block, legit)
	local tool = getBestTool(block.Name)
	if tool and (isAlive() and lplr.Character:FindFirstChild("HandInvItem") and lplr.Character.HandInvItem.Value ~= tool["tool"]) then
		if legit then
			if getHotbarSlot(tool.itemType) then
				bedwars["ClientStoreHandler"]:dispatch({
					type = "InventorySelectHotbarSlot", 
					slot = getHotbarSlot(tool.itemType)
				})
				task.wait(0.1)
				updateitem:Fire(inputobj)
				return true
			else
				return false
			end
		end
		switchItem(tool["tool"])
		task.wait(0.1)
	end
end

local function getBeds() 
	local t = {}
	for i,v in next, WORKSPACE:WaitForChild("Map"):WaitForChild("Blocks"):GetChildren() do 
		if v.Name == "bed" then
			t[#t+1] = v
		end
	end
	return t
end

local function getotherbed(pos)
	local normalsides = {"Top", "Left", "Right", "Front", "Back"}
	for i,v in pairs(normalsides) do
		local bedobj = getblock(pos + (Vector3.FromNormalId(Enum.NormalId[v]) * 3))
		if bedobj and bedobj.Name == "bed" then
			return (pos + (Vector3.FromNormalId(Enum.NormalId[v]) * 3))
		end
	end
	return nil
end

local function isBlockCovered(pos)
	local normalsides = {"Top", "Left", "Right", "Front", "Back"}
	local coveredsides = 0
	for i, v in pairs(normalsides) do
		local blockpos = (pos + (Vector3.FromNormalId(Enum.NormalId[v]) * 3))
		local block = getblock(blockpos)
		if block then
			coveredsides = coveredsides + 1
		end
	end
	return coveredsides == #normalsides
end

local function getallblocks(pos, normal)
	local blocks = {}
	local lastfound = nil
	for i = 1, 20 do
		local blockpos = (pos + (Vector3.FromNormalId(normal) * (i * 3)))
		local extrablock = getblock(blockpos)
		local covered = isBlockCovered(blockpos)
		if extrablock and extrablock.Parent ~= nil and (covered or covered == false and lastblock == nil) then
			if bedwars["BlockController"]:isBlockBreakable({["blockPosition"] = blockpos}, lplr) then
				table.insert(blocks, extrablock.Name)
			else
				table.insert(blocks, "unbreakable")
				break
			end
			lastfound = extrablock
			if covered == false then
				break
			end
		else
			break
		end
	end
	return blocks
end

local function getlastblock(pos, normal)
	local lastfound = nil
	for i = 1, 20 do
		local blockpos = (pos + (Vector3.FromNormalId(normal) * (i * 3)))
		local extrablock = getblock(blockpos)
		local covered = isBlockCovered(blockpos)
		if extrablock and extrablock.Parent ~= nil and (covered or covered == false and lastblock == nil) then
			lastfound = extrablock
			if covered == false then
				break
			end
		else
			break
		end
	end
	return lastfound
end

local function getbestside(pos)
	local softest = 1000000
	local softestside = Enum.NormalId.Top
	local normalsides = {"Top", "Left", "Right", "Front", "Back"}
	for i,v in pairs(normalsides) do
		local sidehardness = 0
		for i2,v2 in pairs(getallblocks(pos, v)) do	
			sidehardness = sidehardness + (((v2 == "unbreakable" or v2 == "bed") and 99999999 or bedwars["ItemTable"][v2]["block"] and bedwars["ItemTable"][v2]["block"]["health"]) or 10)
			if bedwars["ItemTable"][v2]["block"] and v2 ~= "unbreakable" and v2 ~= "bed" and v2 ~= "ceramic" then
				local tool = getBestTool(v2)
				if tool then
					sidehardness = sidehardness - bedwars["ItemTable"][tool.itemType]["breakBlock"][bedwars["ItemTable"][v2]["block"]["breakType"]]
				end
			end
		end
		if sidehardness <= softest then
			softest = sidehardness
			softestside = v
		end
	end
	return softestside, softest
end

local healthbarblocktable = {
	["blockHealth"] = -1,
	["breakingBlockPosition"] = Vector3.new(0, 0, 0)
}

bedwars["breakBlock"] = function(pos, effects, normal, bypass)
	if lplr:GetAttribute("DenyBlockBreak") == true then
		return nil
	end
	local block = ((bypass == nil and getlastblock(pos, Enum.NormalId[normal])) or getblock(pos))
	local notmainblock = not ((bypass == nil and getlastblock(pos, Enum.NormalId[normal])))
	if block and bedwars["BlockController"]:isBlockBreakable({blockPosition = bedwars["BlockController"]:getBlockPosition((notmainblock and pos or block.Position))}, lplr) then
		if bedwars["BlockEngineClientEvents"].DamageBlock:fire(block.Name, bedwars["BlockController"]:getBlockPosition((notmainblock and pos or block.Position)), block):isCancelled() then
			return nil
		end
		local olditem = nil
		pcall(function()
			olditem = lplr.Character.HandInvItem.Value
		end)
		local blockhealthbarpos = {blockPosition = Vector3.new(0, 0, 0)}
		local blockdmg = 0
		if block and block.Parent ~= nil then
			switchToAndUseTool(block)
			blockhealthbarpos = {
				blockPosition = bedwars["BlockController"]:getBlockPosition((notmainblock and pos or block.Position))
			}
			if healthbarblocktable.blockHealth == -1 or blockhealthbarpos.blockPosition ~= healthbarblocktable.breakingBlockPosition then
				local blockdata = bedwars["BlockController"]:getStore():getBlockData(blockhealthbarpos.blockPosition)
				if not blockdata then
					return nil
				end
				local blockhealth = blockdata:GetAttribute(lplr.Name .. "_Health")
				if blockhealth == nil then
					blockhealth = block:GetAttribute("Health");
				end
				healthbarblocktable.blockHealth = blockhealth
				healthbarblocktable.breakingBlockPosition = blockhealthbarpos.blockPosition
			end
			blockdmg = bedwars["BlockController"]:calculateBlockDamage(lplr, blockhealthbarpos)
			healthbarblocktable.blockHealth = healthbarblocktable.blockHealth - blockdmg
			if healthbarblocktable.blockHealth < 0 then
				healthbarblocktable.blockHealth = 0
			end
			bedwars["ClientHandlerDamageBlock"]:Get("DamageBlock"):CallServerAsync({
				blockRef = blockhealthbarpos, 
				hitPosition = (notmainblock and pos or block.Position), 
				hitNormal = Vector3.FromNormalId(Enum.NormalId[normal])
			}):andThen(function(p9)
				if p9 == "failed" then
					healthbarblocktable.blockHealth = healthbarblocktable.blockHealth + blockdmg
				end
			end)
			if effects then
				bedwars["BlockBreaker"]:updateHealthbar(blockhealthbarpos, healthbarblocktable.blockHealth, block:GetAttribute("MaxHealth"), blockdmg)
				if healthbarblocktable.blockHealth <= 0 then
					bedwars["BlockBreaker"].breakEffect:playBreak(block.Name, blockhealthbarpos.blockPosition, lplr)
					bedwars["BlockBreaker"].healthbarMaid:DoCleaning()
				else
					bedwars["BlockBreaker"].breakEffect:playHit(block.Name, blockhealthbarpos.blockPosition, lplr)
				end
			end
		end
	end
end

local function isPointInMapOccupied(p)
	local region = Region3.new(p - Vector3.new(1, 1, 1), p + Vector3.new(1, 1, 1))
	local x = workspace:FindPartsInRegion3WithWhiteList(region, game:GetService("CollectionService"):GetTagged("block"))
	return (#x == 0)
end

local function get3Vector(p) 
	local x,y,z = p.X, p.Y,p.Z 
	x = math.floor((x) + 0.5)
	y = math.floor((y) + 0.5)
	z = math.floor((z) + 0.5)
	return Vector3.new(x,y,z)
end

local function getBestSword()
	local data, slot, bestdmg
	local items = bedwars.getInventory().items
	for i, v in next, items do
		if v.itemType:lower():find("sword") or v.itemType:lower():find("blade") then
			if bestdmg == nil or bedwars.ItemTable[v.itemType].sword.damage > bestdmg then
				data = v
				bestdmg = bedwars.ItemTable[v.itemType].sword.damage
				slot = i
			end
		end
	end
	return data, slot
end

local function state() 
	return bedwars["ClientStoreHandler"]:getState().Game.matchState
end

local states = {
	PRE = 0,
	RUNNING = 1,
	POST = 2
}

local function playsound(id, volume) 
	local sound = Instance.new("Sound")
	sound.Parent = workspace
	sound.SoundId = id
	sound.PlayOnRemove = true 
	if volume then 
		sound.Volume = volume
	end
	sound:Destroy()
end

local function playanimation(id) 
	if isAlive() then 
		local animation = Instance.new("Animation")
		animation.AnimationId = id
		local animatior = lplr.Character.Humanoid.Animator
		animatior:LoadAnimation(animation):Play()
	end
end

local nukerblocks = {}
local function getBlockNear(max, blocktab)
	local returning, nearestnum = nil, max

	for i,v in pairs(nukerblocks)  do 
		if isAlive() and table.find(blocktab, v.Name) and (v.Name=="bed" and v.Covers.BrickColor ~= lplr.TeamColor) then
			local mag = (v.Position - lplr.Character.HumanoidRootPart.Position).Magnitude
			if mag < nearestnum then 
				nearestnum = mag
				returning = v
				break
			end
		end
	end
	return returning
end

local removeNukerFunc, addNukerFunc = function(i,v) 
	local v = v==nil and i or v
	if v.Name == "bed" or v.Name:find("lucky_block") and table.find(nukerblocks, v) then 
		table.remove(nukerblocks, table.find(nukerblocks, v))
	end
end, function(i, v)
	local v = v==nil and i or v
	if v.Name == "bed" or v.Name:find("lucky_block") then 
		table.insert(nukerblocks,v)
	end
end

spawn(function()
	repeat task.wait() until matchState ~= 0
	WORKSPACE:WaitForChild("Map")
	COLLECTION:GetInstanceAddedSignal("block"):connect(addNukerFunc)
	COLLECTION:GetInstanceRemovedSignal("block"):connect(removeNukerFunc)
	table.foreach(COLLECTION:GetTagged("block"), addNukerFunc)
end)



local function colorToRichText(color) 
	return " rgb("..tostring(color.R*255)..", "..tostring(color.G*255)..", "..tostring(color.B*255)..")"
end

local convertHealthToColor = function(health, maxHealth) 
	local percent = (health/maxHealth) * 100
	if percent < 70 then 
		return Color3.fromRGB(255, 196, 0)
	elseif percent < 45 then
		return Color3.fromRGB(255, 71, 71)
	end
	return Color3.fromRGB(96, 253, 48)
end

local cancelViewmodel = false
local currentTarget
local isAuraTweening = false
local AuraAnimationList = {

	Normal = {
		Animation = {
			{CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(295), math.rad(55), math.rad(290)), Time = 0.2},
			{CFrame = CFrame.new(0.69, -0.71, 0.6) * CFrame.Angles(math.rad(200), math.rad(60), math.rad(1)), Time = 0.2}
		},  
		TweenTo = {CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(295), math.rad(55), math.rad(290)), Time = 0.2}
	},

}
local AuraAnimations = {}
for i,v in next, AuraAnimationList do 
	AuraAnimations[#AuraAnimations+1] = i
end

local AttackEntityRemote = bedwars.ClientHandler:Get(bedwars.AttackRemote).instance
local AuraAnimation = {Value = ""}

connectionstodisconnect[#connectionstodisconnect + 1] = bedwars["ClientStoreHandler"].changed:connect(function(p3, p4)
	if p3.Game ~= p4.Game then 
		matchState = p3.Game.matchState
		queueType = p3.Game.queueType or "bedwars_test"
	end
	if p3.Kit ~= p4.Kit then 	
		bedwars["BountyHunterTarget"] = p3.Kit.bountyHunterTarget
	end
	if p3.Bedwars ~= p4.Bedwars then 
		kit = p3.Bedwars.kit
	end
end)

--// UI Elements
local LiteFrame = shared.TabInGui["Non-Gaming chair"]
local IClientToggleProperty = shared.IClientToggledProperty
local ButtonInGui = shared.ButtonInGui

--------------------------------------// Non-Blantant Tab
----------// AutoClicker Handler
do

	local autoclickertick = tick()
	local autoclickermousedown = false
	local autoclickerconnection1
	local autoclickerconnection2
	local ClickFirstTime = true
	--// AutoClicker Title Frame
	local InstantKillToggleFrame = LiteFrame.Button({
		Text = "AutoClicker",
		Callback = function(Value)
		end,
	})

	--// AutoClicker Toggle Frame
	local InstantKillToggleFrame = LiteFrame.Toggle({
		Text = "Toggle",
		Callback = function(Value)
			IClientToggleProperty.AutoClickerToggle = IsToggleAble(Value) 
			if IClientToggleProperty.AutoClickerToggle == true then

				autoclickerconnection1 = UIS.InputBegan:connect(function(input, gameProcessed)
					if gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then
						autoclickermousedown = true
						ClickFirstTime = true
					end
				end)
				autoclickerconnection2 = UIS.InputEnded:connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						autoclickermousedown = false
						ClickFirstTime = true
					end
				end)
			else
				if autoclickerconnection1 then
					autoclickerconnection1:Disconnect()
				end
				if autoclickerconnection2 then
					autoclickerconnection2:Disconnect()
				end
			end
		end,
		Enabled = IClientToggleProperty.AutoClickerToggle
	})

	ButtonInGui["AutoClicker"] = {InstantKillToggleFrame,"AutoClickerToggle"}

	--// AutoClicker CPS Frame
	local InstantKillToggleFrame = LiteFrame.Slider({
		Text = "CPS",
		Callback = function(Value)
			IClientToggleProperty.AutoClickerCps =IsToggleAble(Value) 
		end,
		Min = 1,
		Max = 20,
		Def = IClientToggleProperty.AutoClickerCps 
	})

	ButtonInGui["AutoClickerCps"] = {InstantKillToggleFrame,"AutoClickerCps"}



	BindToRenderStep("AutoClicker", function() 
		if IClientToggleProperty.AutoClickerToggle then else return end
		if isAlive() and autoclickermousedown and autoclickertick <= tick() and isNotHoveringOverGui() and #bedwars["AppController"]:getOpenApps() <= 1 then
			autoclickertick = tick() + (ClickFirstTime and 0.1 or (1 / (IClientToggleProperty.AutoClickerCps*2))) + 0.02
			ClickFirstTime = false
			if getEquipped()["Type"] == "sword" and bedwars["KatanaController"].chargingMaid == nil then
				bedwars["SwordController"]:swingSwordAtMouse()
			end
			if getEquipped()["Type"] == "block"  and bedwars["BlockPlacementController"].blockPlacer then 
				local mouseinfo = bedwars["BlockPlacementController"].blockPlacer.clientManager:getBlockSelector():getMouseInfo(0)
				if mouseinfo then
					if bedwars["BlockPlacementController"].blockPlacer then
						bedwars["BlockPlacementController"].blockPlacer:placeBlock(mouseinfo.placementPosition)
					end
				end
			end
		end
	end)
end


----------// Legit Kill Aura Handler
do

	local InstantKillToggleFrame = LiteFrame.Toggle({
		Text = "Legit KillAura",
		Callback = function(Value)
			IClientToggleProperty.LegitKillAuraToggle = IsToggleAble(Value) 
		end,
		Enabled = IClientToggleProperty.LegitKillAuraToggle
	})
	ButtonInGui["Legit KillAura"] = {InstantKillToggleFrame,"LegitKillAuraToggle"}

	cam.Viewmodel.Humanoid.Animator.AnimationPlayed:connect(function(anim)
		if IClientToggleProperty.LegitKillAuraToggle and anim.Animation.AnimationId == "rbxassetid://8089691925" then
			local equipped = getEquipped()
			if equipped["Type"] == "sword" then
				local plr = getAllPlrsNear(18 -0.01)
				for i,v in next, plr do 
					local entity = bedwars["getEntityTable"]:getEntity(v.Character)
					if entity  and bedwars["SwordController"]:canSee(entity) and canBeTargeted(plr) then
						local tool = equipped["Object"]
						local selfpos = lplr.Character.HumanoidRootPart.Position + (Vector3.new(0, 0, 0))
						AttackEntityRemote:InvokeServer({
							["weapon"] = equipped["Object"],
							["entityInstance"] = v.Character,
							["validate"] = {
								["raycast"] = {
									["cameraPosition"] = hashvector(cam.CFrame.p), 
									["cursorDirection"] = hashvector(CFrame.new(cam.CFrame.p, v.Character.HumanoidRootPart.Position).LookVector)
								},
								["targetPosition"] = hashvector(v.Character.HumanoidRootPart.Position),
								["selfPosition"] = hashvector(selfpos),
							}, 
							["chargedAttack"] = {["chargeRatio"] = 1},
						})
						break
					end
				end
			end
		end
	end)

end

----------// Aim Assist Handler

do

	local aimbegan
	local aimended
	local aimactive = false	

	local SprintFrame = LiteFrame.Toggle({
		Text = "AimAssist",
		Callback = function(Value)
			IClientToggleProperty.AimAssistToggle = IsToggleAble(Value) 
			if IClientToggleProperty.AimAssistToggle then

				aimbegan = UIS.InputBegan:connect(function(input1)
					if UIS:GetFocusedTextBox() == nil and input1.UserInputType == Enum.UserInputType.MouseButton1 then
						aimactive = true
					end
				end)

				aimended = UIS.InputEnded:connect(function(input1)
					if input1.UserInputType == Enum.UserInputType.MouseButton1 then
						aimactive = false
					end
				end)
			else
				if aimbegan and aimended then
					aimbegan:Disconnect()
					aimended:Disconnect()
				end				
				aimactive = false
			end
		end,
		Enabled = IClientToggleProperty.AimAssistToggle
	})

	local function aimpos(vec, multiplier)
		local newvec = (vec - UIS:GetMouseLocation() - Vector2.new(0, 36)) * tonumber(multiplier)
		mousemoverel(newvec.X, newvec.Y)
	end

	BindToRenderStep("AimAssist", function()
		if aimactive then
			local targettable = {}
			local targetsize = 0
			local plr = getAllPlrsNear(18 -0.01)
			for i,v in next, plr do 
				local plr = v
				if plr and canBeTargeted(plr) and getEquipped()["Type"] == "sword" and #bedwars["AppController"]:getOpenApps() <= 1 and isNotHoveringOverGui() and bedwars["SwordController"]:canSee({["instance"] = plr.Character, ["player"] = plr, ["getInstance"] = function() return plr.Character end}) and bedwars["KatanaController"].chargingMaid == nil then
					local pos, vis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
					if vis and isrbxactive() then
						local senst = UserSettings():GetService("UserGameSettings").MouseSensitivity * (1 - (0 / 100))
						aimpos(Vector2.new(pos.X, pos.Y), senst)
						break
					end
				end
			end
		end
	end)

	ButtonInGui["AimAssistToggle"] = {SprintFrame,"AimAssistToggle"}

end

----------// Sprint Handler
do

	local AlreadyStop = false

	local SprintFrame = LiteFrame.Toggle({
		Text = "Sprint",
		Callback = function(Value)
			IClientToggleProperty.SprintToggle = IsToggleAble(Value) 
		end,
		Enabled = IClientToggleProperty.SprintToggle
	})

	ButtonInGui["Sprint"] = {SprintFrame,"SprintToggle"}


	BindToHeartbeat("Sprintng",function()
		if IClientToggleProperty.SprintToggle == false then
			if not AlreadyStop then
				bedwars["sprintTable"]:stopSprinting()
				AlreadyStop = true
			end
		else
			bedwars["sprintTable"]:startSprinting()
			AlreadyStop = false
		end 
	end)


end

----------// Auto Tool Handler
do

	local oldenable2
	local olddisable2
	local oldhitblock
	local blockplacetable2 = {}
	local blockplaceenabled2 = false

	local SprintFrame = LiteFrame.Toggle({
		Text = "Auto Tool",
		Callback = function(Value)
			IClientToggleProperty.AutoToolToggle = IsToggleAble(Value) 
			if IClientToggleProperty.AutoToolToggle then
				oldenable2 = bedwars["BlockBreaker"]["enable"]
				olddisable2 = bedwars["BlockBreaker"]["disable"]
				oldhitblock = bedwars["BlockBreaker"]["hitBlock"]
				bedwars["BlockBreaker"]["enable"] = function(Self, tab)
					blockplaceenabled2 = true
					blockplacetable2 = Self
					return oldenable2(Self, tab)
				end
				bedwars["BlockBreaker"]["disable"] = function(Self)
					blockplaceenabled2 = false
					return olddisable2(Self)
				end
				bedwars["BlockBreaker"]["hitBlock"] = function(...)
					if isAlive() and blockplaceenabled2 then
						local mouseinfo = blockplacetable2.clientManager:getBlockSelector():getMouseInfo(0)
						if mouseinfo and mouseinfo.target then
							if switchToAndUseTool(mouseinfo.target.blockInstance, true) then
								return
							end
						end
					end
					return oldhitblock(...)
				end
			else
				bedwars["BlockBreaker"]["enable"] = oldenable2
				bedwars["BlockBreaker"]["disable"] = olddisable2
				bedwars["BlockBreaker"]["hitBlock"] = oldhitblock
				oldenable2 = nil
				olddisable2 = nil
				oldhitblock = nil
			end
		end,
		Enabled = IClientToggleProperty.AutoToolToggle
	})

	ButtonInGui["Auto Tool"] = {SprintFrame,"AutoToolToggle"}


end

