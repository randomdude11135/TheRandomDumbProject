warn("Version Trash Final 3")

--// Remove all the ui
shared.ButtonInGui["Speed"][1]:Remove()
shared.ButtonInGui["AntiCheat Real"][1]:Remove()

--// Main Varibles
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
local ContentProvider = game:GetService("ContentProvider")
local RealRoot

--// UI Elements
local LiteFrame = shared.TabInGui["Non-Gaming chair"]
local BlantantFrame = shared.TabInGui["Gaming chair"]
local AnimationTab = shared.TabInGui["Animations"]
local IClientToggleProperty = shared.IClientToggledProperty
local ButtonInGui = shared.ButtonInGui

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
local RunService = game:GetService("RunService")
local savedc0 = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Viewmodel"):WaitForChild(
	"RightHand"
):WaitForChild("RightWrist").C0
local oldisnetworkowner = isnetworkowner
local networkownerfunc = isnetworkowner
local isnetworkowner = isnetworkowner or function()
	return true
end
local printtable = printtable or print

local AnticheatBypassNumbers = {
	TPSpeed = 0.1,
	TPCombat = 0.3,
	TPLerp = 0.39,
	TPCheck = 15,
}
--// Functions
local HeartbeatTable = {}
local RenderStepTable = {}
local SteppedTable = {}
local function isAlive(plr)
	local plr = plr or lplr
	if
		plr
		and plr.Character
		and (
			(plr.Character:FindFirstChild("Humanoid"))
			and (plr.Character:FindFirstChild("Humanoid").Health > 0)
			and (plr.Character:FindFirstChild("HumanoidRootPart"))
			and (plr.Character:FindFirstChild("Head"))
		)
	then
		return true
	end
end

local function isNotHoveringOverGui()
	local mousepos = UIS:GetMouseLocation() - Vector2.new(0, 36)
	for i, v in pairs(lplr.PlayerGui:GetGuiObjectsAtPosition(mousepos.X, mousepos.Y)) do
		if v.Active then
			return false
		end
	end
	for i, v in pairs(game:GetService("CoreGui"):GetGuiObjectsAtPosition(mousepos.X, mousepos.Y)) do
		if v.Active then
			return false
		end
	end
	return true
end

function PlayFunction()
	if IClientToggleProperty.CurrentPickAnimationId <= 200 then
		CurrentAnimation =
			bedwars["GameAnimationUtil"].playAnimation(lplr.Character, IClientToggleProperty.CurrentPickAnimationId)

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
			ContentProvider:PreloadAsync({
				anim2,
				"http://www.roblox.com/asset/?id=" .. IClientToggleProperty.CurrentPickAnimationId,
			})

			SavedAnimation[IClientToggleProperty.CurrentPickAnimationId] = anim2
		end
		CurrentAnimation =
			lplr.Character.Humanoid:LoadAnimation(SavedAnimation[IClientToggleProperty.CurrentPickAnimationId])
		CurrentAnimation.Priority = Enum.AnimationPriority.Action
		task.wait()
		CurrentAnimation:Play()
		repeat
			wait()
		until CurrentAnimation.Length > 0
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

local function IsToggleAble(Value, Gateway)
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

local function canBeTargeted(plr, doTeamCheck)
	if plr and plr.Team then
		return not (plr.Team.Name == lplr.Team.Name)
	end
end

local function getremote(t)
	for i, v in next, t do
		if v == "Client" then
			return t[i + 1]
		end
	end
end

local function getAllPlrsNear(max)
	if not isAlive() then
		return {}
	end
	local t = {}
	for i, v in next, PLAYERS:GetPlayers() do
		if isAlive(v) and v ~= lplr then
			if
				v.Character.HumanoidRootPart
				and (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
					<= max
			then
				table.insert(t, v)
			end
		end
	end
	return t
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
	return { ["Object"] = obj and obj.tool, ["Type"] = typetext }
end

local function hashvector(vec)
	return {
		value = vec,
	}
end

--// Framework
warn("[IClient]: Getting Framework")
local Flamework =
	require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@flamework"].core.out).Flamework
repeat
	task.wait()
until Flamework.isInitialized
warn("[IClient]: Framework loaded")
local KnitClient = debug.getupvalue(
	require(lplr.PlayerScripts.TS.controllers.game["block-break-controller"]).BlockBreakController.onEnable,
	1
)
local Client = require(game:GetService("ReplicatedStorage").TS.remotes).default.Client
local InventoryUtil = require(game:GetService("ReplicatedStorage").TS.inventory["inventory-util"]).InventoryUtil
local OldClientGet = getmetatable(Client).Get
local OldClientWaitFor = getmetatable(Client).WaitFor

--[[
getmetatable(Client).Get = function(Self, remotename)
	if remotename == bedwars["AttackRemote"] then
		local res = OldClientGet(Self, remotename)
		return {
			["instance"] = res["instance"],
			["CallServer"] = function(Self, tab)
				local suc, plr = pcall(function()
					return PLAYERS:GetPlayerFromCharacter(tab.entityInstance)
				end)
				if suc and plr then
					if plr and (bedwars["CheckWhitelisted"](plr) and bedwars["CheckWhitelisted"](lplr) == nil) then
						return nil
					end
				end
				return res:CallServer(tab)
			end,
		}
	end
	return OldClientGet(Self, remotename)
end]]
warn("[IClient]: Setting Bedwar table")
bedwars = {
	["AnimationUtil"] = require(
		game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out["shared"].util["animation-util"]
	).AnimationUtil,
	["AngelUtil"] = require(game:GetService("ReplicatedStorage").TS.games.bedwars.kit.kits.angel["angel-kit"]),
	["AppController"] = require(
		game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out.client.controllers["app-controller"]
	).AppController,
	["BalloonController"] = KnitClient.Controllers.BalloonController,
	["BlockController"] = require(
		game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out
	).BlockEngine,
	["BlockController2"] = require(
		game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.client.placement["block-placer"]
	).BlockPlacer,
	["BlockTryController"] = getrenv()._G[game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.client.placement["block-placer"]],
	["BlockEngine"] = require(lplr.PlayerScripts.TS.lib["block-engine"]["client-block-engine"]).ClientBlockEngine,
	["BlockEngineClientEvents"] = require(
		game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.client["block-engine-client-events"]
	).BlockEngineClientEvents,
	["BlockPlacementController"] = KnitClient.Controllers.BlockPlacementController,
	["BedwarsKits"] = require(game:GetService("ReplicatedStorage").TS.games.bedwars.kit["bedwars-kit-shop"]).BedwarsKitShop,
	["BlockBreaker"] = KnitClient.Controllers.BlockBreakController.blockBreaker,
	["ProjectileController"] = KnitClient.Controllers.ProjectileController,
	["ChestController"] = KnitClient.Controllers.ChestController,
	["ClickHold"] = require(
		game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out.client.ui.lib.util["click-hold"]
	).ClickHold,
	["ClientHandler"] = Client,
	["ClientHandlerDamageBlock"] = require(
		game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["block-engine"].out.remotes
	).BlockEngineRemotes.Client,
	["ClientStoreHandler"] = require(game.Players.LocalPlayer.PlayerScripts.TS.ui.store).ClientStore,
	["ClientHandlerSyncEvents"] = require(lplr.PlayerScripts.TS["client-sync-events"]).ClientSyncEvents,
	["CombatConstant"] = require(game:GetService("ReplicatedStorage").TS.combat["combat-constant"]).CombatConstant,
	["CombatController"] = KnitClient.Controllers.CombatController,
	["ConsumeSoulRemote"] = getremote(debug.getconstants(KnitClient.Controllers.GrimReaperController.consumeSoul)),
	["ConstantManager"] = require(
		game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out["shared"].constant["constant-manager"]
	).ConstantManager,
	["CooldownController"] = KnitClient.Controllers.CooldownController,
	["damageTable"] = KnitClient.Controllers.DamageController,
	["DetonateRavenRemote"] = getremote(
		debug.getconstants(getmetatable(KnitClient.Controllers.RavenController).detonateRaven)
	),
	["DropItem"] = getmetatable(KnitClient.Controllers.ItemDropController).dropItemInHand,
	["DropItemRemote"] = getremote(
		debug.getconstants(getmetatable(KnitClient.Controllers.ItemDropController).dropItemInHand)
	),
	["EatRemote"] = getremote(
		debug.getconstants(debug.getproto(getmetatable(KnitClient.Controllers.ConsumeController).onEnable, 1))
	),
	["EquipItemRemote"] = getremote(
		debug.getconstants(
			debug.getprotos(
				shared.oldequipitem
					or require(game:GetService("ReplicatedStorage").TS.entity.entities["inventory-entity"]).InventoryEntity.equipItem
			)[3]
		)
	),
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
		local suc, result = pcall(function()
			return InventoryUtil.getInventory(plr)
		end)
		return (suc and result or {
			["items"] = {},
			["armor"] = {},
			["hand"] = nil,
		})
	end,
	["getItemMetadata"] = require(game:GetService("ReplicatedStorage").TS.item["item-meta"]).getItemMeta,
	["GrimReaperController"] = KnitClient.Controllers.GrimReaperController,
	["GuitarHealRemote"] = getremote(debug.getconstants(KnitClient.Controllers.GuitarController.performHeal)),
	["HighlightController"] = KnitClient.Controllers.EntityHighlightController,
	["ItemTable"] = debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.item["item-meta"]).getItemMeta, 1),
	["JuggernautRemote"] = getremote(
		debug.getconstants(
			debug.getprotos(debug.getprotos(KnitClient.Controllers.JuggernautController.KnitStart)[1])[4]
		)
	),
	["KatanaController"] = KnitClient.Controllers.DaoController,
	["KatanaRemote"] = getremote(debug.getconstants(debug.getproto(KnitClient.Controllers.DaoController.onEnable, 4))),
	["KnockbackTable"] = debug.getupvalue(
		require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil.calculateKnockbackVelocity,
		1
	),
	["KnockbackTable2"] = require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil,
	["LobbyClientEvents"] = require(
		game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"].lobby.out.client.events
	).LobbyClientEvents,
	["MissileController"] = KnitClient.Controllers.GuidedProjectileController,
	["MinerRemote"] = getremote(
		debug.getconstants(
			debug.getprotos(debug.getproto(getmetatable(KnitClient.Controllers.MinerController).onKitEnabled, 1))[2]
		)
	),
	["MinerController"] = KnitClient.Controllers.MinerController,
	["PickupRemote"] = getremote(
		debug.getconstants(getmetatable(KnitClient.Controllers.ItemDropController).checkForPickup)
	),
	["PlayerUtil"] = require(game:GetService("ReplicatedStorage").TS.player["player-util"]).GamePlayerUtil,
	["ProjectileMeta"] = require(game:GetService("ReplicatedStorage").TS.projectile["projectile-meta"]).ProjectileMeta,
	["QueueMeta"] = require(game:GetService("ReplicatedStorage").TS.game["queue-meta"]).QueueMeta,
	["QueryUtil"] = require(
		game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out
	).GameQueryUtil,
	["prepareHashing"] = require(game:GetService("ReplicatedStorage").TS["remote-hash"]["remote-hash-util"]).RemoteHashUtil.prepareHashVector3,
	["ProjectileRemote"] = getremote(
		debug.getconstants(
			debug.getupvalues(getmetatable(KnitClient.Controllers.ProjectileController)["launchProjectileWithValues"])[2]
		)
	),
	["RavenTable"] = KnitClient.Controllers.RavenController,
	["RespawnController"] = KnitClient.Controllers.BedwarsRespawnController,
	["RespawnTimer"] = require(lplr.PlayerScripts.TS.controllers.games.bedwars.respawn.ui["respawn-timer"]).RespawnTimerWrapper,
	["ResetRemote"] = getremote(
		debug.getconstants(debug.getproto(KnitClient.Controllers.ResetController.createBindable, 1))
	),
	["Roact"] = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["roact"].src),
	["RuntimeLib"] = require(game:GetService("ReplicatedStorage")["rbxts_include"].RuntimeLib),
	["Shop"] = require(game:GetService("ReplicatedStorage").TS.games.bedwars.shop["bedwars-shop"]).BedwarsShop,
	["TeamUpgrades"] = require(game:GetService("ReplicatedStorage").TS.games.bedwars.shop["bedwars-shop"]).BedwarsShop.TeamUpgrades,
	["ShopItems"] = debug.getupvalue(
		require(game:GetService("ReplicatedStorage").TS.games.bedwars.shop["bedwars-shop"]).BedwarsShop.getShopItem,
		2
	),
	["ShopRight"] = require(
		lplr.PlayerScripts.TS.controllers.games.bedwars.shop.ui["item-shop"]["shop-left"]["shop-left"]
	).BedwarsItemShopLeft,
	["SpawnRavenRemote"] = getremote(
		debug.getconstants(getmetatable(KnitClient.Controllers.RavenController).spawnRaven)
	),
	["SoundManager"] = require(
		game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out
	).SoundManager,
	["SoundList"] = require(game:GetService("ReplicatedStorage").TS.sound["game-sound"]).GameSound,
	["sprintTable"] = KnitClient.Controllers.SprintController,
	["StopwatchController"] = KnitClient.Controllers.StopwatchController,
	["SwingSword"] = getmetatable(KnitClient.Controllers.SwordController).swingSwordAtMouse,
	["SwingSwordRegion"] = getmetatable(KnitClient.Controllers.SwordController).swingSwordInRegion,
	["SwordController"] = KnitClient.Controllers.SwordController,
	["TreeRemote"] = getremote(
		debug.getconstants(debug.getprotos(debug.getprotos(KnitClient.Controllers.BigmanController.KnitStart)[2])[1])
	),
	["TrinityRemote"] = getremote(
		debug.getconstants(debug.getproto(getmetatable(KnitClient.Controllers.AngelController).onKitEnabled, 1))
	),
	["VictoryScreen"] = require(lplr.PlayerScripts.TS.controllers["game"].match.ui["victory-section"]).VictorySection,
	["ViewmodelController"] = KnitClient.Controllers.ViewmodelController,
	["WeldTable"] = require(game:GetService("ReplicatedStorage").TS.util["weld-util"]).WeldUtil,
	--[[
	["AttackRemote"] = getremote(
		debug.getconstants(getmetatable(KnitClient.Controllers.SwordController)["attackEntity"])
	),]]
	["VelocityUtil"] = require(
		game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out["shared"].util["velocity-util"]
	).VelocityUtil,
	["ItemMeta"] = debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.item["item-meta"]).getItemMeta, 1),
	["PlayerVacuumRemote"] = getremote(
		debug.getconstants(debug.getproto(KnitClient.Controllers.PlayerVacuumController.onEnable, 4))
	),
	["PingController"] = require(lplr.PlayerScripts.TS.controllers.game.ping["ping-controller"]).PingController,
	["RaiseShieldRemote"] = getremote(debug.getconstants(KnitClient.Controllers.InfernalShieldController.constructor)),
}

