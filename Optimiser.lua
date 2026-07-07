local AddonName, Addon = ...
Addon.Optimiser = {}

-- Localize globals for performance optimization
local table_insert = table.insert
local table_remove = table.remove
local ipairs = ipairs
local wipe = wipe or function(t) for k in pairs(t) do t[k] = nil end end

local SPECS = {
    -- Warriors
    ["Arms"] = { class="Warrior", role="Melee", buffs={"Battle Shout", "Commanding Shout", "Blood Frenzy", "Sunder Armor", "Improved Demoralizing Shout", "Improved Thunder Clap"} },
    ["Fury"] = { class="Warrior", role="Melee", buffs={"Battle Shout", "Commanding Shout", "Sunder Armor", "Improved Demoralizing Shout"} },
    ["Protection"] = { class="Warrior", role="Tank", buffs={"Battle Shout", "Commanding Shout", "Sunder Armor", "Improved Demoralizing Shout", "Improved Thunder Clap"} },
    
    -- Paladins
    ["Holy1"] = { class="Paladin", role="Healer", buffs={"Blessing of Kings", "Blessing of Might", "Blessing of Wisdom", "Blessing of Salvation", "Devotion Aura", "Concentration Aura", "Judgement of Wisdom", "Judgement of Light"} },
    ["Holy"] = { class="Paladin", role="Healer", buffs={"Blessing of Kings", "Blessing of Might", "Blessing of Wisdom", "Blessing of Salvation", "Devotion Aura", "Concentration Aura", "Judgement of Wisdom", "Judgement of Light"} },
    ["Protection1"] = { class="Paladin", role="Tank", buffs={"Blessing of Kings", "Blessing of Might", "Blessing of Wisdom", "Blessing of Salvation", "Devotion Aura", "Retribution Aura", "Judgement of Wisdom", "Judgement of Light", "Blessing of Sanctuary"} },
    ["Retribution"] = { class="Paladin", role="Melee", buffs={"Blessing of Kings", "Blessing of Might", "Blessing of Wisdom", "Blessing of Salvation", "Sanctity Aura", "Retribution Aura", "Judgement of Wisdom", "Judgement of Light", "Improved Seal of the Crusader"} },
    ["Protection"] = { class="Warrior", role="Tank", buffs={"Battle Shout", "Commanding Shout", "Sunder Armor"} },
    
    -- Hunters
    ["Beastmastery"] = { class="Hunter", role="Ranged", buffs={"Ferocious Inspiration", "Scorpid Sting"} },
    ["Marksmanship"] = { class="Hunter", role="Ranged", buffs={"Trueshot Aura", "Scorpid Sting"} },
    ["Survival"] = { class="Hunter", role="Ranged", buffs={"Expose Weakness", "Scorpid Sting"} },
    
    -- Rogues
    ["Assassination"] = { class="Rogue", role="Melee", buffs={"Expose Armor", "Improved Expose Armor"} },
    ["Combat"] = { class="Rogue", role="Melee", buffs={"Expose Armor", "Improved Expose Armor"} },
    ["Subtlety"] = { class="Rogue", role="Melee", buffs={"Expose Armor", "Improved Expose Armor", "Hemorrhage"} },
    
    -- Priests
    ["Discipline"] = { class="Priest", role="Healer", buffs={"Power Word: Fortitude", "Shadow Protection", "Divine Spirit", "Pain Suppression"} },
    ["Holy"] = { class="Priest", role="Healer", buffs={"Power Word: Fortitude", "Shadow Protection"} },
    ["Shadow"] = { class="Priest", role="Ranged", buffs={"Power Word: Fortitude", "Shadow Protection", "Vampiric Touch", "Misery", "Shadow Weaving"} },
    ["Smite"] = { class="Priest", role="Ranged", buffs={"Power Word: Fortitude", "Shadow Protection"} },
    
    -- Shamans
    ["Elemental"] = { class="Shaman", role="Ranged", buffs={"Bloodlust", "Totem of Wrath", "Wrath of Air Totem", "Mana Spring Totem", "Tremor Totem"} },
    ["Enhancement"] = { class="Shaman", role="Melee", buffs={"Bloodlust", "Windfury Totem", "Unleashed Rage", "Strength of Earth Totem", "Grace of Air Totem", "Tremor Totem"} },
    ["Restoration1"] = { class="Shaman", role="Healer", buffs={"Bloodlust", "Mana Tide Totem", "Mana Spring Totem", "Wrath of Air Totem", "Healing Stream Totem", "Tremor Totem", "Earth Shield"} },
    ["Restoration"] = { class="Shaman", role="Healer", buffs={"Bloodlust", "Mana Tide Totem", "Mana Spring Totem", "Wrath of Air Totem", "Healing Stream Totem", "Tremor Totem", "Earth Shield"} },
    
    -- Mages
    ["Arcane"] = { class="Mage", role="Ranged", buffs={"Arcane Intellect"} },
    ["Fire"] = { class="Mage", role="Ranged", buffs={"Arcane Intellect", "Improved Scorch"} },
    ["Frost"] = { class="Mage", role="Ranged", buffs={"Arcane Intellect", "Winter's Chill"} },
    
    -- Warlocks
    ["Affliction"] = { class="Warlock", role="Ranged", buffs={"Blood Pact", "Curse of the Elements", "Curse of Recklessness", "Shadow Embrace", "Malediction", "Improved Healthstone"} },
    ["Demonology"] = { class="Warlock", role="Ranged", buffs={"Blood Pact", "Curse of the Elements", "Curse of Recklessness", "Improved Healthstone"} },
    ["Destruction"] = { class="Warlock", role="Ranged", buffs={"Blood Pact", "Curse of the Elements", "Curse of Recklessness", "Improved Healthstone", "Improved Shadow Bolt"} },
    
    -- Druids
    ["Balance"] = { class="Druid", role="Ranged", buffs={"Mark of the Wild", "Improved Mark of the Wild", "Moonkin Aura", "Improved Faerie Fire", "Insect Swarm", "Innervate"} },
    ["Dreamstate"] = { class="Druid", role="Ranged", buffs={"Mark of the Wild", "Improved Mark of the Wild", "Improved Faerie Fire", "Innervate"} },
    ["Feral"] = { class="Druid", role="Melee", buffs={"Mark of the Wild", "Improved Mark of the Wild", "Leader of the Pack", "Mangle", "Faerie Fire", "Innervate"} },
    ["Guardian"] = { class="Druid", role="Tank", buffs={"Mark of the Wild", "Improved Mark of the Wild", "Leader of the Pack", "Mangle", "Faerie Fire", "Innervate"} },
    ["Restoration"] = { class="Druid", role="Healer", buffs={"Mark of the Wild", "Improved Mark of the Wild", "Tree of Life Aura", "Innervate"} },
}

