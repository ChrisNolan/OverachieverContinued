
Overachiever v0.84
==============================

Author: Tuhljin

Tools and tweaks to make the lives of players seeking Achievements a little bit easier.

General:

* Slash commands to search for achievements by name.
* Ctrl+click on an achievement link to open the UI to that achievement. Ctrl+click again to track it.
* Optionally display your progress toward earning an achievement in links provided by others for easy comparison.
* Click and drag to move the Achievement frame around the screen.
* Add information from progress bars and normally-hidden progress information to your achievement tooltips. (For
  example, "Progress: 5/10" or "Assault 2 bases (0/2).")
* Display a tooltip when hovering over an achievement in the Objectives frame to see more details about it.
* Shift+click an achievement title in the Objectives frame to add that achievement's link to chat.
* The tooltips of meta-criteria (achievements displayed as the criteria for obtaining a larger achievement) changed
  from simply giving the date the criteria was met or nothing (if not met) to the standard, detailed tooltip for the
  achievement.
* And more!

Achievement-specific:

* Automatically track exploration achievements as you travel (if desired).
* Critters' tooltips remind you which ones you need to earn "To All The Squirrels I've Loved Before."
* "Well Read" and "Higher Learning": Add whether you've read a relevant book to its tooltip.
* "The Scavenger," "Outland Angler," and "Northrend Angler": Show whether you've fished a node in its tooltip.
* "Let It Snow" and "Fistful of Love": Show whether you need to use a Handful of Snowflakes or a Handful of Rose
  Petals on players in their tooltips.
* "Shake Your Bunny-Maker": Show whether you need to use Spring Flowers on players in their tooltips. Enemy players
  of an unknown level are assumed to be at least level 18.
* "It's Happy Hour Somewhere" and "Tastes Like Chicken": Show whether you've consumed a food or drink item.
* Select a sound effect to play when one of the above reminders show up in a tooltip if you need to do something.

Options can be found using the /oa command or at Interface Options -> AddOns tab -> Overachiever.


More details
--------------

KEY BINDINGS:

You can associate key bindings with each of the new tabs added to the Achievement frame using the standard key binding
interface. The new bindings are located under the heading "Overachiever."


SLASH COMMANDS:

- ALTERED: /ach and its aliases (/achieve, /achievement, and /achievements)

  You can now add the name, part of the name, or the # sign next to the ID number of an achievement to search for it.

  Example A: /ach
   - Result: Toggle visibility of the main achievement UI.
  Example B: /ach gold
   - Result: Outputs links to each achievement with "gold" in its name and opens the UI to the first of these.
  Example C: /ach #1206
   - Result: Outputs a link to the achievement whose ID is 1206 and opens the UI to it.
  Example D: /ach 80
   - Result: As Example B except it searches for "80" in achievement names.

- NEW: /achsilent, /achs

  These commands silently search for the first matching achievement and display it, useful if you don't want text
  added to the chat log.

  Example A: /achs gold
   - Result: Finds the first achievement with "gold" in its name and opens the UI to it.
  Example B: /achs #1206
   - Result: Opens the achievement UI to the achievement whose ID is 1206.

- NEW: /oa

  As /ach, except that if no argument is provided, Overachiever's interface options are displayed instead of the
  main achievement UI.

- NEW: /oasilent, /oas

  As /achsilent, except that if no argument is provided, Overachiever's interface options are displayed instead of the
  main achievement UI.


DRAGGABLE FRAMES:

The main achievement frame (where achievements earned and unearned are listed by category) is draggable when the proper
Interface Options are set. Left-click on an appropriate area and hold the mouse button down to move the frame where you
desire.

By default, the main achievement frame can be moved but it is still subject to some standard frame handling that will
reposition it when it is opened or certain other frames are displayed. To unattach the frame from this position
handling and have Overachiever remember where the frame is from session to session, check the "Remember position"
option under the "Main Achievement UI frame" option. Once in the position you desire, you may want to uncheck the
"Main Achievement UI frame" option so you don't accidentally move it elsewhere.


