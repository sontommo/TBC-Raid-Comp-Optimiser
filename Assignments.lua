local AddonName, Addon = ...
Addon.Assignments = {}

local function createAssignment(name, desc, spellId, requirements, priority)
    return { name = name, desc = desc, spellId = spellId, reqs = requirements, priority = priority or 1 }
end

local function createMalandeInterrupt(name)
    return createAssignment(name, "Strict interrupt rotation for Circle of Healing.", 1766, { {class="Rogue"}, {class="Shaman", spec="Enhancement"}, {class="Warrior", role="Melee"} })
end

local BOSS_TASKS = {
    {
        raid = "Serpentshrine Cavern",
        bosses = {
            {
                name = "Leotheras the Blind",
                tasks = {
                    createAssignment("Demon Form Tank", "Requires high Fire Resistance. Uses Searing Pain to hold threat.", 27209, { {class="Warlock"} })
                }
            },
            {
                name = "Lady Vashj",
                tasks = {
                    createAssignment("Strider Kiter 1", "Kites the Coilfang Strider using slows.", 27072, { {class="Mage", spec="Frost"}, {class="Hunter"}, {class="Shaman", spec="Elemental"} }),
                    createAssignment("Strider Kiter 2", "Kites the Coilfang Strider using slows.", 27072, { {class="Mage", spec="Frost"}, {class="Hunter"}, {class="Shaman", spec="Elemental"} }),
                    createAssignment("Core Turner 1", "High mobility to pass Tainted Cores.", 11305, { {class="Rogue"}, {class="Warrior"} }),
                    createAssignment("Core Turner 2", "High mobility to pass Tainted Cores.", 11305, { {class="Rogue"}, {class="Warrior"} })
                }
            }
        }
    },
    {
        raid = "Tempest Keep",
        bosses = {
            {
                name = "High Astromancer Solarian",
                tasks = {
                    createAssignment("Arcane Soaker", "Requires high Arcane Resistance to soak Wrath of the Astromancer.", 27222, { {class="Warlock"}, {class="Paladin", role="Tank"}, {class="Warrior", role="Tank"} })
                }
            },
            {
                name = "Kael'thas Sunstrider",
                tasks = {
                    createAssignment("Capernian Tank", "Requires high Fire Resistance.", 27209, { {class="Warlock"} }),
                    createAssignment("Telonicus Kiter", "High mobility/kiting for the Toymaker.", 5118, { {class="Hunter"}, {class="Warlock"} }),
                    createAssignment("MC CC 1", "Crowd Control for Mind Controlled players.", 12826, { {class="Mage"}, {class="Rogue"}, {class="Warlock"} }),
                    createAssignment("MC CC 2", "Crowd Control for Mind Controlled players.", 12826, { {class="Mage"}, {class="Rogue"}, {class="Warlock"} })
                }
            }
        }
    },
    {
        raid = "Black Temple",
        bosses = {
            {
                name = "Illidari Council",
                tasks = {
                    createAssignment("Zerevor Tank", "Requires Spellsteal and high stamina.", 30449, { {class="Mage"} }),
                    createMalandeInterrupt("Malande Interrupt 1"),
                    createMalandeInterrupt("Malande Interrupt 2")
                }
            },
            {
                name = "Illidan Stormrage",
                tasks = {
                    createAssignment("Demon Form Tank", "Requires max Shadow Resistance.", 27209, { {class="Warlock"} }),
                    createAssignment("Flame of Azzinoth Tank 1", "Requires max Fire Resistance.", 7386, { {class="Warrior", role="Tank"}, {class="Paladin", role="Tank"} }),
                    createAssignment("Flame of Azzinoth Tank 2", "Requires max Fire Resistance.", 7386, { {class="Warrior", role="Tank"}, {class="Paladin", role="Tank"} })
                }
            }
        }
    },
    {
        raid = "Mount Hyjal",
        bosses = {
            {
                name = "Archimonde",
                tasks = {
                    createAssignment("Decurser 1", "Removes Doomfire curse.", 2782, { {class="Mage"}, {class="Druid"} }),
                    createAssignment("Decurser 2", "Removes Doomfire curse.", 2782, { {class="Mage"}, {class="Druid"} })
                }
            }
        }
    }
}

function Addon.Assignments:Generate(players)
    local results = {}
    
    for _, raid in ipairs(BOSS_TASKS) do
        local raidData = { raidName = raid.raid, bosses = {} }
        for _, boss in ipairs(raid.bosses) do
            local bossData = { bossName = boss.name, assignments = {} }
            local usedPlayers = {}
            
            for _, task in ipairs(boss.tasks) do
                local assignedPlayer = nil
                
                for _, req in ipairs(task.reqs) do
                    if assignedPlayer then break end
                    
                    for _, p in ipairs(players) do
                        if not usedPlayers[p.name] then
                            local match = true
                            if req.class and p.class ~= req.class then match = false end
                            if req.spec and p.spec ~= req.spec then match = false end
                            if req.role and Addon.Optimiser:GetPlayerRole(p.spec) ~= req.role then match = false end
                            
                            if match then
                                assignedPlayer = p
                                usedPlayers[p.name] = true
                                break
                            end
                        end
                    end
                end
                
                table.insert(bossData.assignments, {
                    taskName = task.name,
                    taskDesc = task.desc,
                    spellId = task.spellId,
                    player = assignedPlayer
                })
            end
            table.insert(raidData.bosses, bossData)
        end
        table.insert(results, raidData)
    end
    
    return results
end
