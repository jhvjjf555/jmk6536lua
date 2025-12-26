
-- 初始化服务
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 配置变量
local Config = {
    -- UI主题配置
    UI = {
        Theme = "Midnight",
        Transparency = true,
        SideBarWidth = 200
    },
    
    -- 脚本信息
    ScriptInfo = {
        Name = "培根脚本",
        Author = "普通的培根",
        Version = "1.0.0",
        GitHub = "https://github.com/username/KG-Script",
        QQGroup = "819104139",
        Founded = "2025年10月5日"
    },
    
    -- 音效配置
    Sounds = {
        AgreementAccept = "rbxassetid://114583971068152",  -- 同意协议音效
        AgreementReject = "rbxassetid://88457346646245"   -- 拒绝协议音效
    }
}

-- 用户协议确认函数
local function ShowUserAgreement()
    local agreementShown = false
    
    return function()
        if agreementShown then
            return true
        end
        
        local accepted = false
        local waitingForResponse = true
        
        -- 创建协议界面
        local agreementGui = Instance.new("ScreenGui")
        agreementGui.Name = "UserAgreement"
        agreementGui.ResetOnSpawn = false
        agreementGui.IgnoreGuiInset = true
        agreementGui.DisplayOrder = 1000
        agreementGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        agreementGui.Parent = PlayerGui
        
        -- 背景遮罩
        local background = Instance.new("Frame")
        background.Size = UDim2.new(1, 0, 1, 0)
        background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        background.BackgroundTransparency = 0.5
        background.BorderSizePixel = 0
        background.Parent = agreementGui
        
        -- 主容器 (尺寸缩小)
        local mainContainer = Instance.new("Frame")
        mainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
        mainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
        mainContainer.Size = UDim2.new(0, 500, 0, 400)
        mainContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        mainContainer.BorderSizePixel = 0
        mainContainer.Parent = agreementGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.05, 0)
        corner.Parent = mainContainer
        
        -- 欢迎标题 (单独放在最顶端)
        local welcomeTitle = Instance.new("TextLabel")
        welcomeTitle.Size = UDim2.new(1, 0, 0, 40)
        welcomeTitle.Position = UDim2.new(0, 0, 0, 10)
        welcomeTitle.BackgroundTransparency = 1
        welcomeTitle.Text = "欢迎使用培根脚本"
        welcomeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        welcomeTitle.TextSize = 22
        welcomeTitle.Font = Enum.Font.GothamBold
        welcomeTitle.Parent = mainContainer
        
        -- 协议标题栏
        local titleBar = Instance.new("Frame")
        titleBar.Size = UDim2.new(1, 0, 0, 40)
        titleBar.Position = UDim2.new(0, 0, 0, 60)
        titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        titleBar.BorderSizePixel = 0
        titleBar.Parent = mainContainer
        
        local titleCorner = Instance.new("UICorner")
        titleCorner.CornerRadius = UDim.new(0.05, 0)
        titleCorner.Parent = titleBar
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, 0, 1, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = "用户协议"
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.TextSize = 18
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.Parent = titleBar
        
        -- 协议内容容器
        local contentFrame = Instance.new("ScrollingFrame")
        contentFrame.Size = UDim2.new(1, -40, 1, -190)
        contentFrame.Position = UDim2.new(0, 20, 0, 110)
        contentFrame.BackgroundTransparency = 1
        contentFrame.BorderSizePixel = 0
        contentFrame.ScrollBarThickness = 6
        contentFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        contentFrame.Parent = mainContainer
        
        -- 协议内容
        local agreementText = [[
欢迎使用培根脚本

此脚本为免费脚本，永久免费！！！！！！！！！！！！！！！！！花钱买的话你就被圈了。
1.谢谢你用这个脚本，你使用它就是对我最大的支持
2.这里祝你身体健康，万事如意！
3.号与此脚本无关

作者：普通的培根
更新日期：2025年12月27日
]]
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 0, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = agreementText
        textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        textLabel.TextSize = 14
        textLabel.Font = Enum.Font.Gotham
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.TextYAlignment = Enum.TextYAlignment.Top
        textLabel.TextWrapped = true
        textLabel.AutomaticSize = Enum.AutomaticSize.Y
        textLabel.Parent = contentFrame
        
        -- 自动调整内容大小
        textLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
            contentFrame.CanvasSize = UDim2.new(0, 0, 0, textLabel.TextBounds.Y + 20)
        end)
        
        -- 按钮容器
        local buttonContainer = Instance.new("Frame")
        buttonContainer.Size = UDim2.new(1, -40, 0, 60)
        buttonContainer.Position = UDim2.new(0, 20, 1, -90)
        buttonContainer.BackgroundTransparency = 1
        buttonContainer.Parent = mainContainer
        
        -- 拒绝按钮
        local rejectButton = Instance.new("TextButton")
        rejectButton.Size = UDim2.new(0, 180, 0, 50)
        rejectButton.Position = UDim2.new(0, 0, 0, 0)
        rejectButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        rejectButton.Text = "拒绝"
        rejectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        rejectButton.TextSize = 18
        rejectButton.Font = Enum.Font.GothamBold
        rejectButton.Parent = buttonContainer
        
        local rejectCorner = Instance.new("UICorner")
        rejectCorner.CornerRadius = UDim.new(0.2, 0)
        rejectCorner.Parent = rejectButton
        
        -- 同意按钮
        local acceptButton = Instance.new("TextButton")
        acceptButton.Size = UDim2.new(0, 180, 0, 50)
        acceptButton.Position = UDim2.new(1, -180, 0, 0)
        acceptButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        acceptButton.Text = "同意"
        acceptButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        acceptButton.TextSize = 18
        acceptButton.Font = Enum.Font.GothamBold
        acceptButton.Parent = buttonContainer
        
        local acceptCorner = Instance.new("UICorner")
        acceptCorner.CornerRadius = UDim.new(0.2, 0)
        acceptCorner.Parent = acceptButton
        
        -- 按钮点击事件
        rejectButton.MouseButton1Click:Connect(function()
            -- 播放拒绝音效
            local sound = Instance.new("Sound")
            sound.SoundId = Config.Sounds.AgreementReject
            sound.Parent = game:GetService("SoundService")
            sound:Play()
            
            accepted = false
            waitingForResponse = false
            agreementGui:Destroy()
            
            -- 踢出游戏
            LocalPlayer:Kick("您已拒绝用户协议，脚本已停止运行。")
        end)
        
        acceptButton.MouseButton1Click:Connect(function()
            -- 播放同意音效
            local sound = Instance.new("Sound")
            sound.SoundId = Config.Sounds.AgreementAccept
            sound.Parent = game:GetService("SoundService")
            sound:Play()
            
            accepted = true
            agreementShown = true
            waitingForResponse = false
            agreementGui:Destroy()
        end)
        
        -- 等待用户响应
        while waitingForResponse do
            RunService.Heartbeat:Wait()
        end
        
        return accepted
    end