EXPLORATION AUTO-TRACKING:

When enabled, Overachiever automatically switches tracking to the Exploration achievement for your current zone
as you travel unless you've completed that achievement or you are tracking the maximum number of achievements and
all of them are non-Exploration achievements.


Change log
==========

The change log lists changes of particular note to users, not every change made.

v0.84
- Workaround for a WoW bug where the API gives the wrong count of achievements in a category. This should fix debug
  message spam when doing an achievement search as well as an error when searching by achievement criteria (or
  searching by "Any").

v0.83
- Updated for WoW patch 6.2.
- Suggestions Tab: Added suggestions for Tanaan Jungle and the "storylines" and "bonus objectives" achievements for the
  other Draenor zones.

v0.82
- Updated for WoW patch 6.1.
- Suggestions Tab: Added suggestions for Ashran.
- Attempt to fix an error that appeared upon completion of achievements and certain instances.
- Fixed the options panels not being populated when first shown.
- Fixed "/oa" and related slash commands not opening the correct options panel if the UI options window hadn't been
  opened before in that session.

v0.81
- Suggestions Tab: Added new Darkmoon Faire suggestions.
- Fixed issue where all checkboxes start as checked in the Overachiever options panels even if the saved option was
  really false/disabled.
- Fixed an error related to auto-tracking. (This resulted in error messages when traveling from zone to zone if the
  exploration auto-tracking option was enabled.)
- "Auto-track timed achievements" option is now enabled by default. (No change if not using a fresh install of the
  addon.)

v0.80
- Initial updates for WoW patch 6.0.x. Fixes the most common errors.

v0.73
- Updated for WoW patch 5.4.
- Suggestions Tab:
-- Added suggestions for Siege of Orgrimmar, Deepwind Gorge, and Timeless Isle.
-- Removed suggestions that are now Feats of Strength.

v0.71
- Updated for WoW patch 5.2.
- Tabs module: Corrected a taint issue that could occur when achievements were added to a Watch list from another tab.
- Suggestions Tab: Added suggestions for Throne of Thunder, Isle of Thunder, and a missing one for Vale of Eternal
  Blossoms ("Eternally in the Vale").

v0.70
- Updated for WoW patch 5.1.
- "Pandaren Cuisine" and "Pandaren Delicacies" (new): Added to the consumed item tracking system.
- "Pandarian Angler" (new): Added reminder tooltips for this achievement, expanding the existing option for "The
  Scavenger," "Outland Angler," and "Northrend Angler."
- Kill Creature Achievements: Fixed an issue where reminder tooltips weren't working. (This means you, "Glorious!")
- Trade module: "The Pandaren Gourmet" is now considered when determining if you need to cook a recipe.
- Suggestions Tab, Kill Creature Achievements: When a reminder that you need to kill one of these creatures is
  triggered, the related achievement will temporarily be added to the suggestions list, as intended.
- Suggestions Tab: Suggestions added for Mists of Pandaria raids.
- Suggestions Tab: Fixed an issue where Cooking and Fishing achievements could "take over" the list, preventing you
  from seeing other suggestions once you looked at the tab while the Cooking tradeskill window was open or your fishing
  pole was equipped.
- Switched to LibBabble-Subzone library for zone/subzone localizations. (Should correct some issues with suggestions,
  among other things, for users with non-English clients.)

v0.69
- Fixed an issue where critters that were reclassified as wild pets wouldn't trigger achievement reminders.
- "Turkey Lurkey": Fixed an issue where the proper tooltip reminder wouldn't be displayed in some cases.

v0.68
- Tabs module: Improved performance when switching tabs and scrolling through achievement lists.
- Suggestions Tab:
-- Instance difficulty and raid size override options added. Use them to see suggestions that have particular
   difficulty and/or raid size requirements without having to change your actual instance/group settings.
-- Numerous suggestions added for Mists of Pandaria zones, battlegrounds, and dungeons.
-- Now suggests "Big City Pet Brawlin' - Alliance" and "Big City Pet Brawlin' - Horde" when in an Alliance or Horde
   capital city, respectively.
