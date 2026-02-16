--// Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FakeTabUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--// Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.3,0.18)
frame.Position = UDim2.fromScale(0.35,0.6)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.BorderSizePixel = 0

local stroke = Instance.new("UIStroke",frame)
stroke.Color = Color3.new(1,1,1)

-- Drag bar
local bar = Instance.new("Frame",frame)
bar.Size = UDim2.fromScale(1,0.18)
bar.BackgroundColor3 = Color3.fromRGB(25,25,25)

local title = Instance.new("TextLabel",bar)
title.Size = UDim2.fromScale(1,1)
title.BackgroundTransparency = 1
title.Text = "FAKE TAB"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.Code

-- Button
local btn = Instance.new("TextButton",frame)
btn.Size = UDim2.fromScale(1,0.45)
btn.Position = UDim2.fromScale(0,0.22)
btn.Text = "FAKE TAB : OFF"
btn.BackgroundColor3 = Color3.fromRGB(10,10,10)
btn.TextColor3 = Color3.new(1,1,1)
btn.TextScaled = true
btn.Font = Enum.Font.Code

-- Slider BG
local sliderBg = Instance.new("Frame",frame)
sliderBg.Position = UDim2.fromScale(0,0.72)
sliderBg.Size = UDim2.fromScale(0.9,0.12)
sliderBg.BackgroundColor3 = Color3.fromRGB(30,30,30)

-- Slider
local slider = Instance.new("Frame",sliderBg)
slider.BackgroundColor3 = Color3.fromRGB(200,200,200)
slider.Size = UDim2.fromScale(1,1)

-- Percent
local percent = Instance.new("TextLabel",frame)
percent.Size = UDim2.fromScale(0.1,0.12)
percent.Position = UDim2.fromScale(0.9,0.72)
percent.BackgroundTransparency = 1
percent.TextColor3 = Color3.new(1,1,1)
percent.TextScaled = true
percent.Font = Enum.Font.Code
percent.Text = "100%"

-- Lock
local lock = Instance.new("TextButton",frame)
lock.Size = UDim2.fromScale(0.1,0.18)
lock.Position = UDim2.fromScale(0.9,0)
lock.Text = "🔓"
lock.BackgroundColor3 = Color3.fromRGB(40,40,40)
lock.TextColor3 = Color3.new(1,1,1)

--// Drag UI
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

--// Slider
local sliding=false
local scale=1
local locked=false

sliderBg.InputBegan:Connect(function(i)
 if i.UserInputType==Enum.UserInputType.Touch and not locked then
  sliding=true
 end
end)

UIS.InputChanged:Connect(function(i)
 if sliding and i.UserInputType==Enum.UserInputType.Touch then
  local x=(i.Position.X-sliderBg.AbsolutePosition.X)/sliderBg.AbsoluteSize.X
  x=math.clamp(x,0.4,1)
  scale=x
  slider.Size=UDim2.fromScale(x,1)
  frame.Size=UDim2.fromScale(0.3*x,0.18*x)
  percent.Text=math.floor(x*100).."%"
 end
end)

UIS.InputEnded:Connect(function(i)
 if i.UserInputType==Enum.UserInputType.Touch then sliding=false end
end)

lock.MouseButton1Click:Connect(function()
 locked=not locked
 lock.Text=locked and "🔒" or "🔓"
end)

--// Fake Tab (NO JITTER)
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
  if v:IsA("BasePart") then
   v.Anchored=true
  end
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
  if v:IsA("BasePart") then
   v.Anchored=false
  end
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