Addon.SPECS = SPECS

-- Map EVERY buff to its exact Spell ID to ensure GetSpellInfo resolves it regardless of spellbook cache
Addon.BUFF_SPELL_IDS = {
    ["Battle Shout"] = 2048,
    ["Commanding Shout"] = 469,
    ["Blood Frenzy"] = 29859,
    ["Sunder Armor"] = 7386,
    ["Blessing of Kings"] = 25898,
    ["Blessing of Might"] = 27141,
    ["Blessing of Wisdom"] = 25894,
    ["Blessing of Salvation"] = 25895,
    ["Devotion Aura"] = 465,
    ["Concentration Aura"] = 19746,
    ["Retribution Aura"] = 7294,
    ["Blessing of Sanctuary"] = 25899,
    ["Sanctity Aura"] = 20218,
    ["Judgement of Wisdom"] = 20355,
    ["Judgement of Light"] = 20185,
    ["Ferocious Inspiration"] = 34460,
    ["Trueshot Aura"] = 19506,
    ["Expose Weakness"] = 34503,
    ["Expose Armor"] = 8647,
    ["Hemorrhage"] = 16511,
    ["Power Word: Fortitude"] = 1243,
    ["Shadow Protection"] = 39374,
    ["Divine Spirit"] = 14752,
    ["Pain Suppression"] = 33206,
    ["Vampiric Touch"] = 34914,
    ["Misery"] = 33195,
    ["Shadow Weaving"] = 15332,
    ["Bloodlust"] = 2825,
    ["Heroism"] = 32182,
    ["Totem of Wrath"] = 30706,
    ["Wrath of Air Totem"] = 3738,
    ["Mana Spring Totem"] = 5675,
    ["Tremor Totem"] = 8143,
    ["Windfury Totem"] = 8512,
    ["Unleashed Rage"] = 30809,
    ["Strength of Earth Totem"] = 8075,
    ["Grace of Air Totem"] = 8835,
    ["Mana Tide Totem"] = 16190,
    ["Healing Stream Totem"] = 5394,
    ["Earth Shield"] = 974,
    ["Arcane Intellect"] = 27127,
    ["Improved Scorch"] = 12873,
    ["Winter's Chill"] = 11180,
    ["Curse of the Elements"] = 27228,
    ["Curse of Recklessness"] = 27226,
    ["Blood Pact"] = 27268,
    ["Shadow Embrace"] = 32385,
    ["Malediction"] = 32484,
    ["Improved Healthstone"] = 6262,
    ["Improved Shadow Bolt"] = 17803,
    ["Mark of the Wild"] = 26990,
    ["Improved Mark of the Wild"] = 16998,
    ["Moonkin Aura"] = 24907,
    ["Improved Faerie Fire"] = 33602,
    ["Insect Swarm"] = 27013,
    ["Leader of the Pack"] = 24932,
    ["Mangle"] = 33878,
    ["Faerie Fire"] = 26993,
    ["Tree of Life Aura"] = 34123,
    ["Innervate"] = 29166,
    ["Improved Demoralizing Shout"] = 12879,
    ["Improved Thunder Clap"] = 12666,
    ["Improved Seal of the Crusader"] = 20336,
    ["Scorpid Sting"] = 3043,
    ["Improved Expose Armor"] = 14169,
}

