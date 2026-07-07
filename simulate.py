import random
from collections import defaultdict
import json

SPECS = [
    ("Protection", "Warrior", "Tank"),
    ("Fury", "Warrior", "Melee"),
    ("Arms", "Warrior", "Melee"),
    ("Protection", "Paladin", "Tank"),
    ("Holy", "Paladin", "Healer"),
    ("Retribution", "Paladin", "Melee"),
    ("Feral", "Druid", "Melee"), # We will randomise if they are tank or DPS
    ("Restoration", "Druid", "Healer"),
    ("Balance", "Druid", "Ranged"),
    ("Restoration", "Shaman", "Healer"),
    ("Enhancement", "Shaman", "Melee"),
    ("Elemental", "Shaman", "Ranged"),
    ("Shadow", "Priest", "Ranged"),
    ("Holy", "Priest", "Healer"),
    ("Discipline", "Priest", "Healer"),
    ("Arcane", "Mage", "Ranged"),
    ("Fire", "Mage", "Ranged"),
    ("Frost", "Mage", "Ranged"),
    ("Destruction", "Warlock", "Ranged"),
    ("Affliction", "Warlock", "Ranged"),
    ("Demonology", "Warlock", "Ranged"),
    ("Combat", "Rogue", "Melee"),
    ("Assassination", "Rogue", "Melee"),
    ("Subtlety", "Rogue", "Melee"),
    ("Beast Mastery", "Hunter", "Ranged"),
    ("Marksmanship", "Hunter", "Ranged"),
    ("Survival", "Hunter", "Ranged"),
]

def generate_random_comp():
    comp = []
    # Force 3-4 tanks
    num_tanks = random.randint(3, 4)
    tank_pool = [("Protection", "Warrior"), ("Protection", "Paladin"), ("Feral", "Druid", "Tank")]
    for _ in range(num_tanks):
        t = random.choice(tank_pool)
        if len(t) == 3:
            comp.append({"spec": t[0], "class": t[1], "role": "Tank"})
        else:
            comp.append({"spec": t[0], "class": t[1], "role": "Tank"})
            
    # Force 5-7 healers
    num_healers = random.randint(5, 7)
    healer_pool = [s for s in SPECS if s[2] == "Healer"]
    for _ in range(num_healers):
        h = random.choice(healer_pool)
        comp.append({"spec": h[0], "class": h[1], "role": "Healer"})
        
    # Fill remaining with DPS (sometimes very skewed)
    remaining = 25 - len(comp)
    dps_pool = [s for s in SPECS if s[2] in ("Melee", "Ranged") and s[0] != "Feral"]
    # Allow some feral DPS
    dps_pool.append(("Feral", "Druid", "Melee"))
    
    for _ in range(remaining):
        d = random.choice(dps_pool)
        if len(d) == 3:
            comp.append({"spec": d[0], "class": d[1], "role": d[2]})
    return comp

def optimise(players):
    groups = [[], [], [], [], []]
    
    def get_free(g): return 5 - len(groups[g-1])
    def add_to_group(p, g):
        if p and get_free(g) > 0:
            groups[g-1].append(p)
            return True
        return False
        
    roles = defaultdict(list)
    for p in players:
        r = p.get("role", "DPS")
        s = p["spec"]
        c = p["class"]
        
        if r == "Tank" or "Protection" in s or s == "Guardian": roles["tanks"].append(p)
        elif s == "Enhancement": roles["enhanceShamans"].append(p)
        elif s == "Elemental": roles["eleShamans"].append(p)
        elif s in ("Restoration", "Restoration1") and c == "Shaman": roles["restoShamans"].append(p)
        elif s == "Shadow": roles["shadowPriests"].append(p)
        elif s == "Balance": roles["boomkins"].append(p)
        elif s == "Feral" and r != "Tank": roles["feralDPS"].append(p)
        elif s == "Retribution": roles["retPaladins"].append(p)
        elif c == "Hunter": roles["hunters"].append(p)
        elif c == "Warrior" and r != "Tank": roles["warriors"].append(p)
        elif c == "Rogue": roles["rogues"].append(p)
        elif s == "Arcane": roles["arcaneMages"].append(p)
        elif c == "Warlock": roles["warlocks"].append(p)
        elif r == "Ranged" or c == "Mage": roles["otherCasters"].append(p)
        elif s in ("Restoration", "Restoration1") and c == "Druid": roles["restoDruids"].append(p)
        else: roles["otherHealers"].append(p)

    def place(lst, prefs):
        for p in reversed(lst):
            for g in prefs:
                if add_to_group(p, g):
                    lst.remove(p)
                    break
                    
    def pull_one(lst, prefs):
        for p in reversed(lst):
            for g in prefs:
                if add_to_group(p, g):
                    lst.remove(p)
                    return True
        return False

    # P1
    for p in reversed(roles["tanks"]):
        placed = False
        if p["spec"] == "Guardian" or (p["spec"] == "Feral" and p.get("role") == "Tank"):
            has_bear = any(m["spec"] == "Guardian" or (m["spec"] == "Feral" and m.get("role") == "Tank") for m in groups[0])
            if has_bear:
                placed = add_to_group(p, 3) or add_to_group(p, 2)
        if not placed: placed = add_to_group(p, 1) or add_to_group(p, 2)
        if placed: roles["tanks"].remove(p)
        
    pull_one(roles["warlocks"], [1])
    pull_one(roles["restoDruids"], [1])
    
    # P2
    for p in reversed(roles["enhanceShamans"]):
        if add_to_group(p, 2) or add_to_group(p, 3) or add_to_group(p, 1) or add_to_group(p, 2) or add_to_group(p, 3):
            roles["enhanceShamans"].remove(p)
    for p in reversed(roles["eleShamans"]):
        if add_to_group(p, 4) or add_to_group(p, 5) or add_to_group(p, 4):
            roles["eleShamans"].remove(p)
    for p in reversed(roles["restoShamans"]):
        g1_needs_shaman = not any(m["class"] == "Shaman" for m in groups[0])
        placed = False
        if g1_needs_shaman: placed = add_to_group(p, 1)
        if not placed: placed = add_to_group(p, 5) or add_to_group(p, 4)
        if placed: roles["restoShamans"].remove(p)
        
    # P3
    for p in reversed(roles["shadowPriests"]):
        if add_to_group(p, 4) or add_to_group(p, 5) or add_to_group(p, 4): roles["shadowPriests"].remove(p)
    for p in reversed(roles["boomkins"]):
        if add_to_group(p, 4) or add_to_group(p, 5) or add_to_group(p, 4): roles["boomkins"].remove(p)
        
    # P4
    for p in reversed(roles["feralDPS"]):
        if add_to_group(p, 3) or add_to_group(p, 2): roles["feralDPS"].remove(p)
    for p in reversed(roles["retPaladins"]):
        if add_to_group(p, 2) or add_to_group(p, 3): roles["retPaladins"].remove(p)
        
    # P5
    place(roles["hunters"], [3, 2, 4])
    pull_one(roles["warriors"], [3])
    place(roles["warriors"], [2, 3])
    place(roles["rogues"], [2, 3])
    
    # P6
    place(roles["arcaneMages"], [4, 5])
    place(roles["warlocks"], [5, 4])
    place(roles["otherCasters"], [4, 5, 3])
    
    # P7
    place(roles["restoDruids"], [5, 4, 1])
    place(roles["otherHealers"], [5, 4, 1, 3, 2])
    
    # P8
    for lst in roles.values():
        place(lst, [1, 2, 3, 4, 5])
        
    return groups

