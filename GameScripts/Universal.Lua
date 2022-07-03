--// Main Varibles
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function Cape(char, texture)
	for i,v in pairs(char:GetDescendants()) do
		if v.Name == "Cape" then
			v:Remove()
		end
	end
	local hum = char:WaitForChild("Humanoid")
	local torso = nil
	if hum.RigType == Enum.HumanoidRigType.R15 then
		torso = char:WaitForChild("UpperTorso")
	else
		torso = char:WaitForChild("Torso")
	end
	local p = Instance.new("Part", torso.Parent)
	p.Name = "Cape"
	p.Anchored = false
	p.CanCollide = false
	p.TopSurface = 0
	p.BottomSurface = 0
	p.FormFactor = "Custom"
	p.Size = Vector3.new(0.2,0.2,0.2)
	p.Transparency = 0
	p.BrickColor = BrickColor.new("Black")
	local decal = Instance.new("Decal", p)
	decal.Texture = texture
	decal.Face = "Back"
	local msh = Instance.new("BlockMesh", p)
	msh.Scale = Vector3.new(9,17.5,0.5)
	local motor = Instance.new("Motor", p)
	motor.Part0 = p
	motor.Part1 = torso
	motor.MaxVelocity = 0.01
	motor.C0 = CFrame.new(0,2,0) * CFrame.Angles(0,math.rad(90),0)
	motor.C1 = CFrame.new(0,1,0.45) * CFrame.Angles(0,math.rad(90),0)
	local wave = false
	repeat wait(1/44)
		decal.Transparency = torso.Transparency
		local ang = 0.1
		local oldmag = torso.Velocity.magnitude
		local mv = 0.002
		if wave then
			ang = ang + ((torso.Velocity.magnitude/10) * 0.05) + 0.05
			wave = false
		else
			wave = true
		end
		ang = ang + math.min(torso.Velocity.magnitude/11, 0.5)
		motor.MaxVelocity = math.min((torso.Velocity.magnitude/111), 0.04) --+ mv
		motor.DesiredAngle = -ang
		if motor.CurrentAngle < -0.2 and motor.DesiredAngle > -0.2 then
			motor.MaxVelocity = 0.04
		end
		repeat wait() until motor.CurrentAngle == motor.DesiredAngle or math.abs(torso.Velocity.magnitude - oldmag) >= (torso.Velocity.magnitude/10) + 1
		if torso.Velocity.magnitude < 0.1 then
			wait(0.1)
		end
	until not p or p.Parent ~= torso.Parent
end

local function isAlive(plr)
	local plr = plr or LocalPlayer
	if plr and plr.Character and ((plr.Character:FindFirstChild("Humanoid")) and (plr.Character:FindFirstChild("Humanoid").Health > 0) and (plr.Character:FindFirstChild("HumanoidRootPart")) and (plr.Character:FindFirstChild("Head"))) then
		return true
	end
end

--------------------------------------// Cosmetics Tab
----------// Cape
do
	local Capeconnection

	local WiggleAnimationFrame = shared.TabInGui["Cosmetics"].Toggle({
		Text = "Cape",
		Callback = function(Value)
			shared.IClientToggledProperty.CosmeticCape  = Value
			if shared.IClientToggledProperty.CosmeticCape then
				Capeconnection = LocalPlayer.CharacterAdded:Connect(function(char)
					task.spawn(function()
							pcall(function() 
								Cape(char, "rbxassetid://880811505")
							end)
						end)
				end)
				if LocalPlayer.Character then
					task.spawn(function()
						pcall(function() 
							Cape(LocalPlayer.Character, "rbxassetid://880811505")
						end)
					end)
				end
			else
				if Capeconnection then
					Capeconnection:Disconnect()
				end
				if LocalPlayer.Character then
					for i,v in pairs(LocalPlayer.Character:GetDescendants()) do
						if v.Name == "Cape" then
							v:Destroy()
						end
					end
				end
			end
		end,
		Enabled = shared.IClientToggledProperty.CosmeticCape
	})

	shared.ButtonInGui["Cape"] = {WiggleAnimationFrame,"CosmeticCape"}


end

----------// Trail
do
	local breadcrumbtrail = nil
	local breadcrumbattachment
	local breadcrumbattachment2
	local WiggleAnimationFrame = shared.TabInGui["Cosmetics"].Toggle({
		Text = "Walk Trail",
		Callback = function(Value)
			shared.IClientToggledProperty.CosmeticWalkTrail = Value 
		end,
		Enabled = shared.IClientToggledProperty.CosmeticWalkTrail
	})

	shared.ButtonInGui["Walk Trail"] = {WiggleAnimationFrame,"CosmeticWalkTrail"}


	game:GetService("RunService").Heartbeat:Connect(function()
		if shared.IClientToggledProperty.CosmeticWalkTrail then
			if isAlive() then
				if breadcrumbtrail == nil then
					breadcrumbattachment = Instance.new("Attachment")
					breadcrumbattachment.Position = Vector3.new(0, 0.07 - 2.9, 0.5)
					breadcrumbattachment2 = Instance.new("Attachment")
					breadcrumbattachment2.Position = Vector3.new(0, -0.07 - 2.9, 0.5)
					breadcrumbtrail = Instance.new("Trail")
					breadcrumbtrail.Attachment0 = breadcrumbattachment 
					breadcrumbtrail.Attachment1 = breadcrumbattachment2
					breadcrumbtrail.Color = ColorSequence.new(Color3.new(1, 0, 0), Color3.new(0, 0, 1))
					breadcrumbtrail.FaceCamera = true
					breadcrumbtrail.Lifetime = (20 / 100)
					breadcrumbtrail.Enabled = true
					breadcrumbtrail.Parent = LocalPlayer.Character
				else
					local trailfound = false
					for i,v in pairs(LocalPlayer.Character:GetChildren()) do
						if v:IsA("Trail") then
							if trailfound then	
								v:Destroy()
							else
								trailfound = true
							end
						end
					end
					breadcrumbattachment.Parent = LocalPlayer.character.HumanoidRootPart
					breadcrumbattachment2.Parent = LocalPlayer.character.HumanoidRootPart
					breadcrumbtrail.Parent = LocalPlayer.Character
				end
			end
		else
			if breadcrumbtrail then
				breadcrumbtrail:Destroy()
				if isAlive() then 
					for i,v in pairs(LocalPlayer.Character:GetChildren()) do
						if v:IsA("Trail") then
							v:Destroy()
						end
					end
				end
				breadcrumbtrail = nil
			end
		end
	end)

end