Addon.PHYSICAL_BUFFS = {
    ["Blessing of Might"] = true,
    ["Windfury Totem"] = true,
    ["Unleashed Rage"] = true,
    ["Leader of the Pack"] = true,
    ["Sanctity Aura"] = true,
    ["Trueshot Aura"] = true,
    ["Ferocious Inspiration"] = true,
    ["Expose Weakness"] = true,
    ["Expose Armor"] = true,
    ["Sunder Armor"] = true,
    ["Blood Frenzy"] = true,
    ["Hemorrhage"] = true,
    ["Battle Shout"] = true,
    ["Mangle"] = true,
    ["Faerie Fire"] = true,
    ["Commanding Shout"] = true,
    ["Improved Demoralizing Shout"] = true,
    ["Improved Thunder Clap"] = true,
    ["Improved Expose Armor"] = true,
    ["Scorpid Sting"] = true,
}

Addon.SPELL_BUFFS = {
    ["Blessing of Wisdom"] = true,
    ["Mana Spring Totem"] = true,
    ["Mana Tide Totem"] = true,
    ["Vampiric Touch"] = true,
    ["Moonkin Aura"] = true,
    ["Totem of Wrath"] = true,
    ["Wrath of Air Totem"] = true,
    ["Arcane Intellect"] = true,
    ["Improved Scorch"] = true,
    ["Curse of the Elements"] = true,
    ["Shadow Weaving"] = true,
    ["Misery"] = true,
    ["Divine Spirit"] = true,
    ["Judgement of Wisdom"] = true,
    ["Malediction"] = true,
    ["Winter's Chill"] = true,
    ["Improved Shadow Bolt"] = true,
    ["Improved Seal of the Crusader"] = true,
}

Addon.IGNORED_UI_BUFFS = {
    ["Tremor Totem"] = true,
    ["Power Word: Fortitude"] = true,
    ["Shadow Protection"] = true,
    ["Devotion Aura"] = true,
    ["Concentration Aura"] = true,
    ["Retribution Aura"] = true,
    ["Blessing of Sanctuary"] = true,
    ["Healing Stream Totem"] = true,
    ["Pain Suppression"] = true,
    ["Tree of Life Aura"] = true,
    ["Mark of the Wild"] = true,
    ["Improved Mark of the Wild"] = true,
    ["Judgement of Light"] = true,
    ["Earth Shield"] = true,
    ["Improved Healthstone"] = true,
    ["Innervate"] = true,
}

function Addon.Optimiser:GetPlayerRole(spec)
    if SPECS[spec] then return SPECS[spec].role end
    return "Unknown"
end