-- The "Complete X quests" achievements for Loch Modan and Wetlands were merged into one achievement. Likewise,
   those for Westfall and Duskwood were merged. Suggestions updated to reflect this.
-- Several Horde-specific achievements were merged into their Alliance-specific counterparts. (For instance, "Hail to
   the Chef" had a Horde version and an Alliance version with separate IDs. The ID used by Alliance characters is now
   also used by Horde characters.) Suggestions updated to reflect this.
- Italian localization (itIT) is now supported.
- Remember, translations are provided by users like you. Thanks for your generosity! Please help contribute if you are
  able: http://wow.curseforge.com/projects/overachiever/localization/

v0.67
- "To All the Squirrels I Once Caressed?" (new): Critters' /loved status for this achievement is now part of the option
  that exists for the other "To All the Squirrels..." achievements.
- Fixed an issue where an error was thrown if a battle pet container item is in your inventory.

v0.66
- Updated for WoW patch 5.0.4.
- Unfortunately, the WoW API no longer supports grabbing item IDs from "Tastes Like Chicken" and "It's Happy Hour
  Somewhere". Consequently, we cannot automatically detect new consumable items added to the list of those that give
  credit toward these achievements. Overachiever will instead use whatever list the character had before (saved from
  using Overachiever previously) or, if that is unavailable, a default list of items based on data collected in a prior
  version of WoW.

v0.65
- Updated for WoW patch 4.3.
- Suggestions Tab: Added suggestions for the Darkmoon Faire, Twin Peaks battleground, Tol Barad/Tol Barad Peninsula,
  and Alterac Valley. ("The Alterac Blitz" was moved out of the meta-achievement so it's now a suggestion, lest it be
  forgotten!)
- Brazilian Portuguese localization (ptBR) is now supported.
- Remember, translations are provided by users like you. Thanks for your generosity! Please help contribute if you are
  able: http://wow.curseforge.com/projects/overachiever/localization/

v0.64
- Updated for WoW patch 4.2.
- Suggestions Tab: Removed several suggestions that are now Feats of Strength and one that was removed from the game.
- Suggestions Tab: Added new suggestions for Mount Hyjal, Molten Front, Firelands, Zul'Aman, and Zul'Gurub, as well as
  for the new fishing and cooking daily quests.
- "You'll Feel Right as Rain" (new): Added an option to display a reminder tooltip for gorging yourself on Chocolate
  Cookies.
- "Check Your Head" and "Shake Your Bunny-Maker": Fixed an issue where some races were associated with the wrong
  criteria. (Blizzard added goblins and worgen to the criteria and also changed the order.)
- Updated options layout.

v0.63
- Updated for WoW patch 4.1.
- "Cataclysmically Delicious" and "Drown Your Sorrows" added to the consumed item tracking system.
- Suggestions Tab: Added suggestion for The Battle for Gilneas.
- Minor update to options layout.

v0.62
- Suggestions Tab: Updated suggestions to include Cataclysm dungeons. (Thanks Ackis!)
- Further optimized the reminder tooltip system to improve performance.
- Reduced loading time by saving the full consumed item tracking data between sessions (instead of partial data). If
  the addon version or the game build has changed since you last played a character, or if the character's data is not
  already saved, then load time will be about the same as it was previously because the data will be (re)built.

v0.61
- "Limnologist" and "Oceanographer" (new): Added an option to display reminder tooltips for schools of fish associated
  with these achievements.
- Fixed a compatibility issue with the addon MoveAnything where an error was given when the main achievement UI was
  first loaded if MoveAnything was used to reposition AchievementFrame.
- Fixed an issue where an error message appeared when certain tooltips were displayed.
- Trade module: Corrected an issue where uncooked recipes were treated as if you needed to cook them to earn an
  achievement even if the achievement was already completed. A new interface option has been added to support previous
  behavior, so achievement icons can be placed next to uncooked recipes even if the overall achievement is complete.
