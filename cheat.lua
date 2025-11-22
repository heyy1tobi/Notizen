-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Datenstruktur für Notizen
local PlayerNotesData = {}

-- ScreenGui erstellen
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NotesGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Hauptframe
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 360, 0, 500)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(40,40,45)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0,12)
UICornerMain.Parent = MainFrame

-- Titel
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,50)
Title.BackgroundTransparency = 1
Title.Text = "Lobby Notizen"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextColor3 = Color3.fromRGB(230,230,230)
Title.Parent = MainFrame

-- Suchleiste
local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1,-20,0,35)
SearchBox.Position = UDim2.new(0,10,0,55)
SearchBox.PlaceholderText = "Spieler suchen..."
SearchBox.BackgroundColor3 = Color3.fromRGB(55,55,65)
SearchBox.TextColor3 = Color3.fromRGB(230,230,230)
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 16
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = MainFrame
local UICornerSearch = Instance.new("UICorner")
UICornerSearch.CornerRadius = UDim.new(0,6)
UICornerSearch.Parent = SearchBox

-- Scrollframe für Spieler
local PlayerListFrame = Instance.new("ScrollingFrame")
PlayerListFrame.Size = UDim2.new(1,-20,1,-100)
PlayerListFrame.Position = UDim2.new(0,10,0,100)
PlayerListFrame.BackgroundTransparency = 1
PlayerListFrame.ScrollBarThickness = 6
PlayerListFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = PlayerListFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0,5)

-- Funktion: Notizfenster
local function openNotesWindow(player)
    local NoteFrame = Instance.new("Frame")
    NoteFrame.Size = UDim2.new(0,300,0,200)
    NoteFrame.Position = UDim2.new(0.5,-150,0.5,-100)
    NoteFrame.BackgroundColor3 = Color3.fromRGB(50,50,60)
    NoteFrame.BorderSizePixel = 0
    NoteFrame.Active = true
    NoteFrame.Draggable = true
    NoteFrame.AnchorPoint = Vector2.new(0.5,0.5)
    NoteFrame.Parent = ScreenGui

    local UICornerNote = Instance.new("UICorner")
    UICornerNote.CornerRadius = UDim.new(0,10)
    UICornerNote.Parent = NoteFrame

    -- Titel
    local NoteTitle = Instance.new("TextLabel")
    NoteTitle.Size = UDim2.new(1,-40,0,35)
    NoteTitle.Position = UDim2.new(0,10,0,10)
    NoteTitle.Text = "Notizen: "..player.Name
    NoteTitle.TextColor3 = Color3.fromRGB(230,230,230)
    NoteTitle.Font = Enum.Font.GothamBold
    NoteTitle.TextSize = 18
    NoteTitle.BackgroundTransparency = 1
    NoteTitle.Parent = NoteFrame

    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0,25,0,25)
    CloseButton.Position = UDim2.new(1,-35,0,10)
    CloseButton.Text = "✖"
    CloseButton.TextColor3 = Color3.fromRGB(230,230,230)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 18
    CloseButton.BackgroundColor3 = Color3.fromRGB(180,50,50)
    CloseButton.Parent = NoteFrame
    local UICornerClose = Instance.new("UICorner")
    UICornerClose.CornerRadius = UDim.new(0,6)
    UICornerClose.Parent = CloseButton

    CloseButton.MouseButton1Click:Connect(function()
        NoteFrame:Destroy()
    end)

    -- ScrollFrame für Notizen
    local NotesList = Instance.new("ScrollingFrame")
    NotesList.Size = UDim2.new(1,-20,1,-90)
    NotesList.Position = UDim2.new(0,10,0,50)
    NotesList.BackgroundTransparency = 1
    NotesList.ScrollBarThickness = 5
    NotesList.Parent = NoteFrame

    local NotesLayout = Instance.new("UIListLayout")
    NotesLayout.Parent = NotesList
    NotesLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotesLayout.Padding = UDim.new(0,4)

    -- Notizen aktualisieren
    local function refreshNotes()
        for _, child in ipairs(NotesList:GetChildren()) do
            if child:IsA("TextLabel") then
                child:Destroy()
            end
        end
        local notes = PlayerNotesData[player.UserId] or {}
        for _, note in ipairs(notes) do
            local NoteLabel = Instance.new("TextLabel")
            NoteLabel.Size = UDim2.new(1,0,0,28)
            NoteLabel.BackgroundColor3 = Color3.fromRGB(65,65,75)
            NoteLabel.Text = "• "..note
            NoteLabel.TextColor3 = Color3.fromRGB(230,230,230)
            NoteLabel.Font = Enum.Font.Gotham
            NoteLabel.TextSize = 15
            NoteLabel.Parent = NotesList
            local UICornerN = Instance.new("UICorner")
            UICornerN.CornerRadius = UDim.new(0,6)
            UICornerN.Parent = NoteLabel
        end
    end

    refreshNotes()

    -- Neue Notiz hinzufügen
    local InputBox = Instance.new("TextBox")
    InputBox.Size = UDim2.new(1,-20,0,30)
    InputBox.Position = UDim2.new(0,10,1,-40)
    InputBox.PlaceholderText = "Neue Notiz..."
    InputBox.BackgroundColor3 = Color3.fromRGB(70,70,85)
    InputBox.TextColor3 = Color3.fromRGB(230,230,230)
    InputBox.Font = Enum.Font.Gotham
    InputBox.TextSize = 16
    InputBox.ClearTextOnFocus = true
    InputBox.Parent = NoteFrame
    local UICornerInput = Instance.new("UICorner")
    UICornerInput.CornerRadius = UDim.new(0,6)
    UICornerInput.Parent = InputBox

    InputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed and InputBox.Text ~= "" then
            if not PlayerNotesData[player.UserId] then
                PlayerNotesData[player.UserId] = {}
            end
            table.insert(PlayerNotesData[player.UserId], InputBox.Text)
            InputBox.Text = ""
            refreshNotes()
        end
    end)
end

-- Spielerbutton erstellen
local function createPlayerButton(player)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1,0,0,38)
    Button.BackgroundColor3 = Color3.fromRGB(70,130,200)
    Button.Text = player.Name
    Button.TextColor3 = Color3.fromRGB(230,230,230)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 17
    Button.Parent = PlayerListFrame
    local UICornerB = Instance.new("UICorner")
    UICornerB.CornerRadius = UDim.new(0,8)
    UICornerB.Parent = Button

    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(95,160,220)
    end)
    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(70,130,200)
    end)

    Button.MouseButton1Click:Connect(function()
        openNotesWindow(player)
    end)
end

-- Spielerliste aktualisieren mit Filter
local function updatePlayerList(filter)
    for _, child in ipairs(PlayerListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if not filter or string.find(string.lower(player.Name), string.lower(filter)) then
                createPlayerButton(player)
            end
        end
    end
end

-- Suchbox Event
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    updatePlayerList(SearchBox.Text)
end)

Players.PlayerAdded:Connect(function()
    updatePlayerList(SearchBox.Text)
end)
Players.PlayerRemoving:Connect(function()
    updatePlayerList(SearchBox.Text)
end)

updatePlayerList()
