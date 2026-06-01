# HealBot

A tool to reduce the amount of button mashing in the FFXI game.

### Summary

By default, HealBot will monitor the party that it is in.  Commands to monitor
or ignore additional players can be found below.

Buffs gained via job abilities are now supported, but have not yet been tested
extensively.  Composure has been confirmed to work.  With the addition of job
ability support comes support for prioritization (since, for example, Composure
should be used before other buffs are applied).

Detection of whether the local healer is able to act has been improved for when
debuffs such as sleep or petrify are active, so that now it should not try to
spam spells while unable to act.  This is apparent by the text box in the top-
left corner of the screen displaying the message 'Player is disabled'.

Bard songs are officially unsupported at this time.  YMMV - it cannot handle the
fact that there is no notification given when one song overwrites another, or
maintaining multiple buffs that have the same name.  That being said, if you
only want to maintain 2-3 songs without using a dummy song, it may work.  I have
an idea about how to support BRD songs, so that should be coming soon. Until then
use Singer - https://github.com/Ivaar/Windower-addons/tree/master/Singer

GEO isn't well supported at this time. Alternative:

AutoGEO - https://github.com/zpaav/AutoGEO

COR is also not well supported at this time. Alternatives:

Roller - https://github.com/zpaav/Roller

AutoCOR - https://github.com/Icydeath/ffxi-addons/tree/master/AutoCOR

Coming soon:
The ability to cast offensive spells on an assist target's target.
Work in SCH AOE Regen with Max Duration / Potency.
May try AOE options for other buffs as well (Protect, Shell, etc.).

--------------------------------------------------------------------------------

### IPC (Inter-Process Communication)

HealBot now supports IPC between multiple instances of Windower running on the
same computer when both characters have HealBot loaded!  This means that HealBot
will now be even better at detecting the buffs/debuffs that are active for
characters on the same computer!

Only the healer's HealBot needs to be on - the non-healer just needs to have
HealBot loaded to be able to tell the healer's instance about its active buffs
and debuffs.

## Requirements
### HealBot depends on libs/lor

