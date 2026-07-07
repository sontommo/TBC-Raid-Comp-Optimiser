# WoW: The Burning Crusade Anniversary - Raid Composition Optimiser
*Created by Béautiful - Spineshatter EU*

TBC Raid Comp Optimiser takes the headache out of building 25-man raid groups. Just paste your roster straight from Raid-Helper, and the addon instantly organises your raid into five perfect groups based on TBC's meta rules. It makes sure that crucial party-wide buffs (like Windfury, Totem of Wrath, and Ferocious Inspiration) go exactly where they're needed, and gives you a real-time checklist to ensure your raid is fully optimised.

## How to Use

To import your raid roster from Raid-Helper:
1. Click the **'comp'** link on your Raid-Helper sign-up list on Discord.
2. Click the **'GO TO EVENT'** icon on the webpage.
3. Click **JSON** in the top right corner of the page.
4. Type `/raidcomp` in game.
5. Copy and paste the full JSON string directly into the addon in-game.

## How it Works

### The Shaman Rule
Shamans are the backbone of any TBC raid. While Bloodlust and Heroism are raid-wide in the Anniversary Edition, totems are still party-wide. The addon pulls out all your Shamans first and distributes them perfectly:
- **Melee (Groups 2 & 3):** Gets Enhancement Shamans for Windfury and Unleashed Rage.
- **Casters (Group 4):** Gets an Elemental Shaman for Totem of Wrath and Wrath of Air.
- **Healers (Group 5):** Gets a Restoration Shaman for Mana Tide.
- **Tanks (Group 1):** Gets the remaining Shamans for Tremor, Grace of Air, and Healing Stream.

### Sorting the Roster
After the Shamans are sorted, it organises the rest of the team:
- **Tanks (Group 1):** Protection Warriors, Protection Paladins, and Feral Bears go here. It also hunts down a Restoration Druid for the Tree of Life aura, and a Warlock for the Blood Pact stamina buff.
- **Hunters (Group 3):** Hunters are grouped together to stack Ferocious Inspiration. It also drops a Feral Druid in here for Leader of the Pack to boost their crit.
- **Melee (Group 2):** Feral Druids and Retribution Paladins are slotted in for their damage auras, followed by Fury/Arms Warriors and Rogues who can soak up Windfury.
- **Casters & Healers (Groups 4 & 5):** Shadow Priests and Balance Druids are spread evenly across these groups to maximise Vampiric Touch mana regeneration and Moonkin Aura crit chance without overlapping.

## The Live Buff Checklist
You don't need to memorise any of this. The UI features a live, interactive checklist at the bottom of the window:
- It scans your groups and cross-references them against every major buff in the game.
- If your Melee group has Windfury Totem and Battle Shout active, the icons light up fully coloured.
- If you're missing something critical (like Sunder Armour or a Shadow Priest for the healers), the icon turns grey so you instantly know what you need to recruit.

## Dynamic Context-Aware Buffs
The engine doesn't just lock buffs to a player's spec; it actively inspects where they've been placed and intelligently swaps their auras to maximise value. 
- For example, if you move a Restoration Shaman into a melee group, the addon knows they will drop Windfury Totem instead of Mana Spring Totem, and updates the checklist instantly.
- If a Fury Warrior overflows into a caster group, they'll intelligently use Commanding Shout for survivability instead of Battle Shout.