local clientstorestate = bedwars["ClientStoreHandler"]:getState()
matchState = clientstorestate.Game.matchState or 0
kit = clientstorestate.Bedwars.kit or ""
queueType = clientstorestate.Game.queueType or "bedwars_test"

--// Framework functions
local function getblock(pos)
	return bedwars["BlockController"]:getStore():getBlockAt(bedwars["BlockController"]:getBlockPosition(pos)),
		bedwars["BlockController"]:getBlockPosition(pos)
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

for i, v in pairs(debug.getupvalues(getmetatable(KnitClient.Controllers.SwordController)["attackEntity"])) do
	if tostring(v) == "AC" then
		bedwars["AttackHashTable"] = v
		for i2, v2 in pairs(v) do
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
	if
		bedwars["BlockController"]:isAllowedPlacement(
			lplr,
			placeblocktype,
			Vector3.new(newpos.X / 3, newpos.Y / 3, newpos.Z / 3)
		) and getItem(placeblocktype)
	then
		return blocktable:placeBlock(Vector3.new(newpos.X / 3, newpos.Y / 3, newpos.Z / 3))
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
			slot = getHotbarSlot(tool.Name),
		})
	end
	pcall(function()
		lplr.Character.HandInvItem.Value = tool
	end)
	bedwars["ClientHandler"]:Get(bedwars["EquipItemRemote"]):CallServerAsync({
		hand = tool,
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
	for i, v in pairs(bedwars["getInventory"](lplr)["items"]) do
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
	local realvec = Vector3.new(
		math.floor((vec.X / 3) + 0.5) * 3,
		math.floor((vec.Y / 3) + 0.5) * 3,
		math.floor((vec.Z / 3) + 0.5) * 3
	)
	local newpos = (oldpos - realvec)
	local returedpos = realvec
	if lplr.isAlive then
		local angle =
			math.deg(math.atan2(-lplr.character.Humanoid.MoveDirection.X, -lplr.character.Humanoid.MoveDirection.Z))
		local goingdiagonal = (angle >= 130 and angle <= 150)
			or (angle <= -35 and angle >= -50)
			or (angle >= 35 and angle <= 50)
			or (angle <= -130 and angle >= -150)
		if
			goingdiagonal
			and ((newpos.X == 0 and newpos.Z ~= 0) or (newpos.X ~= 0 and newpos.Z == 0))
			and diagonaltoggle
		then
			return oldpos
		end
	end
	return realvec
end

local function switchToAndUseTool(block, legit)
	local tool = getBestTool(block.Name)
	if
		tool
		and (
			isAlive()
			and lplr.Character:FindFirstChild("HandInvItem")
			and lplr.Character.HandInvItem.Value ~= tool["tool"]
		)
	then
		if legit then
			if getHotbarSlot(tool.itemType) then
				bedwars["ClientStoreHandler"]:dispatch({
					type = "InventorySelectHotbarSlot",
					slot = getHotbarSlot(tool.itemType),
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
	for i, v in next, WORKSPACE:WaitForChild("Map"):WaitForChild("Blocks"):GetChildren() do
		if v.Name == "bed" then
			t[#t + 1] = v
		end
	end
	return t
end

local function getotherbed(pos)
	local normalsides = { "Top", "Left", "Right", "Front", "Back" }
	for i, v in pairs(normalsides) do
		local bedobj = getblock(pos + (Vector3.FromNormalId(Enum.NormalId[v]) * 3))
		if bedobj and bedobj.Name == "bed" then
			return (pos + (Vector3.FromNormalId(Enum.NormalId[v]) * 3))
		end
	end
	return nil
end

local function isBlockCovered(pos)
	local normalsides = { "Top", "Left", "Right", "Front", "Back" }
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
			if bedwars["BlockController"]:isBlockBreakable({ ["blockPosition"] = blockpos }, lplr) then
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
	local normalsides = { "Top", "Left", "Right", "Front", "Back" }
	for i, v in pairs(normalsides) do
		local sidehardness = 0
		for i2, v2 in pairs(getallblocks(pos, v)) do
			sidehardness = sidehardness
				+ (
					(
						(v2 == "unbreakable" or v2 == "bed") and 99999999
						or bedwars["ItemTable"][v2]["block"] and bedwars["ItemTable"][v2]["block"]["health"]
					) or 10
				)
			if bedwars["ItemTable"][v2]["block"] and v2 ~= "unbreakable" and v2 ~= "bed" and v2 ~= "ceramic" then
				local tool = getBestTool(v2)
				if tool then
					sidehardness = sidehardness
						- bedwars["ItemTable"][tool.itemType]["breakBlock"][bedwars["ItemTable"][v2]["block"]["breakType"]]
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
	["breakingBlockPosition"] = Vector3.new(0, 0, 0),
}

bedwars["breakBlock"] = function(pos, effects, normal, bypass)
	if lplr:GetAttribute("DenyBlockBreak") == true then
		return nil
	end
	local block = ((bypass == nil and getlastblock(pos, Enum.NormalId[normal])) or getblock(pos))
	local notmainblock = not (bypass == nil and getlastblock(pos, Enum.NormalId[normal]))
	if
		block
		and bedwars["BlockController"]:isBlockBreakable(
			{ blockPosition = bedwars["BlockController"]:getBlockPosition((notmainblock and pos or block.Position)) },
			lplr
		)
	then
		if
			bedwars["BlockEngineClientEvents"].DamageBlock
				:fire(
					block.Name,
					bedwars["BlockController"]:getBlockPosition((notmainblock and pos or block.Position)),
					block
				)
				:isCancelled()
		then
			return nil
		end
		local olditem = nil
		pcall(function()
			olditem = lplr.Character.HandInvItem.Value
		end)
		local blockhealthbarpos = { blockPosition = Vector3.new(0, 0, 0) }
		local blockdmg = 0
		if block and block.Parent ~= nil then
			switchToAndUseTool(block)
			blockhealthbarpos = {
				blockPosition = bedwars["BlockController"]:getBlockPosition((notmainblock and pos or block.Position)),
			}
			if
				healthbarblocktable.blockHealth == -1
				or blockhealthbarpos.blockPosition ~= healthbarblocktable.breakingBlockPosition
			then
				local blockdata = bedwars["BlockController"]:getStore():getBlockData(blockhealthbarpos.blockPosition)
				if not blockdata then
					return nil
				end
				local blockhealth = blockdata:GetAttribute(lplr.Name .. "_Health")
				if blockhealth == nil then
					blockhealth = block:GetAttribute("Health")
				end
				healthbarblocktable.blockHealth = blockhealth
				healthbarblocktable.breakingBlockPosition = blockhealthbarpos.blockPosition
			end
			blockdmg = bedwars["BlockController"]:calculateBlockDamage(lplr, blockhealthbarpos)
			healthbarblocktable.blockHealth = healthbarblocktable.blockHealth - blockdmg
			if healthbarblocktable.blockHealth < 0 then
				healthbarblocktable.blockHealth = 0
			end
			bedwars["ClientHandlerDamageBlock"]
				:Get("DamageBlock")
				:CallServerAsync({
					blockRef = blockhealthbarpos,
					hitPosition = (notmainblock and pos or block.Position),
					hitNormal = Vector3.FromNormalId(Enum.NormalId[normal]),
				})
				:andThen(function(p9)
					if p9 == "failed" then
						healthbarblocktable.blockHealth = healthbarblocktable.blockHealth + blockdmg
					end
				end)
			if effects then
				bedwars["BlockBreaker"]:updateHealthbar(
					blockhealthbarpos,
					healthbarblocktable.blockHealth,
					block:GetAttribute("MaxHealth"),
					blockdmg
				)
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
	local x, y, z = p.X, p.Y, p.Z
	x = math.floor(x + 0.5)
	y = math.floor(y + 0.5)
	z = math.floor(z + 0.5)
	return Vector3.new(x, y, z)
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
	POST = 2,
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

	for i, v in pairs(nukerblocks) do
		if
			isAlive()
			and table.find(blocktab, v.Name)
			and (v.Name == "bed" and v.Covers.BrickColor ~= lplr.TeamColor)
		then
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

local removeNukerFunc, addNukerFunc =
	function(i, v)
		local v = v == nil and i or v
		if v.Name == "bed" or v.Name:find("lucky_block") and table.find(nukerblocks, v) then
			table.remove(nukerblocks, table.find(nukerblocks, v))
		end
	end, function(i, v)
		table.insert(bedwarsblocks, v)
		local v = v == nil and i or v
		if v.Name == "bed" or v.Name:find("lucky_block") then
			table.insert(nukerblocks, v)
		end
	end

spawn(function()
	repeat
		task.wait()
	until matchState ~= 0
	WORKSPACE:WaitForChild("Map")
	COLLECTION:GetInstanceAddedSignal("block"):connect(addNukerFunc)
	COLLECTION:GetInstanceRemovedSignal("block"):connect(removeNukerFunc)
	table.foreach(COLLECTION:GetTagged("block"), addNukerFunc)
end)

local function colorToRichText(color)
	return " rgb("
		.. tostring(color.R * 255)
		.. ", "
		.. tostring(color.G * 255)
		.. ", "
		.. tostring(color.B * 255)
		.. ")"
end

local convertHealthToColor = function(health, maxHealth)
	local percent = (health / maxHealth) * 100
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
			{
				CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(295), math.rad(55), math.rad(290)),
				Time = 0.2,
			},
			{
				CFrame = CFrame.new(0.69, -0.71, 0.6) * CFrame.Angles(math.rad(200), math.rad(60), math.rad(1)),
				Time = 0.2,
			},
		},
		TweenTo = {
			CFrame = CFrame.new(0.69, -0.7, 0.6) * CFrame.Angles(math.rad(295), math.rad(55), math.rad(290)),
			Time = 0.2,
		},
	},
}
local AuraAnimations = {}
for i, v in next, AuraAnimationList do
	AuraAnimations[#AuraAnimations + 1] = i
end
--[[
local AttackEntityRemote = bedwars.ClientHandler:Get(bedwars.AttackRemote).instance
local AuraAnimation = { Value = "" }
]]
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

warn("[IClient]: Generating tab")

--------------------------------------// Non-Blantant Tab
--[[
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
		Callback = function(Value) end,
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
		Enabled = IClientToggleProperty.AutoClickerToggle,
	})

	ButtonInGui["AutoClicker"] = { InstantKillToggleFrame, "AutoClickerToggle" }

	--// AutoClicker CPS Frame
	local InstantKillToggleFrame = LiteFrame.Slider({
		Text = "CPS",
		Callback = function(Value)
			IClientToggleProperty.AutoClickerCps = IsToggleAble(Value)
		end,
		Min = 1,
		Max = 20,
		Def = IClientToggleProperty.AutoClickerCps,
	})

	ButtonInGui["AutoClickerCps"] = { InstantKillToggleFrame, "AutoClickerCps" }

	BindToRenderStep("AutoClicker", function()
		if IClientToggleProperty.AutoClickerToggle then
		else
			return
		end
		if
			isAlive()
			and autoclickermousedown
			and autoclickertick <= tick()
			and isNotHoveringOverGui()
			and #bedwars["AppController"]:getOpenApps() <= 1
		then
			autoclickertick = tick()
				+ (ClickFirstTime and 0.1 or (1 / (IClientToggleProperty.AutoClickerCps * 2)))
				+ 0.02
			ClickFirstTime = false
			if getEquipped()["Type"] == "sword" and bedwars["KatanaController"].chargingMaid == nil then
				bedwars["SwordController"]:swingSwordAtMouse()
			end
			if getEquipped()["Type"] == "block" and bedwars["BlockPlacementController"].blockPlacer then
				local mouseinfo = bedwars["BlockPlacementController"].blockPlacer.clientManager
					:getBlockSelector()
					:getMouseInfo(0)
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
		Enabled = IClientToggleProperty.LegitKillAuraToggle,
	})
	ButtonInGui["Legit KillAura"] = { InstantKillToggleFrame, "LegitKillAuraToggle" }

	cam.Viewmodel.Humanoid.Animator.AnimationPlayed:connect(function(anim)
		if IClientToggleProperty.LegitKillAuraToggle and anim.Animation.AnimationId == "rbxassetid://8089691925" then
			local equipped = getEquipped()
			if equipped["Type"] == "sword" then
				local plr = getAllPlrsNear(18 - 0.01)
				for i, v in next, plr do
					local entity = bedwars["getEntityTable"]:getEntity(v.Character)
					if entity and bedwars["SwordController"]:canSee(entity) and canBeTargeted(plr) then
						local tool = equipped["Object"]
						local selfpos = lplr.Character.HumanoidRootPart.Position + (Vector3.new(0, 0, 0))
						AttackEntityRemote:InvokeServer({
							["weapon"] = equipped["Object"],
							["entityInstance"] = v.Character,
							["validate"] = {
								["raycast"] = {
									["cameraPosition"] = hashvector(cam.CFrame.p),
									["cursorDirection"] = hashvector(
										CFrame.new(cam.CFrame.p, v.Character.HumanoidRootPart.Position).LookVector
									),
								},
								["targetPosition"] = hashvector(v.Character.HumanoidRootPart.Position),
								["selfPosition"] = hashvector(selfpos),
							},
							["chargedAttack"] = { ["chargeRatio"] = 1 },
						})
						break
					end
				end
			end
		end
	end)