function Addon.Optimiser:Optimise(players)
    local groups = {{}, {}, {}, {}, {}}
    local function getFree(g) return 5 - #groups[g] end
    local function addToGroup(p, g)
        if p and getFree(g) > 0 then
            table_insert(groups[g], p)
            return true
        end
        return false
    end

    -- 1. Micro-role Categorisation
    local roles = {
        tanks = {},
        enhanceShamans = {},
        eleShamans = {},
        restoShamans = {},
        shadowPriests = {},
        boomkins = {},
        feralDPS = {},
        retPaladins = {},
        hunters = {},
        warriors = {},
        rogues = {},
        arcaneMages = {},
        warlocks = {},
        otherCasters = {},
        restoDruids = {},
        otherHealers = {}
    }
    
    for _, p in ipairs(players) do
        local r = self:GetPlayerRole(p.spec)
        local s = p.spec
        local c = p.class
        
        if r == "Tank" or s:match("Protection") or s == "Guardian" then table_insert(roles.tanks, p)
        elseif s == "Enhancement" then table_insert(roles.enhanceShamans, p)
        elseif s == "Elemental" then table_insert(roles.eleShamans, p)
        elseif s == "Restoration" and c == "Shaman" or s == "Restoration1" and c == "Shaman" then table_insert(roles.restoShamans, p)
        elseif s == "Shadow" then table_insert(roles.shadowPriests, p)
        elseif s == "Balance" then table_insert(roles.boomkins, p)
        elseif s == "Feral" then table_insert(roles.feralDPS, p)
        elseif s == "Retribution" then table_insert(roles.retPaladins, p)
        elseif c == "Hunter" then table_insert(roles.hunters, p)
        elseif c == "Warrior" then table_insert(roles.warriors, p)
        elseif c == "Rogue" then table_insert(roles.rogues, p)
        elseif s == "Arcane" then table_insert(roles.arcaneMages, p)
        elseif c == "Warlock" then table_insert(roles.warlocks, p)
        elseif r == "Ranged" or c == "Mage" then table_insert(roles.otherCasters, p)
        elseif s == "Restoration" and c == "Druid" or s == "Restoration1" and c == "Druid" then table_insert(roles.restoDruids, p)
        else table_insert(roles.otherHealers, p) end
    end
    
    local function place(list, prefs)
        for i = #list, 1, -1 do
            local placed = false
            for _, g in ipairs(prefs) do
                if addToGroup(list[i], g) then
                    table_remove(list, i)
                    placed = true
                    break
                end
            end
        end
    end
    
    local function pullOne(list, prefs)
        for i = #list, 1, -1 do
            for _, g in ipairs(prefs) do
                if addToGroup(list[i], g) then
                    table_remove(list, i)
                    return true
                end
            end
        end
        return false
    end

    -- Phase 1: The Core (Tanks & Warlock Blood Pact)
    for i = #roles.tanks, 1, -1 do
        local p = roles.tanks[i]
        local placed = false
        if p.spec == "Guardian" or (p.spec == "Feral" and self:GetPlayerRole(p.spec) == "Tank") then
            local hasBear = false
            for _, m in ipairs(groups[1]) do if m.spec == "Guardian" or (m.spec == "Feral" and self:GetPlayerRole(m.spec) == "Tank") then hasBear = true break end end
            if hasBear then placed = addToGroup(p, 3) or addToGroup(p, 2) end
        end
        if not placed then placed = addToGroup(p, 1) or addToGroup(p, 2) end
        if placed then table_remove(roles.tanks, i) end
    end
    
    pullOne(roles.warlocks, {1})
    pullOne(roles.restoDruids, {1})
    
    -- Phase 2: The Shamans
    for i = #roles.enhanceShamans, 1, -1 do
        local p = roles.enhanceShamans[i]
        local placed = addToGroup(p, 2) or addToGroup(p, 3) or addToGroup(p, 1) or addToGroup(p, 2) or addToGroup(p, 3)
        if placed then table_remove(roles.enhanceShamans, i) end
    end
    for i = #roles.eleShamans, 1, -1 do
        local p = roles.eleShamans[i]
        local placed = addToGroup(p, 4) or addToGroup(p, 5) or addToGroup(p, 4)
        if placed then table_remove(roles.eleShamans, i) end
    end
    for i = #roles.restoShamans, 1, -1 do
        local p = roles.restoShamans[i]
        local g1NeedsShaman = true
        for _, m in ipairs(groups[1]) do if m.class == "Shaman" then g1NeedsShaman = false break end end
        local placed = false
        if g1NeedsShaman then placed = addToGroup(p, 1) end
        if not placed then placed = addToGroup(p, 5) or addToGroup(p, 4) end
        if placed then table_remove(roles.restoShamans, i) end
    end
    
    -- Phase 3: The Mana Batteries (Shadow / Boomkin)
    for i = #roles.shadowPriests, 1, -1 do
        local p = roles.shadowPriests[i]
        local placed = addToGroup(p, 4) or addToGroup(p, 5) or addToGroup(p, 4)
        if placed then table_remove(roles.shadowPriests, i) end
    end
    for i = #roles.boomkins, 1, -1 do
        local p = roles.boomkins[i]
        local placed = addToGroup(p, 4) or addToGroup(p, 5) or addToGroup(p, 4)
        if placed then table_remove(roles.boomkins, i) end
    end
    
    -- Phase 4: Melee Supports (Feral / Ret)
    for i = #roles.feralDPS, 1, -1 do
        local p = roles.feralDPS[i]
        local placed = addToGroup(p, 3) or addToGroup(p, 2)
        if placed then table_remove(roles.feralDPS, i) end
    end
    for i = #roles.retPaladins, 1, -1 do
        local p = roles.retPaladins[i]
        local placed = addToGroup(p, 2) or addToGroup(p, 3)
        if placed then table_remove(roles.retPaladins, i) end
    end
    
    -- Phase 5: Physical Pumpers (Hunters, Warriors, Rogues)
    place(roles.hunters, {3, 2, 4})
    pullOne(roles.warriors, {3}) -- One warrior for Battle Shout
    place(roles.warriors, {2, 3})
    place(roles.rogues, {2, 3})
    
    -- Phase 6: Caster Pumpers (Arcane Mages, Warlocks)
    place(roles.arcaneMages, {4, 5})
    place(roles.warlocks, {5, 4})
    place(roles.otherCasters, {4, 5, 3})
    
    -- Phase 7: Healers
    place(roles.restoDruids, {5, 4, 1})
    place(roles.otherHealers, {5, 4, 1, 3, 2})
    
    -- Phase 8: Spillover Catch-All
    local function catchAll(list)
        place(list, {1, 2, 3, 4, 5})
    end
    for _, list in pairs(roles) do catchAll(list) end

    self:RefreshGroupBuffs(groups)

    return groups
