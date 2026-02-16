--// Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local cam = workspace.CurrentCamera

---------------------------------------------------
-- GUI
---------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "FakeTabUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

---------------------------------------------------
-- INTRO (Blur + FOV + Sounds)
---------------------------------------------------
local oldFov = cam.FieldOfView

local blur = Instance.new("BlurEffect",Lighting)
blur.Size = 0
TweenService:Create(blur,TweenInfo.new(0.6),{Size=24}):Play()
TweenService:Create(cam,TweenInfo.new(0.6),{FieldOfView = oldFov + 25}):Play()

local cover = Instance.new("Frame",gui)
cover.Size = UDim2.fromScale(1,1)
cover.BackgroundTransparency = 1
cover.ZIndex = 10

local boot = Instance.new("Sound",cover)
boot.SoundId = "rbxassetid://9118828560"
boot.Volume = 1
boot:Play()

local discord = Instance.new("Sound",cover)
discord.SoundId = "rbxassetid://301964312"
discord.Volume = 0.8
task.delay(0.6,function() discord:Play() end)

local tri = Instance.new("TextLabel",cover)
tri.Size = UDim2.fromScale(1,1)
tri.BackgroundTransparency = 1
tri.Text = "▲"
tri.TextSize = 70
tri.Font = Enum.Font.GothamBlack
tri.TextColor3 = Color3.new(1,1,1)
tri.ZIndex = 11

task.spawn(function()
 while tri.Parent do
  tri.Rotation += 2
  task.wait()
 end
end)

local init = Instance.new("TextLabel",cover)
init.Size = UDim2.fromScale(1,1)
init.Position = UDim2.fromScale(0,0.12)
init.BackgroundTransparency = 1
init.Text = "Initializing System..."
init.Font = Enum.Font.GothamBold
init.TextSize = 24
init.TextColor3 = Color3.new(1,1,1)
init.ZIndex = 11

local intro = Instance.new("TextLabel",cover)
intro.Size = UDim2.fromScale(1,1)
intro.Position = UDim2.fromScale(0,0.2)
intro.BackgroundTransparency = 1
intro.Text = "Tab Script by IL4SK"
intro.Font = Enum.Font.Arcade
intro.TextSize = 42
intro.TextTransparency = 1
intro.ZIndex = 11

TweenService:Create(intro,TweenInfo.new(1),{TextTransparency=0}):Play()

task.spawn(function()
 while intro.Parent do
  for i=0,360,4 do
   intro.TextColor3 = Color3.fromHSV(i/360,1,1)
   task.wait()
  end
 end
end)

task.wait(3)

TweenService:Create(blur,TweenInfo.new(0.8),{Size=0}):Play()
TweenService:Create(cam,TweenInfo.new(0.8),{FieldOfView = oldFov}):Play()
TweenService:Create(intro,TweenInfo.new(0.8),{TextTransparency=1}):Play()
TweenService:Create(init,TweenInfo.new(0.8),{TextTransparency=1}):Play()

task.wait(1)
cover:Destroy()

---------------------------------------------------
-- UI
---------------------------------------------------
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.3,0.18)
frame.Position = UDim2.fromScale(0.35,0.6)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.BorderSizePixel = 0
Instance.new("UICorner",frame).CornerRadius = UDim.new(0,14)

local stroke = Instance.new("UIStroke",frame)
stroke.Color = Color3.new(1,1,1)

local bar = Instance.new("Frame",frame)
bar.Size = UDim2.fromScale(1,0.18)
bar.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner",bar)

local title = Instance.new("TextLabel",bar)
title.Size = UDim2.fromScale(1,1)
title.BackgroundTransparency = 1
title.Text = "FAKE TAB"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

local btn = Instance.new("TextButton",frame)
btn.Size = UDim2.fromScale(1,0.45)
btn.Position = UDim2.fromScale(0,0.22)
btn.Text = "FAKE TAB : OFF"
btn.BackgroundColor3 = Color3.fromRGB(10,10,10)
btn.TextColor3 = Color3.new(1,1,1)
btn.TextScaled = true
btn.Font = Enum.Font.GothamBold
Instance.new("UICorner",btn)

local sliderBg = Instance.new("Frame",frame)
sliderBg.Position = UDim2.fromScale(0,0.72)
sliderBg.Size = UDim2.fromScale(0.9,0.12)
sliderBg.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner",sliderBg)

