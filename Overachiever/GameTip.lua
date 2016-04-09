
local L = OVERACHIEVER_STRINGS
local OVERACHIEVER_ACHID = OVERACHIEVER_ACHID
local GetStatistic = GetStatistic
local GetAchievementInfo = Overachiever.GetAchievementInfo
local GetAchievementCriteriaInfo = Overachiever.GetAchievementCriteriaInfo

local AchievementIcon = "Interface\\AddOns\\Overachiever\\AchShield"
local tooltip_complete = { r = 0.2, g = 0.5, b = 0.2 }
local tooltip_incomplete = { r = 1, g = 0.1, b = 0.1 }

local time = time

local skipNextExamineOneLiner

local isCriteria
do
  local cache
  function isCriteria(achID, name)
    if (not cache or not cache[achID]) then
      cache = cache or {}
      cache[achID] = {}
      local n
      for i=1,GetAchievementNumCriteria(achID) do
        n = GetAchievementCriteriaInfo(achID, i)
        cache[achID][n] = i  -- Creating lookup table
      end
    end
    if (cache[achID][name]) then
      local _, _, complete = GetAchievementCriteriaInfo(achID, cache[achID][name])
      return true, complete
    end
  end
end

local isCriteria_formatted
do
  local cache
  function isCriteria_formatted(achID, name, base)
    if (not cache or not cache[achID]) then
      cache = cache or {}
      cache[achID] = {}
      local n
      for i=1,GetAchievementNumCriteria(achID) do
        n = GetAchievementCriteriaInfo(achID, i)
        cache[achID][base:format(n)] = i  -- Creating lookup table
      end
    end
    if (cache[achID][name]) then
      local _, _, complete = GetAchievementCriteriaInfo(achID, cache[achID][name])
      return true, complete
    end
  end
end

local isCriteria_asset
do
  local cache
  function isCriteria_asset(achID, assetID)
    local _
    if (not cache or not cache[achID]) then
      cache = cache or {}
      cache[achID] = {}
      local a
      for i=1,GetAchievementNumCriteria(achID) do
        _, _, _, _, _, _, _, a  = GetAchievementCriteriaInfo(achID, i)
        cache[achID][a] = i  -- Creating lookup table
      end
    end
    if (cache[achID][assetID]) then
      local complete
      _, _, complete = GetAchievementCriteriaInfo(achID, cache[achID][assetID])
      return true, complete
    end
  end
end

--[[ Cacheless versions:
local function isCriteria(achID, name)
  local n, t, complete
  for i=1,GetAchievementNumCriteria(achID) do
    n, t, complete = GetAchievementCriteriaInfo(achID, i)
    if (n == name) then  return true, complete;  end
  end
end

local function isCriteria_formatted(achID, name, base)
  local n, t, complete
  for i=1,GetAchievementNumCriteria(achID) do
    n, t, complete = GetAchievementCriteriaInfo(achID, i)
    if (base:format(n) == name) then  return true, complete;  end
  end
end
--]]

Overachiever.IsCriteria = isCriteria

--[[
local function isCriteria_hidden(achID, name)
  local n, t, complete
  local i = 0
  repeat
    i = i + 1
    n, t, complete = GetAchievementCriteriaInfo(achID, i)
    if (n == name) then  return true, complete;  end
  until (not n)
end
--]]

local lastreminder = 0
local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")

local function PlayReminder()
  if (Overachiever_Settings.SoundAchIncomplete ~= 0 and time() >= lastreminder + 15) then
    local sound = SharedMedia:Fetch("sound", Overachiever_Settings.SoundAchIncomplete)
    if (sound) then
      PlaySoundFile(sound)
      lastreminder = time()
    end
  end
end


Overachiever.RecentReminders = {}  -- Used by Tabs module
local RecentReminders = Overachiever.RecentReminders

function Overachiever.RecentReminders_Check()
  local earliest = time() - 120  -- Allow reminders from up to 2 minutes ago
  for id,t in pairs(RecentReminders) do
    if (t < earliest) then
      RecentReminders[id] = nil
    end
  end
end

function Overachiever.GetDifficulty()
  local inInstance = IsInInstance()
  if (inInstance) then
-- IF IN AN INSTANCE:
  -- Returns: <instance type ("pvp"/"arena"/"party"/"raid")>, <Heroic?>, <25-player Raid?>, <Heroic Raid?>, <Dynamic?>
  --   If in a raid, the "Heroic Raid?" return will match the "Heroic?" return. Otherwise, it will be nil (actually
  --   no return). "Dynamic?" refers to whether the current instance's difficulty can be changed on the fly, as is
  --   the case with the Icecrown Citadel raid.
  --   Note: While it may seem that the "Heroic?" and "Heroic Raid?" returns are redundant here, it's done this
  --   way to make the return values consistent with those given when you're NOT in an instance.
    local _, itype, diff, _, _, dynDiff, isDynamic = GetInstanceInfo()
    --if (isDynamic) then  diff = dynDiff;  end  -- Testing is needed to see if this line is necessary.
    local _, _, isHeroic = GetDifficultyInfo(diff) -- This function can also give us isChallengeMode, but we're not using it at the moment.
    return itype, isHeroic, (diff == 4 or diff == 6), (diff == 5 or diff == 6), isDynamic
  end
-- IF NOT IN AN INSTANCE:
  -- Returns: false, <Dungeon set as Heroic?>, <Raid set for 25 players?>, <Raid set as Heroic?>
  local d = GetDungeonDifficultyID()
  local r = GetRaidDifficultyID()
  return false, (d > 1), (r == 4 or r == 6), (r > 4)
end


-- UNIT TOOLTIP HOOK
----------------------

local CritterAch = {
  LoveCritters = { "CritterTip_loved", L.ACH_LOVECRITTERS_COMPLETE, L.ACH_LOVECRITTERS_INCOMPLETE },
  LoveCritters2 = { "CritterTip_loved", L.ACH_LOVECRITTERS_COMPLETE, L.ACH_LOVECRITTERS_INCOMPLETE },
  LoveCritters3 = { "CritterTip_loved", L.ACH_LOVECRITTERS_COMPLETE, L.ACH_LOVECRITTERS_INCOMPLETE },
  LoveCritters4 = { "CritterTip_loved", L.ACH_LOVECRITTERS_COMPLETE, L.ACH_LOVECRITTERS_INCOMPLETE },
  PestControl = { "CritterTip_killed", L.KILL_COMPLETE, L.KILL_INCOMPLETE },
};

local function CritterCheck(ach, name)
  local id = OVERACHIEVER_ACHID[ach]
  if (select(4, GetAchievementInfo(id))) then
    CritterAch[ach] = nil;
    return;
  end
  local isCrit, complete = isCriteria(id, name)
  if (isCrit) then
    local tip = complete and CritterAch[ach][2] or CritterAch[ach][3]
    if (Overachiever_Debug) then  tip = tip .. " (" .. id .. ")";  end
    return id, tip, complete
  end
end

