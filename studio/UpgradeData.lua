-- Shared display and server pricing. All levels reset with each mine.
local Config = require(script.Parent.Config)
local U = {}
U.Order = {"Power", "Speed", "Reach", "Capacity"}
U.Tracks = {
 Power = {Name="Power", Values={50,75,110,160,230,330}, Costs={200,550,1300,3000,6500}, Unit="coal / hit"},
 Speed = {Name="Speed", Values={1,1.15,1.3,1.45,1.6,1.8}, Costs={300,800,1800,4000,8500}, Unit="swing speed"},
 Reach = {Name="Reach", Values={6,7,8,9,10,12}, Costs={150,450,1100,2600,5500}, Unit="stud reach"},
 Capacity = {Name="Cart capacity", Values={250,500,900,1500,2400,4000}, Costs={200,650,1600,3800,8000}, Unit="coal stored"},
}
U.Tracks.Power.Values[1] = Config.StartPower
U.Tracks.Reach.Values[1] = Config.MineRange
U.Tracks.Capacity.Values[1] = Config.StartCartCapacity
function U.Apply(p)
 local l = p.UpgradeLevels
 p.Power = U.Tracks.Power.Values[(l.Power or 0)+1]
 p.SwingSpeed = U.Tracks.Speed.Values[(l.Speed or 0)+1]
 p.Reach = U.Tracks.Reach.Values[(l.Reach or 0)+1]
 p.CartCapacity = U.Tracks.Capacity.Values[(l.Capacity or 0)+1]
end
-- No yields: price, balance and level change form one server transaction.
function U.Purchase(p, key, expectedLevel)
 local track = type(key) == "string" and U.Tracks[key]
 if not track or type(expectedLevel) ~= "number" then return false, "Invalid" end
 local level = p.UpgradeLevels[key] or 0
 if expectedLevel ~= level then return false, "Changed" end
 local price = track.Costs[level+1]
 if not price then return false, "Max" end
 if p.Money < price then return false, "Funds" end
 p.Money -= price
 p.UpgradeLevels[key] = level+1
 U.Apply(p)
 return true, "Bought"
end
return U