end

function Addon.Optimiser:GetPlayerBuffs(player, groupRole)
    local buffs = {}
    local sInfo = SPECS[player.spec]
    if not sInfo then return buffs end
    
    for _, b in ipairs(sInfo.buffs) do
        table_insert(buffs, b)
    end
    
    local function removeBuff(name)
        for i = #buffs, 1, -1 do
            if buffs[i] == name then table_remove(buffs, i) end
        end
    end
    
    if player.class == "Shaman" then
        local totemsToRemove = {
            "Windfury Totem", "Wrath of Air Totem", "Grace of Air Totem",
            "Strength of Earth Totem", "Tremor Totem",
            "Mana Spring Totem", "Healing Stream Totem"
        }
        for _, rem in ipairs(totemsToRemove) do removeBuff(rem) end
        
        if groupRole == "Melee" or groupRole == "DPS" then
            table_insert(buffs, "Windfury Totem")
            table_insert(buffs, "Strength of Earth Totem")
            table_insert(buffs, "Mana Spring Totem")
        elseif groupRole == "Casters" then
            table_insert(buffs, "Wrath of Air Totem")
            table_insert(buffs, "Mana Spring Totem")
        elseif groupRole == "Healers" then
            table_insert(buffs, "Wrath of Air Totem")
            table_insert(buffs, "Mana Spring Totem")
        elseif groupRole == "Tanks" then
            table_insert(buffs, "Grace of Air Totem")
            table_insert(buffs, "Windfury Totem")
            table_insert(buffs, "Healing Stream Totem")
        else
            table_insert(buffs, "Windfury Totem")
            table_insert(buffs, "Mana Spring Totem")
        end
    elseif player.class == "Paladin" then
        if player.spec == "Holy" or player.spec == "Holy1" then
            if groupRole == "Melee" or groupRole == "Tanks" then
                removeBuff("Concentration Aura")
            end
        end
    elseif player.class == "Warrior" then
        if player.spec == "Arms" or player.spec == "Fury" then
            if groupRole == "Casters" or groupRole == "Healers" then
                removeBuff("Battle Shout")
            end
        end
    elseif player.class == "Warlock" then
        if groupRole ~= "Tanks" then
            removeBuff("Blood Pact")
        end
    end
    
    return buffs
end