local RaceClassAch = {
  FistfulOfLove = { "FistfulOfLove_petals", L.ACH_FISTFULOFLOVE_COMPLETE, L.ACH_FISTFULOFLOVE_INCOMPLETE,
    { "Gnome WARLOCK", "Orc DEATHKNIGHT", "Human DEATHKNIGHT", "NightElf PRIEST", "Orc SHAMAN", "Tauren DRUID", "Scourge WARRIOR", "Troll ROGUE", "BloodElf MAGE", "Draenei PALADIN", "Dwarf HUNTER" }
  },
  LetItSnow = { "LetItSnow_flaked", L.ACH_LETITSNOW_COMPLETE, L.ACH_LETITSNOW_INCOMPLETE,
    { "Orc DEATHKNIGHT", "Human WARRIOR", "Tauren SHAMAN", "NightElf DRUID", "Scourge ROGUE", "Troll HUNTER", "Gnome MAGE", "Dwarf PALADIN", "BloodElf WARLOCK", "Draenei PRIEST" }
  },
  CheckYourHead = { "CheckYourHead_pumpkin", L.ACH_CHECKYOURHEAD_COMPLETE, L.ACH_CHECKYOURHEAD_INCOMPLETE,
    { "BloodElf", "Draenei", "Dwarf", "Gnome", "Goblin", "Human", "NightElf", "Orc", "Tauren", "Troll", "Scourge", "Worgen" }, true
  },
  TurkeyLurkey = { "TurkeyLurkey_feathered", L.ACH_TURKEYLURKEY_COMPLETE, L.ACH_TURKEYLURKEY_INCOMPLETE,
    { "BloodElf ROGUE", "Dwarf ROGUE", "Gnome ROGUE", "Goblin ROGUE", "Human ROGUE", "NightElf ROGUE", "Orc ROGUE", "Troll ROGUE", "Scourge ROGUE", "Worgen ROGUE" }
  },
  BunnyMaker = { "BunnyMaker_eared", L.ACH_BUNNYMAKER_COMPLETE, L.ACH_BUNNYMAKER_INCOMPLETE,
    { "BloodElf", "Draenei", "Dwarf", "Gnome", "Goblin", "Human", "NightElf", "Orc", "Tauren", "Troll", "Scourge", "Worgen" }, true,
    function(unit)
      if (UnitSex(unit) == 3) then
        local level = UnitLevel(unit)
        if (level >= 18 or level == -1) then  return true;  end
        -- Assumes that players 10 or more levels higher than you are at least level 18. (Though that's not necessarily
        -- the case, they generally would be.)
      end
    end
  },
};
--[[
-- /run Overachiever.Debug_GetRaceClassAchCrit()
function Overachiever.Debug_GetRaceClassAchCrit()
  local s, sub = ""
  for k,tab in pairs(RaceClassAch) do
    local id = OVERACHIEVER_ACHID[k]
    sub = k.." ("..id.."): "
    for i=1,GetAchievementNumCriteria(id) do
      local n = GetAchievementCriteriaInfo(id, i)
      local r, c
      local n1, n2, n3, n4 = strsplit(" ", n, 4)
      if (n2 == "Elf") then
        r = n1..n2
        if (n3) then  c = strupper(n3..(n4 or ""));  end
      else
        r = n1 == "Undead" and "Scourge" or n1
        if (n2) then  c = strupper(n2..(n3 or ""));  end
      end
      n = r..(c and " "..c or "")
      sub = sub..'"'..n..'"'..", "
    end
    print(sub)
    s = s == "" and sub or s.."|n|n"..sub
  end
  error(s) -- Use the popup for easy copy+paste
end
--]]

local function RaceClassCheck(ach, tab, raceclass, race, unit)
  local id = OVERACHIEVER_ACHID[ach]
  if (select(4, GetAchievementInfo(id))) then
    RaceClassAch[ach] = nil;
    return;
  end
  local func = tab[6]
  if (func and not func(unit)) then  return;  end
  local text = tab[5] and race or raceclass
  for i,c in ipairs(tab[4]) do
    if (c == text) then
      local _, _, complete = GetAchievementCriteriaInfo(id, i)
      return id, complete and tab[2] or tab[3], complete
    end
  end
end

function Overachiever.ExamineSetUnit(tooltip)
  skipNextExamineOneLiner = true
  tooltip = tooltip or GameTooltip  -- Workaround since another addon is known to break this
  local name, unit = tooltip:GetUnit()
  if (not unit) then  return;  end
  local id, text, complete, needtipshow

  if (UnitIsPlayer(unit)) then
    local _, r, c = UnitRace(unit)
    _, c = UnitClass(unit)
    if (r and c) then
      local raceclass = r.." "..c
      for key,tab in pairs(RaceClassAch) do
        if (Overachiever_Settings[ tab[1] ]) then
          id, text, complete = RaceClassCheck(key, tab, raceclass, r, unit)
          if (text) then
            local r, g, b
            if (complete) then
              r, g, b = tooltip_complete.r, tooltip_complete.g, tooltip_complete.b
            else
              r, g, b = tooltip_incomplete.r, tooltip_incomplete.g, tooltip_incomplete.b
              PlayReminder()
              RecentReminders[id] = time()
            end
            tooltip:AddLine(text, r, g, b)
            tooltip:AddTexture(AchievementIcon)
            needtipshow = true
          end
        end
      end
    end

  elseif (name) then
    local type = UnitCreatureType(unit)
    if (type == L.CRITTER or type == L.WILDPET) then
      for key,tab in pairs(CritterAch) do
        if (Overachiever_Settings[ tab[1] ]) then
          id, text, complete = CritterCheck(key, name)
          if (text) then
            local r, g, b
            if (complete) then
              r, g, b = tooltip_complete.r, tooltip_complete.g, tooltip_complete.b
            else
              r, g, b = tooltip_incomplete.r, tooltip_incomplete.g, tooltip_incomplete.b
              PlayReminder()
              RecentReminders[id] = time()
            end
            tooltip:AddLine(text, r, g, b)
            tooltip:AddTexture(AchievementIcon)
            needtipshow = true
          end
        end
      end

    elseif (Overachiever_Settings.CreatureTip_killed and UnitCanAttack("player", unit)) then
      local guid = UnitGUID(unit)
      --guid = tonumber( "0x"..strsub(guid, 6, 10) )
      guid = tonumber(guid:sub(6,10), 16)
      local tab = Overachiever.AchLookup_kill[guid]
      if (tab) then
        local num, numincomplete, potential, _, achcom, c, t = 0, 0
        for i = 1, #tab, 2 do
          id = tab[i]
          _, _, _, achcom = GetAchievementInfo(id)
          if (not achcom) then
            num = num + 1
            _, _, c = GetAchievementCriteriaInfo(id, tab[i+1])
            if (not c) then
              numincomplete = numincomplete + 1
              potential = potential or {}
              potential[id] = i+1
            end
          end
        end

        if (num > 0) then
          if (numincomplete > 0) then
            local cat, t
            local instype, heroic, twentyfive = Overachiever.GetDifficulty()
            for id, crit in pairs(potential) do
              cat = GetAchievementCategory(id)
              if (((not instype or not heroic) and (OVERACHIEVER_CATEGORY_HEROIC[cat] or (OVERACHIEVER_HEROIC_CRITERIA[id] and OVERACHIEVER_HEROIC_CRITERIA[id][crit])))
                  or ((not instype or not twentyfive) and OVERACHIEVER_CATEGORY_25[cat])) then
                numincomplete = numincomplete - 1 -- Discount this reminder if it's heroic-only and you're not in a heroic instance or if it's 25-man only and you're not in a 25-man instance.
              else
                t = t or time()
                RecentReminders[id] = t
              end
            end
          end

          if (numincomplete <= 0) then
            text = L.KILL_COMPLETE
            r, g, b = tooltip_complete.r, tooltip_complete.g, tooltip_complete.b
          else
            text = L.KILL_INCOMPLETE
            r, g, b = tooltip_incomplete.r, tooltip_incomplete.g, tooltip_incomplete.b
            PlayReminder()
          end
          tooltip:AddLine(text, r, g, b)
          tooltip:AddTexture(AchievementIcon)
          needtipshow = true
        end
      end
    end
  end

  if (needtipshow) then  tooltip:Show();  end
