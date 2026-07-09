import re

with open('UI.lua', 'r', encoding='utf-8') as f:
    content = f.read()

pattern = r'for _, assign in ipairs\(boss\.assignments\).*?yOffset = yOffset - 50\n            end'

replacement = '''for _, assign in ipairs(boss.assignments) do
                local aFrame = CreateFrame("Frame", nil, parent, "BackdropTemplate")
                table_insert(parent.contentFrames, aFrame)
                aFrame:SetSize(colWidth - 20, 60)
                aFrame:SetPoint("TOPLEFT", xOffset + 10, yOffset)
                aFrame:SetBackdrop({ bgFile = "Interface\\\\Buttons\\\\WHITE8x8" })
                aFrame:SetBackdropColor(0.15, 0.15, 0.15, 0.8)
                
                local textLeft = 10
                -- Spell Icon
                if assign.spellId then
                    local iconTex = aFrame:CreateTexture(nil, "ARTWORK")
                    iconTex:SetSize(28, 28)
                    iconTex:SetPoint("TOPLEFT", 5, -8)
                    local _, _, tex = GetSpellInfo(assign.spellId)
                    iconTex:SetTexture(tex or "Interface\\\\Icons\\\\INV_Misc_QuestionMark")
                    textLeft = 40
                end
                
                local taskText = aFrame:CreateFontString(nil, "OVERLAY")
                taskText:SetFontObject("GameFontHighlight")
                taskText:SetPoint("TOPLEFT", textLeft, -5)
                taskText:SetWidth(colWidth - textLeft - 15)
                taskText:SetJustifyH("LEFT")
                taskText:SetText(assign.taskName)
                
                local playerText = aFrame:CreateFontString(nil, "OVERLAY")
                playerText:SetFontObject("GameFontNormalSmall")
                playerText:SetPoint("TOPLEFT", textLeft, -20)
                playerText:SetJustifyH("LEFT")
                
                if assign.player then
                    local colorCode = CLASS_COLORS[assign.player.class] or "|cFFFFFFFF"
                    playerText:SetText(colorCode .. assign.player.name .. "|r")
                else
                    playerText:SetText("|cFFFF0000[MISSING]|r")
                end
                
                local descText = aFrame:CreateFontString(nil, "OVERLAY")
                descText:SetFontObject("GameFontHighlightSmall")
                descText:SetPoint("TOPLEFT", textLeft, -35)
                descText:SetWidth(colWidth - textLeft - 15)
                descText:SetHeight(20)
                descText:SetJustifyH("LEFT")
                descText:SetJustifyV("TOP")
                descText:SetTextColor(0.6, 0.6, 0.6)
                descText:SetText(assign.taskDesc)
                
                yOffset = yOffset - 65
            end'''

content = re.sub(pattern, replacement, content, flags=re.DOTALL)

with open('UI.lua', 'w', encoding='utf-8') as f:
    f.write(content)