- Watch Tab: Invalid achievements are now removed from existing Watch lists when the Tabs module loads. This prevents
  errors that could result from watching achievements that subsequently are removed from the game by Blizzard.

v0.60
- You can now search for guild achievements using slash commands and the Tabs module. On the Search tab, a new option
  has been added to allow you to search personal achievements, guild achievements, or all achievements.
- The tooltip that shows which guild members have contributed to the completion of a guild achievement is no longer
  overridden by Overachiever tooltips. Additionally, this information is now displayed where appropriate when viewing
  guild achievements on tabs created by the Tabs module.
- Tabs module: Guild achievements now use the interface art intended for them on all tabs instead of only the Guild
  tab.
- Tabs module: If a guild achievement is selected or the Search tab was set to search only guild achievements, then
  the points shown at the top of the main achievement UI will show Guild Points instead of personal Achievement Points.
- Tabs module: Sorting by points now functions as most would expect, adding points from previous achievements in its
  series (if it is in one) to the points the achievement is worth alone. (This is the same way the points shown on the
  shield on the right-hand side of a displayed achievement are calculated.)
- Tabs module: Expanded the scope of the throttle in order to address performance issues.
- Suggestions Tab: Updated zone-based suggestions.
- "It's Happy Hour Somewhere" and "Tastes Like Chicken": Corrected an issue where an item could sometimes be consumed
  without being properly recorded.
- Fixed a compatibility issue with the addon Failchievements where an error was given when the cursor was placed over
  a custom meta-criteria "achievement."
- Trade module: Fixed an issue where filters (such as "Has skill up") would cause the icons and tooltips added by
  Overachiever to be displayed incorrectly.

v0.59
- Corrected an issue where Vashj'ir achievements weren't being suggested or auto-tracked.
- Tabs module: Addressed some performance issues by throttling an event that can be called frequently in combat.
- Trade module: "The Cataclysmic Gourmet" is now considered when determining if you need to cook a recipe.
- The exploration auto-tracking option will no longer cause tracking to switch away from "Stood in the Fire,"
  "Surveying the Damage," or "From Hell's Heart I Stab at Thee."
- The option to automatically track completed exploration achievements in addition to incomplete ones has been
  removed. (The ability to track completed achievements was removed from the WoW UI in a previous patch.)

v0.58
- Suggestions Tab: Added many suggestions for zone-specific achievements ("complete X quests," exploration, and more)
  as well as new Fishing and Cooking achievements. Removed some suggestions made obsolete by the Cataclysm.
- "To All the Squirrels Who Cared for Me" (new): Critters' /loved status for this achievement is now part of the
  option that exists for "To All The Squirrels I've Loved Before" and "To All The Squirrels Who Shared My Life."
- The Dynamic Difficulty system is now considered when determining whether the current instance is Heroic.

v0.57
- Updated for WoW patch 4.0.1.

v0.56
- Watch Tab: Separate "Global," "Character-Specific," and custom-named watch lists can now be created. (All are saved
  per-account so the player can access them from any character.) You can also select a Default List to be set as the
  active (or "Displayed") list upon logging in. Additionally, you can copy watched achievements from the active list
  to another list you specify using the Watch tab interface.

v0.55
- Updated for WoW patch 3.3.5.
- Fixed a pervasive taint issue that could result in blocked actions as taint eventually spreads to various UI elements
  (such as the Dungeon Finder).
- Achievements are no longer tracked between sessions to resume when you log in because WoW now does this by default.

v0.54
- Suggestions Tab: Added suggestions for Trial of the Champion, Trial of the (Grand) Crusader, Icecrown Citadel, The
  Forge of Souls, Halls of Reflection, and Pit of Saron.
- Non-Heroic versions of creatures should no longer trigger a "need to kill" reminder tooltip for Heroic achievements
  in most (if not all) cases. Please report any cases where this improper reminder still occurs.

v0.53
- "Fistful of Love": Fixed an issue where the reminder tooltip wasn't displayed properly.