end


-- WORLD OBJECT TOOLTIP HOOK
------------------------------

local WorldObjAch = {
  WellRead = { "WellReadTip_read", L.ACH_WELLREAD_COMPLETE, L.ACH_WELLREAD_INCOMPLETE },
  HigherLearning = { "WellReadTip_read", L.ACH_WELLREAD_COMPLETE, L.ACH_WELLREAD_INCOMPLETE },
  Scavenger = { "AnglerTip_fished", L.ACH_ANGLER_COMPLETE, L.ACH_ANGLER_INCOMPLETE, true },
  OutlandAngler = { "AnglerTip_fished", L.ACH_ANGLER_COMPLETE, L.ACH_ANGLER_INCOMPLETE, true },
  NorthrendAngler = { "AnglerTip_fished", L.ACH_ANGLER_COMPLETE, L.ACH_ANGLER_INCOMPLETE, true },
  Limnologist = { "SchoolTip_fished", L.ACH_ANGLER_COMPLETE, L.ACH_ANGLER_INCOMPLETE, true, L.ACH_FISHSCHOOL_FORMAT },
  Oceanographer = { "SchoolTip_fished", L.ACH_ANGLER_COMPLETE, L.ACH_ANGLER_INCOMPLETE, true, L.ACH_FISHSCHOOL_FORMAT },
  PandarianAngler = { "SchoolTip_fished", L.ACH_ANGLER_COMPLETE, L.ACH_ANGLER_INCOMPLETE, true, L.ACH_FISHSCHOOL_FORMAT },
};

local function WorldObjCheck(ach, text)
  local id = OVERACHIEVER_ACHID[ach]
  if (select(4, GetAchievementInfo(id))) then
    WorldObjAch[ach] = nil;
    return;
  end
  local isCrit, complete
  if (WorldObjAch[ach][5]) then
    isCrit, complete = isCriteria_formatted(id, text, WorldObjAch[ach][5])
  else
    isCrit, complete = isCriteria(id, text)
  end
  if (isCrit) then
    return id, complete and WorldObjAch[ach][2] or WorldObjAch[ach][3], complete, WorldObjAch[ach][4]
  end
end

do
  local last_check, last_tiptext = 0
  local last_id, last_text, last_complete, last_angler
  function Overachiever.ExamineOneLiner(tooltip)
  -- Unfortunately, we couldn't find a "GameTooltip:SetWorldObject" or similar type of thing, so we have to check for
  -- these sorts of tooltips in a less direct way.
    if (skipNextExamineOneLiner) then  skipNextExamineOneLiner = nil;  return;  end
    -- Skipping works because this function is consistently called after the functions that set skipNextExamineOneLiner to true.

    tooltip = tooltip or GameTooltip  -- Workaround since another addon is known to break this
    if (tooltip:NumLines() == 1) then
      local n = tooltip:GetName()
      if (_G[n.."TextRight1"]:GetText()) then  return;  end
      local id, text, complete, angler
      local tiptext = _G[n.."TextLeft1"]:GetText()
      local t = time()

      local cache_used
      if (tiptext ~= last_tiptext or t ~= last_check) then
        for key,tab in pairs(WorldObjAch) do
          if (Overachiever_Settings[ tab[1] ]) then
            id, text, complete, angler = WorldObjCheck(key, tiptext)
            if (text) then  break;  end
          end
        end
        last_tiptext, last_check = tiptext, t
        last_id, last_text, last_complete, last_angler = id, text, complete, angler
      else
        id, text, complete, angler = last_id, last_text, last_complete, last_angler
        cache_used = true
      end

      if (text) then
        local r, g, b
        if (complete) then
          r, g, b = tooltip_complete.r, tooltip_complete.g, tooltip_complete.b
        else
          r, g, b = tooltip_incomplete.r, tooltip_incomplete.g, tooltip_incomplete.b
          if (not cache_used) then
            RecentReminders[id] = time()
            if (not angler or not Overachiever_Settings.SoundAchIncomplete_AnglerCheckPole or
                not IsEquippedItemType("Fishing Poles")) then
              PlayReminder()
            end
          end
        end
        tooltip:AddLine(text, r, g, b)
        tooltip:AddTexture(AchievementIcon)
        tooltip:Show()
      end
    end
  end
end


-- ITEM TOOLTIP HOOK
----------------------

-- All this consumable item tracking stuff really should be rewritten when you've got the time. (It's so disorganized and confusing because Blizzard kept changing things on me but I didn't want to take too long fixing things.)

local FoodCriteria, DrinkCriteria, FoodCriteria2, DrinkCriteria2, PandaEats, PandaEats2 = {}, {}, {}, {}, {}, {}
local numDrinksConsumed, numFoodConsumed

local ConsumeItemAch = {
  TastesLikeChicken = { "Item_consumed", L.ACH_CONSUME_COMPLETE, L.ACH_CONSUME_INCOMPLETE, L.ACH_CONSUME_INCOMPLETE_EXTRA, FoodCriteria },
  HappyHour = { "Item_consumed", L.ACH_CONSUME_COMPLETE, L.ACH_CONSUME_INCOMPLETE, L.ACH_CONSUME_INCOMPLETE_EXTRA, DrinkCriteria },
  CataclysmicallyDelicious = { "Item_consumed", L.ACH_CONSUME_COMPLETE, L.ACH_CONSUME_INCOMPLETE, L.ACH_CONSUME_INCOMPLETE_EXTRA, FoodCriteria2 },
  DrownYourSorrows = { "Item_consumed", L.ACH_CONSUME_COMPLETE, L.ACH_CONSUME_INCOMPLETE, L.ACH_CONSUME_INCOMPLETE_EXTRA, DrinkCriteria2 },
  PandarenCuisine = { "Item_consumed", L.ACH_CONSUME_COMPLETE, L.ACH_CONSUME_INCOMPLETE, L.ACH_CONSUME_INCOMPLETE_EXTRA, PandaEats, "PandaEats" },
  PandarenDelicacies = { "Item_consumed", L.ACH_CONSUME_COMPLETE, L.ACH_CONSUME_INCOMPLETE, L.ACH_CONSUME_INCOMPLETE_EXTRA, PandaEats2, "PandaEats2" },
};

--local lastitemTime, lastitemLink = 0

function Overachiever.BuildItemLookupTab(THIS_VERSION, id, savedtab, tab, duptab)
  if (id) then  -- Build lookup tables (since examining the criteria each time is time-consuming):
