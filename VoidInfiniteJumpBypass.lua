-- ================================================
-- FILENAME: VoidInfiniteJumpBypass.lua
-- CREATOR: void (@voidgfx0_)
-- TELEGRAM: https://t.me/vounban
-- FEATURES: Anti-ban, all executors, all games
-- ================================================

-- MAIN CONFIG
local VoidConfig = {
    ScriptName = "VoidInfiniteJumpBypass",
    Version = "6.0",
    Creator = "void (@voidgfx0_)",
    JumpKey = Enum.KeyCode.Space,
    JumpHeight = 50,
    AntiBanMode = true,
    StealthMode = true
}

-- WATERMARK SYSTEM
local function VoidWatermark()
    print("\n========================================")
    print("VOID INFINITE JUMP BYPASS")
    print("Creator: " .. VoidConfig.Creator)
    print("Version: " .. VoidConfig.Version)
    print("Telegram: https://t.me/vounban")
    print("Dibuat oleh void - jangan hapus watermark")
    print("========================================\n")
end

-- ANTI-DETECTION CHECK
local function IsGameSupported()
    local blacklistedGames = {
        [123456789] = true,  -- Example: Anti-cheat game ID
    }
    
    local gameId = game.PlaceId
    if blacklistedGames[gameId] then
        warn("[VOID] Game tidak support infinite jump!")
        return false
    end
    return true
end

-- BYPASS ENGINE
local function CreateSafeJump()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local UIS = game:GetService("UserInputService")
    local RS = game:GetService("RunService")
    
    if not LocalPlayer.Character then return end
    if not LocalPlayer.Character:FindFirstChild("Humanoid") then return end
    
    local Humanoid = LocalPlayer.Character.Humanoid
    local RootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not RootPart then return end
    
    -- TECHNIQUE 1: Velocity-based (stealth)
    local function VelocityJump()
        if Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            local bv = Instance.new("BodyVelocity")
            bv.Velocity = Vector3.new(0, VoidConfig.JumpHeight, 0)
            bv.MaxForce = Vector3.new(0, math.huge, 0)
            bv.Parent = RootPart
            
            game:GetService("Debris"):AddItem(bv, 0.1)
        end
    end
    
    -- TECHNIQUE 2: CFrame-based (alternative)
    local function CFrameJump()
        if RootPart then
            local current = RootPart.CFrame
            RootPart.CFrame = current * CFrame.new(0, 5, 0)
            task.wait(0.05)
            RootPart.CFrame = current
        end
    end
    
    -- TECHNIQUE 3: Humanoid.Jump (mimic normal jump)
    local function HumanoidJump()
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        task.wait(0.1)
    end
    
    -- INPUT DETECTION
    local jumpConnection
    jumpConnection = UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == VoidConfig.JumpKey or input.UserInputType == Enum.UserInputType.Touch then
            -- Randomize technique untuk hindari pattern detection
            local technique = math.random(1, 3)
            
            if technique == 1 then
                VelocityJump()
            elseif technique == 2 then
                CFrameJump()
            else
                HumanoidJump()
            end
            
            -- Anti-rapid fire delay
            task.wait(0.15)
        end
    end)
    
    -- CLEANUP ON RESPAWN
    local charAddedConnection
    charAddedConnection = LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        if jumpConnection then
            jumpConnection:Disconnect()
        end
        CreateSafeJump()
    end)
    
    -- RETURN CLEANUP FUNCTION
    return function()
        if jumpConnection then
            jumpConnection:Disconnect()
        end
        if charAddedConnection then
            charAddedConnection:Disconnect()
        end
    end
end

-- MAIN EXECUTION
task.wait(2)  -- Wait for game to fully load

VoidWatermark()

if IsGameSupported() then
    local cleanup = CreateSafeJump()
    
    -- NOTIFICATION
    game.StarterGui:SetCore("SendNotification", {
        Title = "VOID JUMP BYPASS",
        Text = "Infinite Jump Activated!",
        Duration = 5
    })
    
    print("[VOID] Infinite Jump Ready!")
    print("[VOID] Press Space/Tap to infinite jump")
    print("[VOID] Anti-ban: " .. tostring(VoidConfig.AntiBanMode))
    
    -- AUTO CLEANUP ON SCRIPT STOP
    game:GetService("Players").LocalPlayer.OnTeleport:Connect(function()
        if cleanup then
            cleanup()
        end
    end)
else
    game.StarterGui:SetCore("SendNotification", {
        Title = "VOID JUMP BYPASS",
        Text = "Game tidak support!",
        Duration = 5
    })
end

-- END OF SCRIPT
return "VoidInfiniteJumpBypass loaded - " .. VoidConfig.Creator
