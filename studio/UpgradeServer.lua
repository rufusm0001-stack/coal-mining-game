local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Data = require(script.Parent.Parent.Data.PlayerData)
local Upgrades = require(RS.Modules.UpgradeData)
local remote = RS.RemoteEvents.UpgradeEvent
local last = {}
remote.OnServerEvent:Connect(function(player, key, level)
 local now = os.clock()
 if last[player] and now-last[player] < 0.12 then return end
 last[player] = now
 local p = Data.Get(player)
 if not p then return end
 if key == "Sync" then Data.Push(player); return end
 if RS.MineProgress:GetAttribute("DiamondFound") then
  remote:FireClient(player, key, false, "Run ended"); return
 end
 local ok, reason = Upgrades.Purchase(p, key, level)
 Data.Push(player)
 remote:FireClient(player, type(key)=="string" and key or "", ok, reason)
end)
Players.PlayerRemoving:Connect(function(player) last[player]=nil end)