local slider = Instance.new("Frame",sliderBg)
slider.Size = UDim2.fromScale(1,1)
Instance.new("UICorner",slider)

task.spawn(function()
 while slider.Parent do
  for i=0,360,4 do
   slider.BackgroundColor3 = Color3.fromHSV(i/360,1,1)
   task.wait()
  end
 end
end)

local percent = Instance.new("TextLabel",frame)
percent.Size = UDim2.fromScale(0.1,0.12)
percent.Position = UDim2.fromScale(0.9,0.72)
percent.BackgroundTransparency = 1
percent.TextColor3 = Color3.new(1,1,1)
percent.TextScaled = true
percent.Font = Enum.Font.GothamBold
percent.Text = "100%"

local lock = Instance.new("TextButton",frame)
lock.Size = UDim2.fromScale(0.1,0.18)
lock.Position = UDim2.fromScale(0.9,0)
lock.Text = "🔓"
lock.BackgroundColor3 = Color3.fromRGB(40,40,40)
lock.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",lock)

---------------------------------------------------
-- DRAG
---------------------------------------------------
local dragging=false
local dragStart, startPos
bar.InputBegan:Connect(function(i)
 if i.UserInputType==Enum.UserInputType.Touch then
  dragging=true
  dragStart=i.Position
  startPos=frame.Position
 end
end)

UIS.InputChanged:Connect(function(i)
 if dragging and i.UserInputType==Enum.UserInputType.Touch then
  local d=i.Position-dragStart
  frame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
 end
end)

UIS.InputEnded:Connect(function(i)
 if i.UserInputType==Enum.UserInputType.Touch then dragging=false end
end)

---------------------------------------------------
-- SLIDER (FIXED)
---------------------------------------------------
local sliding = false
local scale = 1
local locked = false
local baseW, baseH = 0.3, 0.18
local originalPos

sliderBg.InputBegan:Connect(function(i)
 if i.UserInputType == Enum.UserInputType.Touch and not locked then
  sliding = true
  originalPos = frame.Position
 end
end)

UIS.InputChanged:Connect(function(i)
 if sliding and i.UserInputType == Enum.UserInputType.Touch then
  local x = (i.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
  x = math.clamp(x, 0.4, 1)

  scale = x
  slider.Size = UDim2.fromScale(x, 1)
  frame.Size = UDim2.fromScale(baseW * x, baseH * x)

  frame.Position = UDim2.new(
    originalPos.X.Scale,
    originalPos.X.Offset,
    originalPos.Y.Scale,
    originalPos.Y.Offset
  )

  percent.Text = math.floor(x * 100) .. "%"
 end
end)

UIS.InputEnded:Connect(function(i)
 if i.UserInputType == Enum.UserInputType.Touch then
  sliding = false
 end
end)

lock.MouseButton1Click:Connect(function()
 locked=not locked
 lock.Text=locked and "🔒" or "🔓"
end)

---------------------------------------------------
-- FAKE TAB
---------------------------------------------------
local active=false
local stored={}

local function enable()
 local c=player.Character
 if not c then return end
 local hum=c:FindFirstChildOfClass("Humanoid")

 stored={}
 if hum then
  stored.ws=hum.WalkSpeed
  stored.jp=hum.JumpPower
  stored.ar=hum.AutoRotate
  hum.WalkSpeed=0
  hum.JumpPower=0
  hum.AutoRotate=false
 end

 for _,v in ipairs(c:GetDescendants()) do
  if v:IsA("BasePart") then v.Anchored=true end
 end
end

local function disable()
 local c=player.Character
 if not c then return end
 local hum=c:FindFirstChildOfClass("Humanoid")

 if hum then
  hum.WalkSpeed=stored.ws or 16
  hum.JumpPower=stored.jp or 50
  hum.AutoRotate=stored.ar~=false
 end

 for _,v in ipairs(c:GetDescendants()) do
  if v:IsA("BasePart") then v.Anchored=false end
 end
end

btn.MouseButton1Click:Connect(function()
 active=not active
 btn.Text=active and "FAKE TAB : ON" or "FAKE TAB : OFF"
 if active then enable() else disable() end
end)

player.CharacterAdded:Connect(function()
 if active then task.wait(0.2); enable() end
end)



