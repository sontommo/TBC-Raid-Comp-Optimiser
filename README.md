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

## How it Works: The Meta Engine

The addon doesn't just blindly throw healers in one group and tanks in another. The engine is built around the exact strategies used by top-parsing guilds on Warcraft Logs to squeeze every ounce of damage out of a 25-man roster:

- **The Arcane Dream:** Arcane Mages do massive damage but burn through mana instantly. The engine builds a dedicated group just for them, guaranteeing they get paired with a Shadow Priest, a Resto Shaman, and an Elemental Shaman. It deliberately starves Warlocks of Shadow Priests until every Arcane Mage is fed.
- **The Hunter Pump Group:** Beast Mastery Hunters are grouped together to stack *Ferocious Inspiration*. To push their damage to the limit, the engine drops a Feral Druid in for crit, an Enhancement Shaman for agility, and crucially, pulls exactly *one* Warrior into the group just to keep *Battle Shout* up on the pets.
- **Tank Threat Scaling:** Rather than stacking the tank group with healers, the engine knows that threat is your biggest bottleneck. If you have a spare Enhancement Shaman, it drops them straight into the tank group so your Protection Warrior gets *Windfury Totem* and *Grace of Air*. 
- **Decoupling Supports:** Auras like a Retribution Paladin's *Sanctity Aura* don't stack. If you bring two Ret Paladins, the engine actively stops them from overlapping. It puts one in the main melee group and spills the second into the Hunter group to make sure you aren't wasting buffs.

## The Live Buff Checklist
You don't need to memorise any of this. The UI features a live, interactive checklist at the bottom of the window:
- It scans your groups and cross-references them against every major buff in the game.
- If your Melee group has Windfury Totem and Battle Shout active, the icons light up fully coloured.
- If you're missing something critical (like Sunder Armour or a Shadow Priest for the healers), the icon turns grey so you instantly know what you need to recruit.

## Dynamic Context-Aware Buffs
The engine doesn't just lock buffs to a player's spec; it actively inspects where they've been placed and intelligently swaps their auras to maximise value. 
- For example, if you move a Restoration Shaman into a melee group, the addon knows they will drop Windfury Totem instead of Mana Spring Totem, and updates the checklist instantly.
- If a Fury Warrior overflows into a caster group, they'll intelligently use Commanding Shout for survivability instead of Battle Shout.
