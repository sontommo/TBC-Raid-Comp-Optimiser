import re

with open('UI.lua', 'r') as f:
    content = f.read()

# Replace Tab UI
tab_pattern = r'    -- Tabs \(Top Right\).*?-- Active by default'
tab_replacement = '''    -- Assignments Window Toggle
    local assignBtn = CreateSleekButton(f, "Show Assignments", 150, 30)
    assignBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -20, -45)
    assignBtn:SetScript("OnClick", function()
        if Addon.UI.AssignmentsFrame then
            if Addon.UI.AssignmentsFrame:IsShown() then
                Addon.UI.AssignmentsFrame:Hide()
            else
                Addon.UI.AssignmentsFrame:Show()
            end
        end
    end)
    
    -- Groups Grid Container (Main View)
    local groupsContainer = CreateFrame("Frame", nil, f)
    groupsContainer:SetPoint("TOPLEFT", 20, -90)
    f.groupsContainer = groupsContainer'''

content = re.sub(tab_pattern, tab_replacement, content, flags=re.DOTALL)

# Replace RenderAssignments
render_pattern = r'function Addon\.UI:RenderAssignments\(assignmentsData\)\n    local parent = self\.MainFrame\.assignScrollChild\n    if not parent then return end'
render_replacement = '''function Addon.UI:RenderAssignments(assignmentsData)
    if not self.AssignmentsFrame then return end
    local parent = self.AssignmentsFrame.assignScrollChild
    if not parent then return end'''
    
content = re.sub(render_pattern, render_replacement, content)

with open('UI.lua', 'w') as f:
    f.write(content)