These libs can be downloaded [here](https://github.com/lorand-ffxi/lor_libs).
Full url: https://github.com/lorand-ffxi/lor_libs

To install, unzip the download and place the internal most `lor` folder into the `Windower\addons\libs` folder.

To verify the correct folder setup, click on the `lor` folder and if it has the `lor-*.lua files` inside that `lor` folder it's good to go.
If not, go one level deeper until you see those files.

### Required addons
shortcuts and cancel
Please install these and turn them on.
This can be done through the Windower Addons options.

## How to use

### Settings

If you have the shortcuts addon installed, your `aliases.xml` file from that addon
will be loaded, and those aliases will be available for use when specifying
buffs.

You can edit/add/remove buff lists that can be invoked with the
`//hb bufflist listName targetName` command in `data/buffLists.lua`.  The order of
buffs within the list does not affect the order in which they will be cast.
Follow the syntax of existing sets when adding/editing your own.

You can also edit/add/remove debuff lists that can be invoked with the
`//hb debufflist listName` command in `data/debuffLists.lua`.
Follow the syntax of existing sets when adding/editing your own.

You can modify the priority with which other players will be attended to by
editing `data/priorities.lua`.  Note that detection of players' jobs is not
perfect at the moment, so it is better to specify individual players' priorities
by name.  Lower numbers represent higher priority.  Follow the syntax of
existing sets when adding/editing your own.

Monster abilities that do not display what debuffs they cause are specified in
`mabil_debuffs.lua`.  This list is woefully incomplete, but I plan on vastly
expanding it in the near future.  If you decide to add any, I would greatly
appreciate it if you would share what you have added.  If you add something, and
it isn't detected, please notify me, and I will attempt to make sure that it can
be detected in the future.

Place the healBot folder in `.../Windower/addons/`

* To load healBot: `//lua load healbot`
* To unload healBot: `//hb unload`
* To reload healBot: `//hb reload`

### Command List

#### General Setup Commands
| Command                                | Action                                                                                                        |
| ---------------------------------------| --------------------------------------------------------------------------------------------------------------|
| //hb on                                | Activate                                                                                                      |
| //hb off                               | Deactivate (note: follow will remain active)                                                                  |
| //hb refresh                           | Reload settings xmls in the data folder                                                                       |
| //hb status                            | Displays whether or not healBot is active in the chat log                                                     |
| //hb mincure (#)                       | Set the minimum cure tier to # (default is 3 - if this is spammy set it to 4 to be safe)                      |
| //hb independent (on/off)              | Sets it as independent player use and continues any of the automation - autoassist and follow should be off   |
| //hb customsettings listName           | Loads a customized settings profile from custom_settings.lua                                                  |
| //hb custom listName                   | Loads a customized settings profile from custom_settings.lua (customsettings shorthand)                       |

#### Healing / Curing
| Command                                         | Action                                                                                               |
| ------------------------------------------------| -----------------------------------------------------------------------------------------------------|
| //hb ignore (charName)                          | Ignore player charName so they won't be healed                                                       |
| //hb unignore (charName)                        | Stop ignoring player charName (note: will not watch a player that would not otherwise be watched)    |
| //hb disable (actionType)                       | Disables actions of a given type (cure, buff, na)                                                    |
| //hb enable (actionType)                        | Enables actions of a given type (cure, buff, na)                                                     |
| //hb disable (actionType)                       | Disables actions of a given type (cure, buff, na)                                                    |
| //hb ignore_debuff (player/always) (debuff)     | Ignores when the given debuff is cast on the given player or everyone                                |
| //hb unignore_debuff (player/always) (debuff)   | Stops ignoring when the given debuff is cast on the given player or everyone                         |
| //hb watch (charName)                           | Watch player charName so they will be healed                                                         |
| //hb unwatch (charName)                         | Stop watching player charName (note: will not ignore a player that would be otherwise watched)       |
| //hb ignoretrusts on                            | Ignore Trust NPCs (default)                                                                          |
| //hb ignoretrusts off                           | Heal Trust NPCs                                                                                      |

#### Buffs and Debuffs
| Command                                | Action                                                                                                    |
| ---------------------------------------| ----------------------------------------------------------------------------------------------------------|
| //hb reset                             | Reset buff & debuff monitors                                                                              |
| //hb reset buffs                       | Reset buff monitors                                                                                       |
| //hb reset debuffs                     | Reset debuff monitors                                                                                     |
| //hb buff charName spellName           | Maintain the buff spellName on player charName                                                            |
| //hb buff (t) spellName                | Maintain the buff spellName on current target                                                             |
| //hb cancelbuff charName spellName     | Stop maintaining the buff spellName on player charName                                                    |
| //hb cancelbuff (t) spellName          | Stop maintaining the buff spellName on current target                                                     |
| //hb bufflist listName charName        | Maintain buffs on selected char from list located in buffLists.Lua                                        |
| //hb bl listName charName              | Maintain buffs on selected char from list located in buffLists.Lua (bufflist shorthand)                   |
| //hb bufflist listName (t)             | Maintain the buffs in the given list of buffs on current target                                           |
| //hb debuff spellName                  | Maintain the debuff spellName on assisted target                                                          |
| //hb debuff rm spellName               | Removes from the list of the debuffs on assisted target                                                   |
| //hb debuff on                         | Auto debuffs on assisted target from set list                                                             |
| //hb debuffList listName               | Loads Auto debuffs on assisted target from set list in debuffLists.lua                                    |
| //hb debl listName                     | Loads Auto debuffs on assisted target from set list in debuffLists.lua (shorthand for debufflist)         |
| //hb debuff off                        | Stops auto debuffs on assisted target                                                                     |
| //hb debuff ls                         | Lists Auto debuffs on assisted target                                                                     |
| //hb db spellName                      | Maintain the debuff spellName on assisted target (shorthand for debuff)                                   |
| //hb db rm spellName                   | Removes from the list of the debuffs on assisted target (shorthand for debuff)                            |
| //hb db on                             | Auto debuffs on assisted target from set list (shorthand for debuff)                                      |
| //hb db off                            | Stops auto debuffs on assisted target (shorthand for debuff)                                              |
| //hb db ls                             | Lists Auto debuffs on assisted target (shorthand for debuff)                                              |
| //hb autoshadows on                    | Enables autoshadow upkeep - Utsusemi, Blink, Third Eye, etc.                                              |
| //hb autoshadows off                   | Disables autoshadow upkeep                                                                                |

#### Action Spamming
| Command                                | Action                                                                                                    |
| ---------------------------------------| ----------------------------------------------------------------------------------------------------------|
| //hb spam on                           | Turns on spell or action spamming                                                                         |
| //hb spam off                          | Turns off spell or action  spamming                                                                       |
| //hb spam (name)                       | Spell or action name to be spammed                                                                        |

#### Auto Assist
| Command                            | Action                                                                                                        |
| -----------------------------------| --------------------------------------------------------------------------------------------------------------|
| //hb assist (charName)             | Assists player charName (This Must be in proper form - Fendo not fendo)                                       |
| //hb assist attack                 | Will engage target mob on assist                                                                              |
| //hb assist noapproach on          | Will not approach target on assist - Set follow dist to .5 to ensure you are in melee range.                  |
| //hb assist noapproach off         | Will approach target on assist (this is the default setting)                                                  |
| //hb assist off                    | Stop assisting player                                                                                         |
| //hb assist resume                 | Resumes assisting                                                                                             |
| //hb as (charName)                 | Assists player charName (This Must be in proper form - Fendo not fendo) (assist shorthand)                    |
| //hb as attack                     | Will engage target mob on assist (assist shorthand)                                                           |
| //hb as noapproach on              | Will not approach target on assist - Set follow dist to .5 to ensure you are in melee range.(assist shorthand)|
| //hb as noapproach off             | Will approach target on assist (this is the default setting) (assist shorthand)                               |
| //hb as off                        | Stop assisting player (assist shorthand)                                                                      |
| //hb as resume                     | Resumes assisting (assist shorthand)                                                                          |


#### Auto Follow
| Command                            | Action                                                                                                        |
| -----------------------------------| --------------------------------------------------------------------------------------------------------------|
| //hb follow (charName)             | Follow player charName                                                                                        |
| //hb follow (t)                    | Follow current target                                                                                         |
| //hb follow off                    | Stop following                                                                                                |
| //hb follow resume                 | Resumes following                                                                                             |
| //hb follow dist (#)               | Set the follow distance to #                                                                                  |
| //hb f (charName)                  | Follow player charName (follow shorthand)                                                                     |
| //hb f (t)                         | Follow current target (follow shorthand)                                                                      |
| //hb f off                         | Stop following (follow shorthand)                                                                             |
| //hb f resume                      | Resumes following (follow shorthand)                                                                          |
| //hb f dist (#)                    | Set the follow distance to # (follow shorthand)                                                               |

#### Weapon Skills
| Command                                | Action                                                                                                        |
| ---------------------------------------| --------------------------------------------------------------------------------------------------------------|
| //hb weaponskill use (ws name)         | Selects weaponskill to use                                                                                    |
| //hb weaponskill tp (number 1000-2999) | Selects min tp for a weaponskill                                                                              |
| //hb weaponskill hp (sign) (mob hp%)   | Sets the mob HP for weaponskill use (example < 100  or > 1)                                                   |
| //hb weaponskill waitfor (player) (tp) | Waits for another player to use weaponskill at a certain TP                                                   |
| //hb weaponskill nopartner             | Does not wait for another player to use weaponskill tain TP                                                   |
| //hb ws use (ws name)                  | Selects weaponskill to use (weaponskill shorthand)                                                            |
| //hb ws keepAM3 (true|false)           | Selects turns on option to maintin AM3                                                                        |
| //hb ws setAM3 (ws name)               | Selects weaponskill to upkeep AM3                                                                             |
| //hb ws tp (number 1000-2999)          | Selects min tp for a weaponskill (weaponskill shorthand)                                                      |
| //hb ws hp (sign) (mob hp%)            | Sets the mob HP for weaponskill use (example < 100  or > 1) (weaponskill shorthand)                           |
| //hb ws waitfor (player) (tp)          | Waits for another player to use weaponskill at a certain TP (weaponskill shorthand)                           |
| //hb ws nopartner                      | Does not wait for another player to use weaponskill tain TP (weaponskill shorthand)                           |

#### Alliance Healing
| Command                                | Action                                                                                                        |
| ---------------------------------------| --------------------------------------------------------------------------------------------------------------|
| //hb alliance on                       | Start monitoring and healing all alliance members in the same zone (default: off)                             |
| //hb alliance off                      | Stop healing alliance members (own party only)                                                                |
| //hb ally on/off                       | Shorthand for //hb alliance                                                                                   |

> **Note:** Alliance members only expose HP% to Windower, not absolute HP values.  HealBot will
> fall back to a 1500 HP estimate when calculating cure tiers for alliance members.  For best
> results, individually `//hb watch` specific high-HP alliance members you want precise coverage
> for — watched players have their HP tracked via packets and get accurate cure tier selection.

#### Job Abilities & Stratagems
| Command                                    | Action                                                                                                    |
| -------------------------------------------| ----------------------------------------------------------------------------------------------------------|
| //hb divinecaress on                       | Before each NA/status-removal spell, fire Divine Caress (WHM JA) to add enfeeble resistance (default: off)|
| //hb divinecaress off                      | Disable automatic Divine Caress use                                                                        |
| //hb dc on/off                             | Shorthand for //hb divinecaress                                                                            |
| //hb nastratagem (stratagem name)          | Fire the named SCH stratagem before each NA/status-removal spell (e.g. Rapture, Accession)                |
| //hb nastratagem off                       | Clear the NA stratagem                                                                                     |
| //hb nastrat (stratagem name / off)        | Shorthand for //hb nastratagem                                                                             |
| //hb curestratagem (stratagem name)        | Fire the named SCH stratagem before each cure spell (e.g. Penury, Celerity)                               |
| //hb curestratagem off                     | Clear the cure stratagem                                                                                   |
| //hb curestrat (stratagem name / off)      | Shorthand for //hb curestratagem                                                                           |

> **How Divine Caress works:** HealBot fires Divine Caress on itself first (just like Divine Seal),
> then immediately casts the NA spell on the target.  The spell lands with the enfeeble-resistance
> augmentation applied by the JA.
>
> **How stratagems work:** The chosen stratagem fires first; HealBot then casts the cure/NA spell on
> the next action cycle (identical to the existing Accession / Divine Seal mechanism).  Stratagems
> are only used when a charge is available and the matching Arts are active.  Setting `nastratagem`
> while `aoe_na` is also enabled is not recommended — use one or the other.

#### GUI Control Panel
| Command                                | Action                                                                                                        |
| ---------------------------------------| --------------------------------------------------------------------------------------------------------------|
| //hb gui                               | Toggle the clickable control panel on/off                                                                     |
| //hb gui pos (x) (y)                   | Reposition the panel to screen coordinates x, y (default: 50, 150)                                           |

The GUI panel is built entirely from Windower's built-in text library — **no additional addons are
required**.  It displays all major settings in collapsible sections and supports mouse interaction:

- **Left-click** a toggle row to switch it on/off
- **Left-click** the left half of a numeric row (`[–]`) to decrease the value
- **Right-click** (or left-click the right half, `[+]`) to increase the value
- **Left-click** a text-input row (stratagem name, follow/assist target) to print the exact
  `//hb` command to type in chat
- **Left-click** a section header (`[v]` / `[>]`) to collapse or expand that section

If clicks feel off by one row, tune `LINE_H` at the top of `HealBot_gui.lua` (increase if clicks
land too high, decrease if too low).

#### Debugging Commands
| Command                                | Action                                                                                                        |
| ---------------------------------------| --------------------------------------------------------------------------------------------------------------|
| //hb moveinfo on                       | Will display current (x,y,z) position and the amount of time spent at that location in the upper left corner. |
| //hb moveinfo off                      | Hides the moveInfo display                                                                                    |
| //hb packetinfo on                     | Adds to the chat log packet info about monitored players                                                      |
| //hb packetinfo off                    | Prevents packet info from being added to the chat log                                                         |

### Custom / Saved Settings and loading

There is an option to load up custom settings file that is setup by the end user.
This will minimize the amount of commands that are run to get healbot up and moving.

To load custom settings healBot: `//hb custom (Custom Settings List Name)`

The location of the custom settings are in `data/custom_settings.lua`.
Reference the custom lists already in there for some ideas. Further explanation of the settings and examples are below.

These settings can work along with the `data/buffLists.lua` and `data/debuffLists.lua` lists that are setup to ensure that buffs and debuffs are brought in.
Reference each of these as well to setup customized buffs and debuff lists to be brought in.

### Custom Setting Example lists with explanations.

#### The following custom setting entry is to assist the character Denorea as a RDM job that is using Savage Blade at 1000 TP.
```lua
['rdmAssistDenorea'] = {                    -- List Name that will be used to pull in - Try to make these specific since I assist other people.
    ['assist'] = true,                      -- Auto Assist (true | false) - Is autoAssist being used?
    ['assistName'] = 'Denorea',             -- Auto Assist (Name) - If AutoAssist is false this is not required, otherwise character name to assist.
    ['assistEngage'] = true,                -- Engage on Auto Assist (true | false) - If AutoAssist is false this is not required, otherwise engaging on assisting toggle.
    ['noapproach'] = false,                 -- (true | false) toggle. Do not approach target on assisting.
    ['follow'] = true,                      -- Auto Follow (true | false) - Is autoFollow being used?
    ['followTarget'] = 'Denorea',           -- Auto Follow (Name) - If autoFollow is false this is not required, otherwise character name to follow.
    ['followDist'] = 0.3,                   -- Auto Follow Distance - If autoFollow is false this is not required, otherwise must be a number. Distance to follow character.
    ['useWeaponSkill'] = 'Savage Blade',    -- Auto Weaponskill to use. - Must be an actual weaponskill. If it's one you can't use it won't actually ever fire.
    ['useWeaponSkillTP'] = 1000,            -- Auto Weaponskill TP threshold. - Must be a number.
    ['applySelfBuffList'] = 'rdmExemplar',  -- Bufflist to apply to self. - This is not required
    ['applyP1BuffList'] = 'ddExemplar',     -- Bufflist to apply first member of party. - This is not required. Bufflist for P1.
    ['applyP2BuffList'] = 'ddExemplar',     -- Bufflist to apply second member of party. - This is not required. Bufflist for P2.
    ['applyP3BuffList'] = 'ddExemplar',     -- Bufflist to apply third member of party. - This is not required. Bufflist for P3.
    ['applyP4BuffList'] = 'ddExemplar',     -- Bufflist to apply fouth member of party. - This is not required. Bufflist for P4.
    ['applyP5BuffList'] = 'ddExemplar',     -- Bufflist to apply fifth member of party. - This is not required. Bufflist for P5.
    ['independent'] = false,                -- (true | false) toggle. Independent mode (This must be used if not assisting someone).
    ['autoshadows'] = false,                -- (true | false) toggle. Auto shadows mode.
    ['useDebuffs'] = false,                 -- (true | false) toggle. Turn on auto debuffing. - Not required. Turning on Debuffs.
    ['applyDebuffList'] = 'rdmExemplar',    -- (true | false) toggle. - This is not required. Debuff list to use on mob.
    ['ignoreTrusts'] = true,                -- (true | false) toggle. Option toggle to ignore trusts for healing.
    ['heal_alliance'] = false,              -- (true | false) toggle. Heal all alliance members in zone (see note above re: HP accuracy).
    ['use_divine_caress'] = false,          -- (true | false) toggle. Fire Divine Caress before each NA spell (WHM).
    ['na_stratagem'] = 'Rapture',           -- (string | nil). SCH stratagem to fire before each NA spell. nil = disabled.
    ['cure_stratagem'] = 'Penury',          -- (string | nil). SCH stratagem to fire before each cure spell. nil = disabled.
},
```
#### The following Custom setting entry is to assist the character Denorea as a DD job (WAR, COR, etc.) that is using Savage Blade at 1000 TP.

```lua
['savAssistDenorea'] = {                    -- List Name that will be used to pull in - Try to make these specific since I assist other people.
    ['assist'] = true,                      -- Auto Assist (true | false) - Is autoAssist being used?
    ['assistName'] = 'Denorea',             -- Auto Assist (Name) - If AutoAssist is false this is not required, otherwise character name to assist.
    ['assistEngage'] = true,                -- Engage on Auto Assist (true | false) - If AutoAssist is false this is not required, otherwise engaging on assisting toggle.
    ['noapproach'] = false,                 -- (true | false) toggle. Do not approach target on assisting.
    ['follow'] = true,                      -- Auto Follow (true | false) - Is autoFollow being used?
    ['followTarget'] = 'Denorea',           -- Auto Follow (Name) - If autoFollow is false this is not required, otherwise character name to follow.
    ['followDist'] = 0.3,                   -- Auto Follow Distance - If autoFollow is false this is not required, otherwise must be a number. Distance to follow character.
    ['useWeaponSkill'] = 'Savage Blade',    -- Auto Weaponskill to use. - Must be an actual weaponskill. If it's one you can't use it won't actually ever fire.
    ['useWeaponSkillTP'] = 1000,            -- Auto Weaponskill TP threshold. - Must be a number.
    ['independent'] = false,                -- (true | false) toggle. Independent mode (This must be used if not assisting someone).
    ['autoshadows'] = false,                -- (true | false) toggle. Auto shadows mode.
    ['ignoreTrusts'] = true,                -- (true | false) toggle. Option toggle to ignore trusts for healing.
},
```

#### The following Custom setting entry is to NOT to assist (lead a group or solo play) as a DD job (WAR, COR, etc.) that is using Savage Blade at 1000 TP.

```lua
['savIndependent'] = {                      -- List Name that will be used to pull in - Try to make these specific since I assist other people.
    ['assist'] = false,                     -- Auto Assist (true | false) - Is autoAssist being used?
    ['assistEngage'] = false,               -- Engage on Auto Assist (true | false) - If AutoAssist is false this is not required, otherwise engaging on assisting toggle.
    ['noapproach'] = false,                 -- (true | false) toggle. Do not approach target on assisting.
    ['follow'] = false,                     -- Auto Follow (true | false) - Is autoFollow being used?
    ['useWeaponSkill'] = 'Savage Blade',    -- Auto Weaponskill to use. - Must be an actual weaponskill. If it's one you can't use it won't actually ever fire.
    ['useWeaponSkillTP'] = 1000,            -- Auto Weaponskill TP threshold. - Must be a number.
    ['independent'] = true,                 -- (true | false) toggle. Independent mode (This must be used if not assisting someone).
    ['autoshadows'] = false,                -- (true | false) toggle. Auto shadows mode.
    ['ignoreTrusts'] = true,                -- (true | false) toggle. Option toggle to ignore trusts for healing.
},
```

#### The following Custom setting entry is to NOT to assist (lead a group or solo play) as a Bard to maintain AM3 that is using Mordant Rime at 1000 TP otherwise.

```lua
['brdLead'] = {                      -- List Name that will be used to pull in - Try to make these specific since I assist other people.
    ['assist'] = false,                     -- Auto Assist (true | false) - Is autoAssist being used?
    ['assistEngage'] = false,               -- Engage on Auto Assist (true | false) - If AutoAssist is false this is not required, otherwise engaging on assisting toggle.
    ['noapproach'] = false,                 -- (true | false) toggle. Do not approach target on assisting.
    ['follow'] = false,                     -- Auto Follow (true | false) - Is autoFollow being used?
    ['useWeaponSkill'] = "Mordant Rime",   -- Auto Weaponskill to use. - Must be an actual weaponskill. If it's one you can't use it won't actually ever fire.
    ['useWeaponSkillTP'] = 1000,            -- Auto Weaponskill TP threshold. - Must be a number.
    ['independent'] = true,                 -- (true | false) toggle. Independent mode (This must be used if not assisting someone).
    ['autoshadows'] = false,                -- (true | false) toggle. Auto shadows mode.
    ['ignoreTrusts'] = true,                -- (true | false) toggle. Option toggle to ignore trusts for healing.
    ['AM3_name'] = 'Mordant Rime',          -- AM3 Auto Weaponskill to use. - Must be an actual weaponskill. If it's one you can't use it won't actually ever fire.
    ['keep_AM3'] = true,                    -- Maintin AM3 - Will Weaponskill at 3000 TP If AM3 is not up.
},
```

#### The following Custom setting entry shows a WHM leading an alliance, using Divine Caress and Rapture before NA spells.

```lua
['whmAllianceLead'] = {
    ['assist'] = false,
    ['assistEngage'] = false,
    ['follow'] = false,
    ['independent'] = true,
    ['autoshadows'] = false,
    ['ignoreTrusts'] = true,
    ['heal_alliance'] = true,               -- Heal all alliance members in zone
    ['use_divine_caress'] = true,           -- Fire Divine Caress before each NA spell
    ['na_stratagem'] = 'Rapture',           -- Fire Rapture before each NA spell (Light Arts required)
    -- ['cure_stratagem'] = 'Celerity',     -- Optional: faster casts with Celerity
},
```

> **Custom settings reference — all available keys:**
>
> | Key | Type | Description |
> |-----|------|-------------|
> | `assist` | bool | Enable auto-assist |
> | `assistName` | string | Name of player to assist |
> | `assistEngage` | bool | Engage target mob when assisting |
> | `noapproach` | bool | Do not walk toward target when assisting |
> | `follow` | bool | Enable auto-follow |
> | `followTarget` | string | Name of player to follow |
> | `followDist` | number | Follow distance |
> | `independent` | bool | Independent mode (no assist target required) |
> | `autoshadows` | bool | Auto-upkeep shadows (Utsusemi, Blink, etc.) |
> | `ignoreTrusts` | bool | Skip Trust NPCs when healing |
> | `useWeaponSkill` | string | Weapon skill name to use |
> | `useWeaponSkillTP` | number | Minimum TP to fire weapon skill |
> | `AM3_name` | string | Weapon skill to use at 3000 TP to maintain AM3 |
> | `keep_AM3` | bool | Weaponskill at 3000 TP to maintain AM3 |
> | `applySelfBuffList` | string | Buff list name to apply to self |
> | `applyP1BuffList` … `applyP5BuffList` | string | Buff list name to apply to party slots 1–5 |
> | `useDebuffs` | bool | Enable auto-debuffing on assist target |
> | `applyDebuffList` | string | Debuff list name to load |
> | `heal_alliance` | bool | Monitor and heal alliance members (all groups) |
> | `use_divine_caress` | bool | Fire Divine Caress (WHM) before each NA spell |
> | `na_stratagem` | string | SCH stratagem to fire before each NA spell |
> | `cure_stratagem` | string | SCH stratagem to fire before each cure spell |

# Thanks to the Original creator and others that modified before I found this!
## This is a mashup between Original and Updated Versions with additional features.

## The Original Healbot

https://github.com/lorand-ffxi/HealBot

## Additions / Other ideas taken from these other repos

https://github.com/PeachBlossomWine/HealBot

https://github.com/KateFFXI/HealBot (Updated 09/22/2021)

https://github.com/AkadenTK/HealBot (Updated 05/21/2019)