-- This is separate from the BuildCriteriaLookupTab function because while that gave some good achievements
-- involving consumable items, it also gave some that didn't fit well. This function instead uses hardcoded IDs
-- taken from OVERACHIEVER_ACHID.
-- When duptab is used, it specifies that: 1) The achievement ID given provides reliable data on whether a
-- criteria is completed, so it is good to use that data instead of relying on saved data. 2) Some asset data
-- in duptab overlaps with the assets in this achievement, but since duptab didn't get its criteria info
-- reliably, we should update duptab data to match where applicable.
    tab = tab or {}

    if (id == OVERACHIEVER_ACHID.TastesLikeChicken or id == OVERACHIEVER_ACHID.HappyHour) then
    -- Unfortunately, the WoW API no longer supports grabbing item IDs from "Tastes Like Chicken" and "It's Happy Hour Somewhere".
    -- This guts the functionality that the Reminder Tooltips feature relied on for those two achievements. Consequently,
    -- we're not going to be able to intelligently detect new foods you come across and whether you need to consume them.
    -- So we will just preserve whatever table data is already there so as not to remove from the SavedVariables
    -- file the info we've already gathered, just in case we can use it again in the future somehow.
    -- If there is no saved data, we'll use a default list of items based on data collected in a prior version of WoW.
      if ((not savedtab or next(savedtab) == nil) and Overachiever.Consumed_Default[id]) then
        wipe(tab)
        for k,v in pairs(Overachiever.Consumed_Default[id]) do
          tab[k] = v;
          if (savedtab) then  savedtab[k] = v;  end
        end
        if (Overachiever_Debug) then  Overachiever.chatprint("Skipped lookup table rebuild for Ach #"..id..": Used default list because WoW API no longer supports the required method and character has no relevant saved data.");  end
      elseif (savedtab) then
        wipe(tab)
        for k,v in pairs(savedtab) do  tab[k] = v;  end  -- Copy table (cannot just set using "=" or reference will be lost)
        if (Overachiever_Debug) then  Overachiever.chatprint("Skipped lookup table rebuild for Ach #"..id..": Retrieved from saved variables because WoW API no longer supports the required method.");  end
      end
      return tab
    end

    local i, _, completed, asset = 1
    _, _, completed, _, _, _, _, asset = GetAchievementCriteriaInfo(id, i)
    while (asset) do -- while loop used because "hidden" criteria may be used (where GetAchievementNumCriteria returns only 1).
      if (duptab) then
        tab[asset] = completed or 0
        if (duptab[asset]) then  duptab[asset] = completed or 0;  end
      else
        tab[asset] = savedtab[asset] or 0
      end
      i = i + 1
      _, _, completed, _, _, _, _, asset = GetAchievementCriteriaInfo(id, i)
    end
    return tab
  end

  numDrinksConsumed = tonumber((GetStatistic(OVERACHIEVER_ACHID.Stat_ConsumeDrinks))) or 0
  numFoodConsumed = tonumber((GetStatistic(OVERACHIEVER_ACHID.Stat_ConsumeFood))) or 0

--[[  -- Old code to see whether tables should be built. Now, tables are always used (either built or retrieved
      -- from a saved variable) because Blizzard's API no longer tells us what has been consumed. To be
      -- reliable, Overachiever needs to "see" what is consumed so from now on we'll always use the tracking
      -- table. (Variable ItemLookupTabBuilt is no longer used.)
  if ( ItemLookupTabBuilt or not Overachiever_Settings.Item_consumed or
       (not Overachiever_Settings.Item_consumed_whencomplete and select(4, GetAchievementInfo(foodID)) and
       select(4, GetAchievementInfo(drinkID))) ) then
  -- OLD: If the tables are built, or we don't add this info to tooltips, or we don't add this info to tooltips if
  -- the achievement is complete AND both achievements are complete, then do nothing.
    return;
  end
--]]

  -- Determine whether we should (re)build the lookup tables. If they don't exist (in whole or in part), the
  -- addon has changed, or the game build has changed, the tables will be (re)built.
  local needBuild
  local _, gamebuild = GetBuildInfo()
  if (not Overachiever_CharVars_Consumed or not Overachiever_CharVars_Consumed.LastBuilt or
      not Overachiever_CharVars_Consumed.Food or not Overachiever_CharVars_Consumed.Drink or
      not Overachiever_CharVars_Consumed.Food2 or not Overachiever_CharVars_Consumed.Drink2 or
      not Overachiever_CharVars_Consumed.PandaEats or not Overachiever_CharVars_Consumed.PandaEats2) then
    Overachiever_CharVars_Consumed = Overachiever_CharVars_Consumed or {}
    Overachiever_CharVars_Consumed.Food = Overachiever_CharVars_Consumed.Food or {}
    Overachiever_CharVars_Consumed.Drink = Overachiever_CharVars_Consumed.Drink or {}
    Overachiever_CharVars_Consumed.Food2 = Overachiever_CharVars_Consumed.Food2 or {}
    Overachiever_CharVars_Consumed.Drink2 = Overachiever_CharVars_Consumed.Drink2 or {}
    Overachiever_CharVars_Consumed.PandaEats = Overachiever_CharVars_Consumed.PandaEats or {}
    Overachiever_CharVars_Consumed.PandaEats2 = Overachiever_CharVars_Consumed.PandaEats2 or {}
    needBuild = true
  else
    local oldver, oldbuild = strsplit("|", Overachiever_CharVars_Consumed.LastBuilt, 2)
    if (oldver ~= THIS_VERSION or gamebuild ~= oldbuild) then  needBuild = true;  end
  end

  if (needBuild) then
    Overachiever_CharVars_Consumed.Food = Overachiever.BuildItemLookupTab(nil, OVERACHIEVER_ACHID.TastesLikeChicken, Overachiever_CharVars_Consumed.Food, FoodCriteria)
    Overachiever_CharVars_Consumed.Drink = Overachiever.BuildItemLookupTab(nil, OVERACHIEVER_ACHID.HappyHour, Overachiever_CharVars_Consumed.Drink, DrinkCriteria)
    Overachiever_CharVars_Consumed.Food2 = Overachiever.BuildItemLookupTab(nil, OVERACHIEVER_ACHID.CataclysmicallyDelicious, Overachiever_CharVars_Consumed.Food2, FoodCriteria2, FoodCriteria)
    Overachiever_CharVars_Consumed.Drink2 = Overachiever.BuildItemLookupTab(nil, OVERACHIEVER_ACHID.DrownYourSorrows, Overachiever_CharVars_Consumed.Drink2, DrinkCriteria2, DrinkCriteria)
    Overachiever_CharVars_Consumed.PandaEats = Overachiever.BuildItemLookupTab(nil, OVERACHIEVER_ACHID.PandarenCuisine, Overachiever_CharVars_Consumed.PandaEats, PandaEats)
    Overachiever_CharVars_Consumed.PandaEats2 = Overachiever.BuildItemLookupTab(nil, OVERACHIEVER_ACHID.PandarenDelicacies, Overachiever_CharVars_Consumed.PandaEats2, PandaEats2)
    Overachiever_CharVars_Consumed.LastBuilt = THIS_VERSION.."|"..gamebuild
  else
    FoodCriteria, DrinkCriteria = Overachiever_CharVars_Consumed.Food, Overachiever_CharVars_Consumed.Drink
    FoodCriteria2, DrinkCriteria2 = Overachiever_CharVars_Consumed.Food2, Overachiever_CharVars_Consumed.Drink2
    PandaEats, PandaEats2 = Overachiever_CharVars_Consumed.PandaEats, Overachiever_CharVars_Consumed.PandaEats2;
    ConsumeItemAch.TastesLikeChicken[5], ConsumeItemAch.HappyHour[5] = FoodCriteria, DrinkCriteria
    ConsumeItemAch.CataclysmicallyDelicious[5], ConsumeItemAch.DrownYourSorrows[5] = FoodCriteria2, DrinkCriteria2
    ConsumeItemAch.PandarenCuisine[5], ConsumeItemAch.PandarenDelicacies[5] = PandaEats, PandaEats2
    if (Overachiever_Debug) then  Overachiever.chatprint("Skipped food/drink lookup table rebuild: Retrieved from saved variables.");  end
  end
  Overachiever.Consumed_Default = nil
