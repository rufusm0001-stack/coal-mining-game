-- Map QA: run with execute_luau (Edit). Reports floating, tipped, unanchored and non-Plastic
-- decor, per top-level folder. Ground = StudTerrain plus anything else solid that isn't the prop.
-- Returns a summary string; set FIX = true to also lower floating props onto the ground.

local FIX = false
local FOLDERS = { "VoxelScenery", "CaveDecor", "MineSystems", "TownSquare", "HouseLobby", "ValleyDecor",
	"PickaxeShop", "Workshop", "BlockyTownFountain", "SellStand", "AdaCamp", "DiamondLeaderboard", "CoalNodes", "MineCartLine" }
local ALLOWED_MATERIALS = { [Enum.Material.Plastic] = true, [Enum.Material.SmoothPlastic] = true,
	[Enum.Material.Neon] = true, [Enum.Material.Glass] = true, [Enum.Material.ForceField] = true }

local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Exclude

local counts, worst = {}, {}
local function bump(cat, name, value)
	counts[cat] = (counts[cat] or 0) + 1
	table.insert(worst, { cat = cat, name = name, value = value or 0 })
end

local function bounds(obj)
	if obj:IsA("BasePart") then return obj.CFrame, obj.Size end
	return obj:GetBoundingBox()
end

local function gapUnder(obj)
	local cf, size = bounds(obj)
	params.FilterDescendantsInstances = { obj, workspace.CurrentCamera }
	local bottom = cf.Position.Y - size.Y / 2
	local maxGap, minGap = 0, math.huge
	local hx, hz = math.max(size.X / 2 - 0.3, 0), math.max(size.Z / 2 - 0.3, 0)
	for _, o in ipairs({ { 0, 0 }, { hx, hz }, { -hx, hz }, { hx, -hz }, { -hx, -hz } }) do
		local p = cf.Position + cf.RightVector * o[1] + cf.LookVector * o[2]
		local hit = workspace:Raycast(Vector3.new(p.X, bottom + 0.5, p.Z), Vector3.new(0, -60, 0), params)
		local g = hit and (bottom - hit.Position.Y) or 60
		maxGap = math.max(maxGap, g)
		minGap = math.min(minGap, g)
	end
	return minGap, maxGap
end

local function check(obj, folder)
	local name = folder .. "." .. obj.Name
	local minGap, maxGap = gapUnder(obj)
	if minGap > 0.25 and minGap < 60 then
		bump("floating", name, minGap)
		if FIX then
			if obj:IsA("BasePart") then obj.CFrame -= Vector3.new(0, minGap - 0.05, 0)
			else obj:PivotTo(obj:GetPivot() - Vector3.new(0, minGap - 0.05, 0)) end
		end
	elseif maxGap > 0.6 and maxGap < 60 then
		bump("corner_hanging", name, maxGap)
	end
	if obj:IsA("Model") then
		local up = obj:GetPivot().UpVector.Y
		if up < 0.97 then bump("tipped", name, up) end
	end
	for _, p in ipairs(obj:IsA("BasePart") and { obj } or obj:GetDescendants()) do
		if p:IsA("BasePart") then
			if not p.Anchored then bump("unanchored", name) break end
			if not ALLOWED_MATERIALS[p.Material] and not p:IsA("MeshPart") then bump("material:" .. p.Material.Name, name) break end
		end
	end
end

for _, fname in ipairs(FOLDERS) do
	local f = workspace:FindFirstChild(fname)
	if f then
		local kids = (f:IsA("Folder") or fname == "VoxelScenery" or fname == "CoalNodes" or fname == "CaveDecor") and f:GetChildren() or { f }
		for _, obj in ipairs(kids) do
			if obj:IsA("Model") or obj:IsA("BasePart") then check(obj, fname) end
		end
	end
end

table.sort(worst, function(a, b) return a.value > b.value end)
local lines = {}
for cat, n in pairs(counts) do table.insert(lines, cat .. "=" .. n) end
table.sort(lines)
local top = {}
for i = 1, math.min(12, #worst) do top[i] = string.format("%s %s %.2f", worst[i].cat, worst[i].name, worst[i].value) end
return "QA " .. (FIX and "(fixed floating) " or "") .. table.concat(lines, ", ") .. "\n" .. table.concat(top, "\n")
