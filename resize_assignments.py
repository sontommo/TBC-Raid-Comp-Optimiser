import re

with open('UI.lua', 'r', encoding='utf-8') as f:
    content = f.read()

# Replace assignments window size
size_pattern = r"f:SetSize\(800, 600\)"
size_replacement = "f:SetSize(1150, 700)"
content = re.sub(size_pattern, size_replacement, content)

child_pattern = r"assignScrollChild:SetSize\(740, 1000\)"
child_replacement = "assignScrollChild:SetSize(1100, 1000)"
content = re.sub(child_pattern, child_replacement, content)

with open('UI.lua', 'w', encoding='utf-8') as f:
    f.write(content)