end
-- Run periodically (then "/dump TESTTAB") to see if Blizzard reinstated API-accessible tracking:
-- /run TESTTAB={};local id,i,_,a=1832,1; _, _, c, _, _, _, _, a = GetAchievementCriteriaInfo(id, i); while (a) do TESTTAB[i]=c or nil; i=i+1; _, _, c, _, _, _, _, a = GetAchievementCriteriaInfo(id, i); end
-- Only worth doing on a character that's actually consumed things on the list for ach #1832, of course.
-- Also, you can use this to get an item's ID:  /run local name,link=GameTooltip:GetItem();local _,_,id=strfind(link,"item:(%d+)");print(link,":",id)

local LBI = LibStub:GetLibrary("LibBabble-Inventory-3.0"):GetLookupTable()

local function ItemConsumedCheck(ach, itemID)
  local id = OVERACHIEVER_ACHID[ach]
  ach = ConsumeItemAch[ach]
  local achcomplete = select(4, GetAchievementInfo(id))
  if (achcomplete and not Overachiever_Settings[ ach[1].."_whencomplete" ]) then
    return;
  end
  local isCrit = ach[5][itemID]
  if (isCrit) then
    local complete
    if (ach[6]) then -- Special case for criteria we can't track by seeing what was consumed (consumed food/drink statistic doesn't change - Blizzard bug?) but CAN track through the achievement itself:
      isCrit, complete = isCriteria_asset(id, itemID)
      if (not isCrit) then  return;  end  -- That should never happen..
      -- Update the table for tracking purposes, just to be consistent (mostly for the saved variable, in case we use it in some other way in the future):
      ach[5][itemID] = complete or 0
      Overachiever_CharVars_Consumed[ ach[6] ][itemID] = complete or 0
    else
      complete = isCrit == true
    end
    local tip = complete and ach[2] or achcomplete and ach[4] or ach[3]
    if (Overachiever_Debug) then  tip = tip .. " (" .. id .. ")";  end
    return id, tip, complete, achcomplete
  end
end


local MiscItemAch = {
  [62680] = { "RightAsRain", "Item_satisfied", L.ACH_CONSUME_91_COMPLETE, L.ACH_CONSUME_91_INCOMPLETE },
}

local function MiscItemCheck(tab)
  --local tab = MiscItemAch[itemID]
  if (not Overachiever_Settings[ tab[2] ]) then  return;  end
  local id = OVERACHIEVER_ACHID[tab[1]]
  local _, _, _, complete = GetAchievementInfo(id)
  return id, complete and tab[3] or tab[4], complete
end


function Overachiever.ExamineItem(tooltip)
  skipNextExamineOneLiner = true
  tooltip = tooltip or this or GameTooltip  -- Workaround in case another addon breaks this
  local name, link = tooltip:GetItem() -- Issue: This doesn't reliably get the item we want?
  if (not link) then  return;  end
  -- Could check IsUsableItem(link) to see if it's something in your inventory..
  local itemMinLevel, itemType, subtype = select(5, GetItemInfo(link))
  if ((itemType == LBI["Consumable"] and (subtype == LBI["Food & Drink"] or subtype == LBI["Consumable"])) or
      (itemType == LBI["Trade Goods"] and subtype == LBI["Meat"])) then
    local _, _, itemID  = strfind(link, "item:(%d+)")
    itemID = tonumber(itemID)
    if (not itemID) then  return;  end  -- Ignores special objects not classified as normal items, like battlepets
    local id, text, complete, achcomplete
    for key,tab in pairs(ConsumeItemAch) do
      if (Overachiever_Settings[ tab[1] ]) then
        id, text, complete, achcomplete = ItemConsumedCheck(key, itemID)
        if (text) then  break;  end
      end
    end
    if (text) then
      local r, g, b
      if (complete) then
        r, g, b = tooltip_complete.r, tooltip_complete.g, tooltip_complete.b
      else
        r, g, b = tooltip_incomplete.r, tooltip_incomplete.g, tooltip_incomplete.b
        if (not achcomplete and tooltip == GameTooltip and itemMinLevel <= UnitLevel("player")) then
          -- Extra checks needed since the previous item sometimes shows up on the tooltip?
          PlayReminder()
          RecentReminders[id] = time()
        end
      end
      tooltip:AddLine(text, r, g, b)
      tooltip:AddTexture(AchievementIcon)
      needtipshow = true
    end

    if (MiscItemAch[itemID]) then
      id, text, complete = MiscItemCheck(MiscItemAch[itemID])
      if (text) then
        local r, g, b
        if (complete) then
          r, g, b = tooltip_complete.r, tooltip_complete.g, tooltip_complete.b
        else
          r, g, b = tooltip_incomplete.r, tooltip_incomplete.g, tooltip_incomplete.b
          if (tooltip == GameTooltip and itemMinLevel <= UnitLevel("player")) then
            -- Extra checks needed since the previous item sometimes shows up on the tooltip?
            PlayReminder()
            RecentReminders[id] = time()
          end
        end
        tooltip:AddLine(text, r, g, b)
        tooltip:AddTexture(AchievementIcon)
        needtipshow = true
      end
    end

    if (needtipshow) then  tooltip:Show();  end

  end
end

local function BagUpdate(...)
  local oldF, oldD = numFoodConsumed, numDrinksConsumed
  numFoodConsumed = tonumber((GetStatistic(OVERACHIEVER_ACHID.Stat_ConsumeFood))) or 0
  numDrinksConsumed = tonumber((GetStatistic(OVERACHIEVER_ACHID.Stat_ConsumeDrinks))) or 0

  --print("BagUpdate?",numFoodConsumed,oldF < numFoodConsumed, numDrinksConsumed,oldD < numDrinksConsumed)

  local changeF, changeD = oldF < numFoodConsumed, oldD < numDrinksConsumed
  if (changeF or changeD) then
    local itemID, old, new
    for i=1,select("#", ...),3 do
      itemID, old, new = select(i, ...)
      --print(itemID, old, new)
      --if (old > new) then
      if (changeF) then
        if (FoodCriteria[itemID]) then
          --local _, link = GetItemInfo(itemID)
          --print("You ate:",link)
          FoodCriteria[itemID] = true
          Overachiever_CharVars_Consumed.Food[itemID] = true
        end
        if (FoodCriteria2[itemID]) then
          --local _, link = GetItemInfo(itemID)
          --print("You ate:",link)
          FoodCriteria2[itemID] = true
          Overachiever_CharVars_Consumed.Food2[itemID] = true
        end
        if (PandaEats[itemID]) then -- Unfortunately, this won't be triggered because the associated consumables don't increase the statistic properly.
          if (Overachiever_Debug) then
            local _, link = GetItemInfo(itemID)
            print("You ate:",link)
          end
          PandaEats[itemID] = true
          Overachiever_CharVars_Consumed.PandaEats[itemID] = true
        end
        if (PandaEats2[itemID]) then -- Unfortunately, this won't be triggered because the associated consumables don't increase the statistic properly.
          if (Overachiever_Debug) then
            local _, link = GetItemInfo(itemID)
            print("You ate:",link)
          end
          PandaEats2[itemID] = true
          Overachiever_CharVars_Consumed.PandaEats2[itemID] = true
        end
      end
      if (changeD) then
        if (DrinkCriteria[itemID]) then
          --local _, link = GetItemInfo(itemID)
          --print("You drank:",link)
          DrinkCriteria[itemID] = true
          Overachiever_CharVars_Consumed.Drink[itemID] = true
        end
        if (DrinkCriteria2[itemID]) then
          --local _, link = GetItemInfo(itemID)
          --print("You drank:",link)
          DrinkCriteria2[itemID] = true
          Overachiever_CharVars_Consumed.Drink2[itemID] = true
        end
        if (PandaEats[itemID]) then -- Unfortunately, this won't be triggered because the associated consumables don't increase the statistic properly.
          if (Overachiever_Debug) then
            local _, link = GetItemInfo(itemID)
            print("You drank:",link)
          end
          PandaEats[itemID] = true
          Overachiever_CharVars_Consumed.PandaEats[itemID] = true
        end
        if (PandaEats2[itemID]) then -- Unfortunately, this won't be triggered because the associated consumables don't increase the statistic properly.
          if (Overachiever_Debug) then
            local _, link = GetItemInfo(itemID)
            print("You drank:",link)
          end
          PandaEats2[itemID] = true
          Overachiever_CharVars_Consumed.PandaEats2[itemID] = true
        end
      end
      --end
    end
  end