v0.52
- Fixed an error that sometimes occurred when achievement criteria or statistics were updated.
- Trade module: Now supports the addon Producer. Instead of ctrl+clicking on a recipe to open to the relevant
  achievement, simply left click on the achievement listed in the popup menu for that recipe. If you shift+click on the
  listed achievement, it will be linked to chat.

v0.51
- Updated for WoW patch 3.3.
- Suggestions Tab: "Master Angler of Azeroth" is now suggested when a fishing pole is equipped while in Stranglethorn
  Vale or most Northrend zones.

v0.50
- "Turkey Lurkey": Option added to show whether you need to use your Turkey Shooter on players in their tooltips.
- Options that add reminders to tooltips are now in their own interface options panel (a sub-category to the main
  Overachiever panel) and they have had their checkbox text simplified (English localization).
- When /oa would open to an interface options panel, the new Reminder Tooltips panel is used.
- Achievement name labels in Overachiever's interface options now include icons that can be interacted with: Mouse-over
  to see achievement details, click to open to the achievement, shift+click to link to chat.
- "It's Happy Hour Somewhere" and "Tastes Like Chicken": Consumed item tracking now occurs whether or not the option
  to show tooltip reminders about these achievements is enabled.
- Suggestions Tab: Fixed an issue where the tab key didn't always cycle through locations when it should.

v0.48
- Suggestions Tab: Zone/instance and subzone override options added. Use them to see suggestions for locations far and
  near without actually traveling there!
- "Check Your Head": Fixed an issue where some races were associated with the wrong criteria.

v0.47
- "Check Your Head": Option added to show whether you need to use a Weighted Jack-o'-Lantern on players in their
  tooltips.
- Suggestions Tab: Implemented proper differentiation between 10- and 25-man raid achievements and proper detection
  of whether the player is in a Heroic instance, whether it is a 10- or 25-man raid instance, and (when not in an
  instance) the current raid/dungeon difficulty settings.
- Suggestions Tab: Many new suggestions added: Ulduar, Icecrown's Argent Tournament, Isle of Conquest, Onyxia's Lair
  (level 80 version), and more.
- Kill Creature Achievements: Now only shows a reminder if the player can attack the unit. This prevents reminders to
  destroy certain siege weapons (which can be either friendly or hostile) while they are friendly, for example.
- The option to not play a reminder sound for fishing node reminders if a fishing pole is equipped no longer affects
  whether achievements are added to the list of recent reminders.
- "Show achievement IDs" option now affects tooltips in the main achievement UI.

v0.46
- Timed achievements are now added to the Suggestions list when the timer starts.
- Achievements added in WoW 3.2 are now included in search results.
- Suggestions Tab: Fixed an error that occurred when looking at Suggestions while in Wintergrasp.

v0.45
- Updated for WoW patch 3.2.
- Suggestions Tab: Now only displays "The Fishing Diplomat" when appropriate for your current location as determined
  by whether the relevant criteria is complete and the current filter ("Earned"/"Incomplete"/"All"). For instance, if
  you are in Stormwind and the "Stormwind" criteria is complete, "The Fishing Diplomat" is only suggested when the
  filter is set to "All" or "Earned."
- Trade module: Fixed an issue where, with English clients, Worm Delight wasn't considered a requirement of "The
  Northrend Gourmet" because WoW lists it as "Wyrm Delight" in the achievement itself.

