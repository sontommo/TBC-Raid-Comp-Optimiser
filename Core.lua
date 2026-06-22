local AddonName, Addon = ...
Addon.Core = {}

-- Localize globals for performance optimization
local type = type
local pairs = pairs
local pcall = pcall
local print = print
local string_gsub = string.gsub
local table_insert = table.insert

function Addon.Core:OnInitialize()
    Addon.UI:CreateMainFrame()
    
    SLASH_TBCRAIDCOMP1 = "/raidcomp"
    SlashCmdList["TBCRAIDCOMP"] = function(msg)
        if Addon.MainFrame:IsShown() then
            Addon.MainFrame:Hide()
        else
            Addon.MainFrame:Show()
        end
    end
end

local function FindPlayers(t, results)
    if type(t) == "table" then
        local pName = t.name
        local pClass = t.className or t.class
        local pSpec = t.specName or t.spec
        
        -- Check if it's a valid player object
        if pName and pClass and pSpec and type(pName) == "string" and type(pClass) == "string" and type(pSpec) == "string" then
            -- Raid-Helper sometimes puts "Tank" or "Healer" as className
            local realClass = pClass
            if Addon.SPECS and Addon.SPECS[pSpec] then
                realClass = Addon.SPECS[pSpec].class
            end
            
            -- Ignore absences, bench, late
            if pClass ~= "Absence" and pClass ~= "Late" and pClass ~= "Bench" and pClass ~= "Tentative" then
                table_insert(results, {
                    name = pName,
                    class = realClass,
                    spec = pSpec
                })
            end
        else
            for k, v in pairs(t) do
                if type(v) == "table" then
                    FindPlayers(v, results)
                end
            end
        end
    end
end

function Addon.Core:OnGenerateClicked(jsonStr)
    if not jsonStr or jsonStr == "" then
        print("TBC Raid Comp: Please paste JSON string first.")
        return
    end
    
    -- Replace non-printable characters or weird quotes sometimes copied from Discord
    jsonStr = string_gsub(jsonStr, "“", '"')
    jsonStr = string_gsub(jsonStr, "”", '"')
    
    local success, data = pcall(TBCJSON.decode, jsonStr)
    if not success then
        print("TBC Raid Comp: Failed to parse JSON. Ensure you copied the raw JSON.")
        print(data)
        return
    end
    
    local players = {}
    FindPlayers(data, players)
    
    if #players == 0 then
        print("TBC Raid Comp: Found 0 players in the JSON. Check the format.")
        return
    end
    
    print("TBC Raid Comp: Optimising " .. #players .. " players...")
    
    local groups = Addon.Optimiser:Optimise(players)
    local buffs = Addon.Optimiser:AnalyzeBuffs(groups)
    
    Addon.UI:RenderGroups(groups, buffs)
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        self:UnregisterEvent("PLAYER_LOGIN")
        Addon.Core:OnInitialize()
    end
end)