end
]]
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

				BindToRenderStep("AimAssist", function()
					if aimactive and IClientToggleProperty.AimAssistToggle then
						local plr = getAllPlrsNear(18 - 0.01)
						for i, v in next, plr do
							local plr = v
							if
								plr
								and canBeTargeted(plr)
								and getEquipped()["Type"] == "sword"
								and #bedwars["AppController"]:getOpenApps() <= 1
								and isNotHoveringOverGui()
								and bedwars["SwordController"]:canSee({
									["instance"] = plr.Character,
									["player"] = plr,
									["getInstance"] = function()
										return plr.Character
									end,
								})
								and bedwars["KatanaController"].chargingMaid == nil
							then
								local pos, vis = cam:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
								if vis and isrbxactive() then
									local senst = UserSettings():GetService("UserGameSettings").MouseSensitivity
										* (1 - (0 / 100))
									aimpos(Vector2.new(pos.X, pos.Y), senst)
									break
								end
							end
						end
					end
				end)
			else
				if aimbegan and aimended then
					aimbegan:Disconnect()
					aimended:Disconnect()
				end

				UnbindFromRenderStep("AimAssist")

				aimactive = false
			end
		end,
		Enabled = IClientToggleProperty.AimAssistToggle,
	})

	ButtonInGui["AimAssistToggle"] = { SprintFrame, "AimAssistToggle" }
end

----------// Sprint Handler
do
	local AlreadyStop = true

	local SprintFrame = LiteFrame.Toggle({
		Text = "Sprint",
		Callback = function(Value)
			IClientToggleProperty.SprintToggle = IsToggleAble(Value)
			if IClientToggleProperty.SprintToggle then
				BindToHeartbeat("Sprintng", function()
					if IClientToggleProperty.SprintToggle == false then
						bedwars["sprintTable"]:stopSprinting()
					else
						bedwars["sprintTable"]:startSprinting()
					end
				end)
			else
				UnbindFromHeartbeat("Sprintng")
			end
		end,
		Enabled = IClientToggleProperty.SprintToggle,
	})

	ButtonInGui["Sprint"] = { SprintFrame, "SprintToggle" }
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
		Enabled = IClientToggleProperty.AutoToolToggle,
	})

	ButtonInGui["Auto Tool"] = { SprintFrame, "AutoToolToggle" }
end

