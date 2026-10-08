-- Coal nodes in the cave, the hidden diamond, per-zone progress and the run reset.
-- Server-authoritative: the diamond's node is only ever held in locals here, so clients can't
-- find it early. Progress is published as attributes on ReplicatedStorage.MineProgress:
--   Total, Mined, DiamondFound, and per zone Z_<key>_Total / Z_<key>_Mined / ZoneName_<key>.

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")

local Config = require(RS.Modules.Config)
local PlayerData = require(script.Parent.Parent.Data.PlayerData)
local Remotes = RS.RemoteEvents

local nodesFolder = workspace:WaitForChild("CoalNodes")

local progress = RS:FindFirstChild("MineProgress") or Instance.new("Configuration")
progress.Name = "MineProgress"
progress.Parent = RS

local function zoneKey(zone)
	return (string.gsub(zone, "[^%w]", "_"))
end

-- Untagged copies of the starting nodes, so the mine can be rebuilt after the diamond is found.
local snapshot = Instance.new("Folder")
snapshot.Name = "CoalNodeSnapshot"
snapshot.Parent = SS
for _, node in ipairs(nodesFolder:GetChildren()) do
	local copy = node:Clone()
	CollectionService:RemoveTag(copy, "CoalNode")
	copy.Parent = snapshot
end

local diamondNode, diamondAt
local diamondFound = false
local lastHit = {}

local function liveNodes()
	local list = {}
	for _, node in ipairs(CollectionService:GetTagged("CoalNode")) do
		if node:IsDescendantOf(nodesFolder) then
			table.insert(list, node)
		end
	end
	return list
end

local function resetProgress(nodes)
	for name in pairs(progress:GetAttributes()) do
		progress:SetAttribute(name, nil)
	end
	local total, zones = 0, {}
	for _, node in ipairs(nodes) do
		local units = node:GetAttribute("MaxUnits") or 0
		local zone = node:GetAttribute("Zone") or "Mine"
		local key = zoneKey(zone)
		total += units
		zones[key] = (zones[key] or 0) + units
		progress:SetAttribute("ZoneName_" .. key, zone)
	end
	for key, units in pairs(zones) do
		progress:SetAttribute("Z_" .. key .. "_Total", units)
		progress:SetAttribute("Z_" .. key .. "_Mined", 0)
	end
	progress:SetAttribute("Total", total)
	progress:SetAttribute("Mined", 0)
	progress:SetAttribute("DiamondFound", false)
end

-- One coal unit out of the whole mine, picked uniformly.
local function hideDiamond(nodes)
	local total = 0
	for _, node in ipairs(nodes) do
		total += node:GetAttribute("MaxUnits")
	end
	local pick = Random.new():NextInteger(1, total)
	for _, node in ipairs(nodes) do
		local units = node:GetAttribute("MaxUnits")
		if pick <= units then
			diamondNode = node
			-- pops out once this node has been mined down past this many remaining units
			diamondAt = units - pick
			return
		end
		pick -= units
	end
end

local function startRun()
	diamondFound = false
	local nodes = liveNodes()
	resetProgress(nodes)
	hideDiamond(nodes)
	for player in pairs(PlayerData.All()) do
		PlayerData.ResetRun(player)
	end
end

local function regenerate()
	for _, node in ipairs(liveNodes()) do
		node:Destroy()
	end
	for _, saved in ipairs(snapshot:GetChildren()) do
		local node = saved:Clone()
		node.Parent = nodesFolder
		CollectionService:AddTag(node, "CoalNode")
	end
	startRun()
end

local function spawnPosition()
	local spawn = workspace:FindFirstChild("SpawnLocation", true)
	return spawn and spawn.Position + Vector3.new(0, 5, 0) or Vector3.new(0, 10, 0)
end