end

-- 创建用户协议检查
local CheckAgreement = ShowUserAgreement()

-- 加载动画
local function CreateLoadingScreen()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LoadingScreen"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 999
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ScreenGui.Parent = PlayerGui
    
    local Frame = Instance.new("Frame")
    Frame.Name = "MainContainer"
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame.Size = UDim2.new(0, 400, 0, 400)
    Frame.BackgroundTransparency = 1
    Frame.Parent = ScreenGui
    
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Name = "Logo"
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.Position = UDim2.new(0.5, 0, 0.4, 0)
    ImageLabel.Size = UDim2.new(0, 200, 0, 200)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://128586210657724"
    ImageLabel.ImageTransparency = 1
    ImageLabel.ZIndex = 999
    ImageLabel.Parent = Frame
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.2, 0)
    UICorner.Parent = ImageLabel
    
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "WelcomeText"
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    TextLabel.Position = UDim2.new(0.5, 0, 0.75, 0)
    TextLabel.Size = UDim2.new(0, 350, 0, 60)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = ""
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 42
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextTransparency = 1
    TextLabel.TextStrokeTransparency = 0.8
    TextLabel.TextStrokeColor3 = Color3.fromRGB(50, 50, 50)
    TextLabel.ZIndex = 999
    TextLabel.Parent = Frame
    
    -- 动画效果
    local startTime = tick()
    local duration = 1.5
    
    local function animateOut()
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / duration, 1)
        
        if progress < 1 then
            local alpha = progress
            local offset = 100 * alpha
            
            ImageLabel.Position = UDim2.new(0.5, -offset, 0.4, 0)
            ImageLabel.ImageTransparency = alpha
            
            TextLabel.Position = UDim2.new(0.5, offset, 0.75, 0)
            TextLabel.TextTransparency = alpha
            
            RunService.Heartbeat:Wait()
            animateOut()
        else
            ImageLabel.ImageTransparency = 0
            TextLabel.TextTransparency = 0
            
            task.wait(1)
            
            -- 加载主界面
            ScreenGui:Destroy()
        end
    end
    
    task.spawn(animateOut)
    return ScreenGui
end

