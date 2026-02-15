local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- ========== GUI ==========
local gui = Instance.new("ScreenGui")
gui.Name = "FakeTabUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.3, 0.18)
frame.Position = UDim2.fromScale(0.35, 0.6)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.BorderSizePixel = 0

local uiStroke = Instance.new("UIStroke", frame)
uiStroke.Color = Color3.new(1,1,1)

-- drag bar (small)
local bar = Instance.new("Frame", frame)
bar.Size = UDim2.fromScale(1, 0.15)
bar.BackgroundColor3 = Color3.fromRGB(15,15,15)

local title = Instance.new("TextLabel", bar)
title.Size = UDim2.fromScale(1,1)
title.BackgroundTransparency = 1
title.Text = "FAKE TAB"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.Code
local ts = Instance.new("UIStroke", title)
ts.Color = Color3.new(1,1,1)

-- button
local tabBtn = Instance.new("TextButton", frame)
tabBtn.Size = UDim2.fromScale(1,0.5)
tabBtn.Position = UDim2.fromScale(0,0.18)
tabBtn.Text = "FAKE TAB: OFF"
tabBtn.TextScaled = true
tabBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
tabBtn.TextColor3 = Color3.new(1,1,1)
tabBtn.Font = Enum.Font.Code
local bs = Instance.new("UIStroke", tabBtn)
bs.Color = Color3.new(1,1,1)

-- UI size slider
local sliderBg = Instance.new("Frame", frame)
sliderBg.Size = UDim2.fromScale(1, 0.1)
sliderBg.Position = UDim2.fromScale(0, 0.72)
sliderBg.BackgroundColor3 = Color3.fromRGB(25,25,25)
local sStroke = Instance.new("UIStroke", sliderBg)
sStroke.Color = Color3.new(1,1,1)

local slider = Instance.new("Frame", sliderBg)
slider.Size = UDim2.fromScale(0.4, 1)
slider.BackgroundColor3 = Color3.new(1,1,1)

-- ========== Drag UI ==========
local dragging, startPos, startFrame
bar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		startPos = input.Position
		startFrame = frame.Position
	end
end)
bar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)
bar.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.Touch then
		local delta = input.Position - startPos
		frame.Position = UDim2.new(
			startFrame.X.Scale, startFrame.X.Offset + delta.X,
			startFrame.Y.Scale, startFrame.Y.Offset + delta.Y
		)
	end
end)

-- ========== Slider ==========
local sliding = false
sliderBg.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then sliding = true end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then sliding = false end
end)
UserInputService.InputChanged:Connect(function(input)
	if sliding and input.UserInputType == Enum.UserInputType.Touch then
		local x = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0.3, 1)
		slider.Size = UDim2.fromScale(x,1)
		frame.Size = UDim2.fromScale(0.3 * x, 0.18 * x)
	end
end)

-- ========== FAKE TAB ==========
local active = false
local bp, bg

local function enable()
	local char = player.Character
	if not char then return end
	local hrp = char:WaitForChild("HumanoidRootPart")
	local hum = char:WaitForChild("Humanoid")

	hum.WalkSpeed = 0
	hum.JumpPower = 0
	hum.AutoRotate = false

	bp = Instance.new("BodyPosition", hrp)
	bp.MaxForce = Vector3.new(1e6,1e6,1e6)
	bp.Position = hrp.Position

	bg = Instance.new("BodyGyro", hrp)
	bg.MaxTorque = Vector3.new(1e6,1e6,1e6)
	bg.CFrame = hrp.CFrame
end

local function disable()
	local char = player.Character
	if not char then return end
	local hum = char:FindFirstChild("Humanoid")
	if hum then
		hum.WalkSpeed = 16
		hum.JumpPower = 50
		hum.AutoRotate = true
	end
	if bp then bp:Destroy() bp=nil end
	if bg then bg:Destroy() bg=nil end
end

tabBtn.MouseButton1Click:Connect(function()
	active = not active
	tabBtn.Text = active and "FAKE TAB: ON" or "FAKE TAB: OFF"
	if active then enable() else disable() end
end)

player.CharacterAdded:Connect(function()
	if active then
		task.wait(0.2)
		enable()
	end
end)