--------------------------------------// Blantant Tab
--[[
----------// Kill Aura Handler
do
	local KillAuraTick = tick()
	local KillAuraToggleFrame = BlantantFrame.Toggle({
		Text = "KillAura",
		Callback = function(Value)
			IClientToggleProperty.KillAuraToggle = IsToggleAble(Value)
		end,
		Enabled = IClientToggleProperty.KillAuraToggle,
	})

	ButtonInGui["KillAura"] = { KillAuraToggleFrame, "KillAuraToggle" }

	--// Kill Aura Range Frame
	local KillAuraRangeFrame = BlantantFrame.Slider({
		Text = "KillAura [Range]",
		Callback = function(Value)
			IClientToggleProperty.KillAuraRange = Value

			if IClientToggleProperty.KillAuraRange then
				BindToHeartbeat("KillAura",function()
					if not IClientToggleProperty.KillAuraToggle then
						return
					end
					if KillAuraTick > tick() then
						return
					end
					local plrs = getAllPlrsNear(IClientToggleProperty.KillAuraRange - 0.01)
					if #plrs == 0 then
						currentTarget = nil
					end
			
					for i, v in next, plrs do
						if canBeTargeted(v) then
							currentTarget = v
							local weapon = getBestSword()
							local selfpos = lplr.Character.HumanoidRootPart.Position
								+ (
									IClientToggleProperty.KillAuraRange > 14
										and (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude > 14
										and (CFrame.lookAt(
											lplr.Character.HumanoidRootPart.Position,
											v.Character.HumanoidRootPart.Position
										).lookVector * 4)
									or Vector3.new(0, 0, 0)
								)
							local attackArgs = {
								["weapon"] = weapon ~= nil and weapon.tool,
								["entityInstance"] = v.Character,
								["validate"] = {
									["raycast"] = {
										["cameraPosition"] = hashvector(cam.CFrame.p),
										["cursorDirection"] = hashvector(
											Ray.new(cam.CFrame.p, v.Character.HumanoidRootPart.Position).Unit.Direction
										),
									},
									["targetPosition"] = hashvector(v.Character.HumanoidRootPart.Position),
									["selfPosition"] = hashvector(selfpos),
								},
								["chargedAttack"] = { ["chargeRatio"] = 1 },
							}
							spawn(function()
								local weapon = getBestSword()
								KillAuraTick = tick() + bedwars["ItemTable"][weapon["tool"].Name].sword.attackSpeed
								AttackEntityRemote:InvokeServer(attackArgs)
							end)
							break
						end
					end
				end)
			else
				UnbindFromHeartbeat("KillAura")
			end
		end,
		Min = 1,
		Max = 18,
		Def = IClientToggleProperty.KillAuraRange,
	})

	ButtonInGui["KillAura [Range]"] = { KillAuraRangeFrame, "KillAuraRange" }
end
]]
----------// Bed Nuker Handler
do
	local bedtick = tick()
	--// Bed Nuker Frame
	local BedNukerFrame = BlantantFrame.Toggle({
		Text = "Bed Nuker",
		Callback = function(Value)
			IClientToggleProperty.BedAuraToggle = IsToggleAble(Value, "BedAuraToggle")
			if IClientToggleProperty.BedAuraToggle then
				BindToHeartbeat("BedNuker", function()
					if tick() < bedtick or not IClientToggleProperty.BedAuraToggle then
						return
					end
					local blocktab = { "bed" }
					local block = getBlockNear(40, blocktab)
					if block then
						local bestSide = getbestside(block.Position)
						if bestSide then
							bedtick = tick() + 0.3
							bedwars["breakBlock"](block.Position, true, bestSide)
						end
					end
				end)
			else
				UnbindFromHeartbeat("BedNuker")
			end
		end,
		Enabled = IClientToggleProperty.BedAuraToggle,
	})

	ButtonInGui["Bed Nuker"] = { BedNukerFrame, "BedAuraToggle" }
end

----------// Speed Handler
do
	--// Speed Frame
	local SpeedFrame = BlantantFrame.Toggle({
		Text = "Speed",
		Callback = function(Value)
			IClientToggleProperty.SpeedToggled = IsToggleAble(Value)
			if not IClientToggleProperty.SpeedToggled then
				lplr.Character:WaitForChild("Humanoid").WalkSpeed = 16
				UnbindFromHeartbeat("Speed")
			else
				BindToHeartbeat("Speed", function(dt)
					if isAlive() then
						if IClientToggleProperty.SpeedToggled then
							lplr.Character.Humanoid.WalkSpeed = speedsettings.wsvalue
							local velo = lplr.Character.Humanoid.MoveDirection
								* (IClientToggleProperty.WalkSpeed * ((isnetworkowner and isnetworkowner(
									lplr.Character.HumanoidRootPart
								)) and speedsettings.factor or 0))
								* dt
							velo = Vector3.new(velo.x / 11, 0, velo.z / 11)
							lplr.Character:TranslateBy(velo)
							local velo2 = (lplr.Character.Humanoid.MoveDirection * IClientToggleProperty.WalkSpeed)
								/ speedsettings.velocitydivfactor
							lplr.Character.HumanoidRootPart.Velocity =
								Vector3.new(velo2.X, lplr.Character.HumanoidRootPart.Velocity.Y, velo2.Z)
						end
					end
				end)
			end
		end,
		Enabled = IClientToggleProperty.SpeedToggled,
	})

	ButtonInGui["Speed"] = { SpeedFrame, "SpeedToggled" }

	--SpeedFrame:SetState(IClientToggleProperty.SpeedToggled)
end

----------// Gravity Handler
do
	--// Gravity Frame
	local KillAuraRangeFrame = BlantantFrame.Slider({
		Text = "Gravity Changer",
		Callback = function(Value)
			IClientToggleProperty.GravitySet = IsToggleAble(Value, "GravitySet")
			workspace.Gravity = IClientToggleProperty.GravitySet
		end,
		Min = 1,
		Max = 192,
		Def = IClientToggleProperty.GravitySet or 192,
	})

	ButtonInGui["Gravity Changer"] = { KillAuraRangeFrame, "GravitySet" }
end

----------// Flying Handler
do
	local flyup
	local flydown
	local flydownconnection
	local flyupconnection

	--// Flying Frame
	local BedNukerFrame = BlantantFrame.Toggle({
		Text = "Fly yeah",
		Callback = function(Value)
			IClientToggleProperty.FlyToggle = IsToggleAble(Value, "FlyToggle")
			if IClientToggleProperty.FlyToggle then
				BindToRenderStep("Fly", function(time, dt)
					if isAlive() then
						local dt = 1
						local updirection = 0 - 5
						if UIS:GetFocusedTextBox() == nil then
							updirection = (flyup and 30 or flydown and -30 or 0) * dt
						end
						local MoveDirection = lplr.Character.Humanoid.MoveDirection * (50 * dt)
						lplr.Character.HumanoidRootPart.Velocity =
							Vector3.new(MoveDirection.X, updirection, MoveDirection.Z)
					end
				end)
				flyupconnection = UIS.InputBegan:Connect(function(input)
					if input.KeyCode == Enum.KeyCode.Space then
						flyup = true
					end
					if input.KeyCode == Enum.KeyCode.LeftShift then
						flydown = true
					end
				end)
				flydownconnection = UIS.InputEnded:Connect(function(input)
					if input.KeyCode == Enum.KeyCode.Space then
						flyup = false
					end
					if input.KeyCode == Enum.KeyCode.LeftShift then
						flydown = false
					end
				end)
			else
				flyup = false
				flydown = false
				UnbindFromRenderStep("Fly")
				if flyupconnection then
					flyupconnection:Disconnect()
				end
				if flydownconnection then
					flydownconnection:Disconnect()
				end
			end
		end,
		Enabled = IClientToggleProperty.FlyToggle,
	})
	ButtonInGui["Fly yeah"] = { BedNukerFrame, "FlyToggle" }
end

----------// Super Jump Handler
do
	local Duration, Power = { Value = 50 }, { Value = 5 }

	--// Flying Frame
	local BedNukerFrame = BlantantFrame.Button({
		Text = "Super Jump",
		Callback = function(Value)
			spawn(function()
				if isAlive() then
					for i = 1, Duration.Value do
						lplr.Character.HumanoidRootPart.Velocity = lplr.Character.HumanoidRootPart.Velocity
							+ Vector3.new(0, Power.Value, 0)
						task.wait()
					end
				end
			end)
		end,
	})
end

----------// Phase Handler
do
	local raycastparameters = RaycastParams.new()
	raycastparameters.FilterType = Enum.RaycastFilterType.Whitelist
	local phasedelay2 = tick()

	--// Flying Frame
	local BedNukerFrame = BlantantFrame.Toggle({
		Text = "Phase (Not done but atleast it work)",
		Callback = function(Value)
			IClientToggleProperty.PhaseToggled = IsToggleAble(Value)
			if IClientToggleProperty.PhaseToggled then
				BindToHeartbeat("PhaseRender", function()
					if IClientToggleProperty.PhaseToggled then
						if isAlive() and lplr.Character.Humanoid.MoveDirection ~= Vector3.zero then
							if phasedelay2 > tick() then
								return
							end
							local pos3 = lplr.Character.Head.Position

							raycastparameters.FilterDescendantsInstances =
								{ bedwarsblocks, COLLECTION:GetTagged("spawn-cage"), workspace.SpectatorPlatform }
							local newray =
								workspace:Raycast(pos3, lplr.Character.Humanoid.MoveDirection, raycastparameters)
							if newray then
								print("Found")
								phasedelay2 = tick() + 0.1
								lplr.Character.HumanoidRootPart.CFrame =
									addvectortocframe(lplr.Character.HumanoidRootPart.CFrame, (newray.Normal * -3.5))
							end
						end
					end
				end)
			else
				UnbindFromHeartbeat("PhaseRender")
			end
		end,
		Enabled = IClientToggleProperty.PhaseToggled,
	})
end

----------// Anti cheat bypass real
do
	local IsUsingAntiCheatAssist = false

	local AnticheatAssistConstants = {
		MaxDistance = 20,
		-- normal
		Delay = 0.125,
		Lerp = 0.39,
		TPDelay = 0.1,

		-- combat
		CombatDelay = 0.1,
		CombatLerp = 0.5,
		CombatTPDelay = 0,
	}

	local BodyPart = {
		R6 = {
			"Head",
			"Torso",
			"Left Arm",
			"Right Arm",
			"Left Leg",
			"Right Leg",
		},
		R15 = {
			"Head",
			"UpperTorso",
			"LowerTorso",
			"LeftUpperLeg",
			"LeftLowerLeg",
			"LeftFoot",
			"RightUpperLeg",
			"RightLowerLeg",
			"RightFoot",
			"LeftUpperArm",
			"LeftLowerArm",
			"LeftHand",
			"RightUpperArm",
			"RightLowerArm",
			"RightHand",
		},
	}

	local OldHipHeight
	local AnticheatAssistLastTick = 0
	local AnticheatAssistConnections = {}
	local AnticheatAssistTransparent = {}
	local lagbacknum = 0
	local lagbackcurrent = false
	local NextTrack = os.time()
	local pinglist = {}
	local fpslist = {}

	local function AnticheatAssistFunction(char)
		IsUsingAntiCheatAssist = true
		spawn(function()
			if not isAlive() then
				repeat
					task.wait()
				until isAlive()
			end
			if not lplr.CharacterAppearanceLoaded then
				repeat
					task.wait()
				until lplr.CharacterAppearanceLoaded
			end
			local char = char or lplr.Character

			local Humanoid = char:WaitForChild("Humanoid", 15)
			local HumanoidRootPart = char:WaitForChild("HumanoidRootPart", 15)
			local RigType = Humanoid.RigType
			local BodyParts = BodyPart[RigType.Name]
			for i, v in next, BodyParts do
				char:WaitForChild(v, 10)
			end

			repeat
				task.wait()
				if
					networkownerfunc == nil
					and gethiddenproperty(HumanoidRootPart, "NetworkOwnershipRule") == Enum.NetworkOwnership.Manual
				then
					sethiddenproperty(HumanoidRootPart, "NetworkOwnershipRule", Enum.NetworkOwnership.Automatic)
				end
			until HumanoidRootPart
				and (
					networkownerfunc and networkownerfunc(HumanoidRootPart)
					or networkownerfunc == nil
						and gethiddenproperty(HumanoidRootPart, "NetworkOwnershipRule") == Enum.NetworkOwnership.Automatic
				)

			OldHipHeight = OldHipHeight or Humanoid.HipHeight --// Change Hip Hieght
			Humanoid.HipHeight = OldHipHeight
			RealRoot = HumanoidRootPart -- // Change HhumanoidRotPart
			char.Parent = game -- Parent char to game
			FakeRoot = RealRoot:Clone() -- Clone Root (Fake Root)
			FakeRoot.Parent = char
			RealRoot.Parent = cam
			FakeRoot.CFrame = RealRoot.CFrame
			char.PrimaryPart = FakeRoot -- // Change
			char.Parent = workspace
			RealRoot.CanCollide = true
			RealRoot.Transparency = AnticheatAssistTransparent.Enabled and 1 or 0
			RealRoot.Color = Color3.fromRGB(71, 236, 50)
			RealRoot.Material = Enum.Material.Water

			task.wait(0.1)

			for i, v in next, char:GetDescendants() do
				if v:IsA("BodyVelocity") then
					v:Destroy()
				end
				if v:IsA("Weld") or v:IsA("Motor6D") then
					if v.Part0 and v.Part0 == RealRoot then
						v.Part0 = FakeRoot
					end
					if v.Part1 and v.Part1 == RealRoot then
						v.Part1 = FakeRoot
					end
				end
			end

			for i, v in next, RealRoot:GetDescendants() do
				if v:IsA("BodyVelocity") then
					v:Destroy()
				end
			end

			PlayFunction()

			BindToRenderStep("AnticheatAssist", function()
				--// Check FPS
				if NextTrack <= os.time() then
					local ping = math.floor(
						tonumber(game:GetService("Stats"):FindFirstChild("PerformanceStats").Ping:GetValue())
					)
					local fps = math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
					if #pinglist >= 10 then
						table.remove(pinglist, 1)
					end
					if #fpslist >= 10 then
						table.remove(fpslist, 1)
					end
					table.insert(pinglist, ping)
					table.insert(fpslist, fps)
					task.wait(1)
				end

				--// Setting CFrame
				if isAlive() then
					--// Check if got anti cheated
					if
						networkownerfunc == nil
						and gethiddenproperty(RealRoot, "NetworkOwnershipRule") == Enum.NetworkOwnership.Manual
					then
						if lagbackcurrent == false then
							lagbacknum = tick() + 8
							lagbackcurrent = true
						end
						if lagbacknum <= tick() then
							sethiddenproperty(RealRoot, "NetworkOwnershipRule", Enum.NetworkOwnership.Automatic)
						end
					else
						lagbackcurrent = false
					end

					--// Actual CFraming
					if RealRoot and FakeRoot then
						--//
						if
							networkownerfunc == nil
							and gethiddenproperty(RealRoot, "NetworkOwnershipRule") == Enum.NetworkOwnership.Manual
						then
							if lagbackcurrent == false then
								lagbacknum = tick() + 8
								lagbackcurrent = true
							end
							if lagbacknum <= tick() then
								sethiddenproperty(RealRoot, "NetworkOwnershipRule", Enum.NetworkOwnership.Automatic)
							end
						else
							lagbackcurrent = false
						end

						--// Setting up the cframe
						if
							networkownerfunc and (not networkownerfunc(RealRoot))
							or networkownerfunc == nil
								and gethiddenproperty(RealRoot, "NetworkOwnershipRule") == Enum.NetworkOwnership.Manual
						then
							FakeRoot.CFrame = RealRoot.CFrame
						else
							local MoveDirection = Humanoid.MoveDirection * 20
							local Velo = Vector3.new(MoveDirection.X, FakeRoot.Velocity.Y, MoveDirection.Z)
							RealRoot.Velocity = Velo
							RealRoot.RotVelocity = Vector3.zero
							RealRoot.Transparency = AnticheatAssistTransparent.Enabled and 1 or 0.7

							local Magnitude = (FakeRoot.Position - RealRoot.Position).Magnitude
							if Magnitude > AnticheatAssistConstants.MaxDistance then
								FakeRoot.CFrame = RealRoot.CFrame
							end

							local Delay = currentTarget ~= nil and AnticheatAssistConstants.CombatDelay
								or AnticheatAssistConstants.Delay
							if tick() - AnticheatAssistLastTick > Delay then
								AnticheatAssistLastTick = tick()
								RealRoot.CFrame = RealRoot.CFrame:Lerp(FakeRoot.CFrame, AnticheatAssistConstants.Lerp)
							end
						end
					end
				end
			end)
		end)
	end

	local function DisableAnticheatAssist(char)
		if IsUsingAntiCheatAssist then
		else
			return
		end
		spawn(function()
			if not isAlive() then
				repeat
					task.wait()
				until isAlive()
			end
			local char = char or lplr.Character
			local Humanoid = char:FindFirstChildWhichIsA("Humanoid")
			UnbindFromRenderStep("AnticheatAssist")
			pcall(function()
				char.Parent = game
			end)
			if RealRoot and RealRoot.Parent ~= nil then
				RealRoot.Parent = char
				char.PrimaryPart = RealRoot
				RealRoot.Transparency = 1
			end
			if char.Parent ~= nil then
				char.Parent = workspace
			end
			for i, v in next, char:GetDescendants() do
				if v:IsA("BodyVelocity") then
					v:Destroy()
				end
				if v:IsA("Weld") or v:IsA("Motor6D") then
					if v.Part0 and v.Part0 == FakeRoot then
						v.Part0 = RealRoot
					end
					if v.Part1 and v.Part1 == FakeRoot then
						v.Part1 = RealRoot
					end
				end
			end
			if Humanoid then
				Humanoid.HipHeight = OldHipHeight
			end
			if FakeRoot then
				FakeRoot:Destroy()
				FakeRoot = nil
			end
		end)
	end

	-- AntiCheat Bypass real

	--// AntiCheat Frame
	local AntiCheatFrame = BlantantFrame.Toggle({
		Text = "AntiCheat Real",
		Callback = function(Value)
			IClientToggleProperty.AnticheatBypass = IsToggleAble(Value)
			if IClientToggleProperty.AnticheatBypass then
				AnticheatAssistConnections["CharacterRemoving"] = lplr.CharacterRemoving:Connect(function(char)
					DisableAnticheatAssist(char)
				end)

				AnticheatAssistConnections["CharacterAdded"] = lplr.CharacterAdded:Connect(function(char)
					AnticheatAssistFunction(char)
				end)

				AnticheatAssistConnections["TeamUpdate"] = lplr:GetPropertyChangedSignal("Team"):Connect(function()
					local char = lplr.Character
					DisableAnticheatAssist(char)
					AnticheatAssistFunction(char)
				end)

				if isAlive() then
					AnticheatAssistFunction(lplr.Character)
				end
			else
				UnbindFromRenderStep("AnticheatAssist")

				for i, v in next, AnticheatAssistConnections do
					v:Disconnect()
					AnticheatAssistConnections[i] = nil
				end

				if isAlive() then
					DisableAnticheatAssist(lplr.Character)
				end
			end
		end,
		Enabled = IClientToggleProperty.AnticheatBypass,
	})

	ButtonInGui["AntiCheat Real"] = { AntiCheatFrame, "AnticheatBypass" }
end

----------// AutoBuy Handler
do
	local priolist = {
		[1] = {
			"leather_chestplate",
			"iron_chestplate",
			"diamond_chestplate",
			"emerald_chestplate",
		},

		[2] = {
			"stone_sword",
			"iron_sword",
			"diamond_sword",
			"emerald_sword",
		},

		[3] = {
			"stone_pickaxe",
			"iron_pickaxe",
			"diamond_pickaxe",
		},
		[4] = {
			"wood_axe",
			"stone_axe",
			"iron_axe",
			"diamond_axe",
		},
		[5] = {
			"wool_white",
		},
	}

	local teampriolist = {
		--"armory",
		"damage",
		"armor",
	}

	local WoolCap = { Value = 16 }

	local function getShopItem(_type)
		for i, v in next, bedwars.ShopItems do
			if v.itemType and v.itemType == _type then
				return v
			end
		end
	end

	local function getTeamUpgrade(id)
		for i, v in next, bedwars.TeamUpgrades do
			if v.id and v.id == id then
				return v
			end
		end
	end

	local function buy(item)
		if item == nil then
			return
		end
		local i = item.itemType
		if table.find(priolist[2], i) and IClientToggleProperty.OnePunchManToggle then
			return
		end
		spawn(function()
			game
				:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.BedwarsPurchaseItem
				:InvokeServer({ shopItem = item })
		end)
	end

	local function upgrade(id, tier)
		local tier = tier or 0
		spawn(function()
			game
				:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.BedwarsPurchaseTeamUpgrade
				:InvokeServer({ ["upgradeId"] = id, ["tier"] = tier })
		end)
	end

	local function getCurrentItem(t)
		local best
		for i, v in next, t do
			if getItem(v) then
				best = v
			end
		end
		return getShopItem(best)
	end

	local childadded
	local tu = {}
	local is = {}

	--// AutoBuyFrame
	local AutoBuyFrame = BlantantFrame.Toggle({
		Text = "Auto Buy",
		Callback = function(Value)
			IClientToggleProperty.AutoBuyToggle = IsToggleAble(Value)

			if IClientToggleProperty.AutoBuyToggle then
				BindToHeartbeat("AutoBuy", function()
					if not IClientToggleProperty.AutoBuyToggle then
						return
					end
					local currentTeamUpgrades = bedwars["ClientStoreHandler"]:getState().Bedwars.teamUpgrades
					if isAlive() then
						for i, v in next, is do
							local mag = (lplr.Character.HumanoidRootPart.Position - v.Position).magnitude
							if mag <= 15 then
								for b, a in ipairs(priolist) do
									local buyme
									for i, v in next, a do
										local item = getShopItem(v)
										local amt = getItemAmt(item.currency)
										local currentItem = getCurrentItem(a) or { itemType = "placeholder" }
										if
											amt
											and item
											and item.price
											and amt >= item.price
											and (i > (table.find(a, currentItem.itemType) or 0))
										then
											if item.itemType == "diamond_sword" or item.itemType == "emerald_sword" then
												if currentTeamUpgrades.armory ~= nil then
													buyme = item
												end
											else
												buyme = item
											end
										end
									end
									if buyme and not getItem(buyme.itemType) then
										if buyme.itemType == "wool_white" and getwoolamt() < WoolCap.Value then
											buy(buyme)
										elseif buyme.itemType ~= "wool_white" then
											buy(buyme)
										end
									end
								end
							end
						end
						for i, v in next, tu do
							local mag = (lplr.Character.HumanoidRootPart.Position - v.Position).magnitude
							if mag <= 15 then
								for a, b in ipairs(teampriolist) do
									local upgradetab = getTeamUpgrade(b)
									local currentTier = currentTeamUpgrades[b] or -1
									if currentTier + 1 ~= #upgradetab.tiers then
										for i, v in next, upgradetab.tiers do
											upgrade(b, i - 1)
										end
									end
								end
							end
						end
					end
				end)
			else
				UnbindFromHeartbeat("AutoBuy")
			end
		end,
		Enabled = IClientToggleProperty.AutoBuyToggle,
	})

	ButtonInGui["Auto Buy"] = { AutoBuyFrame, "AutoBuyToggle" }

	for i, v in next, WORKSPACE:GetChildren() do
		if v.Name == "item_shop" then
			is[#is + 1] = v
		elseif v.Name:find("upgrade_shop") then
			tu[#tu + 1] = v
		end
	end

	childadded = WORKSPACE.ChildAdded:Connect(function(v)
		if v.Name == "item_shop" then
			is[#is + 1] = v
		elseif v.Name:find("upgrade_shop") then
			tu[#tu + 1] = v
		end
	end)

	--AutoBuyFrame:SetState(IClientToggleProperty.AutoBuyToggle)
end

----------// No Fall Damage Handler
do
	local falltick = tick()
	--// Frame
	local AutoBuyFrame = BlantantFrame.Toggle({
		Text = "No Fall Damage",
		Callback = function(Value)
			IClientToggleProperty.NoFallToggle = IsToggleAble(Value)

			if IClientToggleProperty.NoFallToggle then
				BindToHeartbeat("NoFall", function()
					if not IClientToggleProperty.NoFallToggle then
						return
					end
					if tick() >= falltick then
					else
						return
					end
					falltick = tick() + 0.5
					bedwars["ClientHandler"]:Get("GroundHit"):SendToServer()
				end)
			else
				UnbindFromHeartbeat("NoFall")
			end
		end,
		Enabled = IClientToggleProperty.NoFallToggle,
	})

	ButtonInGui["No Fall Damage"] = { AutoBuyFrame, "NoFallToggle" }
end

----------// Player ESP Handler
do
	local BeeTable = {}
	--// Frame
	local AutoBuyFrame = BlantantFrame.Toggle({
		Text = "Player ESP",
		Callback = function(Value)
			IClientToggleProperty.PlayEspToggle = IsToggleAble(Value)
			if IClientToggleProperty.PlayEspToggle then
				BindToRenderStep("ESP", function()
					if IClientToggleProperty.PlayEspToggle then
						for i, plr in pairs(PLAYERS:GetPlayers()) do
							if plr.Character then
								if BeeTable[plr.Character] then
								else
									if plr.Name == lplr.Name then
									else
										if plr.Character then
											local MakeHighLight = Instance.new("BoxHandleAdornment")
											MakeHighLight.Name = plr.Name
											MakeHighLight.Adornee = plr.Character.HumanoidRootPart
											MakeHighLight.Size = plr.Character.HumanoidRootPart.Size
											MakeHighLight.AlwaysOnTop = true
											MakeHighLight.Color3 = plr.Team.Name == lplr.Team.Name
													and Color3.new(0.333333, 1, 0)
												or Color3.new(1, 0, 0)
											MakeHighLight.Parent = ESPFolder
											MakeHighLight.ZIndex = 1
											MakeHighLight.Transparency = 0.3
											BeeTable[plr.Character] = MakeHighLight
										end
									end
								end

								for i, v in pairs(BeeTable) do
									if i:IsDescendantOf(workspace) then
										if i.Humanoid.Health > 0 then
											v.Transparency = 0.3
										else
											v.Transparency = 1
										end
									else
										v:Destroy()
									end
								end
							end
						end
					end
				end)
			else
				UnbindFromRenderStep("ESP")
				for i, v in pairs(BeeTable) do
					v.Transparency = 1
				end
				BeeTable = {}
			end
		end,
		Enabled = IClientToggleProperty.PlayEspToggle,
	})

	ButtonInGui["Player ESP"] = { AutoBuyFrame, "PlayEspToggle" }
end

----------// Bee ESP Handler
do
	local BeeTable = {}
	--// Frame
	local AutoBuyFrame = BlantantFrame.Toggle({
		Text = "Bee ESP",
		Callback = function(Value)
			IClientToggleProperty.BeeEspToggle = IsToggleAble(Value)

			if IClientToggleProperty.BeeEspToggle then
				BindToRenderStep("BeeEsp", function()
					if IClientToggleProperty.BeeEspToggle then
						for i, plr in pairs(COLLECTION:GetTagged("bee")) do
							if BeeTable[plr] then
							else
								local MakeHighLight = Instance.new("BoxHandleAdornment")
								MakeHighLight.Name = "BeeEsp"
								MakeHighLight.Adornee = plr.Root
								MakeHighLight.Size = plr.Root.Size
								MakeHighLight.AlwaysOnTop = true
								MakeHighLight.Color3 = Color3.fromRGB(255, 255, 127)
								MakeHighLight.Parent = ESPFolder
								MakeHighLight.ZIndex = 1
								MakeHighLight.Transparency = 0.3
								BeeTable[plr] = MakeHighLight
							end
						end

						for i, v in pairs(BeeTable) do
							if i:IsDescendantOf(workspace) then
								if IClientToggleProperty.InstantBeeToggle then
									i.Root.ProximityPrompt.HoldDuration = 0
								else
									i.Root.ProximityPrompt.HoldDuration = 0.3
								end
							else
								v:Destroy()
							end
						end
					end
				end)
			else
				UnbindFromRenderStep("BeeEsp")
				for i, v in pairs(BeeTable) do
					v.Transparency = 1
				end
				BeeTable = {}
			end
		end,
		Enabled = IClientToggleProperty.BeeEspToggle,
	})

	ButtonInGui["Bee ESP"] = { AutoBuyFrame, "BeeEspToggle" }
end

----------// Sheep ESP Handler
do
	local BeeTable = {}
	--// Frame
	local AutoBuyFrame = BlantantFrame.Toggle({
		Text = "Sheep ESP",
		Callback = function(Value)
			IClientToggleProperty.SheepEspToggle = IsToggleAble(Value)
			if IClientToggleProperty.SheepEspToggle then
				BindToRenderStep("SheepEsp", function()
					if IClientToggleProperty.SheepEspToggle then
						for i, plr in pairs(COLLECTION:GetTagged("SheepModel")) do
							if BeeTable[plr] then
							else
								local MakeHighLight = Instance.new("BoxHandleAdornment")
								MakeHighLight.Name = "SheepEsp"
								MakeHighLight.Adornee = plr.RootPart
								MakeHighLight.Size = plr.RootPart.Size
								MakeHighLight.AlwaysOnTop = true
								MakeHighLight.Color3 = Color3.fromRGB(85, 170, 255)
								MakeHighLight.Parent = ESPFolder
								MakeHighLight.ZIndex = 1
								MakeHighLight.Transparency = 0.3
								BeeTable[plr] = MakeHighLight
							end
						end

						for i, v in pairs(BeeTable) do
							if i:IsDescendantOf(workspace) then
							else
								v:Destroy()
							end
						end
					else
						for i, v in pairs(BeeTable) do
							v.Transparency = 1
						end
					end
				end)
			else
				UnbindFromRenderStep("SheepEsp")
				for i, v in pairs(BeeTable) do
					v.Transparency = 1
				end
				BeeTable = {}
			end
		end,
		Enabled = IClientToggleProperty.SheepEspToggle,
	})

	ButtonInGui["Sheep ESP"] = { AutoBuyFrame, "SheepEspToggle" }
end

----------// Metal ESP Handler
do
	local BeeTable = {}
	--// Frame
	local AutoBuyFrame = BlantantFrame.Toggle({
		Text = "Metal ESP",
		Callback = function(Value)
			IClientToggleProperty.MetalEspToggle = IsToggleAble(Value)
			if IClientToggleProperty.MetalEspToggle then
				BindToRenderStep("MetalEsp", function()
					if IClientToggleProperty.MetalEspToggle then
						for i, plr in pairs(COLLECTION:GetTagged("hidden-metal")) do
							if BeeTable[plr] then
							else
								local MakeHighLight = Instance.new("BoxHandleAdornment")
								MakeHighLight.Name = "MetalEsp"
								MakeHighLight.Adornee = plr.Part
								MakeHighLight.Size = plr.Part.Size
								MakeHighLight.AlwaysOnTop = true
								MakeHighLight.Color3 = Color3.fromRGB(0, 0, 255)
								MakeHighLight.Parent = ESPFolder
								MakeHighLight.ZIndex = 1
								MakeHighLight.Transparency = 0.3
								BeeTable[plr] = MakeHighLight
							end
						end

						for i, v in pairs(BeeTable) do
							if i:IsDescendantOf(workspace) then
								v.Adornee = i.Part

								if IClientToggleProperty.MetalCollectType == "2x Speed" then
									i.ProximityPrompt.HoldDuration = 0.5
								elseif IClientToggleProperty.MetalCollectType == "Instant Collect" then
									i.ProximityPrompt.HoldDuration = 0
								else
									i.ProximityPrompt.HoldDuration = 1
								end
							else
								v:Destroy()
							end
						end
					else
					end
				end)
			else
				UnbindFromRenderStep("MetalEsp")
				for i, v in pairs(BeeTable) do
					v.Transparency = 1
				end
				BeeTable = {}
			end
		end,
		Enabled = IClientToggleProperty.MetalEspToggle,
	})

	ButtonInGui["Metal ESP"] = { AutoBuyFrame, "MetalEspToggle" }
end

----------// Metal Aura Handler
do
	local IsCollectingMetal = false

	--// Frame
	local AutoBuyFrame = BlantantFrame.Toggle({
		Text = "Metal Aura",
		Callback = function(Value)
			IClientToggleProperty.MetalAuraToggle = IsToggleAble(Value)
			if IClientToggleProperty.MetalAuraToggle then
				BindToHeartbeat("MetalAura", function()
					if IClientToggleProperty.MetalAuraToggle then
						for i, TheMetalObject in pairs(COLLECTION:GetTagged("hidden-metal")) do
							if
								IsCollectingMetal == false
								and TheMetalObject.ProximityPrompt.Enabled == true
								and (lplr.Character.HumanoidRootPart.Position - TheMetalObject.Part.Position).Magnitude
									<= TheMetalObject.ProximityPrompt.MaxActivationDistance
							then
								IsCollectingMetal = TheMetalObject.ProximityPrompt.PromptButtonHoldEnded:Connect(
									function()
										IsCollectingMetal:Disconnect()
										IsCollectingMetal = false
									end
								)
								task.spawn(function()
									TheMetalObject.ProximityPrompt:InputHoldBegin()
									TheMetalObject.Changed:Wait()
									TheMetalObject.ProximityPrompt:InputHoldEnd()
									IsCollectingMetal:Disconnect()
									IsCollectingMetal = false
								end)
								break
							end
						end
					else
					end
				end)
			else
				UnbindFromHeartbeat("MetalAura")
			end
		end,
		Enabled = IClientToggleProperty.MetalAuraToggle,
	})

	ButtonInGui["MetalAura"] = { AutoBuyFrame, "MetalAuraToggle" }
end

----------// Star Handler
do
	local IsCollectingMetal = false
    local StarTable = {}
	local BeeTable = {}
	local Connection
	local Connection2

	for i , v in pairs(game.Workspace:GetChildren()) do
		if v.Name == "CritStar" or v.Name == "VitalityStar" then
			print("Inserted " .. v.Name)
			table.insert(StarTable,v)
		end
	end


	Connection = game.Workspace.ChildAdded:Connect(function(Value)
		if Value.Name == "CritStar" or Value.Name == "VitalityStar" then
			table.insert(StarTable,Value)
		end
	end)	

	Connection2 = game.Workspace.ChildRemoved:Connect(function(Value)
		if Value.Name == "CritStar" or Value.Name == "VitalityStar" then
			table.remove(StarTable,table.find(StarTable,Value))
		end

	end)	


	--// Frame
	local AutoBuyFrame = BlantantFrame.Toggle({
		Text = "Star Aura",
		Callback = function(Value)
			IClientToggleProperty.StarAuraToggle = IsToggleAble(Value)
			if IClientToggleProperty.StarAuraToggle then

				BindToHeartbeat("StarAura", function()
					if IClientToggleProperty.StarAuraToggle then
						for i, TheMetalObject in pairs(StarTable) do
							if
								IsCollectingMetal == false
								and TheMetalObject.ProximityPrompt.Enabled == true
								and (lplr.Character.HumanoidRootPart.Position - TheMetalObject.RootPart.Position).Magnitude
									<= TheMetalObject.ProximityPrompt.MaxActivationDistance * 1.5
							then
								IsCollectingMetal = TheMetalObject.ProximityPrompt.PromptButtonHoldEnded:Connect(
									function()
										IsCollectingMetal:Disconnect()
										IsCollectingMetal = false
									end
								)
								task.spawn(function()
									TheMetalObject.ProximityPrompt:InputHoldBegin()
									TheMetalObject.Changed:Wait()
									TheMetalObject.ProximityPrompt:InputHoldEnd()
									IsCollectingMetal:Disconnect()
									IsCollectingMetal = false
								end)
								break
							end
						end
					else
					end
				end)
			else
				UnbindFromHeartbeat("StarAura")
			end
		end,
		Enabled = IClientToggleProperty.StarAuraToggle,
	})

	local AutoBuyFrame2 = BlantantFrame.Toggle({
		Text = "Star Esp",
		Callback = function(Value)
			IClientToggleProperty.StarESPToggle = IsToggleAble(Value)
			if IClientToggleProperty.StarESPToggle then

				BindToHeartbeat("StarEsp", function()
					if IClientToggleProperty.StarESPToggle then
						for i, TheMetalObject in pairs(StarTable) do
							if BeeTable[TheMetalObject] then
							else
								local MakeHighLight = Instance.new("BoxHandleAdornment")
								MakeHighLight.Name = "MetalEsp"
								MakeHighLight.Adornee = TheMetalObject.PrimaryPart
								MakeHighLight.Size = TheMetalObject.PrimaryPart.Size
								MakeHighLight.AlwaysOnTop = true
								MakeHighLight.Color3 = Color3.fromRGB(229, 255, 0)
								MakeHighLight.Parent = ESPFolder
								MakeHighLight.ZIndex = 1
								MakeHighLight.Transparency = 0.3
								BeeTable[TheMetalObject] = MakeHighLight
							end
						end
					
						for i, v in pairs(BeeTable) do
							if i:IsDescendantOf(workspace) then
								v.Adornee = i.PrimaryPart
							else
								v:Destroy()
							end
						end

					else
						
					end
				end)
			else
				for i, v in pairs(BeeTable) do
					v.Transparency = 1
				end
				BeeTable = {}
				UnbindFromHeartbeat("StarEsp")
			end
		end,
		Enabled = IClientToggleProperty.StarESPToggle,
	})

	ButtonInGui["StarAura"] = { AutoBuyFrame, "StarAuraToggle" }

	ButtonInGui["StarEsp"] = { AutoBuyFrame2, "StarESPToggle" }
end


----------// Bee Aura Handler
do
	local IsCollectingMetal = false

	--// Frame
	local AutoBuyFrame = BlantantFrame.Toggle({
		Text = "Bee Aura",
		Callback = function(Value)
			IClientToggleProperty.BeeAuraToggle = IsToggleAble(Value)
			if IClientToggleProperty.BeeAuraToggle then
				BindToHeartbeat("BeeAura", function()
					if IClientToggleProperty.BeeAuraToggle then
						for i, TheMetalObject in pairs(COLLECTION:GetTagged("bee")) do
							if
								IsCollectingMetal == false
								and TheMetalObject.Root.ProximityPrompt.Enabled == true
								and (lplr.Character.HumanoidRootPart.Position - TheMetalObject.Root.Position).Magnitude
									<= TheMetalObject.Root.ProximityPrompt.MaxActivationDistance
							then
								IsCollectingMetal = true
								IsCollectingMetal = TheMetalObject.Root.ProximityPrompt.PromptButtonHoldEnded:Connect(
									function()
										IsCollectingMetal:Disconnect()
										IsCollectingMetal = false
									end
								)
								task.spawn(function()
									TheMetalObject.Root.ProximityPrompt:InputHoldBegin()
									TheMetalObject.Changed:Wait()
									TheMetalObject.Root.ProximityPrompt:InputHoldEnd()
									IsCollectingMetal:Disconnect()
									IsCollectingMetal = false
								end)
								break
							end
						end
					else
					end
				end)
			else
				UnbindFromHeartbeat("BeeAura")
			end
		end,
		Enabled = IClientToggleProperty.BeeAuraToggle,
	})

	ButtonInGui["BeeAura"] = { AutoBuyFrame, "BeeAuraToggle" }
end

----------// Auto Bank Handler
do
	local IsWithdrawed = false
	local WithdrawTick = tick()

	--// UI Stats
	local MakeUI = Instance.new("ScreenGui", lplr.PlayerGui)
	MakeUI.ResetOnSpawn = false
	autobankui = Instance.new("Frame")
	autobankui.Size = UDim2.new(0, 160, 0, 40)
	autobankui.Position = UDim2.new(0, 0, 0, -200)
	autobankui.BackgroundTransparency = 1
	autobankui.Parent = MakeUI
	local emerald = Instance.new("ImageLabel")
	emerald.Image = bedwars["getIcon"]({ itemType = "emerald" }, true)
	emerald.Size = UDim2.new(0, 40, 0, 40)
	emerald.Name = "emerald"
	emerald.Position = UDim2.new(0, 80, 0, 0)
	emerald.BackgroundTransparency = 1
	emerald.Parent = autobankui
	local emeraldtext = Instance.new("TextLabel")
	emeraldtext.TextSize = 20
	emeraldtext.BackgroundTransparency = 1
	emeraldtext.Size = UDim2.new(1, 0, 1, 0)
	emeraldtext.Font = Enum.Font.SourceSans
	emeraldtext.TextStrokeTransparency = 0.3
	emeraldtext.Name = "Amount"
	emeraldtext.Text = ""
	emeraldtext.TextColor3 = Color3.new(1, 1, 1)
	emeraldtext.Parent = emerald
	local diamond = emerald:Clone()
	diamond.Image = bedwars["getIcon"]({ itemType = "diamond" }, true)
	diamond.Position = UDim2.new(0, 40, 0, 0)
	diamond.Name = "diamond"
	diamond.Parent = autobankui
	local iron = emerald:Clone()
	iron.Image = bedwars["getIcon"]({ itemType = "iron" }, true)
	iron.Position = UDim2.new(0, 0, 0, 0)
	iron.Name = "iron"
	iron.Parent = autobankui
	local crystal = emerald:Clone()
	crystal.Image = bedwars["getIcon"]({ itemType = "void_crystal" }, true)
	crystal.Position = UDim2.new(0, 120, 0, 0)
	crystal.Name = "void_crystal"
	crystal.Parent = autobankui

	local echest = ReplicatedStorage.Inventories:FindFirstChild(lplr.Name .. "_personal")
	local AutoBankTransmitted, AutoBankTransmittedType = false, false

	local function refreshbank()
		if autobankui then
			local echest = ReplicatedStorage.Inventories:FindFirstChild(lplr.Name .. "_personal")
			for i, v in pairs(autobankui:GetChildren()) do
				if echest:FindFirstChild(v.Name) then
					v.Amount.Text = echest[v.Name]:GetAttribute("Amount")
				else
					v.Amount.Text = ""
				end
			end
		end
	end

	local tu = {}
	local is = {}
	local isWithdrawed = false

	for i, v in next, WORKSPACE:GetChildren() do
		if v.Name == "item_shop" then
			is[#is + 1] = v
		elseif v.Name:find("upgrade_shop") then
			tu[#tu + 1] = v
		end
	end

	childadded = WORKSPACE.ChildAdded:Connect(function(v)
		if v.Name == "item_shop" then
			is[#is + 1] = v
		elseif v.Name:find("upgrade_shop") then
			tu[#tu + 1] = v
		end
	end)

	--// Frame
	local AutoBuyFrame = BlantantFrame.Toggle({
		Text = "Auto Bank",
		Callback = function(Value)
			IClientToggleProperty.AutoBankToggle = IsToggleAble(Value)

			if IClientToggleProperty.AutoBankToggle then
				BindToRenderStep("AutoBank", function()
					if tick() < WithdrawTick then
						return
					end
					WithdrawTick = tick() + 0.15
					if IClientToggleProperty.AutoBankToggle then
						local IsNearNPC = false

						for i, v in next, is do
							local mag = (lplr.Character.HumanoidRootPart.Position - v.Position).magnitude
							if mag <= 15 then
								IsNearNPC = true
							end
						end
						for i, v in next, tu do
							local mag = (lplr.Character.HumanoidRootPart.Position - v.Position).magnitude
							if mag <= 15 then
								IsNearNPC = true
							end
						end

						if isAlive() then
							isWithdrawed = false
							if IsNearNPC then
								if echest == nil then
									echest = ReplicatedStorage.Inventories:FindFirstChild(lplr.Name .. "_personal")
								end
								local chestitems = echest and echest:GetChildren() or {}
								if #chestitems > 0 then
									for i3, v3 in pairs(chestitems) do
										if
											v3:IsA("Accessory")
											and (
												v3.Name == "void_crystal"
												or v3.Name == "emerald"
												or v3.Name == "iron"
												or v3.Name == "diamond"
											)
										then
											task.spawn(function()
												bedwars["ClientHandler"]
													:GetNamespace("Inventory")
													:Get("ChestGetItem")
													:CallServer(echest, v3)
												refreshbank()
											end)
										end
									end
								end
							else
								local chestitems = bedwars["getInventory"](lplr).items
								for i3, v3 in pairs(chestitems) do
									if
										v3.itemType == "void_crystal"
										or v3.itemType == "emerald"
										or v3.itemType == "iron"
										or v3.itemType == "diamond"
									then
										bedwars["ClientHandler"]
											:GetNamespace("Inventory")
											:Get("ChestGiveItem")
											:CallServer(echest, v3.tool)
										refreshbank()
									end
								end
							end
						end

						if autobankui then
							local hotbar = lplr.PlayerGui:FindFirstChild("hotbar")
							if hotbar then
								local healthbar = hotbar["1"]:FindFirstChild("HotbarHealthbarContainer")
								if healthbar then
									autobankui.Position = UDim2.new(0.5, -80, 0, healthbar.AbsolutePosition.Y - 50)
								end
							end
						end
					else
						if not isWithdrawed then
							isWithdrawed = true
							local chestitems = echest and echest:GetChildren() or {}
							if #chestitems > 0 then
								for i3, v3 in pairs(chestitems) do
									if
										v3:IsA("Accessory")
										and (
											v3.Name == "void_crystal"
											or v3.Name == "emerald"
											or v3.Name == "iron"
											or v3.Name == "diamond"
										)
									then
										task.spawn(function()
											bedwars["ClientHandler"]
												:GetNamespace("Inventory")
												:Get("ChestGetItem")
												:CallServer(echest, v3)
											refreshbank()
										end)
									end
								end
							end
						end
					end
				end)
			else
				UnbindFromRenderStep("AutoBank")
				autobankui.Position = UDim2.new(0, 0, 0, -200)
				if not isWithdrawed then
					isWithdrawed = true
					local chestitems = echest and echest:GetChildren() or {}
					if #chestitems > 0 then
						for i3, v3 in pairs(chestitems) do
							if
								v3:IsA("Accessory")
								and (
									v3.Name == "void_crystal"
									or v3.Name == "emerald"
									or v3.Name == "iron"
									or v3.Name == "diamond"
								)
							then
								task.spawn(function()
									bedwars["ClientHandler"]
										:GetNamespace("Inventory")
										:Get("ChestGetItem")
										:CallServer(echest, v3)
									refreshbank()
								end)
							end
						end
					end
				end
			end
		end,
		Enabled = IClientToggleProperty.AutoBankToggle,
	})

	ButtonInGui["Auto Bank"] = { AutoBuyFrame, "AutoBankToggle" }
end

----------// Chest Stealer Handler
do
	local ChestStealerDelay = { ["Value"] = 1 }

	local cheststealerfuncs = {
		Open = function()
			if bedwars["AppController"]:isAppOpen("ChestApp") then
				local chest = lplr.Character:FindFirstChild("ObservedChestFolder")
				local chestitems = chest and chest.Value and chest.Value:GetChildren() or {}
				if #chestitems > 0 then
					for i3, v3 in pairs(chestitems) do
						if v3:IsA("Accessory") then
							task.spawn(function()
								pcall(function()
									bedwars["ClientHandler"]
										:GetNamespace("Inventory")
										:Get("ChestGetItem")
										:CallServer(chest.Value, v3)
								end)
							end)
							task.wait(ChestStealerDelay["Value"] / 100)
						end
					end
				end
			end
		end,
		Closed = function()
			for i, v in pairs(COLLECTION:GetTagged("chest")) do
				if
					(lplr.Character.HumanoidRootPart.Position - v.Position).magnitude <= 18
					and v:FindFirstChild("ChestFolderValue")
				then
					local chest = v:FindFirstChild("ChestFolderValue")
					chest = chest and chest.Value or nil
					local chestitems = chest and chest:GetChildren() or {}
					if #chestitems > 0 then
						bedwars["ClientHandler"]:GetNamespace("Inventory"):Get("SetObservedChest"):SendToServer(chest)
						for i3, v3 in pairs(chestitems) do
							if v3:IsA("Accessory") then
								task.spawn(function()
									pcall(function()
										bedwars["ClientHandler"]
											:GetNamespace("Inventory")
											:Get("ChestGetItem")
											:CallServer(v.ChestFolderValue.Value, v3)
									end)
								end)
								task.wait(ChestStealerDelay["Value"] / 100)
							end
						end
						bedwars["ClientHandler"]:GetNamespace("Inventory"):Get("SetObservedChest"):SendToServer(nil)
					end
				end
			end
		end,
	}

	local WiggleAnimationFrame = BlantantFrame.Toggle({
		Text = "Chest Stealer",
		Callback = function(Value)
			IClientToggleProperty.ChestStealerToggle = IsToggleAble(Value)

			if IClientToggleProperty.ChestStealerToggle then
				BindToRenderStep("ChestStealer", function()
					if IClientToggleProperty.ChestStealerToggle then
					else
						return
					end
					if isAlive() then
						cheststealerfuncs["Open"]()
						cheststealerfuncs["Closed"]()
					end
				end)
			else
				UnbindFromRenderStep("ChestStealer")
			end
		end,
		Enabled = IClientToggleProperty.ChestStealerToggle,
	})

	ButtonInGui["Chest Stealer"] = { WiggleAnimationFrame, "ChestStealerToggle" }
end

----------// Fast Consumer Handler
do
	local shoothook
	local oldchargetime
	local oldclickhold
	local oldclickhold2
	local roact

	local WiggleAnimationFrame = BlantantFrame.Toggle({
		Text = "Insta Consume",
		Callback = function(Value)
			IClientToggleProperty.FastConsumeToggle = IsToggleAble(Value, "FastConsumeToggle")
			if IClientToggleProperty.FastConsumeToggle then
				oldclickhold = bedwars["ClickHold"].startClick
				oldclickhold2 = bedwars["ClickHold"].showProgress
				bedwars["ClickHold"].showProgress = function(p5)
					local roact = debug.getupvalue(oldclickhold2, 1)
					local countdown = roact.mount(
						roact.createElement("ScreenGui", {}, {
							roact.createElement("Frame", {
								[roact.Ref] = p5.wrapperRef,
								Size = UDim2.new(0, 0, 0, 0),
								Position = UDim2.new(0.5, 0, 0.55, 0),
								AnchorPoint = Vector2.new(0.5, 0),
								BackgroundColor3 = Color3.fromRGB(0, 0, 0),
								BackgroundTransparency = 0.8,
							}, {
								roact.createElement("Frame", {
									[roact.Ref] = p5.progressRef,
									Size = UDim2.new(0, 0, 1, 0),
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 0.5,
								}),
							}),
						}),
						lplr:FindFirstChild("PlayerGui")
					)
					p5.handle = countdown
					local sizetween =
						game:GetService("TweenService"):Create(p5.wrapperRef:getValue(), TweenInfo.new(0.1), {
							Size = UDim2.new(0.11, 0, 0.005, 0),
						})
					table.insert(p5.tweens, sizetween)
					sizetween:Play()
					local countdowntween = game:GetService("TweenService"):Create(
						p5.progressRef:getValue(),
						TweenInfo.new(p5.durationSeconds * (0 / 40), Enum.EasingStyle.Linear),
						{
							Size = UDim2.new(1, 0, 1, 0),
						}
					)
					table.insert(p5.tweens, countdowntween)
					countdowntween:Play()
					return countdown
				end
				bedwars["ClickHold"].startClick = function(p4)
					p4.startedClickTime = tick()
					local u2 = p4:showProgress()
					local clicktime = p4.startedClickTime
					bedwars["RuntimeLib"].Promise.defer(function()
						task.wait(p4.durationSeconds * (0 / 40))
						if u2 == p4.handle and clicktime == p4.startedClickTime and p4.closeOnComplete then
							p4:hideProgress()
							if p4.onComplete ~= nil then
								p4.onComplete()
							end
							if p4.onPartialComplete ~= nil then
								p4.onPartialComplete(1)
							end
							p4.startedClickTime = -1
						end
					end)
				end
			else
				if oldclickhold and oldclickhold2 then
					bedwars["ClickHold"].startClick = oldclickhold
					bedwars["ClickHold"].showProgress = oldclickhold2
				end
				oldchargetime = nil
				oldclickhold = nil
				oldclickhold2 = nil
				shoothook = nil
			end
		end,
		Enabled = IClientToggleProperty.FastConsumeToggle,
	})
	ButtonInGui["Insta Consume"] = { WiggleAnimationFrame, "FastConsumeToggle" }
end

----------// Fast Bee Handler
do
	--// Frame
	local AutoBuyFrame = BlantantFrame.Toggle({
		Text = "Instant Bee pickup",
		Callback = function(Value)
			IClientToggleProperty.InstantBeeToggle = IsToggleAble(Value)
		end,
		Enabled = IClientToggleProperty.InstantBeeToggle,
	})

	ButtonInGui["Fast Bee"] = { AutoBuyFrame, "InstantBeeToggle" }
end

----------// Fast Metal Handler
do
	--// Frame
	local AutoBuyFrame = BlantantFrame.Dropdown({
		Text = "Metal Collect Type",
		Callback = function(Value)
			IClientToggleProperty.MetalCollectType = Value
		end,
		Options = { "Normal Speed", "2x Speed", "Instant Collect" },
	})

	ButtonInGui["Metal Collect Type"] = { AutoBuyFrame, "MetalCollectType" }
end

----------// Instant Fishing Handler
do
	local oldfish

	--// Frame
	local AutoBuyFrame = BlantantFrame.Toggle({
		Text = "Instant Fishing",
		Callback = function(Value)
			IClientToggleProperty.InstantFishingToggle = IsToggleAble(Value)

			if IClientToggleProperty.InstantFishingToggle then
				oldfish = bedwars["FishermanTable"].startMinigame
				bedwars["FishermanTable"].startMinigame = function(Self, dropdata, func)
					func({ win = true })
				end
			else
				if oldfish then
					bedwars["FishermanTable"].startMinigame = oldfish
					oldfish = nil
				end
			end
		end,
		Enabled = IClientToggleProperty.InstantFishingToggle,
	})

	ButtonInGui["InstantFishing"] = { AutoBuyFrame, "InstantFishingToggle" }
end

----------// Auto Eat Handler
do
	--// Frame
	local AutoBuyFrame = BlantantFrame.Toggle({
		Text = "Auto Heal",
		Callback = function(Value)
			IClientToggleProperty.AutoHealToggle = IsToggleAble(Value)

			if IClientToggleProperty.AutoHealToggle then
				BindToRenderStep("AutoHeal", function()
					if IClientToggleProperty.AutoHealToggle then
					else
						return
					end
					if isAlive() then
						local item = getItem("apple")
						local shield = getItem("big_shield") or getItem("mini_shield")
						local pot = getItem("heal_splash_potion")
						if item or pot then
							if
								lplr.Character:GetAttribute("Health")
								<= (lplr.Character:GetAttribute("MaxHealth") - (100 - 70))
							then
								if item then
									bedwars["ClientHandler"]:Get(bedwars["EatRemote"]):CallServerAsync({
										["item"] = item["tool"],
									})
								else
									local newray = workspace:Raycast(
										(lplr.character.HumanoidRootPart).Position,
										Vector3.new(0, -76, 0),
										blockraycast
									)
									if newray ~= nil then
										bedwars["ClientHandler"]:Get(bedwars["ProjectileRemote"]):CallServerAsync(
											pot["tool"],
											"heal_splash_potion",
											"heal_splash_potion",
											(lplr.character.HumanoidRootPart).Position,
											Vector3.new(0, -70, 0),
											game:GetService("HttpService"):GenerateGUID(),
											{ drawDurationSeconds = 1 }
										)
									end
								end
							end
						end
						if shield then
							if
								lplr.Character:GetAttribute("Shield_POTION")
								and (
									(not lplr.Character:GetAttribute("Shield_POTION"))
									or lplr.Character:GetAttribute("Shield_POTION") == 0
								)
							then
								bedwars["ClientHandler"]:Get(bedwars["EatRemote"]):CallServerAsync({
									["item"] = shield["tool"],
								})
							end
						end
					end
				end)
			else
				UnbindFromRenderStep("AutoHeal")
			end
		end,
		Enabled = IClientToggleProperty.AutoHealToggle,
	})

	ButtonInGui["Auto Heal"] = { AutoBuyFrame, "AutoHealToggle" }
end

----------// Auto Leave/Queue Handler
do
	local autoleaveconnection

	--// Frame
	local AutoBuyFrame = BlantantFrame.Toggle({
		Text = "Auto Leave",
		Callback = function(Value)
			IClientToggleProperty.AutoLeaveToggle = IsToggleAble(Value, "AutoLeaveToggle")
		end,
		Enabled = IClientToggleProperty.AutoLeaveToggle,
	})

	ButtonInGui["Auto Leave"] = { AutoBuyFrame, "AutoLeaveToggle" }

	--// Frame
	local AutoBuyFrame = BlantantFrame.Toggle({
		Text = "Auto Queue",
		Callback = function(Value)
			IClientToggleProperty.AutoPlayToggle = IsToggleAble(Value, "AutoPlayToggle")
		end,
		Enabled = IClientToggleProperty.AutoPlayToggle,
	})

	ButtonInGui["Auto Queue"] = { AutoBuyFrame, "AutoPlayToggle" }

	connectionstodisconnect[#connectionstodisconnect + 1] = bedwars["ClientHandler"]:OnEvent(
		"MatchEndEvent",
		function(p2)
			if
				bedwars["ClientStoreHandler"]:getState().Game.customMatch == nil
				and bedwars["ClientStoreHandler"]:getState().Party.leader.userId == lplr.UserId
			then
				if IClientToggleProperty.AutoPlayToggle then
					warn("[IClient]: Queueing " .. queueType)
					bedwars["LobbyClientEvents"].joinQueue:fire({
						queueType = queueType,
					})
				else
					if IClientToggleProperty.AutoLeaveToggle then
						bedwars["ClientHandler"]:Get("TeleportToLobby"):SendToServer()
					end
				end
			end
		end
	)

	autoleaveconnection = PLAYERS.PlayerAdded:connect(function(plr)
		task.spawn(function()
			pcall(function()
				if
					plr:IsInGroup(5774246)
					and plr:GetRankInGroup(5774246) >= 100
					and (plr.UserId ~= 87365146 or shared.VapePrivate)
				then
					if IClientToggleProperty.AutoLeaveToggle then
						coroutine.resume(coroutine.create(function()
							ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
								"/Bedwars all",
								"All"
							)
						end))
						game:GetService("StarterGui"):SetCore("SendNotification", {
							Title = "IClient",
							Text = "Staff Detected\n"
								.. (plr.DisplayName and plr.DisplayName .. " (" .. plr.Name .. ")" or plr.Name),
							Duration = 60,
						})
						return
					end
				end
			end)
		end)
	end)
end

----------// SpinBot
do
	local bodyspin

	--// Frame
	local AutoBuyFrame = BlantantFrame.Toggle({
		Text = "SpinBot",
		Callback = function(Value)
			IClientToggleProperty.SpinBotToggle = IsToggleAble(Value, "AutoLeaveToggle")
			if IClientToggleProperty.SpinBotToggle then
				BindToRenderStep("SpinBot", function()
					if isAlive() then
						if bodyspin == nil or bodyspin ~= nil and bodyspin.Parent ~= lplr.Character then
							bodyspin = Instance.new("BodyAngularVelocity")
							bodyspin.MaxTorque = Vector3.new(0, math.huge, 0)
							bodyspin.AngularVelocity = Vector3.new(0, 40, 0)
							bodyspin.Parent = lplr.Character.HumanoidRootPart
						else
							bodyspin.AngularVelocity = Vector3.new(0, 40, 0)
						end
					end
				end)
			else
				UnbindFromRenderStep("SpinBot")
				if bodyspin then
					bodyspin.AngularVelocity = Vector3.new(0, 0, 0)
					bodyspin:Destroy()
				end
			end
		end,
		Enabled = IClientToggleProperty.SpinBotToggle,
	})

	ButtonInGui["SpinBot"] = { AutoBuyFrame, "SpinBotToggle" }
end

----------// Immortal
do
	--// Frame
	local AutoBuyFrame = BlantantFrame.Button({
		Text = "Be a person who cant do anything in exchange of not dying to most damage",
		Callback = function(Value)
			--[[
			lplr.Character.Humanoid.Health = -5
			for i = 1, 5 do
				lplr.Character.Humanoid.Health = -5
				task.wait(0.5)
			end
			]]
			local Char = lplr.Character
			local OldParent = Char.Parent
			local HRP = Char and Char:FindFirstChild("HumanoidRootPart")
			local OldPos = HRP.CFrame
			Char.Parent = game
			local HRP1 = HRP:Clone()
			HRP1.Parent = Char
			HRP = HRP:Destroy()
			HRP1.CFrame = OldPos
			Char.Parent = OldParent
			task.wait()
			lplr.Character.Humanoid.Health = -5
		end,
	})
end

----------// Immortal Fly
do
	function getRoot(char)
		local rootPart = char:FindFirstChild("HumanoidRootPart")
			or char:FindFirstChild("Torso")
			or char:FindFirstChild("UpperTorso")
		return rootPart
	end

	FLYING = false
	QEfly = true
	iyflyspeed = 1
	vehicleflyspeed = 1
	local flyKeyDown, flyKeyUp
	function sFLY(vfly)
		repeat
			wait()
		until lplr and lplr.Character and getRoot(lplr.Character) and lplr.Character:FindFirstChildOfClass("Humanoid")
		repeat
			wait()
		until mouse
		if flyKeyDown or flyKeyUp then
			flyKeyDown:Disconnect()
			flyKeyUp:Disconnect()
		end

		local T = getRoot(lplr.Character)
		local CONTROL = { F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0 }
		local lCONTROL = { F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0 }
		local SPEED = 0

		local function FLY()
			FLYING = true
			local BG = Instance.new("BodyGyro")
			local BV = Instance.new("BodyVelocity")
			--BG.P = 9e4
			--BG.Parent = T
			BV.Parent = T
			--BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
			--BG.cframe = T.CFrame
			BV.velocity = Vector3.new(0, 0, 0)
			BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
			task.spawn(function()
				repeat
					task.wait()
					if not vfly and lplr.Character:FindFirstChildOfClass("Humanoid") then
						lplr.Character:FindFirstChildOfClass("Humanoid").PlatformStand = true
					end
					if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
						SPEED = 50
					elseif
						not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0)
						and SPEED ~= 0
					then
						SPEED = 0
					end
					if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
						BV.velocity = (
							(workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B))
							+ (
								(
									workspace.CurrentCamera.CoordinateFrame
									* CFrame.new(
										CONTROL.L + CONTROL.R,
										(CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2,
										0
									).p
								) - workspace.CurrentCamera.CoordinateFrame.p
							)
						) * SPEED
						lCONTROL = { F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R }
					elseif
						(CONTROL.L + CONTROL.R) == 0
						and (CONTROL.F + CONTROL.B) == 0
						and (CONTROL.Q + CONTROL.E) == 0
						and SPEED ~= 0
					then
						BV.velocity = (
							(workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B))
							+ (
								(
									workspace.CurrentCamera.CoordinateFrame
									* CFrame.new(
										lCONTROL.L + lCONTROL.R,
										(lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2,
										0
									).p
								) - workspace.CurrentCamera.CoordinateFrame.p
							)
						) * SPEED
					else
						BV.velocity = Vector3.new(0, 0, 0)
					end
				--BG.cframe = workspace.CurrentCamera.CoordinateFrame
				until not FLYING
				CONTROL = { F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0 }
				lCONTROL = { F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0 }
				SPEED = 0
				BG:Destroy()
				BV:Destroy()
				if lplr.Character:FindFirstChildOfClass("Humanoid") then
					lplr.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
				end
			end)
		end

		flyKeyDown = mouse.KeyDown:Connect(function(KEY)
			if KEY:lower() == "w" then
				CONTROL.F = (vfly and vehicleflyspeed or iyflyspeed)
			elseif KEY:lower() == "s" then
				CONTROL.B = -(vfly and vehicleflyspeed or iyflyspeed)
			elseif KEY:lower() == "a" then
				CONTROL.L = -(vfly and vehicleflyspeed or iyflyspeed)
			elseif KEY:lower() == "d" then
				CONTROL.R = (vfly and vehicleflyspeed or iyflyspeed)
			elseif QEfly and KEY:lower() == "e" then
				CONTROL.Q = (vfly and vehicleflyspeed or iyflyspeed) * 2
			elseif QEfly and KEY:lower() == "q" then
				CONTROL.E = -(vfly and vehicleflyspeed or iyflyspeed) * 2
			end
			pcall(function()
				workspace.CurrentCamera.CameraType = Enum.CameraType.Track
			end)
		end)

		flyKeyUp = mouse.KeyUp:Connect(function(KEY)
			if KEY:lower() == "w" then
				CONTROL.F = 0
			elseif KEY:lower() == "s" then
				CONTROL.B = 0
			elseif KEY:lower() == "a" then
				CONTROL.L = 0
			elseif KEY:lower() == "d" then
				CONTROL.R = 0
			elseif KEY:lower() == "e" then
				CONTROL.Q = 0
			elseif KEY:lower() == "q" then
				CONTROL.E = 0
			end
		end)
		FLY()
	end

	function NOFLY()
		FLYING = false
		if flyKeyDown or flyKeyUp then
			flyKeyDown:Disconnect()
			flyKeyUp:Disconnect()
		end
		if lplr.Character:FindFirstChildOfClass("Humanoid") then
			lplr.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
		end
		pcall(function()
			workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
		end)
	end

	--// Frame
	local AutoBuyFrame = BlantantFrame.Button({
		Text = "Fly (For above)",
		Callback = function(Value)
			if FLYING then
				NOFLY()
			else
				sFLY()
			end
		end,
	})
end

----------// Auto Report
do
	local LoggedPerson = {}

	--// Frame
	local AutoBuyFrame = BlantantFrame.Toggle({
		Text = "Auto Report",
		Callback = function(Value)
			IClientToggleProperty.AutoReportToggle = IsToggleAble(Value)

			if IClientToggleProperty.AutoReport then
				BindToRenderStep("AutoReport", function()
					if IClientToggleProperty.AutoReportToggle then
						for i, v in pairs(PLAYERS:GetPlayers()) do
							if not LoggedPerson[v] and v ~= lplr then
								LoggedPerson[v] = true
								PLAYERS:ReportAbuse(v, "Swearing", "Player did a bad thing!")
							end
						end
					end
				end)
			else
				UnbindFromRenderStep("AutoReport")
			end
		end,
		Enabled = IClientToggleProperty.AutoReportToggle,
	})
end

--------------------------------------// Animation Tab
----------// AutoPlay Handler
do
	local Connection = {}
	local WiggleAnimationFrame = AnimationTab.Toggle({
		Text = "AutoPlay",
		Callback = function(Value)
			IClientToggleProperty.AnimationAutoPlay = IsToggleAble(Value)
			if IClientToggleProperty.AnimationAutoPlay then
				Connection["CharacterAdded"] = lplr.CharacterAdded:Connect(function(char)
					PlayFunction()
				end)

				Connection["TeamUpdate"] = lplr:GetPropertyChangedSignal("Team"):Connect(function()
					PlayFunction()
				end)

				if isAlive() then
					PlayFunction()
				end
			else
				for i, v in pairs(Connection) do
					v:Disconnect()
				end
			end
		end,
		Enabled = IClientToggleProperty.AnimationAutoPlay,
	})
end

----------// NONE Animation
do
	local WiggleAnimationFrame = AnimationTab.Button({
		Text = "None",
		Callback = function(Value)
			if CurrentAnimation then
				CurrentAnimation:Stop()
				CurrentAnimation = nil
			end
		end,
	})
end

----------// Wiggle Animation
do
	local WiggleAnimationFrame = AnimationTab.Button({
		Text = "Wiggle",
		Callback = function(Value)
			IClientToggleProperty.CurrentPickAnimationId = 162
			if CurrentAnimation then
				CurrentAnimation:Stop()
			end
			PlayFunction()
		end,
	})
end

----------// Rock Out Animation
do
	local WiggleAnimationFrame = AnimationTab.Button({
		Text = "Rock Out",
		Callback = function(Value)
			IClientToggleProperty.CurrentPickAnimationId = 127
			if CurrentAnimation then
				CurrentAnimation:Stop()
			end
			PlayFunction()
		end,
	})
end

----------// Side To Side Animation
do
	local WiggleAnimationFrame = AnimationTab.Button({
		Text = "Side To Side",
		Callback = function(Value)
			IClientToggleProperty.CurrentPickAnimationId = 129
			if CurrentAnimation then
				CurrentAnimation:Stop()
			end
			PlayFunction()
		end,
	})
end

----------// Side To Side Animation
do
	local WiggleAnimationFrame = AnimationTab.Button({
		Text = "Party Up",
		Callback = function(Value)
			IClientToggleProperty.CurrentPickAnimationId = 128
			if CurrentAnimation then
				CurrentAnimation:Stop()
			end
			PlayFunction()
		end,
	})
end

----------// Nightmare Animation
do
	local WiggleAnimationFrame = AnimationTab.Button({
		Text = "Nightmare",
		Callback = function(Value)
			IClientToggleProperty.CurrentPickAnimationId = 134
			if CurrentAnimation then
				CurrentAnimation:Stop()
			end
			PlayFunction()
		end,
	})
end

----------// Ascend Animation
do
	local WiggleAnimationFrame = AnimationTab.Button({
		Text = "Ascend",
		Callback = function(Value)
			IClientToggleProperty.CurrentPickAnimationId = 34
			if CurrentAnimation then
				CurrentAnimation:Stop()
			end
			PlayFunction()
		end,
	})
end

----------// Charge Shield Animation
do
	local WiggleAnimationFrame = AnimationTab.Button({
		Text = "Charge Shield Charge",
		Callback = function(Value)
			IClientToggleProperty.CurrentPickAnimationId = 42
			if CurrentAnimation then
				CurrentAnimation:Stop()
			end
			PlayFunction()
			CurrentAnimation.Looped = true
		end,
	})
end

----------// Coward
do
	local WiggleAnimationFrame = AnimationTab.Button({
		Text = "Cower",
		Callback = function(Value)
			if CurrentAnimation then
				CurrentAnimation:Stop()
			end
			IClientToggleProperty.CurrentPickAnimationId = 4940563117
			PlayFunction()
		end,
	})
end

----------// Floss
do
	local WiggleAnimationFrame = AnimationTab.Button({
		Text = "Floss",
		Callback = function(Value)
			if CurrentAnimation then
				CurrentAnimation:Stop()
			end
			IClientToggleProperty.CurrentPickAnimationId = 5917459365

			PlayFunction()
		end,
	})
end

----------// T pose
do
	local WiggleAnimationFrame = AnimationTab.Button({
		Text = "T Pose",
		Callback = function(Value)
			if CurrentAnimation then
				CurrentAnimation:Stop()
			end
			IClientToggleProperty.CurrentPickAnimationId = 3338010159
			PlayFunction()
		end,
	})
end
