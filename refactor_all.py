import re

with open('Core.lua', 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace('    Addon.UI:CreateMainFrame()', '    Addon.UI:CreateMainFrame()\n    Addon.UI:CreateAssignmentsFrame()')

with open('Core.lua', 'w', encoding='utf-8') as f:
    f.write(content)

with open('UI.lua', 'r', encoding='utf-8') as f:
    ui_content = f.read()

render_pattern = r'function Addon\.UI:RenderAssignments\(assignmentsData\)\n    local parent = self\.MainFrame\.assignScrollChild\n    if not parent then return end'
render_replacement = '''function Addon.UI:RenderAssignments(assignmentsData)
    if not self.AssignmentsFrame then return end
    local parent = self.AssignmentsFrame.assignScrollChild
    if not parent then return end'''
    
ui_content = re.sub(render_pattern, render_replacement, ui_content)

with open('UI.lua', 'w', encoding='utf-8') as f:
    f.write(ui_content)