local function onDiamondFound(player, node)
	diamondFound = true
	progress:SetAttribute("DiamondFound", true)
	local where = (node.PrimaryPart or node:FindFirstChildWhichIsA("BasePart")).Position
	local finderRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	for other, profile in pairs(PlayerData.All()) do
		local shards = math.floor(profile.RunContribution / Config.UnitsPerShard)
		if other == player then
			shards += Config.FinderShardBonus
		end
		profile.Shards += shards
		PlayerData.Push(other)
		Remotes.RunEvent:FireClient(other, "DiamondFound", {
			Finder = player.DisplayName,
			Position = where,
			FinderPosition = finderRoot and finderRoot.Position or nil,
			ShardsEarned = shards,
			RegenerateIn = Config.RegenerateDelay,
		})
	end
	task.delay(Config.RegenerateDelay, function()
		regenerate()
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Character then
				p.Character:PivotTo(CFrame.new(spawnPosition()))
			end
			Remotes.RunEvent:FireClient(p, "RunStarted")
		end
	end)
end

local function onMine(player, node)
	if diamondFound or typeof(node) ~= "Instance" or not node:IsA("Model") then
		return
	end
	if not CollectionService:HasTag(node, "CoalNode") or not node:IsDescendantOf(nodesFolder) then
		return
	end
	local profile = PlayerData.Get(player)
	if not profile then return end
	local now = os.clock()
	if lastHit[player] and now - lastHit[player] < Config.MineCooldown / profile.SwingSpeed then
		return
	end
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local tool = character and character:FindFirstChildOfClass("Tool")
	if not root or not tool or not string.match(tool.Name, "^Pickaxe_") then
		return
	end
	local hitbox = node.PrimaryPart or node:FindFirstChild("Hitbox")
	if not hitbox then
		return
	end
	local toNode = hitbox.Position - root.Position
	local reach = profile.Reach + math.max(hitbox.Size.X, hitbox.Size.Z) / 2
	if toNode.Magnitude > reach then
		return
	end
	local flat = Vector3.new(toNode.X, 0, toNode.Z)
	local look = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
	if flat.Magnitude > 3 and look.Unit:Dot(flat.Unit) < Config.MineFacingDotThreshold then
		return
	end

	local units = node:GetAttribute("Units") or 0
	if not profile or units <= 0 then
		return
	end
	local room = profile.CartCapacity - profile.Cart
	if room <= 0 then
		return
	end
	local amount = math.min(profile.Power, units, room)
	lastHit[player] = now

	units -= amount
	node:SetAttribute("Units", units)
	profile.Cart += amount
	profile.RunContribution += amount

	local key = zoneKey(node:GetAttribute("Zone") or "Mine")
	progress:SetAttribute("Z_" .. key .. "_Mined", (progress:GetAttribute("Z_" .. key .. "_Mined") or 0) + amount)
	progress:SetAttribute("Mined", (progress:GetAttribute("Mined") or 0) + amount)
	PlayerData.Push(player)

	if node == diamondNode and units <= diamondAt then
		onDiamondFound(player, node)
	end
	if units <= 0 then
		node:Destroy()
	end
end

Remotes.MineNodeEvent.OnServerEvent:Connect(onMine)
Players.PlayerRemoving:Connect(function(player)
	lastHit[player] = nil
end)

-- Studio-only test hook: ServerStorage.DevTools.ForceDiamond:Invoke(player) finds the diamond in
-- the coal rock nearest that player, so the celebration can be tested without mining a million units.
if game:GetService("RunService"):IsStudio() then
	local devTools = SS:FindFirstChild("DevTools")
	if devTools then
		local hook = devTools:FindFirstChild("ForceDiamond") or Instance.new("BindableFunction")
		hook.Name = "ForceDiamond"
		hook.Parent = devTools
		hook.OnInvoke = function(player)
			local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			if diamondFound or not root then
				return false
			end
			local best, bestDistance
			for _, node in ipairs(liveNodes()) do
				local d = (node:GetPivot().Position - root.Position).Magnitude
				if not bestDistance or d < bestDistance then
					best, bestDistance = node, d
				end
			end
			if best then
				onDiamondFound(player, best)
			end
			return best ~= nil
		end
	end
end

startRun()
