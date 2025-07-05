
-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2025-07-05 03:30:41
-- Luau version 6, Types version 3
-- Time taken: 0.008734 seconds

local Assets = game.ReplicatedStorage.Assets
local GUI_upvr = require(game.ReplicatedStorage.Library.Client.GUI)
local Save_upvr = require(game.ReplicatedStorage.Library.Client.Save)
local Functions_upvr = require(game.ReplicatedStorage.Library.Functions)
local InstancingCmds_upvr = require(game.ReplicatedStorage.Library.Client.InstancingCmds)
local TabController_upvr = require(game.ReplicatedStorage.Library.Client.TabController)
local Signal_upvr = require(game.ReplicatedStorage.Library.Signal)
local GymTrain_upvr = require(script.Parent.GymTrain)
local any_Main_result1_upvr = GUI_upvr.Main()
local GymButtons_upvr = any_Main_result1_upvr.GymButtons
local tbl_4_upvr = {GymButtons_upvr.Content.Slot1, GymButtons_upvr.Content.Slot2, GymButtons_upvr.Content.Slot3}
function animationHotbar(arg1) -- Line 38
	--[[ Upvalues[4]:
		[1]: InstancingCmds_upvr (readonly)
		[2]: Save_upvr (readonly)
		[3]: tbl_4_upvr (readonly)
		[4]: Functions_upvr (readonly)
	]]
	if not InstancingCmds_upvr.IsInInstance("GymEvent") then
	else
		if not Save_upvr.Get() then return end
		local var19 = tbl_4_upvr[arg1]
		if var19 then
			local UIScale_upvr_2 = var19.SlotButton:FindFirstChild("UIScale")
			if UIScale_upvr_2 then
				Functions_upvr.Tween(UIScale_upvr_2, {
					Scale = 1.25;
				}, {0.05, "Quad", "Out"}).Completed:Connect(function() -- Line 51
					--[[ Upvalues[2]:
						[1]: Functions_upvr (copied, readonly)
						[2]: UIScale_upvr_2 (readonly)
					]]
					Functions_upvr.Tween(UIScale_upvr_2, {
						Scale = 1;
					}, {0.09, "Quad", "Out"})
				end)
			end
		end
	end
end
local any_ObjectDebounce_result1_upvr = Functions_upvr.ObjectDebounce()
function triggerHotbar(arg1) -- Line 58
	--[[ Upvalues[6]:
		[1]: InstancingCmds_upvr (readonly)
		[2]: Save_upvr (readonly)
		[3]: tbl_4_upvr (readonly)
		[4]: any_ObjectDebounce_result1_upvr (readonly)
		[5]: Functions_upvr (readonly)
		[6]: GymTrain_upvr (readonly)
	]]
	if not InstancingCmds_upvr.IsInInstance("GymEvent") then
	else
		if not Save_upvr.Get() then return end
		if getOwnedSlots() < arg1 then return end
		local var28_upvr = tbl_4_upvr[arg1]
		any_ObjectDebounce_result1_upvr(arg1, 0.05, function() -- Line 71
			--[[ Upvalues[4]:
				[1]: var28_upvr (readonly)
				[2]: Functions_upvr (copied, readonly)
				[3]: arg1 (readonly)
				[4]: GymTrain_upvr (copied, readonly)
			]]
			if var28_upvr then
				local UIScale_upvr = var28_upvr.SlotButton:FindFirstChild("UIScale")
				if UIScale_upvr then
					Functions_upvr.Tween(UIScale_upvr, {
						Scale = 1.25;
					}, {0.05, "Quad", "Out"}).Completed:Connect(function() -- Line 76
						--[[ Upvalues[2]:
							[1]: Functions_upvr (copied, readonly)
							[2]: UIScale_upvr (readonly)
						]]
						Functions_upvr.Tween(UIScale_upvr, {
							Scale = 1;
						}, {0.09, "Quad", "Out"})
					end)
				end
			end
			UIScale_upvr = arg1
			if UIScale_upvr == GymTrain_upvr.GetTrainingIndex() then
				UIScale_upvr = GymTrain_upvr.RequestTrain
				UIScale_upvr()
			else
				UIScale_upvr = GymTrain_upvr.SetTrainingByIndex
				UIScale_upvr(arg1)
			end
		end)
	end
