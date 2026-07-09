import re

with open('UI.lua', 'r', encoding='utf-8') as f:
    content = f.read()

pattern = r'function Addon\.UI:RenderAssignments\(assignmentsData\).*?parent:SetHeight\(math_abs\(yOffset\)\)\nend'

replacement = '''function Addon.UI:RenderAssignments(assignmentsData)
    if not self.AssignmentsFrame then return end
    local parent = self.AssignmentsFrame.assignScrollChild
    if not parent then return end
    
    -- Clean previous elements safely
    if parent.contentFrames then
        for _, f in ipairs(parent.contentFrames) do f:Hide() end
    end
    parent.contentFrames = {}
    
    local numColumns = #assignmentsData
    if numColumns == 0 then numColumns = 1 end
    
    local windowWidth = 1100
    local colWidth = windowWidth / numColumns
    local globalMaxY = 0
    
    for colIndex, raid in ipairs(assignmentsData) do
        local xOffset = (colIndex - 1) * colWidth + 10
        local yOffset = -10
        
        local rHeader = CreateFrame("Frame", nil, parent)
        table_insert(parent.contentFrames, rHeader)
        rHeader:SetSize(colWidth - 20, 30)
        rHeader:SetPoint("TOPLEFT", xOffset, yOffset)
        
        local rt = rHeader:CreateFontString(nil, "OVERLAY")
        rt:SetPoint("LEFT", 5, 0)
        rt:SetFontObject("GameFontHighlightLarge")
        rt:SetText("|cFFFFFF00" .. raid.raidName .. "|r")
        yOffset = yOffset - 40
        
        for _, boss in ipairs(raid.bosses) do
            local bHeader = CreateFrame("Frame", nil, parent)
            table_insert(parent.contentFrames, bHeader)
            bHeader:SetSize(colWidth - 20, 24)
            bHeader:SetPoint("TOPLEFT", xOffset + 5, yOffset)
            
            local bt = bHeader:CreateFontString(nil, "OVERLAY")
            bt:SetPoint("LEFT", 0, 0)
            bt:SetFontObject("GameFontNormalLarge")
            bt:SetText(boss.bossName)
            yOffset = yOffset - 30
            
            for _, assign in ipairs(boss.assignments) do
                local aFrame = CreateFrame("Frame", nil, parent, "BackdropTemplate")
                table_insert(parent.contentFrames, aFrame)
                aFrame:SetSize(colWidth - 20, 45)
                aFrame:SetPoint("TOPLEFT", xOffset + 10, yOffset)
                aFrame:SetBackdrop({ bgFile = "Interface\\\\Buttons\\\\WHITE8x8" })
                aFrame:SetBackdropColor(0.15, 0.15, 0.15, 0.8)
                
                -- Spell Icon
                if assign.spellId then
                    local iconTex = aFrame:CreateTexture(nil, "ARTWORK")
                    iconTex:SetSize(28, 28)
                    iconTex:SetPoint("TOPLEFT", 5, -8)
                    local _, _, tex = GetSpellInfo(assign.spellId)
                    iconTex:SetTexture(tex or "Interface\\\\Icons\\\\INV_Misc_QuestionMark")
                    
                    local taskText = aFrame:CreateFontString(nil, "OVERLAY")
                    taskText:SetFontObject("GameFontHighlight")
                    taskText:SetPoint("TOPLEFT", 40, -5)
                    taskText:SetWidth(colWidth - 110)
                    taskText:SetHeight(15)
                    taskText:SetJustifyH("LEFT")
                    taskText:SetText(assign.taskName)
                    
                    local descText = aFrame:CreateFontString(nil, "OVERLAY")
                    descText:SetFontObject("GameFontHighlightSmall")
                    descText:SetPoint("BOTTOMLEFT", 40, 5)
                    descText:SetWidth(colWidth - 110)
                    descText:SetHeight(25)
                    descText:SetJustifyH("LEFT")
                    descText:SetJustifyV("TOP")
                    descText:SetTextColor(0.6, 0.6, 0.6)
                    descText:SetText(assign.taskDesc)
                else
                    local taskText = aFrame:CreateFontString(nil, "OVERLAY")
                    taskText:SetFontObject("GameFontHighlight")
                    taskText:SetPoint("TOPLEFT", 5, -5)
                    taskText:SetWidth(colWidth - 75)
                    taskText:SetHeight(15)
                    taskText:SetJustifyH("LEFT")
                    taskText:SetText(assign.taskName)
                    
                    local descText = aFrame:CreateFontString(nil, "OVERLAY")
                    descText:SetFontObject("GameFontHighlightSmall")
                    descText:SetPoint("BOTTOMLEFT", 5, 5)
                    descText:SetWidth(colWidth - 75)
                    descText:SetHeight(25)
                    descText:SetJustifyH("LEFT")
                    descText:SetJustifyV("TOP")
                    descText:SetTextColor(0.6, 0.6, 0.6)
                    descText:SetText(assign.taskDesc)
                end
                
                local playerText = aFrame:CreateFontString(nil, "OVERLAY")
                playerText:SetFontObject("GameFontNormalSmall")
                playerText:SetPoint("TOPRIGHT", -5, -5)
                playerText:SetJustifyH("RIGHT")
                
                if assign.player then
                    local colorCode = CLASS_COLORS[assign.player.class] or "|cFFFFFFFF"
                    local shortSpec = string.gsub(assign.player.spec, "%d+$", "")
                    playerText:SetText(colorCode .. assign.player.name .. "\\n(" .. shortSpec .. ")|r")
                else
                    playerText:SetText("|cFFFF0000[MISSING]|r")
                end
                
                yOffset = yOffset - 50
            end
            yOffset = yOffset - 10
        end
        if math_abs(yOffset) > globalMaxY then
            globalMaxY = math_abs(yOffset)
        end
    end
    
    parent:SetHeight(globalMaxY + 20)
end'''

content = re.sub(pattern, replacement, content, flags=re.DOTALL)

with open('UI.lua', 'w', encoding='utf-8') as f:
    f.write(content)