end

TjBagWatch.RegisterFunc(BagUpdate, true)


-- Register some Blizzard sounds
----------------------------------

if (SharedMedia) then
  local soundtab = {
  ["Sound\\Doodad\\BellTollAlliance.wav"] = L.SOUND_BELL_ALLIANCE,
  ["Sound\\Doodad\\BellTollHorde.wav"] = L.SOUND_BELL_HORDE,
  ["Sound\\Doodad\\BellTollNightElf.wav"] = L.SOUND_BELL_NIGHTELF,
  ["Sound\\Doodad\\BellTollTribal.wav"] = L.SOUND_DRUMHIT,
  ["Sound\\Doodad\\BoatDockedWarning.wav"] = L.SOUND_BELL_BOATARRIVED,
  ["Sound\\Doodad\\G_GongTroll01.wav"] = L.SOUND_GONG_TROLL,
  ["Sound\\Spells\\ShaysBell.wav"] = L.SOUND_BELL_MELLOW,

  ["Sound\\Spells\\PVPEnterQueue.wav"] = L.SOUND_ENTERQUEUE,
  ["Sound\\Spells\\bind2_Impact_Base.wav"] = L.SOUND_HEARTHBIND,
  ["Sound\\Doodad\\KharazahnBellToll.wav"] = L.SOUND_BELL_KARA,

  ["Sound\\Interface\\AuctionWindowOpen.wav"] = L.SOUND_DING_AUCTION,
  ["Sound\\Interface\\AuctionWindowClose.wav"] = L.SOUND_BELL_AUCTION,
  ["Sound\\Interface\\AlarmClockWarning1.wav"] = L.SOUND_ALARM1,
  ["Sound\\Interface\\AlarmClockWarning2.wav"] = L.SOUND_ALARM2,
  ["Sound\\Interface\\AlarmClockWarning3.wav"] = L.SOUND_ALARM3,
  ["Sound\\Interface\\MapPing.wav"] = L.SOUND_MAP_PING,

  ["Sound\\Spells\\SimonGame_Visual_GameTick.wav"] = L.SOUND_SIMON_DING,
  ["Sound\\Spells\\SimonGame_Visual_LevelStart.wav"] = L.SOUND_SIMON_STARTGAME,
  ["Sound\\Spells\\SimonGame_Visual_GameStart.wav"] = L.SOUND_SIMON_STARTLEVEL,

  ["Sound\\Spells\\YarrrrImpact.wav"] = L.SOUND_YAR,
  }
  for data,name in pairs(soundtab) do
    SharedMedia:Register("sound", "Blizzard: "..name, data)
  end
  soundtab = nil
end


-- Default consumable items list
----------------------------------