end
local GUIFX_upvr = require(game.ReplicatedStorage.Library.Client.GUIFX)
local ClientGymAuto_upvr = require(script.Parent.ClientGymAuto)
local Inventory_upvr = GymButtons_upvr.Content.Inventory
local Settings_upvr = GymButtons_upvr.Content.Settings
local var45_upvw
function initHotbar() -- Line 91
	--[[ Upvalues[10]:
		[1]: tbl_4_upvr (readonly)
		[2]: GUI_upvr (readonly)
		[3]: GUIFX_upvr (readonly)
		[4]: Save_upvr (readonly)
		[5]: ClientGymAuto_upvr (readonly)
		[6]: Inventory_upvr (readonly)
		[7]: TabController_upvr (readonly)
		[8]: Settings_upvr (readonly)
		[9]: Functions_upvr (readonly)
		[10]: var45_upvw (read and write)
	]]
	for i_upvr, v in pairs(tbl_4_upvr) do
		GUI_upvr.ButtonActivated(v.SlotButton, function() -- Line 93
			--[[ Upvalues[1]:
				[1]: i_upvr (readonly)
			]]
			triggerHotbar(i_upvr)
		end)
		GUIFX_upvr.ButtonFX(v)
		GUI_upvr.ButtonActivated(v.Auto, function() -- Line 98
			--[[ Upvalues[2]:
				[1]: Save_upvr (copied, readonly)
				[2]: ClientGymAuto_upvr (copied, readonly)
			]]
			local any_Get_result1_3 = Save_upvr.Get()
			if not any_Get_result1_3 then
			else
				if any_Get_result1_3.GymAuto then
					ClientGymAuto_upvr.StopAuto()
				else
					ClientGymAuto_upvr.StartAuto()
				end
				any_Get_result1_3.GymAuto = not any_Get_result1_3.GymAuto
			end
		end)
		GUIFX_upvr.ButtonFX(v.Auto)
		GUI_upvr.ButtonActivated(Inventory_upvr, function() -- Line 114
			--[[ Upvalues[1]:
				[1]: TabController_upvr (copied, readonly)
			]]
			TabController_upvr.OpenTab("Inventory")
		end)
		GUIFX_upvr.ButtonFX(Inventory_upvr)
		GUI_upvr.ButtonActivated(Settings_upvr, function() -- Line 119
			--[[ Upvalues[1]:
				[1]: TabController_upvr (copied, readonly)
			]]
			TabController_upvr.OpenTab("GymSettings")
		end)
		GUIFX_upvr.ButtonFX(Settings_upvr)
		local UIScale_upvr_4 = Instance.new("UIScale")
		UIScale_upvr_4.Parent = v.SlotButton
		v.SlotButton.MouseEnter:Connect(function() -- Line 126
			--[[ Upvalues[4]:
				[1]: i_upvr (readonly)
				[2]: Functions_upvr (copied, readonly)
				[3]: UIScale_upvr_4 (readonly)
				[4]: var45_upvw (copied, read and write)
			]]
			if not ownsSlot(i_upvr) then
			else
				Functions_upvr.Tween(UIScale_upvr_4, {
					Scale = 1.15;
				}, {0.15, "Quad", "Out"})
				var45_upvw = i_upvr
			end
		end)
		v.SlotButton.MouseLeave:Connect(function() -- Line 133
			--[[ Upvalues[4]:
				[1]: i_upvr (readonly)
				[2]: Functions_upvr (copied, readonly)
				[3]: UIScale_upvr_4 (readonly)
				[4]: var45_upvw (copied, read and write)
			]]
			if not ownsSlot(i_upvr) then
			else
				Functions_upvr.Tween(UIScale_upvr_4, {
					Scale = 1;
				}, {0.15, "Quad", "Out"})
				var45_upvw = nil
			end
		end)
	end
	updateHotbar()
end
function ownsSlot(arg1) -- Line 145
	local var63
	if arg1 > getOwnedSlots() then
		var63 = false
	else
		var63 = true
	end
	return var63
