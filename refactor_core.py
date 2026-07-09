import re

with open('Core.lua', 'r') as f:
    content = f.read()

content = content.replace('    Addon.UI:CreateMainFrame()', '    Addon.UI:CreateMainFrame()\n    Addon.UI:CreateAssignmentsFrame()')

with open('Core.lua', 'w') as f:
    f.write(content)