v0.44
- "It's Happy Hour Somewhere" and "Tastes Like Chicken": Implemented a system to work around the fact that, since
  WoW 3.1, addons cannot use Blizzard's API to query whether a specific item has already been consumed. The new system
  tracks whether items have been consumed itself and stores this on a per-character basis. The primary drawback to this
  is that all items are labeled as unconsumed until Overachiever v0.44+ "sees" you consume them (even if you consumed
  them before). (Additionally, in the rare event of a rollback, items may be marked as consumed when the character
  hasn't actually consumed them.)
- Trade module: Fixed an issue where, with English clients, "The Northrend Gourmet" didn't consider Rhinolicious
  Wormsteak as a requirement because WoW lists it as "Rhinolicious Wyrmsteak" in the achievement itself.
- Suggestions Tab: The Horde-specific versions of "Destruction Derby" and "Master of Wintergrasp" are now suggested
  to Horde players in Wintergrasp instead of the Alliance versions.

v0.43
- Added an option to display whether you need to kill a creature for an achievement in its tooltip. This applies not
  only to such achievements as "Northern Exposure" and "Medium Rare," but many others. See the option's tooltip
  in-game for more information.
- enGB clients: Fixed an issue where the completion date shown when comparing your progress with another's in an
  achievement link appeared in the enUS format instead of dd/mm/yy.

v0.42
- "Shake Your Bunny-Maker": Players of an unknown level ("skulls") are now assumed to be at least level 18. (While
  this won't always be the case, it's worth the assumption most of the time.)

v0.41
- "Shake Your Bunny-Maker": Option added to show whether you need to use Spring Flowers on players in their tooltips.
- Unit tooltips can now show multiple reminders when applicable.
- Tabs module: Achievement filters ("Earned"/"Incomplete"/"All") for each tab in the main UI are now saved between
  sessions (including the default tab).
- Tabs module: Fixed a display glitch that occurred when switching to an Overachiever tab if the previous tab's
  categories list was long enough to be scrollable.
- Fixed an issue that caused the client to lock up if the Objectives frame was used to attempt to open the UI to an
  achievement that is exclusive to the opposing faction.
- Trade module: Fixed an issue where, with English clients, "The Northrend Gourmet" didn't consider Spiced Worm
  Burger as a requirement because it is incorrectly listed as "Spiced Wyrm Burger" in the achievement itself by
  Blizzard. A system is now in place to allow translators to make these name substitutions for cooking achievements'
  criteria. (See the context notes for the TRADE_COOKING_OBJRENAME phrase in the Curse Forge localization system.)
- Mexican localization (esMX) is now supported. It falls back on Spanish (esES) translations when esMX-specific ones
  are unavailable.
- All localizations are now supported in the base code, though not all have translations. Please help contribute if
  you are able: http://wow.curseforge.com/projects/overachiever/localization/

v0.40
- Updated for WoW patch 3.1.
- Options involving the now-defunct achievement tracker have been removed. The default UI's new Objectives frame (AKA
  Watch Frame) has taken its place, and it is draggable.
- The remaining features that involved some interaction with the old tracker's icons are now associated with the
  achievement titles displayed by the Objectives frame (since the new frame does not use achievement icons). This
  includes achievement tooltip display and Shift+clicking to produce chat links.
- Watch Tab: You can now Alt+click on an achievement's chat link to watch it.

v0.39
- Tabs module: The new Watch tab has been implemented, allowing you to create a custom list of achievements. Alt+click
  on an achievement in another tab to watch it. Alt+click on an achievement in the Watch tab to stop watching it.

v0.38
- New option: Auto-track timed achievements.
- The exploration auto-tracking option will no longer cause tracking to switch away from "Bloody Rare," "Northern
  Exposure," or their followup achievements.

v0.37
- Tabs module: You can now use the dropdown added to the default UI in WoW 3.0.8 to filter Search results and
  Suggestions. The Suggestions filter defaults to "Incomplete"; by changing it, you can now display achievements that
  you've already earned.
- Suggestions Tab: Added battleground achievements.
- Suggestions Tab: Added Cooking and Fishing achievements. When the Cooking tradeskill window is open, all suggestions
  will be for Cooking. Otherwise, if a fishing pole is equipped, all suggestions will be for Fishing. In other cases,
  Cooking and Fishing achievements specific to the zone you're in will be shown alongside other relevant achievements.

v0.36
- Trade module: Now supports lilsparky's branch of Skillet. Because that addon uses ctrl-clicking on recipes to do
  something else, use Alt instead to open to the achievement associated with the recipe.
- Fixed an issue that occurred when using a client that isn't updated to WoW 3.0.8 yet (Chinese).
- Revamped the localization system.

