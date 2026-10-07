-- In-memory player state for the current server. LIMITATION: not saved to DataStore yet.
-- Cart and CartCapacity are mirrored onto Player attributes so every client can draw
-- everyone's cart filling up.

local RS = game:GetService("ReplicatedStorage")
local Config = require(RS.Modules.Config)
local Upgrades = require(RS.Modules.UpgradeData)
local UpdateHUDEvent = RS.RemoteEvents.UpdateHUDEvent

local PlayerData = {}
local profiles = {}

function PlayerData.Init(player)
	profiles[player] = {
		Cart = 0,
		UpgradeLevels = {Power=0, Speed=0, Reach=0, Capacity=0},
		SwingSpeed = 1,
		Reach = Config.MineRange,
		CartCapacity = Config.StartCartCapacity,
		Power = Config.StartPower,
		Money = 0,
		PipeMoney = 0, -- earned by burning, travelling through the pipes, not yet collected
		BurnQueue = 0, -- coal dumped into the furnace, not yet burned
		Shards = 0,
		RunContribution = 0,
	}
end

function PlayerData.ResetRun(player)
 local previous = profiles[player]
 if not previous then return end
 local shards = previous.Shards
 -- Replace the table so delayed furnace callbacks cannot credit the next run.
 PlayerData.Init(player)
 profiles[player].Shards = shards
 PlayerData.Push(player)
end

function PlayerData.Remove(player)
	profiles[player] = nil
end

function PlayerData.Get(player)
	return profiles[player]
end

function PlayerData.All()
	return profiles
end

function PlayerData.Push(player)
	local p = profiles[player]
	if not p then
		return
	end
	Upgrades.Apply(p)
 player:SetAttribute("Money", p.Money)
 player:SetAttribute("Cart", p.Cart)
	player:SetAttribute("CartCapacity", p.CartCapacity)
	UpdateHUDEvent:FireClient(player, {
		Cart = p.Cart,
		CartCapacity = p.CartCapacity,
		Money = p.Money,
		PipeMoney = p.PipeMoney,
		Shards = p.Shards,
		Power = p.Power,
		SwingSpeed = p.SwingSpeed,
		Reach = p.Reach,
		UpgradeLevels = table.clone(p.UpgradeLevels),
	})
end

return PlayerData
