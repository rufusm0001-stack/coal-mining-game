-- Responsive upgrade ledger, built with the shared ToyUI kit.
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Tween = game:GetService("TweenService")
local Input = game:GetService("UserInputService")
local UI = require(RS.Modules.ToyUI)
local Icons = require(RS.Modules.Icons)
local Upgrades = require(RS.Modules.UpgradeData)
local player = Players.LocalPlayer
local remote = RS.RemoteEvents:WaitForChild("UpgradeEvent")
local T = UI.Theme
local gui = UI.root("UpgradeBook", player:WaitForChild("PlayerGui"))
gui.DisplayOrder = 20
-- Panel reflows at phone width, keeping actual touch targets at least 48px.
local scale = gui:FindFirstChildOfClass("UIScale")
if scale then scale:Destroy() end
local state = {Money=0,UpgradeLevels={}}
local page = "Pickaxe"
local rows = {}
local pending = {}
local function number(n)
 if n >= 10000 then return string.format("%.1fK", n/1000) end
 return tostring(n):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,","")
end
local rail,_,railHit = UI.button({Parent=gui,Name="Open",Size=UDim2.fromOffset(48,48),Position=UDim2.new(0,16,0.5,-24),color=T.green,depth=5,Text=""})
UI.icon(rail,Icons.Pickaxe_Stone,UDim2.fromOffset(42,42),UDim2.fromOffset(3,0),12)
UI.label(rail,{Text="Upgrades",TextSize=16,Size=UDim2.fromOffset(88,24),Position=UDim2.fromOffset(-12,50)})
local book,face = UI.block({Parent=gui,Name="Book",Size=UDim2.fromOffset(624,420),AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),color=T.coal,depth=5,ZIndex=20})
book.Visible=false
local pop=Instance.new("UIScale");pop.Parent=book
local paper,paperFace=UI.block({Parent=face,Name="Pages",Size=UDim2.new(1,-24,1,-24),Position=UDim2.fromOffset(12,12),color=T.cream,depth=3,studs=.85,ZIndex=23})
local banner,bannerFace=UI.block({Parent=book,Name="Banner",Size=UDim2.new(1,-96,0,48),Position=UDim2.fromOffset(20,-12),color=T.green,depth=5,ZIndex=30})
UI.label(bannerFace,{Text="UPGRADE BOOK",TextSize=32,ZIndex=33})
local close,_,closeHit=UI.button({Parent=book,Name="Close",Size=UDim2.fromOffset(48,48),Position=UDim2.new(1,-60,0,-12),Text="×",TextSize=32,color=T.red,depth=5,ZIndex=35})
local hero=UI.icon(paperFace,Icons.Pickaxe_Stone,UDim2.fromOffset(132,144),UDim2.fromOffset(12,116),27)
local heroName=UI.label(paperFace,{Text="Stone pickaxe",TextSize=20,Size=UDim2.fromOffset(156,48),Position=UDim2.fromOffset(0,258),ZIndex=28})
local seam=Instance.new("Frame");seam.Name="Spine";seam.BorderSizePixel=0;seam.BackgroundColor3=T.track;seam.Position=UDim2.fromOffset(160,52);seam.Size=UDim2.new(0,3,1,-102);seam.ZIndex=27;seam.Parent=paperFace
local tabs={}
for i,name in ipairs({"Pickaxe","Cart"}) do
 local root,_,hit=UI.button({Parent=paperFace,Name=name.."Tab",Size=UDim2.fromOffset(132,48),Position=UDim2.fromOffset(176+(i-1)*148,40),Text=name,TextSize=20,color=name=="Pickaxe" and T.green or T.blue,depth=3,ZIndex=28})
 tabs[name]={root=root,hit=hit}
end
local money=UI.label(paperFace,{Text="Your money: $0",TextSize=20,TextColor3=T.gold,Size=UDim2.new(1,-24,0,30),Position=UDim2.new(0,12,1,-58),ZIndex=29})
local note=UI.label(paperFace,{Text="Upgrades last for this mine",TextSize=14,Size=UDim2.new(1,-24,0,22),Position=UDim2.new(0,12,1,-28),ZIndex=29})
local list=Instance.new("ScrollingFrame");list.Name="Tracks";list.BackgroundTransparency=1;list.BorderSizePixel=0;list.ScrollBarThickness=4;list.ScrollBarImageColor3=T.coal;list.CanvasSize=UDim2.fromOffset(0,234);list.ZIndex=28;list.Parent=paperFace
for _,key in ipairs(Upgrades.Order) do
 local row,rowFace=UI.block({Parent=list,Name=key,Size=UDim2.fromOffset(408,84),Position=UDim2.fromOffset(176,104),color=T.track,depth=3,studs=.85,ZIndex=28})
 local name=UI.label(rowFace,{Text=Upgrades.Tracks[key].Name,TextSize=20,Size=UDim2.new(1,-160,0,26),Position=UDim2.fromOffset(12,4),TextXAlignment=Enum.TextXAlignment.Left,ZIndex=31})
 local value=UI.label(rowFace,{Text="",TextSize=16,Size=UDim2.new(1,-156,0,24),Position=UDim2.fromOffset(12,29),TextXAlignment=Enum.TextXAlignment.Left,ZIndex=31})
 local pips={}
 for i=1,5 do
  local pip=Instance.new("Frame");pip.Name="Level"..i;pip.BorderSizePixel=0;pip.Size=UDim2.fromOffset(18,6);pip.Position=UDim2.fromOffset(12+(i-1)*24,62);pip.BackgroundColor3=T.grey;pip.ZIndex=32;pip.Parent=rowFace;pips[i]=pip
 end
 local buy,_,hit,label=UI.button({Parent=rowFace,Name="Buy",Size=UDim2.fromOffset(144,48),Position=UDim2.new(1,-156,.5,-24),Text="",TextSize=22,color=T.green,depth=3,ZIndex=33})
 rows[key]={root=row,name=name,value=value,pips=pips,buy=buy,hit=hit,label=label}
 hit.Activated:Connect(function()
  if pending[key] then return end
  pending[key]=true
  remote:FireServer(key,state.UpgradeLevels[key] or 0)
  task.delay(1,function() pending[key]=nil end)
 end)