function Addon.Optimiser:RefreshGroupBuffs(groups)
    local globalTanks = 0
    local globalHealers = 0
    local classCounts = {}
    local specCounts = {}
    
    for g=1, 5 do
        for _, p in ipairs(groups[g]) do
            local role = self:GetPlayerRole(p.spec)
            if role == "Tank" then globalTanks = globalTanks + 1
            elseif role == "Healer" then globalHealers = globalHealers + 1 end
            
            classCounts[p.class] = (classCounts[p.class] or 0) + 1
            specCounts[p.spec] = (specCounts[p.spec] or 0) + 1
            if p.spec == "Restoration1" then specCounts["Restoration"] = (specCounts["Restoration"] or 0) + 1 end
            if p.spec == "Holy1" then specCounts["Holy"] = (specCounts["Holy"] or 0) + 1 end
        end
    end
    
    for g=1, 5 do
        local groupRole = "Mixed"
        local counts = { Tank=0, Healer=0, Melee=0, Ranged=0 }
        
        for _, p in ipairs(groups[g]) do
            local role = self:GetPlayerRole(p.spec)
            if role then counts[role] = (counts[role] or 0) + 1 end
        end
        if counts.Tank >= 2 then groupRole = "Tanks"
        elseif counts.Healer >= 3 then groupRole = "Healers"
        elseif counts.Melee > 0 and counts.Ranged > 0 then groupRole = "DPS"
        elseif counts.Melee >= 3 then groupRole = "Melee"
        elseif counts.Ranged >= 3 then groupRole = "Casters"
        end
        groups[g].label = groupRole
        
        -- Recommendation Generator
        groups[g].recommendations = {}
        local missingSlots = 5 - #groups[g]
        if missingSlots > 0 then
            local function hasSpec(spec)
                for _, p in ipairs(groups[g]) do
                    if p.spec == spec or (spec == "Restoration" and p.spec == "Restoration1") or (spec == "Holy" and p.spec == "Holy1") then return true end
                end
                return false
            end
            local function hasClass(cls)
                for _, p in ipairs(groups[g]) do if p.class == cls then return true end end
                return false
            end
            
            local recs = groups[g].recommendations
            
            local function getDynamicDPSRecommendation(rolePref)
                if (classCounts["Paladin"] or 0) < 3 then return "Retribution Paladin" end
                if (classCounts["Shaman"] or 0) < 5 then return "Elemental Shaman" end
                if (classCounts["Mage"] or 0) < 1 then return "Arcane Mage" end
                if (classCounts["Priest"] or 0) < 1 then return "Shadow Priest" end
                if (classCounts["Druid"] or 0) < 1 then return "Balance Druid" end
                if (classCounts["Warlock"] or 0) < 1 then return "Destruction Warlock" end
                if (specCounts["Arms"] or 0) < 1 then return "Arms Warrior" end
                if (specCounts["Survival"] or 0) < 1 then return "Survival Hunter" end
                if (specCounts["Fire"] or 0) < 1 then return "Fire Mage" end
                if (specCounts["Discipline"] or 0) < 1 then return "Discipline Priest" end
                
                if rolePref == "Melee" then return "Fury Warrior"
                elseif rolePref == "Casters" then return "Destruction Warlock"
                else return "Destruction Warlock" end
            end
            
            local function addRec(rec, isTank, isHealer)
                if #recs >= missingSlots then return end
                
                if rec == "DynamicDPS" or rec == "DynamicMelee" or rec == "DynamicCaster" then
                    local pref = "Ranged"
                    if rec == "DynamicMelee" then pref = "Melee" elseif rec == "DynamicCaster" then pref = "Casters" end
                    rec = getDynamicDPSRecommendation(pref)
                end
                
                if isTank then globalTanks = globalTanks + 1 end
                if isHealer then
                    if globalHealers >= 6 then
                        rec = getDynamicDPSRecommendation("Casters")
                    else
                        globalHealers = globalHealers + 1
                    end
                end
                
                local rSpec, rClass = rec:match("^(%S+)%s+(.*)$")
                if rClass then
                    classCounts[rClass] = (classCounts[rClass] or 0) + 1
                    specCounts[rSpec] = (specCounts[rSpec] or 0) + 1
                end
                
                table_insert(recs, rec)
            end
            
            if g == 1 then
                while globalTanks < 3 and #recs < missingSlots do
                    addRec("Protection Warrior", true, false)
                end
            end
            
            if groupRole == "Tanks" then
                if not hasClass("Warlock") then addRec("Destruction Warlock", false, false) end
                if not hasSpec("Restoration") then addRec("Restoration Druid", false, true) end
                if not hasClass("Paladin") then addRec("Holy Paladin", false, true) end
                while #recs < missingSlots do addRec("Restoration Shaman", false, true) end
            elseif groupRole == "Melee" or groupRole == "DPS" then
                if not hasSpec("Enhancement") then addRec("Enhancement Shaman", false, false) end
                if not hasSpec("Feral") then addRec("Feral Druid", false, false) end
                if not hasSpec("Retribution") then addRec("Retribution Paladin", false, false) end
                while #recs < missingSlots do addRec("DynamicMelee", false, false) end
            elseif groupRole == "Casters" then
                if not hasSpec("Elemental") then addRec("Elemental Shaman", false, false) end
                if not hasSpec("Shadow") then addRec("Shadow Priest", false, false) end
                if not hasSpec("Balance") then addRec("Balance Druid", false, false) end
                while #recs < missingSlots do addRec("DynamicCaster", false, false) end
            elseif groupRole == "Healers" then
                if not hasSpec("Restoration") and not hasClass("Shaman") then addRec("Restoration Shaman", false, true) end
                if not hasSpec("Shadow") then addRec("Shadow Priest", false, false) end
                while #recs < missingSlots do addRec("Holy Paladin", false, true) end
            else
                while #recs < missingSlots do addRec("DynamicDPS", false, false) end
            end
            -- Trim excess recommendations to exactly match empty slots
            while #recs > missingSlots do table_remove(recs) end
        end
        
        if not groups[g].buffs then
            groups[g].buffs = {}
        else
            wipe(groups[g].buffs)
        end
        local seenBuffs = {}
        
        local isCasterOrHealer = (groupRole == "Casters" or groupRole == "Healers")
        local isMeleeOrTank = (groupRole == "Melee" or groupRole == "Tanks")
        
        for _, p in ipairs(groups[g]) do
            local pBuffs = self:GetPlayerBuffs(p, groupRole)
            p.activeBuffs = pBuffs -- Cache buffs directly onto the player object for O(1) retrieval downstream
            
            for _, buffName in ipairs(pBuffs) do
                local skip = false
                if Addon.IGNORED_UI_BUFFS and Addon.IGNORED_UI_BUFFS[buffName] then
                    skip = true
                elseif isCasterOrHealer and Addon.PHYSICAL_BUFFS[buffName] then
                    skip = true
                elseif isMeleeOrTank and Addon.SPELL_BUFFS[buffName] then
                    skip = true
                end
                
                if not skip and not seenBuffs[buffName] then
                    seenBuffs[buffName] = true
                    table_insert(groups[g].buffs, buffName)
                end
            end
        end
    end