-- 主初始化函数
local function Initialize()
    -- 首先显示用户协议
    local accepted = CheckAgreement()
    if not accepted then
        return -- 用户拒绝协议，脚本已停止
    end
    
    -- 创建加载界面
    CreateLoadingScreen()
    
    -- 延迟加载主UI，确保动画播放完成
    task.wait(2)
    
    -- 尝试加载WindUI库
    local success, WindUI = pcall(function()
        return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    end)
    
    if not success then
        -- 如果加载失败，显示错误提示
        local message = Instance.new("ScreenGui")
        message.Name = "ErrorMessage"
        message.Parent = PlayerGui
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 400, 0, 200)
        frame.Position = UDim2.new(0.5, -200, 0.5, -100)
        frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        frame.BorderSizePixel = 0
        frame.Parent = message
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.1, 0)
        corner.Parent = frame
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 50)
        title.Position = UDim2.new(0, 0, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = "加载失败"
        title.TextColor3 = Color3.fromRGB(255, 100, 100)
        title.TextSize = 24
        title.Font = Enum.Font.GothamBold
        title.Parent = frame
        
        local desc = Instance.new("TextLabel")
        desc.Size = UDim2.new(1, -40, 0, 80)
        desc.Position = UDim2.new(0, 20, 0, 60)
        desc.BackgroundTransparency = 1
        desc.Text = "无法加载WindUI库\n请检查网络连接或稍后重试"
        desc.TextColor3 = Color3.fromRGB(200, 200, 200)
        desc.TextSize = 16
        desc.TextWrapped = true
        desc.Font = Enum.Font.Gotham
        desc.Parent = frame
        
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 120, 0, 40)
        closeBtn.Position = UDim2.new(0.5, -60, 1, -60)
        closeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        closeBtn.Text = "关闭"
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.TextSize = 16
        closeBtn.Font = Enum.Font.Gotham
        closeBtn.Parent = frame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0.2, 0)
        btnCorner.Parent = closeBtn
        
        closeBtn.MouseButton1Click:Connect(function()
            message:Destroy()
        end)
        
        warn("无法加载WindUI库，请检查网络连接")
        return
    end
    
    local UI = WindUI
    
    -- 创建主窗口
    local Window = UI:CreateWindow({
        Title = "培根脚本",
        Author = "作者:普通的培根",
        Icon = "rbxassetid://129260712070622",
        Size = UDim2.fromOffset(300, 400),
        Theme = Config.UI.Theme,
        Folder = "培根脚本",
        Transparent = Config.UI.Transparency,
        HideSearchBar = true,
        ScrollBarEnabled = true,
        SideBarWidth = Config.UI.SideBarWidth,
        IconThemed = true,
        User = {
            Enabled = true,
            Anonymous = false,
            Callback = function()
                print("用户信息点击")
            end
        }
    })
    
    -- ==================== 公告区 ====================
    local AnnouncementTab = Window:Tab({
        Title = "公告区",
        Icon = "bell"
    })
    
    AnnouncementTab:Paragraph({
        Title = "公告",
        Image = "rbxassetid://128586210657724",
        Desc = "没有责任的人，大手子不要开源，求求你😭\n\n祝你们身体健康，万事如意！\n创作者:普通的培根\n支持者:666\n制作者:xiao",
        ImageSize = 68
    })
    
    -- ==================== 暴力区 ====================
    local ViolenceTab = Window:Tab({
        Title = "暴力区",
        Icon = "shield"
    })
    
    ViolenceTab:Paragraph({
        Title = "暴力区脚本",
        Desc = "点击下方按钮加载暴力区脚本",
        Image = "shield",
        ImageSize = 30
    })
    
    ViolenceTab:Button({
        Title = "加载暴力区脚本",
        Icon = "download",
        Desc = "点击加载暴力区脚本",
        Callback = function()
            UI:Notify({
                Title = "正在加载",
                Content = "正在加载暴力区脚本...",
                Icon = "loader",
                Duration = 2
            })
            
            -- 加载暴力区脚本
            local success, err = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/ddjlb7598/-78-/refs/heads/main/%E6%9A%B4%E5%8A%9B%E5%8C%BA.lua"))()
            end)
            
            if success then
                UI:Notify({
                    Title = "加载成功",
                    Content = "暴力区脚本已成功加载！",
                    Icon = "check-circle",
                    Duration = 3
                })
            else
                UI:Notify({
                    Title = "加载失败",
                    Content = "无法加载暴力区脚本：\n" .. tostring(err),
                    Icon = "x-circle",
                    Duration = 5
                })
                warn("暴力区脚本加载失败:", err)
            end
        end
    })
    
    -- ==================== 俄亥俄州 ====================
    local OhioTab = Window:Tab({
        Title = "俄亥俄州",
        Icon = "globe"
    })
    
    OhioTab:Paragraph({
        Title = "俄亥俄州脚本",
        Desc = "点击下方按钮加载俄亥俄州脚本",
        Image = "globe",
        ImageSize = 30
    })
    
    OhioTab:Button({
        Title = "加载俄亥俄州脚本",
        Icon = "download",
        Desc = "点击加载俄亥俄州脚本",
        Callback = function()
            UI:Notify({
                Title = "正在加载",
                Content = "正在加载俄亥俄州脚本...",
                Icon = "loader",
                Duration = 2
            })
            
            -- 加载俄亥俄州脚本
            local success, err = pcall(function()
                loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/255252de1022af03326e6874f4d2daed.lua"))()
            end)
            
            if success then
                UI:Notify({
                    Title = "加载成功",
                    Content = "俄亥俄州脚本已成功加载！",
                    Icon = "check-circle",
                    Duration = 3
                })
            else
                UI:Notify({
                    Title = "加载失败",
                    Content = "无法加载俄亥俄州脚本：\n" .. tostring(err),
                    Icon = "x-circle",
                    Duration = 5
                })
                warn("俄亥俄州脚本加载失败:", err)
            end
        end
    })
    
    -- ==================== 最强战场 ====================
    local BattlefieldTab = Window:Tab({
        Title = "最强战场",
        Icon = "target"
    })
    
    BattlefieldTab:Paragraph({
        Title = "最强战场脚本",
        Desc = "点击下方按钮加载最强战场脚本",
        Image = "target",
        ImageSize = 30
    })
    
    BattlefieldTab:Button({
        Title = "加载最强战场脚本",
        Icon = "download",
        Desc = "点击加载最强战场脚本",
        Callback = function()
            UI:Notify({
                Title = "正在加载",
                Content = "正在加载最强战场脚本...",
                Icon = "loader",
                Duration = 2
            })
            
            -- 加载最强战场脚本
            local success, err = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/phantasm.lua"))()
            end)
            
            if success then
                UI:Notify({
                    Title = "加载成功",
                    Content = "最强战场脚本已成功加载！",
                    Icon = "check-circle",
                    Duration = 3
                })
            else
                UI:Notify({
                    Title = "加载失败",
                    Content = "无法加载最强战场脚本：\n" .. tostring(err),
                    Icon = "x-circle",
                    Duration = 5
                })
                warn("最强战场脚本加载失败:", err)
            end
        end
    })
    
    -- ==================== 亡命速递 ====================
    local DeliveryTab = Window:Tab({
        Title = "亡命速递",
        Icon = "truck"
    })
    
    DeliveryTab:Paragraph({
        Title = "亡命速递脚本",
        Desc = "点击下方按钮加载亡命速递脚本",
        Image = "truck",
        ImageSize = 30
    })
    
    DeliveryTab:Button({
        Title = "加载亡命速递脚本",
        Icon = "download",
        Desc = "点击加载亡命速递脚本",
        Callback = function()
            UI:Notify({
                Title = "正在加载",
                Content = "正在加载亡命速递脚本...",
                Icon = "loader",
                Duration = 2
            })
            
            -- 加载亡命速递脚本
            local success, err = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/JanseJYC/Script/refs/heads/main/Deadly-Deliver.lua"))()
            end)
            
            if success then
                UI:Notify({
                    Title = "加载成功",
                    Content = "亡命速递脚本已成功加载！",
                    Icon = "check-circle",
                    Duration = 3
                })
            else
                UI:Notify({
                    Title = "加载失败",
                    Content = "无法加载亡命速递脚本：\n" .. tostring(err),
                    Icon = "x-circle",
                    Duration = 5
                })
                warn("亡命速递脚本加载失败:", err)
            end
        end
    })
    
    -- ==================== 99夜虚空区 ====================
    local Night99Tab = Window:Tab({
        Title = "99夜虚空",
        Icon = "zap"
    })
    
    Night99Tab:Paragraph({
        Title = "99夜虚空脚本",
        Desc = "点击下方按钮加载99夜虚空脚本",
        Image = "zap",
        ImageSize = 30
    })
    
    Night99Tab:Button({
        Title = "加载99夜虚空",
        Icon = "download",
        Desc = "点击加载99夜虚空脚本",
        Callback = function()
            UI:Notify({
                Title = "正在加载",
                Content = "正在加载99夜虚空脚本...",
                Icon = "loader",
                Duration = 2
            })
            
            -- 加载99夜虚空脚本
            local success, err = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/ke9460394-dot/ugik/refs/heads/main/99%E5%A4%9C%E8%99%9A%E7%A9%BA.txt"))()
            end)
            
            if success then
                UI:Notify({
                    Title = "加载成功",
                    Content = "99夜虚空脚本已成功加载！",
                    Icon = "check-circle",
                    Duration = 3
                })
            else
                UI:Notify({
                    Title = "加载失败",
                    Content = "无法加载99夜虚空脚本：\n" .. tostring(err),
                    Icon = "x-circle",
                    Duration = 5
                })
                warn("99夜虚空脚本加载失败:", err)
            end
        end
    })
    
    -- ==================== 窗口控制 ====================
    Window:Tag({
        Title = "纯净UI框架",
        Color = Color3.fromHex("#10C550")
    })
    
    Window:EditOpenButton({
        Title = "打开培根脚本",
        Icon = "monitor",
        Color = ColorSequence.new(Color3.fromHex("#00FF7F"), Color3.fromHex("#0080FF")),
        StrokeThickness = 4,
        CornerRadius = UDim.new(0, 16),
        Draggable = true
    })
    
    Window:SelectTab(1)
    
    -- 清理函数
    local function Cleanup()
        print("[培根脚本] 正在清理...")
    end
    
    -- 监听窗口关闭
    game:GetService("CoreGui").ChildRemoved:Connect(function(child)
        if child.Name == "WindUI" then
            Cleanup()
        end
    end)
    
    -- 脚本启动成功提示
    UI:Notify({
        Title = "培根脚本 已加载",
        Content = "纯净UI框架版本 v" .. Config.ScriptInfo.Version,
        Icon = "check-circle",
        Duration = 3
    })
    
    print(string.format("[培根脚本] %s v%s 已完全加载！", Config.ScriptInfo.Name, Config.ScriptInfo.Version))
    print(string.format("[培根脚本] 作者: %s", Config.ScriptInfo.Author))
    print(string.format("[培根脚本] GitHub: %s", Config.ScriptInfo.GitHub))
    print("[培根脚本] 状态: 纯净UI框架 - 使用WindUI库")
