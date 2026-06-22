# Changelog

All notable changes to this project will be documented in this file.

## [v1.0] - Initial Release
### Added
- **Initial Release** of the WoW: The Burning Crusade Anniversary - Raid Composition Optimiser.
- Built a mathematical engine to automatically sort 25-man raid rosters imported from a Raid-Helper JSON string into 5 mathematically optimal groups.
- Implemented a strict Shaman priority matrix ensuring the "One Shaman Per Group" meta, appropriately assigning Enhancement to Melee, Elemental to Casters, and Restoration to Healers.
- Implemented deterministic synergy sorting for Tanks, Melee Pumpers, Casters, and Healers.
- Added a dynamic, native World of Warcraft UI window with a live, interactive Buff & Debuff icon checklist.
- Added a re-flowable UI flexbox-style grid system with dynamic group centering.
- Fully supported and dynamically integrated all class buffs natively using cached TBC Spell IDs.
