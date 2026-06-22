# WoW: The Burning Crusade Anniversary - Raid Composition Optimiser
*Created by Béautiful - Spineshatter EU*

If you've played The Burning Crusade for more than 10 minutes, you know the absolute nightmare of arranging raid groups. While the Anniversary Edition brought some massive quality-of-life changes—like making Bloodlust and Heroism raid-wide—many of the most important buffs in the game are still strictly **party-wide**. If your Enhancement Shaman is in Group 2, the Rogues in Group 3 are missing out on Windfury and getting angry.

This addon solves that completely. You just paste your 25-man roster straight from Raid-Helper, and it automatically mathematically sorts everyone into 5 optimised groups so nobody misses out on the buffs they need to parse. 

## How to Use

To import your raid roster from Raid-Helper:
1. Click the **'comp'** link on your Raid-Helper sign-up list on Discord.
2. Click the **'GO TO EVENT'** icon on the webpage.
3. Click **JSON** in the top right corner of the page.
4. Copy and paste the full JSON string directly into the addon in-game.

## The Shaman Rule

Any good raid leader knows that Shamans are the backbone of a TBC raid. Even though Bloodlust and Heroism are now beautifully raid-wide in the Anniversary Edition, **Totems are still party-wide**. That means the absolute best comps run exactly 5 Shamans so you can put **one in every single group**.

Because of this, the Optimiser engine pulls out **all Shamans first** before it touches any other class, and distributes them exactly where they need to be:
- **Melee Groups (Group 2 & 3)**: It forcefully grabs **Enhancement Shamans** and locks them in here. Warriors and Rogues need Windfury Totem and Unleashed Rage to function.
- **Caster Group (Group 4)**: It grabs an **Elemental Shaman** so your Mages and Warlocks get Totem of Wrath (Spell Crit/Hit) and Wrath of Air (Spell Damage).
- **Healer Group (Group 5)**: It grabs a **Restoration Shaman** so your main healers get permanent Mana Tide Totem rotations.
- **Tank Group (Group 1)**: It drops a remaining Resto or flex Shaman in here for Healing Stream Totem, Grace of Air (for dodge), and Tremor Totem so your tanks don't get feared.

If you bring more than 5 Shamans (lucky you), it intelligently overflows them into the most logical backup groups.

## How the Rest of the Raid is Sorted

After the Shamans are perfectly locked in, it sorts the rest of the raid to stack synergies:

### 1. The Tanks (Group 1)
- Protection Warriors, Protection Paladins, and Feral Bears are dumped in here.
- **Blood Pact**: The engine actively hunts down a Warlock from the ranged pile and yanks them into the Tank group just so their Imp can give the tanks a massive stamina buff. 
- Holy Paladins are usually stacked here as well for Devotion Aura.

### 2. The Pumpers (Groups 2 & 3)
- After the Enhancement Shamans are slotted in, it looks for **Feral Druids (Cats)**. They give Leader of the Pack (5% Melee Crit), which is huge for physical DPS.
- **Ret Paladins** are brought in for Sanctity Aura (damage boost) and improved blessings.
- All remaining Fury/Arms Warriors and Rogues fill up the rest of the slots so they can soak up all these auras and totems.

### 3. The Casters & Healers (Groups 4 & 5)
- **Shadow Priests**: Shadow Priests provide massive damage buffs to Warlocks and act as mana batteries (Vampiric Touch). The addon explicitly prioritises placing Shadow Priests into the **Caster Group (Group 4)** so Arcane Mages and Warlocks benefit from their mana regen and Shadow Weaving.
- **Balance Druids**: Boomkins bring Moonkin Aura (5% Spell Crit), so they get clumped up with the Mages and Warlocks in Group 4.
- **Hunters**: Beastmastery (Ferocious Inspiration) and Survival (Expose Weakness) hunters are flexed between the physical and ranged groups depending on where there's room.

## The Live Buff Checklist

Nobody wants to memorise all this. That's why the UI has a fully interactive, native icon checklist at the bottom of the window.
- It scans the groups you just built and cross-references them against every buff in the game.
- If your Melee group has an active Windfury Totem and Battle Shout, the icons light up fully coloured.
- If you're missing something critical (like no Sunder Armour or no Shadow Priest for the healers), the icon will be greyed out so you instantly know what you're missing.