Overachiever.Consumed_Default = {
	[ OVERACHIEVER_ACHID.TastesLikeChicken ] = {
		[27657] = 0,
		[6038] = 0,
		[21030] = 0,
		[44072] = 0,
		[16168] = 0,
		[20064] = 0,
		[62660] = 0,
		[4537] = 0,
		[4539] = 0,
		[4541] = 0,
		[18635] = 0,
		[22236] = 0,
		[5066] = 0,
		[1017] = 0,
		[34747] = 0,
		[20224] = 0,
		[21254] = 0,
		[27635] = 0,
		[21240] = 0,
		[34762] = 0,
		[17198] = 0,
		[27857] = 0,
		[22324] = 0,
		[17222] = 0,
		[8543] = 0,
		[12212] = 0,
		[12216] = 0,
		[24408] = 0,
		[19306] = 0,
		[33454] = 0,
		[42431] = 0,
		[9681] = 0,
		[2680] = 0,
		[24009] = 0,
		[4599] = 0,
		[4601] = 0,
		[4603] = 0,
		[4605] = 0,
		[4607] = 0,
		[34125] = 0,
		[24008] = 0,
		[6657] = 0,
		[8950] = 0,
		[59228] = 0,
		[12224] = 0,
		[2683] = 0,
		[34748] = 0,
		[34764] = 0,
		[34780] = 0,
		[43004] = 0,
		[27658] = 0,
		[21023] = 0,
		[21031] = 0,
		[24105] = 0,
		[33872] = 0,
		[5525] = 0,
		[2070] = 0,
		[21071] = 0,
		[34065] = 0,
		[33024] = 0,
		[7228] = 0,
		[13889] = 0,
		[18045] = 0,
		[34765] = 0,
		[6290] = 0,
		[35563] = 0,
		[62662] = 0,
		[34062] = 0,
		[30357] = 0,
		[23211] = 0,
		[17119] = 0,
		[13929] = 0,
		[13933] = 0,
		[33026] = 0,
		[42350] = 0,
		[27858] = 0,
		[4457] = 0,
		[59227] = 0,
		[34749] = 0,
		[42430] = 0,
		[34767] = 0,
		[11952] = 0,
		[12763] = 0,
		[43005] = 0,
		[17199] = 0,
		[8364] = 0,
		[62677] = 0,
		[42779] = 0,
		[62661] = 0,
		[35947] = 0,
		[29453] = 0,
		[33025] = 0,
		[27665] = 0,
		[19994] = 0,
		[20223] = 0,
		[3663] = 0,
		[21217] = 0,
		[23435] = 0,
		[62663] = 0,
		[34063] = 0,
		[6316] = 0,
		[37252] = 0,
		[34064] = 0,
		[13546] = 0,
		[787] = 0,
		[7807] = 0,
		[8959] = 0,
		[22238] = 0,
		[32721] = 0,
		[2687] = 0,
		[34750] = 0,
		[42942] = 0,
		[34763] = 0,
		[27651] = 0,
		[27659] = 0,
		[27667] = 0,
		[6807] = 0,
		[3664] = 0,
		[3665] = 0,
		[3666] = 0,
		[16169] = 0,
		[21072] = 0,
		[6308] = 0,
		[1326] = 0,
		[20074] = 0,
		[19060] = 0,
		[22645] = 0,
		[12209] = 0,
		[23172] = 0,
		[35565] = 0,
		[62664] = 0,
		[62680] = 0,
		[30358] = 0,
		[12213] = 0,
		[30355] = 0,
		[2679] = 0,
		[5476] = 0,
		[1114] = 0,
		[2684] = 0,
		[59231] = 0,
		[41729] = 0,
		[40356] = 0,
		[33218] = 0,
		[42432] = 0,
		[35948] = 0,
		[13888] = 0,
		[29448] = 0,
		[43518] = 0,
		[33825] = 0,
		[6362] = 0,
		[33866] = 0,
		[29393] = 0,
		[43087] = 0,
		[35949] = 0,
		[12217] = 0,
		[13754] = 0,
		[13758] = 0,
		[2682] = 0,
		[20857] = 0,
		[75028] = 0,
		[2685] = 0,
		[62649] = 0,
		[62665] = 0,
		[33043] = 0,
		[42433] = 0,
		[27661] = 0,
		[17344] = 0,
		[3220] = 0,
		[20031] = 0,
		[13810] = 0,
		[35710] = 0,
		[59232] = 0,
		[32722] = 0,
		[58275] = 0,
		[58258] = 0,
		[75029] = 0,
		[42434] = 0,
		[117] = 0,
		[27660] = 0,
		[3726] = 0,
		[21033] = 0,
		[3728] = 0,
		[3729] = 0,
		[33874] = 0,
		[43088] = 0,
		[35950] = 0,
		[33246] = 0,
		[43647] = 0,
		[33443] = 0,
		[19061] = 0,
		[27664] = 0,
		[75030] = 0,
		[34768] = 0,
		[11415] = 0,
		[62666] = 0,
		[21153] = 0,
		[30359] = 0,
		[6458] = 0,
		[35287] = 0,
		[13930] = 0,
		[13934] = 0,
		[23756] = 0,
		[34760] = 0,
		[22239] = 0,
		[67270] = 0,
		[40358] = 0,
		[34753] = 0,
		[75031] = 0,
		[1113] = 0,
		[43488] = 0,
		[29449] = 0,
		[5472] = 0,
		[11950] = 0,
		[8365] = 0,
		[5480] = 0,
		[37452] = 0,
		[5474] = 0,
		[35951] = 0,
		[5478] = 0,
		[19301] = 0,
		[67271] = 0,
		[27859] = 0,
		[75032] = 0,
		[3770] = 0,
		[3771] = 0,
		[62651] = 0,
		[62667] = 0,
		[8932] = 0,
		[3727] = 0,
		[6522] = 0,
		[34754] = 0,
		[8948] = 0,
		[8952] = 0,
		[58276] = 0,
		[45932] = 0,
		[24539] = 0,
		[67272] = 0,
		[40359] = 0,
		[58260] = 0,
		[8075] = 0,
		[42429] = 0,
		[19996] = 0,
		[5526] = 0,
		[21537] = 0,
		[38427] = 0,
		[20390] = 0,
		[1082] = 0,
		[16166] = 0,
		[16170] = 0,
		[35952] = 0,
		[33924] = 0,
		[45901] = 0,
		[67273] = 0,
		[19062] = 0,
		[2287] = 0,
		[75034] = 0,
		[12215] = 0,
		[62652] = 0,
		[62668] = 0,
		[4538] = 0,
		[4540] = 0,
		[4542] = 0,
		[4544] = 0,
		[5057] = 0,
		[414] = 0,
		[12214] = 0,
		[12218] = 0,
		[29394] = 0,
		[13760] = 0,
		[13756] = 0,
		[34755] = 0,
		[75035] = 0,
		[36831] = 0,
		[43490] = 0,
		[42995] = 0,
		[23326] = 0,
		[44049] = 0,
		[961] = 0,
		[28486] = 0,
		[4602] = 0,
		[12210] = 0,
		[35953] = 0,
		[5095] = 0,
		[13755] = 0,
		[13759] = 0,
		[22895] = 0,
		[4592] = 0,
		[75036] = 0,
		[43015] = 0,
		[62653] = 0,
		[62669] = 0,
		[20388] = 0,
		[4604] = 0,
		[4606] = 0,
		[4608] = 0,
		[24540] = 0,
		[43523] = 0,
		[6361] = 0,
		[65499] = 0,
		[20452] = 0,
		[29452] = 0,
		[34759] = 0,
		[34756] = 0,
		[58278] = 0,
		[30458] = 0,
		[43491] = 0,
		[42996] = 0,
		[20516] = 0,
		[20222] = 0,
		[58265] = 0,
		[43571] = 0,
		[16971] = 0,
		[21236] = 0,
		[40202] = 0,
		[33048] = 0,
		[39691] = 0,
		[13931] = 0,
		[30816] = 0,
		[4656] = 0,
		[37583] = 0,
		[23175] = 0,
		[62654] = 0,
		[62670] = 0,
		[43268] = 0,
		[30361] = 0,
		[13935] = 0,
		[13927] = 0,
		[18632] = 0,
		[422] = 0,
		[42342] = 0,
		[27854] = 0,
		[12238] = 0,
		[58263] = 0,
		[21235] = 0,
		[34757] = 0,
		[58279] = 0,
		[42994] = 0,
		[43492] = 0,
		[42997] = 0,
		[23327] = 0,
		[34751] = 0,
		[38428] = 0,
		[43572] = 0,
		[11951] = 0,
		[11444] = 0,
		[2681] = 0,
		[6888] = 0,
		[28501] = 0,
		[24421] = 0,
		[23160] = 0,
		[8953] = 0,
		[37584] = 0,
		[6317] = 0,
		[62655] = 0,
		[62671] = 0,
		[20389] = 0,
		[2888] = 0,
		[33449] = 0,
		[58264] = 0,
		[32685] = 0,
		[7806] = 0,
		[7808] = 0,
		[35285] = 0,
		[724] = 0,
		[42998] = 0,
		[20557] = 0,
		[34758] = 0,
		[58280] = 0,
		[6289] = 0,
		[27655] = 0,
		[27663] = 0,
		[6303] = 0,
		[33254] = 0,
		[6299] = 0,
		[1707] = 0,
		[16167] = 0,
		[16171] = 0,
		[6291] = 0,
		[20062] = 0,
		[11584] = 0,
		[3927] = 0,
		[8957] = 0,
		[29292] = 0,
		[37585] = 0,
		[23495] = 0,
		[62656] = 0,
		[24338] = 0,
		[62676] = 0,
		[11109] = 0,
		[29451] = 0,
		[19223] = 0,
		[18633] = 0,
		[68687] = 0,
		[41751] = 0,
		[27855] = 0,
		[4594] = 0,
		[18255] = 0,
		[29412] = 0,
		[33226] = 0,
		[733] = 0,
		[43478] = 0,
		[19224] = 0,
		[42999] = 0,
		[13724] = 0,
		[65515] = 0,
		[13851] = 0,
		[27662] = 0,
		[58262] = 0,
		[12211] = 0,
		[5349] = 0,
		[37582] = 0,
		[19304] = 0,
		[3448] = 0,
		[6890] = 0,
		[29450] = 0,
		[58277] = 0,
		[58261] = 0,
		[62657] = 0,
		[7097] = 0,
		[30610] = 0,
		[4536] = 0,
		[58259] = 0,
		[58267] = 0,
		[32686] = 0,
		[31672] = 0,
		[22237] = 0,
		[30155] = 0,
		[17408] = 0,
		[20225] = 0,
		[27636] = 0,
		[58266] = 0,
		[22019] = 0,
		[34752] = 0,
		[27656] = 0,
		[43000] = 0,
		[65500] = 0,
		[65516] = 0,
		[17407] = 0,
		[8243] = 0,
		[21552] = 0,
		[14894] = 0,
		[4593] = 0,
		[20063] = 0,
		[34770] = 0,
		[33451] = 0,
		[1487] = 0,
		[29293] = 0,
		[75033] = 0,
		[33004] = 0,
		[62658] = 0,
		[34769] = 0,
		[33052] = 0,
		[58269] = 0,
		[18254] = 0,
		[13928] = 0,
		[13932] = 0,
		[42993] = 0,
		[6887] = 0,
		[27856] = 0,
		[5527] = 0,
		[19696] = 0,
		[20226] = 0,
		[34761] = 0,
		[19995] = 0,
		[43480] = 0,
		[19225] = 0,
		[43001] = 0,
		[17197] = 0,
		[65517] = 0,
		[44071] = 0,
		[33867] = 0,
		[5473] = 0,
		[34410] = 0,
		[5477] = 0,
		[5479] = 0,
		[19305] = 0,
		[33452] = 0,
		[16766] = 0,
		[21215] = 0,
		[17406] = 0,
		[20227] = 0,
		[62659] = 0,
		[27666] = 0,
		[33053] = 0,
		[42778] = 0,
		[38706] = 0,
		[13893] = 0,
		[73260] = 0,
		[31673] = 0,
		[75027] = 0,
		[28112] = 0,
		[74921] = 0,
		[42428] = 0,
		[3662] = 0,
		[58268] = 0,
		[8076] = 0,
		[24072] = 0,
		[34766] = 0,
	},
	[ OVERACHIEVER_ACHID.HappyHour ] = {
		[33030] = 0,
		[37899] = 0,
		[37907] = 0,
		[32668] = 0,
		[23492] = 0,
		[24006] = 0,
		[46402] = 0,
		[17404] = 0,
		[37493] = 0,
		[21241] = 0,
		[22779] = 0,
		[22018] = 0,
		[19221] = 0,
		[30457] = 0,
		[34019] = 0,
		[23584] = 0,
		[8766] = 0,
		[33031] = 0,
		[34832] = 0,
		[37900] = 0,
		[37908] = 0,
		[2593] = 0,
		[42777] = 0,
		[44570] = 0,
		[2595] = 0,
		[2723] = 0,
		[2596] = 0,
		[44618] = 0,
		[40036] = 0,
		[37494] = 0,
		[61982] = 0,
		[21114] = 0,
		[33956] = 0,
		[34020] = 0,
		[1179] = 0,
		[33032] = 0,
		[27553] = 0,
		[15723] = 0,
		[37909] = 0,
		[38698] = 0,
		[24007] = 0,
		[23246] = 0,
		[4952] = 0,
		[4953] = 0,
		[1119] = 0,
		[34411] = 0,
		[44619] = 0,
		[27860] = 0,
		[37495] = 0,
		[61983] = 0,
		[38300] = 0,
		[19222] = 0,
		[43695] = 0,
		[17198] = 0,
		[34021] = 0,
		[23585] = 0,
		[29454] = 0,
		[33033] = 0,
		[37902] = 0,
		[3772] = 0,
		[29482] = 0,
		[33445] = 0,
		[29401] = 0,
		[38430] = 0,
		[18269] = 0,
		[34412] = 0,
		[44620] = 0,
		[37488] = 0,
		[37496] = 0,
		[61984] = 0,
		[37901] = 0,
		[37489] = 0,
		[13813] = 0,
		[42381] = 0,
		[9360] = 0,
		[40357] = 0,
		[23704] = 0,
		[40042] = 0,
		[43696] = 0,
		[1322] = 0,
		[34022] = 0,
		[23161] = 0,
		[21721] = 0,
		[29395] = 0,
		[33034] = 0,
		[2894] = 0,
		[159] = 0,
		[37903] = 0,
		[5265] = 0,
		[38429] = 0,
		[38294] = 0,
		[37492] = 0,
		[44573] = 0,
		[29112] = 0,
		[1262] = 0,
		[8077] = 0,
		[8078] = 0,
		[8079] = 0,
		[17402] = 0,
		[2136] = 0,
		[32455] = 0,
		[35720] = 0,
		[36748] = 0,
		[32722] = 0,
		[31451] = 0,
		[11846] = 0,
		[62790] = 0,
		[44616] = 0,
		[37904] = 0,
		[33234] = 0,
		[1645] = 0,
		[17199] = 0,
		[9260] = 0,
		[58256] = 0,
		[23586] = 0,
		[62675] = 0,
		[33035] = 0,
		[19318] = 0,
		[38350] = 0,
		[46319] = 0,
		[30499] = 0,
		[1205] = 0,
		[44716] = 0,
		[44574] = 0,
		[4791] = 0,
		[41731] = 0,
		[19299] = 0,
		[4595] = 0,
		[18287] = 0,
		[46399] = 0,
		[38466] = 0,
		[37490] = 0,
		[10841] = 0,
		[61986] = 0,
		[23176] = 0,
		[58274] = 0,
		[23164] = 0,
		[17048] = 0,
		[44941] = 0,
		[59229] = 0,
		[33236] = 0,
		[28284] = 0,
		[30858] = 0,
		[19997] = 0,
		[32667] = 0,
		[58257] = 0,
		[44575] = 0,
		[33028] = 0,
		[33036] = 0,
		[3703] = 0,
		[30615] = 0,
		[37905] = 0,
		[39738] = 0,
		[38431] = 0,
		[59230] = 0,
		[62672] = 0,
		[32424] = 0,
		[9361] = 0,
		[23848] = 0,
		[37497] = 0,
		[21151] = 0,
		[46400] = 0,
		[17403] = 0,
		[37491] = 0,
		[33929] = 0,
		[5342] = 0,
		[20709] = 0,
		[22778] = 0,
		[37499] = 0,
		[74822] = 0,
		[62674] = 0,
		[38320] = 0,
		[30703] = 0,
		[5350] = 0,
		[17196] = 0,
		[34017] = 0,
		[2288] = 0,
		[28399] = 0,
		[1708] = 0,
		[2686] = 0,
		[33029] = 0,
		[37498] = 0,
		[37898] = 0,
		[37906] = 0,
		[59029] = 0,
		[38432] = 0,
		[39520] = 0,
		[33042] = 0,
		[4600] = 0,
		[43086] = 0,
		[19300] = 0,
		[18284] = 0,
		[18288] = 0,
		[46401] = 0,
		[35954] = 0,
		[18300] = 0,
		[2594] = 0,
		[37253] = 0,
		[44571] = 0,
		[33444] = 0,
		[32453] = 0,
		[30309] = 0,
		[9451] = 0,
		[12003] = 0,
		[7676] = 0,
		[44617] = 0,
		[46403] = 0,
		[34018] = 0,
		[40035] = 0,
		[61985] = 0,
	}
}