v0.35
- Trade module: You can now ctrl-click on a recipe in the list to open the achievement UI to the achievement for which
  you still need to cook the recipe.
- Trade module: Now supports the addon Advanced Trade Skill Window.
- Suggestions Tab: Added several new zone-based suggestions.
- Fixed various situational bugs.

v0.34
- Trade module: Now supports the addon Skillet. Achievement icons are placed before the names of recipes you need to
  cook in the main list. Tooltips and text beneath the selected recipe's reagents list indicate which achievements
  are associated with the recipe.
- Extra feature for Skillet users: A new sorting method, "By Achievement," is provided. This sorts the list of recipes
  by the number of achievements the recipe is associated with (provided you haven't already cooked the given recipe),
  then by the name of the first such achievement (which is "first" is determined by ID, though currently there is no
  overlap between relevant achievements), and finally, by the recipe name.
- Trade module: Fixed an error that occurs with non-English clients.
- Updated German localization.

v0.33
- "The Northrend Gourmet" and "The Outland Gourmet": Pulled this functionality out of the core addon and placed it
  into a new module, Overachiever_Trade. The module may be disabled or deleted if desired.
- The new module is far more efficient and accurate than the old system and fixes an issue where the reminder icon
  system didn't always initialize properly (which resulted in no icons appearing in the trade skill UI).
- Updated most localizations.

v0.32
- "Pest Control" (new): Added an option to display reminder tooltips for critters you need to kill.
- "To All The Squirrels Who Shared My Life" (new): Critters' /loved status for this achievement is now part of the
  option that exists for "To All The Squirrels I've Loved Before."
- "The Northrend Gourmet" and "The Outland Gourmet" (new): In the trade skill UI, an achievement shield icon is now
  placed next to recipes that you currently need to cook in order to earn these achievements. A tooltip indicates
  which achievement requires the given recipe.
- Added an option to display a tooltip when the cursor is over an achievement in the main achievement UI giving the
  names of any meta-achievements that list this achievement as a criteria.
- Changed achievement sorting so that two strings beginning with numbers compare the numbers first. This means
  "5 Exalted Reputations" is now listed before "20 Exalted Reputations," for example.
- Updated most localizations. Translations are generously provided by users like you! Please help contribute if you
  are able: http://wow.curseforge.com/projects/overachiever/localization/

v0.31
- Suggestions Tab: Many new suggestions based on your current location are possible, including those for: completing
  a number of quests in your zone, goals to accomplish in your current dungeon or raid instance (or, in some cases,
  one you are near), Heroic dungeon or raid goals when that is the current difficulty mode, City PvP goals when
  in a capitol city (varying, depending on your faction and which city it is), Wintergrasp PvP, and more.
- Suggestions Tab: Achievements you were reminded about through a tooltip within the last 2 minutes are now given as
  suggestions. Additionally, any such achievement in any Overachiever-provided tab has its background colored green
  for quick identification.
- "It's Happy Hour Somewhere" and "Tastes Like Chicken": Now examines item IDs instead of names, making this option
  more reliable.
- If draggable frames with saved positions are used and you log in with a character that doesn't have a position saved
  for one of these frames yet, the position used by the previous character is applied. (Positions are still saved per
  character, so each one can have a different layout if desired. This simply removes the need for dragging frames to
  the same location every time you log in with a new character.)
- Format of the completion date shown when comparing your progress with another's in an achievement link changed to
  dd/mm/yy for enGB and non-English clients.
- Fixed an issue where the achievement frame wouldn't save its position if the achievement UI loaded earlier than
  normal (as another addon may cause to be the case).
- "Let It Snow" and "Fistful of Love": Reminders should now trigger properly with non-English clients.
- Spanish localization updated.

v0.30
- Added an option to display a tooltip when the cursor is over an achievement in the main achievement UI that is part
  of a series in order to display the names of other achievements in the series and its relation to them.
- The Overachiever Tabs module has been released! This adds two new tabs to the default achievement UI. This module
  is installed as a separate addon: The Overachiever_Tabs folder goes in the AddOns folder along with the Overachiever
  folder. The module can be disabled or you can opt to not install it without affecting the core addon's
  functionality.
- The first new tab is Search. Use it to search for achievements by name, description, criteria, and/or reward. You
  can opt to only display achievements available in the normal UI or to include all achievements, including those
  exclusive to the opposing faction, etc.
- The second new tab is Suggestions. This is where Overachiever will display achievements you might be interested in
  based on your character's current circumstances. For now, it simply displays incomplete exploration achievements for
  the current zone, but more is planned for the future.
- Key bindings have been added to open to the Search and Suggestions tabs. Set them in the default key bindings
  interface.
- Individual tabs can be disabled without disabling the entire Tabs module by renaming or deleting the individual
  file that creates that tab. That'd be either Search.lua or Suggestions.lua.
- Compensated for a Blizzard typo that made Tel'Abim Bananas get overlooked by the "Tastes Like Chicken" check when
  using an English client.
- Spanish localization implemented. (Some unresolved issues remain. Please report any you find.)
- Updated German localization.

v0.25
- Updated localizations: French, traditional Chinese.

v0.24
- New option for "It's Happy Hour Somewhere" and "Tastes Like Chicken": Show whether an item needs to be consumed
  in its tooltip. A second new option has this display even when the achievement is complete (for the curious).
- New option added to choose a sound effect to play when reminder text is added to the tooltip about an incomplete
  achievement. It will not play more than once every 15 seconds. This uses LibSharedMedia, so any sound registered
  with that library can be selected. (No sound selected by default.)
- New option added to prevent the reminder sound from being triggered by fishing nodes when your fishing pole is
  equipped. (Enabled by default.)
- Fixed a compatibility issue that produced an error when some addons made the tooltip show before Overachiever was
  fully initialized.
- Simplified Chinese localization implemented.

v0.23
- When you enable an exploration achievement auto-tracking option, tracking begins immediately (if applicable) instead
  of requiring you to enter a new zone.
- Slash commands /oa, /oasilent, and /oas now show Overachiever's interface options instead of the main achievement UI
  when no argument is provided.
- Updated to latest LibBabble-Zone-3.0 (used for auto-tracking of exploration zones).

v0.22
- Fixed an issue that could cause taint if the draggable achievement tracker is enabled when performing certain
  actions while in combat, such as entering/exiting a vehicle.
- Updated localizations: German, traditional Chinese.

v0.21
- "Let It Snow" and "Fistful of Love" achievements: Options added to show whether you need to use a Handful of
  Snowflakes or a Handful of Rose Petals on players in their tooltips.
- Traditional Chinese and Russian localizations updated.

v0.20
- "Well Read" achievement option expanded to include "Higher Learning."
- New option: Show in fishing nodes' tooltips whether you need to fish them for "The Scavenger," "Outland Angler,"
  or "Northrend Angler."
- Fixed an error that occurred when trying to open to an achievement that isn't in the normal UI. (For example,
  achievements exclusive to the opposing faction.)
- Russian localization implemented.

v0.18
- New option for "Well Read" achievement: Add whether you've read a relevant book to its tooltip.

v0.17
- The achievement tracker is now draggable.
- Traditional Chinese localization implemented.

v0.16
- Quantity-based criteria progress is now added to the tooltip even if it is of the type that would not use a
  progress bar when it is tracked, including information that is normally hidden from the user.
- When there are multiple criteria, your progress with each is now inserted directly next to its listing on the
  achievement tooltip. (Combined with the above change, you might see something like this: "Assault 2 bases (0/2).")
- Achievement progress comparison feature added, replacing the option to simply show your "progress bar data" in
  others' achievement links.

v0.15
- Revamped automatic tracking of exploration achievements to better support non-English clients.
- French localization implemented.

v0.14
- New option added to save the position of the draggable Achievement UI.
- Corrected German localization issue. Further work may be necessary, but this should be an improvement.

v0.13
- German localization implemented.

v0.12
- The main Achievement UI is now draggable.

v0.11
- Initial release.