end

function Addon.Optimiser:AnalyzeBuffs(groups)
    local categories = {}
    local currentCat = nil
    
    local function addCategory(name)
        currentCat = { name = name, items = {} }
        table_insert(categories, currentCat)
    end
    
    local function addBuff(text, active, spellName)
        if currentCat then
            table_insert(currentCat.items, { text=text, active=active, spellName=spellName })
        end
    end
    
    -- O(N) Cache pass over the entire raid roster
    local RaidStats = {
        classes = {},
        roles = {},
        raidBuffs = {},
        groupBuffs = {{}, {}, {}, {}, {}}
    }
    
    for g=1, 5 do
        RaidStats.roles[g] = { Tank = 0, Healer = 0, Melee = 0, Ranged = 0 }
        
        for _, p in ipairs(groups[g]) do
            -- Class count
            RaidStats.classes[p.class] = (RaidStats.classes[p.class] or 0) + 1
            
            -- Role count
            local role = self:GetPlayerRole(p.spec)
            if role then
                RaidStats.roles[g][role] = (RaidStats.roles[g][role] or 0) + 1
            end
            
            -- Buff tracking (using the cached activeBuffs computed during RefreshGroupBuffs)
            if p.activeBuffs then
                for _, buff in ipairs(p.activeBuffs) do
                    RaidStats.raidBuffs[buff] = true
                    RaidStats.groupBuffs[g][buff] = true
                end
            end
        end
    end
    
    -- Fast O(1) query helpers
    local function hasClass(className) return (RaidStats.classes[className] or 0) > 0 end
    local function countClass(className) return RaidStats.classes[className] or 0 end
    local function hasRaidBuff(buffName) return RaidStats.raidBuffs[buffName] == true end
    local function countRole(gIndex, role) return RaidStats.roles[gIndex][role] or 0 end
    local function checkGroupBuff(gIndex, buffName) return RaidStats.groupBuffs[gIndex][buffName] == true end

    addCategory("Raid Buffs")
    local blName = (Addon.Faction == "Alliance") and "Heroism" or "Bloodlust"
    addBuff(blName, hasClass("Shaman"), "Bloodlust")
    addBuff("Power Word: Fortitude", hasClass("Priest"), "Power Word: Fortitude")
    addBuff("Shadow Protection", hasClass("Priest"), "Shadow Protection")
    addBuff("Mark of the Wild", hasClass("Druid"), "Mark of the Wild")
    addBuff("Arcane Brilliance", hasClass("Mage"), "Arcane Brilliance")
    
    local numPaladins = countClass("Paladin")
    addBuff("Blessing of Kings", numPaladins >= 1, "Blessing of Kings")
    addBuff("Blessing of Might", numPaladins >= 2, "Blessing of Might")
    addBuff("Blessing of Wisdom", numPaladins >= 3, "Blessing of Wisdom")
    addBuff("Blessing of Salvation", numPaladins >= 4, "Blessing of Salvation")

    addBuff("Divine Spirit", hasRaidBuff("Divine Spirit"), "Divine Spirit")

    addCategory("Raid Debuffs (Target)")
    addBuff("Sunder / Expose Armor", hasRaidBuff("Sunder Armor") or hasRaidBuff("Expose Armor"), "Sunder Armor")
    addBuff("Curse of the Elements", hasRaidBuff("Curse of the Elements"), "Curse of the Elements")
    addBuff("Curse of Recklessness", hasRaidBuff("Curse of Recklessness"), "Curse of Recklessness")
    addBuff("Misery", hasRaidBuff("Misery"), "Misery")
    addBuff("Shadow Weaving", hasRaidBuff("Shadow Weaving"), "Shadow Weaving")
    addBuff("Improved Scorch", hasRaidBuff("Improved Scorch"), "Improved Scorch")
    addBuff("Blood Frenzy (Phys Dmg)", hasRaidBuff("Blood Frenzy"), "Blood Frenzy")
    addBuff("Expose Weakness", hasRaidBuff("Expose Weakness"), "Expose Weakness")
    addBuff("Mangle (Bleed Dmg)", hasRaidBuff("Mangle"), "Mangle")
    addBuff("Judgement of Wisdom", hasRaidBuff("Judgement of Wisdom"), "Judgement of Wisdom")
    addBuff("Judgement of Light", hasRaidBuff("Judgement of Light"), "Judgement of Light")
    addBuff("Improved Faerie Fire", hasRaidBuff("Improved Faerie Fire"), "Improved Faerie Fire")
    
    addCategory("Melee Group Buffs")
    local meleeWF, meleeLotP, meleeUR, meleeBS, meleeSA = false, false, false, false, false
    for g=1, 5 do
        if countRole(g, "Melee") >= 2 then
            if checkGroupBuff(g, "Windfury Totem") then meleeWF = true end
            if checkGroupBuff(g, "Leader of the Pack") then meleeLotP = true end
            if checkGroupBuff(g, "Unleashed Rage") then meleeUR = true end
            if checkGroupBuff(g, "Battle Shout") then meleeBS = true end
            if checkGroupBuff(g, "Sanctity Aura") then meleeSA = true end
        end
    end
    addBuff("Windfury Totem", meleeWF, "Windfury Totem")
    addBuff("Leader of the Pack", meleeLotP, "Leader of the Pack")
    addBuff("Unleashed Rage", meleeUR, "Unleashed Rage")
    addBuff("Battle Shout", meleeBS, "Battle Shout")
    addBuff("Sanctity Aura", meleeSA, "Sanctity Aura")

    addCategory("Caster Group Buffs")
    local casterWoA, casterToW, casterMA, casterVT = false, false, false, false
    for g=1, 5 do
        if countRole(g, "Ranged") >= 2 then
            if checkGroupBuff(g, "Wrath of Air Totem") then casterWoA = true end
            if checkGroupBuff(g, "Totem of Wrath") then casterToW = true end
            if checkGroupBuff(g, "Moonkin Aura") then casterMA = true end
            if checkGroupBuff(g, "Vampiric Touch") then casterVT = true end
        end
    end
    addBuff("Wrath of Air Totem", casterWoA, "Wrath of Air Totem")
    addBuff("Totem of Wrath", casterToW, "Totem of Wrath")
    addBuff("Moonkin Aura", casterMA, "Moonkin Aura")
    addBuff("Vampiric Touch", casterVT, "Vampiric Touch")
    
    addCategory("Healer Group Buffs")
    local healerMT, healerToL = false, false
    for g=1, 5 do
        if countRole(g, "Healer") >= 2 then
            if checkGroupBuff(g, "Mana Tide Totem") then healerMT = true end
            if checkGroupBuff(g, "Tree of Life Aura") then healerToL = true end
        end
    end
    addBuff("Mana Tide Totem", healerMT, "Mana Tide Totem")
    addBuff("Tree of Life Aura", healerToL, "Tree of Life Aura")
    
    addCategory("Tank Group Buffs")
    local tankBP, tankDA = false, false
    for g=1, 5 do
        if countRole(g, "Tank") >= 1 then
            if checkGroupBuff(g, "Blood Pact") then tankBP = true end
            if checkGroupBuff(g, "Devotion Aura") then tankDA = true end
        end
    end
    addBuff("Blood Pact", tankBP, "Blood Pact")
    addBuff("Devotion Aura", tankDA, "Devotion Aura")

    return categories
end
