import re

with open('Core.lua', 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace('    Addon.UI:CreateAssignmentsFrame()\n    Addon.UI:CreateAssignmentsFrame()', '    Addon.UI:CreateAssignmentsFrame()')

with open('Core.lua', 'w', encoding='utf-8') as f:
    f.write(content)