end

-- 安全启动脚本
local function SafeInitialize()
    local success, err = pcall(Initialize)
    if not success then
        warn("[培根脚本] 加载失败:", err)
        
        -- 显示错误提示
        local errorGui = Instance.new("ScreenGui")
        errorGui.Name = "ScriptError"
        errorGui.Parent = PlayerGui
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 500, 0, 150)
        frame.Position = UDim2.new(0.5, -250, 0.5, -75)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        frame.BorderSizePixel = 0
        frame.Parent = errorGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.1, 0)
        corner.Parent = frame
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 40)
        title.Position = UDim2.new(0, 0, 0, 0)
        title.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        title.Text = "培根脚本 - 加载错误"
        title.TextColor3 = Color3.fromRGB(255, 100, 100)
        title.TextSize = 20
        title.Font = Enum.Font.GothamBold
        title.Parent = frame
        
        local titleCorner = Instance.new("UICorner")
        titleCorner.CornerRadius = UDim.new(0.1, 0)
        titleCorner.Parent = title
        
        local errorText = Instance.new("TextLabel")
        errorText.Size = UDim2.new(1, -40, 0, 60)
        errorText.Position = UDim2.new(0, 20, 0, 50)
        errorText.BackgroundTransparency = 1
        errorText.Text = "错误信息: " .. tostring(err)
        errorText.TextColor3 = Color3.fromRGB(200, 200, 200)
        errorText.TextSize = 14
        errorText.TextWrapped = true
        errorText.TextXAlignment = Enum.TextXAlignment.Left
        errorText.TextYAlignment = Enum.TextYAlignment.Top
        errorText.Font = Enum.Font.Gotham
        errorText.Parent = frame
        
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 100, 0, 35)
        closeBtn.Position = UDim2.new(0.5, -50, 1, -45)
        closeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        closeBtn.Text = "关闭"
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.TextSize = 16
        closeBtn.Font = Enum.Font.Gotham
        closeBtn.Parent = frame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0.2, 0)
        btnCorner.Parent = closeBtn
        
        closeBtn.MouseButton1Click:Connect(function()
            errorGui:Destroy()
        end)
    end
end

-- 延迟启动，确保游戏完全加载
if game:IsLoaded() then
    SafeInitialize()
else
    game.Loaded:Wait()
    task.wait(1)
    SafeInitialize()
end

return {
    Config = Config,
    Version = Config.ScriptInfo.Version,
    Author = Config.ScriptInfo.Author
}