end
local function refresh()
 money.set("Your money: $"..number(state.Money or 0))
 for key,row in pairs(rows) do
  local track=Upgrades.Tracks[key]
  local level=state.UpgradeLevels[key] or 0
  local price=track.Costs[level+1]
  local current=track.Values[level+1]
  local nextValue=track.Values[level+2]
  local suffix=key=="Speed" and "x" or (key=="Reach" and " studs" or "")
  row.value.set(tostring(current)..suffix..(nextValue and (" → "..tostring(nextValue)..suffix) or " · MAX"))
  row.label.set(price and ("$"..number(price)) or "MAX")
  row.label.color(price and ((state.Money or 0)>=price and T.white or T.cream) or T.gold)
  for i,pip in ipairs(row.pips) do pip.BackgroundColor3=i<=level and T.green or T.grey end
  row.root.Visible=(page=="Cart" and key=="Capacity") or (page=="Pickaxe" and key~="Capacity")
 end
 hero.Image=page=="Cart" and Icons.Cart or Icons.Pickaxe_Stone
 heroName.set(page=="Cart" and "Coal cart" or "Stone pickaxe")
end
local function layout()
 local viewport=workspace.CurrentCamera.ViewportSize
 local narrow=viewport.X<1000
 local width=narrow and math.min(348,viewport.X-28) or math.min(624,viewport.X*.5)
 local height=math.min(420,viewport.Y-100)
 book.Size=UDim2.fromOffset(width,height)
 hero.Visible=not narrow;heroName.frame.Visible=not narrow;seam.Visible=not narrow
 local shadow=hero.Parent:FindFirstChild("IconShadow")
 if shadow then shadow.Visible=not narrow end
 local left=narrow and 12 or 176
 local available=width-24-left-12
 for i,name in ipairs({"Pickaxe","Cart"}) do
  tabs[name].root.Position=UDim2.fromOffset(left+(i-1)*(available/2+6),40)
  tabs[name].root.Size=UDim2.fromOffset(available/2-6,48)
 end
 list.Position=UDim2.fromOffset(left,100)
 list.Size=UDim2.fromOffset(available,height-190)
 list.CanvasSize=UDim2.fromOffset(0,page=="Cart" and 76 or 232)
 for i,key in ipairs(Upgrades.Order) do
  local row=rows[key]
  row.root.Position=UDim2.fromOffset(4,4+((i-1)%3)*76)
  row.root.Size=UDim2.fromOffset(available-8,72)
  local buyWidth=narrow and 108 or 144
  row.buy.Size=UDim2.fromOffset(buyWidth,48)
  row.buy.Position=UDim2.new(1,-buyWidth-8,.5,-24)
  row.name.frame.Size=UDim2.new(1,-buyWidth-24,0,26)
  row.value.frame.Size=UDim2.new(1,-buyWidth-24,0,24)
 end
 pop.Scale=1
end
local function setOpen(open)
 book.Visible=open;player:SetAttribute("MenuOpen",open)
 if open then
  layout();local target=pop.Scale;pop.Scale=target*.9
  book.Position=UDim2.fromScale(.5,.55)
  Tween:Create(pop,TweenInfo.new(.2,Enum.EasingStyle.Back),{Scale=target}):Play()
  Tween:Create(book,TweenInfo.new(.2),{Position=UDim2.fromScale(.5,.5)}):Play()
  remote:FireServer("Sync")
 end
end
railHit.Activated:Connect(function() setOpen(not book.Visible) end)
closeHit.Activated:Connect(function() setOpen(false) end)
Input.InputBegan:Connect(function(input,processed)
 if not processed and input.KeyCode==Enum.KeyCode.B then setOpen(not book.Visible) end
end)
for name,tab in pairs(tabs) do tab.hit.Activated:Connect(function() page=name;list.CanvasPosition=Vector2.zero;layout();refresh() end) end
RS.RemoteEvents.UpdateHUDEvent.OnClientEvent:Connect(function(data)
 if data and data.UpgradeLevels then state=data;refresh() end
end)
remote.OnClientEvent:Connect(function(key,ok,reason)
 pending[key]=nil
 local row=rows[key];if not row then return end
 if ok then
  for i=1,4 do
   local coin=Instance.new("ImageLabel");coin.BackgroundTransparency=1;coin.Image=Icons.Coin;coin.Size=UDim2.fromOffset(24,24);coin.ZIndex=60
   coin.Position=UDim2.fromOffset(row.buy.AbsolutePosition.X+24,row.buy.AbsolutePosition.Y+12);coin.Parent=gui
   local target=UDim2.new(1,-72,0,32)
   Tween:Create(coin,TweenInfo.new(.45+i*.08,Enum.EasingStyle.Quad),{Position=target,ImageTransparency=1}):Play()
   game:GetService("Debris"):AddItem(coin,.9)
  end
 end
 row.label.set(ok and "Bought!" or (reason=="Funds" and "Need coins" or reason))
 row.label.color(ok and T.green or T.red)
 if not ok then
  local origin=row.buy.Position
  Tween:Create(row.buy,TweenInfo.new(.06,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,3,true),{Position=origin+UDim2.fromOffset(4,0)}):Play()
 end
 task.delay(.7,refresh)
end)
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(layout)
layout();refresh();remote:FireServer("Sync")
