-- Pickaxe rest pose + swing (left click, hold to keep swinging). At the swing's "Contact"
-- marker it asks the server to mine the coal rock in front of you. Coal is awarded only by
-- MiningServer; the "+N" text and sound here are local predictions so hits feel instant.

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")
local Debris = game:GetService("Debris")
local KeyframeSequenceProvider = game:GetService("KeyframeSequenceProvider")

local Config = require(RS.Modules.Config)
local Remotes = RS.RemoteEvents
local ImpactSound = RS.Effects:WaitForChild("MineImpactSound")
local AnimationSources = RS.Assets:WaitForChild("Animations")

local GOLD = Color3.fromHex("FFD23F")
local RED = Color3.fromHex("FF5A5A")
local OUTLINE = Color3.fromHex("1E1A2E")

local player = Players.LocalPlayer
local hud = { Cart = 0, CartCapacity = Config.StartCartCapacity, Power = Config.StartPower }
Remotes.UpdateHUDEvent.OnClientEvent:Connect(function(data)
	if data then
		hud = data
	end
end)

local registered = {}
local function loadTrack(animator, publishedId, name)
	local id
	if publishedId ~= "" then
		id = "rbxassetid://" .. publishedId
	elseif RunService:IsStudio() then
		registered[name] = registered[name] or KeyframeSequenceProvider:RegisterKeyframeSequence(AnimationSources:WaitForChild(name))
		id = registered[name]
	else
		warn("[MiningClient] " .. name .. " has no published id in Config.Animations")
		return nil
	end
	local animation = Instance.new("Animation")
	animation.AnimationId = id
	return animator:LoadAnimation(animation)
end

local function findTarget(root)
	local look = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z).Unit
	local best, bestScore
	for _, node in ipairs(CollectionService:GetTagged("CoalNode")) do
		local hitbox = node.PrimaryPart
		if hitbox then
			local toNode = hitbox.Position - root.Position
			local reach = (hud.Reach or Config.MineRange) + math.max(hitbox.Size.X, hitbox.Size.Z) / 2
			local distance = toNode.Magnitude
			if distance <= reach then
				local flat = Vector3.new(toNode.X, 0, toNode.Z)
				local facing = flat.Magnitude > 3 and look:Dot(flat.Unit) or 1
				if facing >= Config.MineFacingDotThreshold then
					local score = distance - facing * 3
					if not bestScore or score < bestScore then
						best, bestScore = node, score
					end
				end
			end
		end
	end
	return best
end

local function floatText(hitbox, root, text, color)
	local toPlayer = Vector3.new(root.Position.X - hitbox.Position.X, 0, root.Position.Z - hitbox.Position.Z)
	local side = toPlayer.Magnitude > 0 and toPlayer.Unit * (hitbox.Size.Z / 2) or Vector3.zero
	local start = side + Vector3.new((math.random() - 0.5) * 1.2, 1, (math.random() - 0.5) * 1.2)
	local billboard = Instance.new("BillboardGui")
	billboard.Adornee = hitbox
	billboard.Size = UDim2.fromOffset(170, 46)
	billboard.StudsOffsetWorldSpace = start
	billboard.AlwaysOnTop = true
	billboard.Parent = player.PlayerGui
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.fromScale(1, 1)
	label.Font = Enum.Font.FredokaOne
	label.TextScaled = true
	label.TextColor3 = color
	label.Text = text
	label.Parent = billboard
	local stroke = Instance.new("UIStroke")
	stroke.Color = OUTLINE
	stroke.Thickness = 2.5
	stroke.Parent = label
	local info = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(billboard, info, { StudsOffsetWorldSpace = start + Vector3.new(0, 2.5, 0) }):Play()
	TweenService:Create(label, info, { TextTransparency = 1 }):Play()
	TweenService:Create(stroke, info, { Transparency = 1 }):Play()
	Debris:AddItem(billboard, 0.85)
end

local function impact(hitbox)
	local sound = ImpactSound:Clone()
	sound.Parent = hitbox
	sound:Play()
	Debris:AddItem(sound, 3)
end

local function onPickaxe(tool, character)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
	local root = character:FindFirstChild("HumanoidRootPart")
	if not animator or not root then
		return
	end
	local rest = loadTrack(animator, Config.Animations.RestId, "PickaxeRest")
	local swing = loadTrack(animator, Config.Animations.SwingId, "PickaxeSwing")
	if rest then
		rest:Play(0.25)
	end

	local holding, swinging, target = false, false, nil
	local connections = {}

	-- Consumes the target so a stray or repeated marker can never mine twice per swing.
	local function onContact()
		if not swinging then
			return
		end
		local node = target
		target = nil
		local hitbox = node and node.Parent and node.PrimaryPart
		if not hitbox then
			return
		end
		local room = hud.CartCapacity - hud.Cart
		if room <= 0 then
			floatText(hitbox, root, "Cart full! Burn it", RED)
			return
		end
		Remotes.MineNodeEvent:FireServer(node)
		local amount = math.min(hud.Power or Config.StartPower, node:GetAttribute("Units") or 0, room)
		if amount > 0 then
			floatText(hitbox, root, "+" .. amount, GOLD)
		end
		impact(hitbox)
	end
	if swing then
		table.insert(connections, swing:GetMarkerReachedSignal("Contact"):Connect(onContact))
	end

	local function swingOnce()
		local speed = hud.SwingSpeed or 1
		swinging = true
		target = findTarget(root)
		if target then
			local p = target.PrimaryPart.Position
			local flat = Vector3.new(p.X, root.Position.Y, p.Z)
			if (flat - root.Position).Magnitude > 0.5 then
				root.CFrame = CFrame.lookAt(root.Position, flat)
			end
		end
		if swing then
			swing:Play(0.05, 1, speed)
			task.wait(Config.SwingDuration / speed)
		else
			task.wait(0.3 / speed)
			onContact()
			task.wait((Config.SwingDuration - 0.3) / speed)
		end
		swinging = false
	end

	table.insert(connections, tool.Activated:Connect(function()
		if player:GetAttribute("MenuOpen") then return end
		holding = true
		if not swinging then
			task.spawn(function()
				while holding and tool.Parent == character and not player:GetAttribute("MenuOpen") do
					swingOnce()
				end
			end)
		end
	end))
	table.insert(connections, tool.Deactivated:Connect(function()
		holding = false
	end))

	local unequip
	unequip = tool.Unequipped:Connect(function()
		holding = false
		unequip:Disconnect()
		for _, c in ipairs(connections) do
			c:Disconnect()
		end
		if rest then rest:Stop(0.2) end
		if swing then swing:Stop(0.1) end
	end)
end

local function onCharacter(character)
	local function check(child)
		if child:IsA("Tool") and string.match(child.Name, "^Pickaxe_") then
			onPickaxe(child, character)
		end
	end
	character.ChildAdded:Connect(check)
	for _, child in ipairs(character:GetChildren()) do
		check(child)
	end
end

player.CharacterAdded:Connect(onCharacter)
if player.Character then
	onCharacter(player.Character)
end