end
local InstanceZoneCmds_upvr = require(game.ReplicatedStorage.Library.Client.InstanceZoneCmds)
local Gym_upvr = require(game.ReplicatedStorage.Library.Types.Gym)
function getOwnedSlots() -- Line 149
	--[[ Upvalues[3]:
		[1]: InstancingCmds_upvr (readonly)
		[2]: InstanceZoneCmds_upvr (readonly)
		[3]: Gym_upvr (readonly)
	]]
	local any_Get_result1_5 = InstancingCmds_upvr.Get()
	if not any_Get_result1_5 or any_Get_result1_5.instanceID ~= "GymEvent" then
		return 1
	end
	local any_GetVirtualZoneNumber_result1 = InstanceZoneCmds_upvr.GetVirtualZoneNumber(any_Get_result1_5)
	if not any_GetVirtualZoneNumber_result1 then
		return 1
	end
	return math.min(any_GetVirtualZoneNumber_result1, Gym_upvr.PushupZone)
end
function updateHotbar(arg1) -- Line 163
	--[[ Upvalues[2]:
		[1]: Save_upvr (readonly)
		[2]: tbl_4_upvr (readonly)
	]]
	if not Save_upvr.Get() then
	else
		local var75
		for i_3, v_3 in pairs(tbl_4_upvr) do
			if getOwnedSlots() >= i_3 then
				var75 = false
			else
				var75 = true
			end
			v_3.SlotButton.Locked.Visible = var75
		end
	end
end
local RedGradient_upvr = Assets.UI.Gradients.RedGradient
local GreenGradient_upvr = Assets.UI.Gradients.GreenGradient
task.spawn(function() -- Line 176
	--[[ Upvalues[11]:
		[1]: Save_upvr (readonly)
		[2]: InstancingCmds_upvr (readonly)
		[3]: TabController_upvr (readonly)
		[4]: GymButtons_upvr (readonly)
		[5]: Signal_upvr (readonly)
		[6]: any_Main_result1_upvr (readonly)
		[7]: tbl_4_upvr (readonly)
		[8]: GymTrain_upvr (readonly)
		[9]: Functions_upvr (readonly)
		[10]: RedGradient_upvr (readonly)
		[11]: GreenGradient_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	while true do
		local var105
		if not task.wait() then break end
		var105 = Save_upvr
		local any_Get_result1_4 = var105.Get()
		var105 = any_Get_result1_4
		if var105 then
			var105 = any_Get_result1_4.GymAuto
		end
		local any_IsInInstance_result1_2 = InstancingCmds_upvr.IsInInstance("GymEvent")
		local any_Get_result1 = TabController_upvr.Get()
		local var109 = any_IsInInstance_result1_2
		if var109 then
			var109 = not any_Get_result1
		end
		GymButtons_upvr.Visible = var109
		local var110 = not any_IsInInstance_result1_2
		if not var110 then
			var110 = true
			if any_Get_result1 ~= "Inventory" then
				var110 = Signal_upvr.Invoke("IsSecondaryVisible")
			end
		end
		any_Main_result1_upvr.BottomButtons.BUTTONS.Inventory.Visible = var110
		for i_2, v_2 in pairs(tbl_4_upvr) do
			local var114
			if i_2 ~= GymTrain_upvr.GetTrainingIndex() then
				var114 = false
			else
				var114 = true
			end
			v_2.SelectedStroke.Enabled = var114
			v_2.Auto.Visible = var114
			if var105 then
			else
			end
			v_2.Auto.TextLabel.Text = "Auto"
			if not var105 or not RedGradient_upvr then
			end
			Functions_upvr.GradientSwap(v_2.Auto, GreenGradient_upvr)
		end
		if any_IsInInstance_result1_2 then
			updateHotbar()
		end
	end
end)
game:GetService("UserInputService").InputBegan:Connect(function(arg1, arg2) -- Line 203
	if arg2 then
	else
		if arg1.UserInputType ~= Enum.UserInputType.Keyboard then return end
		local var117 = ({
			[Enum.KeyCode.One] = 1;
			[Enum.KeyCode.Two] = 2;
			[Enum.KeyCode.Three] = 3;
		})[arg1.KeyCode]
		if not var117 then return end
		triggerHotbar(var117)
	end
end)
Signal_upvr.Fired("GymHotbar_Animate"):Connect(function(arg1) -- Line 222
	animationHotbar(arg1)
end)
while not Save_upvr.Get() do
	task.wait()
end
initHotbar()