def score_comp(groups):
    score = 0
    
    # We evaluate synergy within each group
    for group in groups:
        specs_in_group = [p["spec"] for p in group]
        classes_in_group = [p["class"] for p in group]
        roles_in_group = [p.get("role", "DPS") for p in group]
        
        has_windfury = "Enhancement" in specs_in_group
        has_totem_of_wrath = "Elemental" in specs_in_group
        has_mana_tide = "Restoration" in specs_in_group and "Shaman" in classes_in_group
        has_shadow_priest = "Shadow" in specs_in_group
        has_battle_shout = "Warrior" in classes_in_group
        has_lotp = "Feral" in specs_in_group
        has_moonkin = "Balance" in specs_in_group
        has_sanctity = "Retribution" in specs_in_group
        
        hunters = specs_in_group.count("Beast Mastery") + specs_in_group.count("Survival") + specs_in_group.count("Marksmanship")
        
        for p in group:
            role = p.get("role", "DPS")
            spec = p["spec"]
            
            if role == "Melee" or p["class"] in ["Rogue", "Warrior"] or (spec == "Feral" and role != "Tank"):
                if has_windfury: score += 100
                if has_battle_shout: score += 50
                if has_lotp: score += 50
                if has_sanctity: score += 40
                
            if p["class"] == "Hunter":
                if has_windfury: score += 50
                if has_battle_shout: score += 80 # Pets love AP
                if has_lotp: score += 50
                score += (hunters * 30) # FI stacking simulation
                
            if role == "Ranged" and p["class"] in ["Mage", "Warlock", "Priest", "Druid"]:
                if has_totem_of_wrath: score += 80
                if has_shadow_priest: score += 100
                if has_moonkin: score += 50
                
            if spec == "Arcane":
                if has_shadow_priest: score += 150 # Critical synergy
                
            if role == "Healer":
                if has_mana_tide: score += 100
                if has_shadow_priest: score += 60
                
    # Quirky penalization
    # We want to discover comps that score high but have a weird setup (e.g., 0 meta specs)
    # A standard comp usually has 1 of each support. Let's not penalize, let's just let the score speak for itself.
    
    return score

def main():
    best_comps = []
    
    for i in range(100000):
        players = generate_random_comp()
        groups = optimise(players)
        
        # Check if perfectly filled (all groups have 5)
        if any(len(g) != 5 for g in groups):
            continue
            
        score = score_comp(groups)
        
        best_comps.append((score, players, groups))
        
    best_comps.sort(key=lambda x: x[0], reverse=True)
    
    # We want top 10 unique comps. We consider comps unique if their class distribution is different.
    unique_comps = []
    seen_distributions = set()
    
    for score, players, groups in best_comps:
        dist = tuple(sorted([p["spec"] + " " + p["class"] for p in players]))
        if dist not in seen_distributions:
            seen_distributions.add(dist)
            unique_comps.append((score, players, groups))
        if len(unique_comps) == 10:
            break
            
    with open("simulation_results.txt", "w") as f:
        f.write("Top 10 High-Synergy 'Quirky' Raid Compositions:\n\n")
        for idx, (score, players, groups) in enumerate(unique_comps):
            f.write(f"--- Comp #{idx+1} | Synergy Score: {score} ---\n")
            
            # Count specs for summary
            spec_counts = defaultdict(int)
            for p in players:
                spec_counts[p["spec"] + " " + p["class"]] += 1
            summary = ", ".join(f"{v}x {k}" for k, v in sorted(spec_counts.items(), key=lambda item: item[1], reverse=True))
            f.write(f"Roster Summary: {summary}\n\n")
            
            for g_idx, group in enumerate(groups):
                f.write(f"  Group {g_idx+1}:\n")
                for p in group:
                    f.write(f"    - {p['spec']} {p['class']}\n")
            f.write("\n")

if __name__ == "__main__":
    main()
