
--
--  Overachiever - Tabs: Suggestions.lua
--    by Tuhljin
--
--  If you don't wish to use the suggestions tab, feel free to delete this file or rename it (e.g. to
--  Suggestions_unused.lua). The addon's other features will work regardless.
--

local L = OVERACHIEVER_STRINGS
local GetAchievementInfo = Overachiever.GetAchievementInfo
local GetAchievementCriteriaInfo = Overachiever.GetAchievementCriteriaInfo

local LBZ = LibStub("LibBabble-SubZone-3.0"):GetUnstrictLookupTable()
local LBZR = LibStub("LibBabble-SubZone-3.0"):GetReverseLookupTable()
local LBI = LibStub:GetLibrary("LibBabble-Inventory-3.0"):GetLookupTable()
local LBIR = LibStub:GetLibrary("LibBabble-Inventory-3.0"):GetReverseLookupTable()

local RecentReminders = Overachiever.RecentReminders

local IsAlliance = UnitFactionGroup("player") == "Alliance"
local suggested = {}



-- ZONE-SPECIFIC ACHIEVEMENTS
----------------------------------------------------

local ACHID_ZONE_NUMQUESTS
if (IsAlliance) then
  ACHID_ZONE_NUMQUESTS = {
  -- Kalimdor
	["Ashenvale"] = 4925,
	--["Azshara"] = nil,
	["Darkshore"] = 4928,
	["Desolace"] = 4930, -- faction neutral?
	--["Durotar"] = nil,
	["Dustwallow Marsh"] = 4929,
	["Felwood"] = 4931, -- faction neutral
	["Feralas"] = 4932,
	--["Moonglade"] = nil,
	--["Mulgore"] = nil,
	--["Northern Barrens"] = nil,
	["Silithus"] = 4934, -- faction neutral
	["Southern Barrens"] = 4937,
	["Stonetalon Mountains"] = 4936,
	["Tanaris"] = 4935, -- faction neutral
	--["Teldrassil"] = nil,
	["Thousand Needles"] = 4938, -- faction neutral
	["Un'Goro Crater"] = 4939, -- faction neutral
	["Winterspring"] = 4940, -- faction neutral
    -- Burning Crusade:
	--["Azuremyst Isle"] = nil,
	["Bloodmyst Isle"] = 4926,
    -- Cataclysm:
	["Mount Hyjal"] = 4870,
	["Uldum"] = 4872,
  -- Eastern Kingdoms
	["Arathi Highlands"] = 4896, -- faction neutral
	["Badlands"] = 4900, -- faction neutral
	["Blasted Lands"] = 4909, -- faction neutral
	["Burning Steppes"] = 4901, -- faction neutral
	["The Cape of Stranglethorn"] = 4905,
	--["Deadwind Pass"] = nil,
	--["Dun Morogh"] = nil,
	["Duskwood"] = 4903,
	["Eastern Plaguelands"] = 4892, -- faction neutral
	--["Elwynn Forest"] = nil,
	--["Hillsbrad Foothills"] = nil,
	["The Hinterlands"] = 4897, -- faction neutral
	["Loch Modan"] = 4899,
	["Northern Stranglethorn"] = 4906,
	["Redridge Mountains"] = 4902,
	["Searing Gorge"] = 4910, -- faction neutral
	--["Silverpine Forest"] = nil,
	["Swamp of Sorrows"] = 4904, -- faction neutral
	--["Tirisfal Glades"] = nil,
	["Western Plaguelands"] = 4893, -- faction neutral
	["Westfall"] = 4903,
	["Wetlands"] = 4899,
     -- Burning Crusade:
	--["Eversong Woods"] = nil,
	--["Ghostlands"] = nil,
	--["Isle of Quel'Danas"] = nil,
     -- Cataclysm:
	["Twilight Highlands"] = 4873,
	-- Vashj'ir:
	["Vashj'ir"] = 4869,
	["Kelp'thar Forest"] = 4869,
	["Shimmering Expanse"] = 4869,
	["Abyssal Depths"] = 4869,
  -- Outland
	["Blade's Edge Mountains"] = 1193,
	["Zangarmarsh"] = 1190,
	["Netherstorm"] = 1194,
	["Hellfire Peninsula"] = 1189,
	["Terokkar Forest"] = 1191,
	["Shadowmoon Valley"] = 1195,
	["Nagrand"] = 1192,
  -- Northrend
	["Icecrown"] = 40,
	["Dragonblight"] = 35,
	["Howling Fjord"] = 34,
	["Borean Tundra"] = 33,
	["Sholazar Basin"] = 39,
	["Zul'Drak"] = 36,
	["Grizzly Hills"] = 37,
	["The Storm Peaks"] = 38,
  -- Other (Cataclysm)
	["Deepholm"] = 4871, -- faction neutral
  }
else
  ACHID_ZONE_NUMQUESTS = {
  -- Kalimdor
	["Ashenvale"] = 4976,
	["Azshara"] = 4927,
	--["Darkshore"] = nil,
	["Desolace"] = 4930, -- faction neutral?
	--["Durotar"] = nil,
	["Dustwallow Marsh"] = 4978,
	["Felwood"] = 4931, -- faction neutral
	["Feralas"] = 4979,
	--["Moonglade"] = nil,
	--["Mulgore"] = nil,
	["Northern Barrens"] = 4933,
	["Silithus"] = 4934, -- faction neutral
	["Southern Barrens"] = 4981,
	["Stonetalon Mountains"] = 4980,
	["Tanaris"] = 4935, -- faction neutral
	--["Teldrassil"] = nil,
	["Thousand Needles"] = 4938, -- faction neutral
	["Un'Goro Crater"] = 4939, -- faction neutral
	["Winterspring"] = 4940, -- faction neutral
    -- Burning Crusade:
	--["Azuremyst Isle"] = nil,
	--["Bloodmyst Isle"] = nil,
    -- Cataclysm:
	["Mount Hyjal"] = 4870,
	["Uldum"] = 4872,
  -- Eastern Kingdoms
	["Arathi Highlands"] = 4896, -- faction neutral
	["Badlands"] = 4900, -- faction neutral
	["Blasted Lands"] = 4909, -- faction neutral
	["Burning Steppes"] = 4901, -- faction neutral
	["The Cape of Stranglethorn"] = 4905,
	--["Deadwind Pass"] = nil,
	--["Dun Morogh"] = nil,
	--["Duskwood"] = nil,
	["Eastern Plaguelands"] = 4892, -- faction neutral
	--["Elwynn Forest"] = nil,
	["Hillsbrad Foothills"] = 4895,
	["The Hinterlands"] = 4897, -- faction neutral
	--["Loch Modan"] = nil,
	["Northern Stranglethorn"] = 4906,
	--["Redridge Mountains"] = nil,
	["Searing Gorge"] = 4910, -- faction neutral
	["Silverpine Forest"] = 4894,
	["Swamp of Sorrows"] = 4904, -- faction neutral
	--["Tirisfal Glades"] = nil,
	["Western Plaguelands"] = 4893, -- faction neutral
	--["Westfall"] = nil,
	--["Wetlands"] = nil,
     -- Burning Crusade:
	--["Eversong Woods"] = nil,
	["Ghostlands"] = 4908,
	--["Isle of Quel'Danas"] = nil,
     -- Cataclysm:
	["Twilight Highlands"] = 5501,
	-- Vashj'ir:
	["Vashj'ir"] = 4982,
	["Kelp'thar Forest"] = 4982,
	["Shimmering Expanse"] = 4982,
	["Abyssal Depths"] = 4982,
  -- Outland
	["Blade's Edge Mountains"] = 1193,
	["Zangarmarsh"] = 1190,
	["Netherstorm"] = 1194,
	["Hellfire Peninsula"] = 1271,
	["Terokkar Forest"] = 1272,
	["Shadowmoon Valley"] = 1195,
	["Nagrand"] = 1273,
  -- Northrend
	["Icecrown"] = 40,
	["Dragonblight"] = 1359,
	["Howling Fjord"] = 1356,
	["Borean Tundra"] = 1358,
	["Sholazar Basin"] = 39,
	["Zul'Drak"] = 36,
	["Grizzly Hills"] = 1357,
	["The Storm Peaks"] = 38,
  -- Other (Cataclysm)
	["Deepholm"] = 4871, -- faction neutral
  }
end

local ACHID_ZONE_MISC = {
-- Kalimdor
	["Ashenvale"] = "4827:6",	-- "Surveying the Damage"
	["Azshara"] = { 5448, 5546, 5547 },	-- "Glutton for Fiery/Icy/Shadowy Punishment"
	["Darkshore"] = { "4827:4" },	-- "Surveying the Damage"
	["Desolace"] = "4827:8",	-- "Surveying the Damage"
	["Durotar"] = "4827:7",		-- "Surveying the Damage"
	["Molten Front"] = { 5859, 5866, 5867,	-- "Legacy of Leyara", "The Molten Front Offensive", "Flawless Victory", "Fireside Chat", "Master of the Molten Flow",
		5870, 5871, 5872, 5873, 5874, 5879 }, -- "King of the Spider-Hill", "Ready for Raiding II", "Death From Above", "Veteran of the Molten Front"
	["Mount Hyjal"] = { 4959, 5483,		-- "Beware of the 'Unbeatable?' Pterodactyl", "Bounce",
		5859, 5860, 5861, 5862, 5864,	-- "Legacy of Leyara", "The 'Unbeatable?' Pterodactyl: BEATEN.", "The Fiery Lords of Sethria's Roost", "Ludicrous Speed", "Gang War",
		5865, 5868, 5869 },		-- "Have... Have We Met?", "And the Meek Shall Inherit Kalimdor", "Infernal Ambassadors"
	["Southern Barrens"] = "4827:1",	-- "Surveying the Damage"
	["Tanaris"] = "4827:5",		-- "Surveying the Damage"
	["Thousand Needles"] = "4827:9",	-- "Surveying the Damage"
	["Uldum"] =			-- "Help the Bombardier! I'm the Bombardier!", "One Hump or Two?",
		{ 5317, 4888, 4961 },	-- "In a Thousand Years Even You Might be Worth Something"
	["Winterspring"] = 5443,	-- "E'ko Madness"
-- Eastern Kingdoms
	["The Cape of Stranglethorn"] =	-- "Master Angler of Azeroth",
		{ 306, 389, 396,	-- "Gurubashi Arena Master", "Gurubashi Arena Grand Master",
		  "4827:2" },		-- "Surveying the Damage"
	["Northern Stranglethorn"] =	-- Need to confirm where these two achievements belong since Cataclysm:
		{ 306, 940 },	-- "Master Angler of Azeroth", "The Green Hills of Stranglethorn"
	["Badlands"] = "4827:3",	-- "Surveying the Damage"
	["Eastern Plaguelands"] = 5442,	-- "Full Caravan"
	--Peacebloom vs. Ghouls achievements unavailable at this time:
	--["Hillsbrad Foothills"] = { 5364, 5365,	-- "Don't Want No Zombies on My Lawn", "Bloom and Doom",
	--			    "4827:13" },	-- "Surveying the Damage"
	["Hillsbrad Foothills"] = "4827:13",	-- "Surveying the Damage"
	["Loch Modan"] = "4827:12",		-- "Surveying the Damage"
	["Silverpine Forest"] = "4827:10",	-- "Surveying the Damage"
	["Tol Barad"] = { 4874, IsAlliance and 5489 or 5490,	-- "Breaking out of Tol Barad", "Master of Tol Barad"
			  IsAlliance and 5718 or 5719 },	-- "Just Another Day in Tol Barad"
	["Tol Barad Peninsula"] = IsAlliance and 5718 or 5719,	-- "Just Another Day in Tol Barad"
	["Twilight Highlands"] = { 5451, 4960,	-- "Consumed by Nightmare", "Round Three. Fight!",
				   "4958:3" },	-- "The First Rule of Ring of Blood is You Don't Talk About Ring of Blood"
	["Westfall"] = "4827:11",	-- "Surveying the Damage"
	-- Vashj'ir:
	["Vashj'ir"] = { 4975, 5452,		-- "From Hell's Heart I Stab at Thee", "Visions of Vashj'ir Past"
			 IsAlliance and 5318 or 5319 },	-- "20,000 Leagues Under the Sea"
	["Kelp'thar Forest"] = { 4975, 5452,	-- "From Hell's Heart I Stab at Thee", "Visions of Vashj'ir Past"
			 IsAlliance and 5318 or 5319 },	-- "20,000 Leagues Under the Sea"
	["Shimmering Expanse"] = { 4975, 5452,	-- "From Hell's Heart I Stab at Thee", "Visions of Vashj'ir Past"
			 IsAlliance and 5318 or 5319 },	-- "20,000 Leagues Under the Sea"
	["Abyssal Depths"] = { 4975, 5452,	-- "From Hell's Heart I Stab at Thee", "Visions of Vashj'ir Past"
			 IsAlliance and 5318 or 5319 },	-- "20,000 Leagues Under the Sea"
-- Outland
	["Blade's Edge Mountains"] = 1276,	-- "Blade's Edge Bomberman"
	["Nagrand"] = { 939, "1576:1" },	-- "Hills Like White Elekk", "Of Blood and Anguish"
	["Netherstorm"] = 545,		-- "Shave and a Haircut"
	["Shattrath City"] =	-- "My Sack is "Gigantique"", "Old Man Barlowned", "Kickin' It Up a Notch",
		{ 1165, 905, 906, 903,  },	-- "Shattrath Divided"
	["Terokkar Forest"] = { 905, 1275 },	-- "Old Man Barlowned", "Bombs Away"
	["Zangarmarsh"] = 893,		-- "Cenarion War Hippogryph"
-- Northrend
	["Borean Tundra"] = 561,	-- "D.E.H.T.A's Little P.I.T.A."
	["Dragonblight"] = { 1277, 547 },	-- "Rapid Defense", "Veteran of the Wrathgate"
	["Dalaran"] = { 2096, 1956, 1958, 545, 1998, IsAlliance and 1782 or 1783, 3217 },
	["Grizzly Hills"] = { "1596:1" },	-- "Guru of Drakuru"
	["Icecrown"] = { SUBZONES = {
		["*Argent Tournament Grounds*The Ring of Champions*Argent Pavilion*The Argent Valiants' Ring*The Aspirants' Ring*The Alliance Valiants' Ring*Silver Covenant Pavilion*Sunreaver Pavilion*The Horde Valiants' Ring*"] =
			{ 2756, 2772, 2836, 2773, 3736 },
		-- "Argent Aspiration", "Tilted!", "Lance a Lot", "It's Just a Flesh Wound", "Pony Up!"
	} },
	["The Storm Peaks"] = 1428,	-- "Mine Sweeper"
	["Sholazar Basin"] =		-- "The Snows of Northrend", "Honorary Frenzyheart",
		{ 938, 961, 962, 952 },	-- "Savior of the Oracles", "Mercenary of Sholazar"
	["Zul'Drak"] = { "1576:2", "1596:2" },	-- "Of Blood and Anguish", "Guru of Drakuru"
	["Wintergrasp"] = { 1752, 2199, 1717, 1751, 1755, 1727, 1723 },
-- Darkmoon Faire
	["Darkmoon Island"] = { 6020, 6021, 6022, 6023, 6026, 6027, 6028, 6029, IsAlliance and 6030 or 6031, 6032, 6025,
		9250, 6019, 6332 },
	["Darkmoon Faire"] = { 6020, 6021, 6022, 6023, 6026, 6027, 6028, 6029, IsAlliance and 6030 or 6031, 6032, 6025,
		9250, 6019, 6332 },
	-- !! not 100% certain which is needed; may be both; test when the faire's available
-- Other Cataclysm-related
	["Deepholm"] = { 5445, 5446, 5447, 5449 },	-- "Fungalophobia", "The Glop Family Line",
							-- "My Very Own Broodmother", "Rock Lover"
-- Pandaria
	["The Jade Forest"] = {
		IsAlliance and 6300 or 6534, -- Upjade Complete
		6550, -- Order of the Cloud Serpent
		7289, -- Shadow Hopper
		7290, -- How To Strain Your Dragon
		7291, -- In a Trail of Smoke
		7381, -- Restore Balance
	},
	["Krasarang Wilds"] = {
		IsAlliance and 6535 or 6536, -- Mighty Roamin' Krasaranger
		6547, -- The Anglers
		7518, -- Wanderers, Dreamers, and You
	},
	["Kun-Lai Summit"] = {
		6480, -- Settle Down, Bro
		IsAlliance and 6537 or 6538, -- Slum It in the Summit
		7386, -- Grand Expedition Yak
	},
	["Valley of the Four Winds"] = {
		6301, -- Rally the Valley
		6544, -- The Tillers
		6551, -- Friend on the Farm
		7292, -- Green Acres
		7293, -- Till the Break of Dawn
		7294, -- A Taste of Things to Come
		7295, -- Listen to the Drunk Fish
		7325, -- Now I'm the Master
		7502, -- Savior of Stoneplow
		6517, -- Extinction Event
	},
	["Townlong Steppes"] = {
		6539, -- One Steppe Foward, Two Steppes Back
		7299, -- Loner and a Rebel
	},
	["Dread Wastes"] = {
		6540, -- Dread Haste Makes Dread Waste
		6545, -- Klaxxi
		7312, -- Amber is the Color of My Energy
		7313, -- Stay Klaxxi
		7314, -- Test Drive
	},
	["Vale of Eternal Blossoms"] = {
		6546, -- The Golden Lotus
		7317, -- One Many Army
		7318, -- A Taste of History
		--7315 "Eternally in the Vale" is now a Feat of Strength
	},
	["Isle of Thunder"] = 8121, -- "Stormbreaker"
	["Timeless Isle"] = {
		8715, 8726, 8725, 8728, 8712, 8723, 8533, 8724, 8730, 8717
	},
-- Draenor
	["Ashran"] = {
		9102, -- Ashran Victory
		IsAlliance and 9104 or 9103, -- Bounty Hunter
		9105, -- Tour of Duty
		9106, -- Just for Me
		9216, -- High-value Targets
		IsAlliance and 9408 or 9217, -- Operation Counterattack
		IsAlliance and 9225 or 9224, -- Take Them Out
		9218, -- Grand Theft, 1st Degree
		9222, -- Divide and Conquer
		9223, -- Weed Whacker
		IsAlliance and 9256 or 9257, -- Rescue Operation
		IsAlliance and 9214 or 9215, -- Hero of Stormshield / Hero of Warspear
		IsAlliance and 9714 or 9715, -- Thy Kingdom Come
	},
	["Gorgrond"] = {
		IsAlliance and 8923 or 8924,
		9607,
	},
	["Talador"] = {
		IsAlliance and 8920 or 8919,
		9674,
	},
	["Spires of Arak"] = {
		IsAlliance and 8925 or 8926,
		9605,
	},
	--["Nagrand"] = { -- section handled below temporarily
	--	IsAlliance and 8927 or 8928,
	--	9615,
	--},
	["Tanaan Jungle"] = {
		10261, -- Jungle Treasure Hunter
		10259, -- Jungle Hunter
		10069, -- I Came, I Clawed, I Conquered
		10061, -- Hellbane
		IsAlliance and 10067 or 10074, -- In Pursuit of Gul'dan
		IsAlliance and 10068 or 10075, -- Draenor's Last Stand
		10071, -- The Legion Will NOT Conquer All
		IsAlliance and 10072 or 10265, -- Rumble in the Jungle (complete the above, and any in same series as one of the above, and the explore achievement)
		10052, -- Tiny Terrors in Tanaan
	},
}
if (IsAlliance) then
  tinsert(ACHID_ZONE_MISC["Grizzly Hills"], 2016) -- "Grizzled Veteran"
  tinsert(ACHID_ZONE_MISC["Wintergrasp"], 1737) -- "Destruction Derby"
  --Currently a Feat of Strength but this may be a bug as I've seen reports that you can still get one. Then
  --again, maybe since it was much more difficult to get one previously, a FoS is meant to recognize that:
  --tinsert(ACHID_ZONE_MISC["Winterspring"], 3356) -- "Winterspring Frostsaber"
  tinsert(ACHID_ZONE_MISC["Twilight Highlands"], 5320) -- "King of the Mountain"
  tinsert(ACHID_ZONE_MISC["Twilight Highlands"], 5481) -- "Wildhammer Tour of Duty"
  tinsert(ACHID_ZONE_MISC["Darkshore"], 5453) -- "Ghosts in the Dark"
  -- As applicable, "City Defender", "Shave and a Haircut", "Fish or Cut Bait: <City>", "Let's Do Lunch: <City>":
  ACHID_ZONE_MISC["Stormwind City"] = { 388, 545, 5476, 5474 }
  ACHID_ZONE_MISC["Ironforge"] = { 388, 545, 5847, 5841 }
  ACHID_ZONE_MISC["Darnassus"] = { 388, 5848, 5842 }
  ACHID_ZONE_MISC["The Exodar"] = { 388 }
  -- "Wrath of the Alliance", faction leader kill, "For The Alliance!":
  ACHID_ZONE_MISC["Orgrimmar"] = { 604, 610, 614 }
  ACHID_ZONE_MISC["Thunder Bluff"] = { 604, 611, 614 }
  ACHID_ZONE_MISC["Undercity"] = { 604, 612, 614 }
  ACHID_ZONE_MISC["Silvermoon City"] = { 604, 613, 614 }
  -- "A Silver Confidant", "Champion of the Alliance":
  tinsert(ACHID_ZONE_MISC["Icecrown"], 3676)
  tinsert(ACHID_ZONE_MISC["Icecrown"], 2782)
  -- "Down Goes Van Rook" (currently no Horde equivalent?)
  tinsert(ACHID_ZONE_MISC["Ashran"], 9228)

  ACHID_ZONE_MISC["Shadowmoon Valley"] = {
	8845,
	9602,
  }

else
  tinsert(ACHID_ZONE_MISC["Azshara"], 5454) -- "Joy Ride"
  tinsert(ACHID_ZONE_MISC["Grizzly Hills"], 2017) -- "Grizzled Veteran"
  tinsert(ACHID_ZONE_MISC["Wintergrasp"], 2476)	-- "Destruction Derby"
  tinsert(ACHID_ZONE_MISC["Twilight Highlands"], 5482) -- "Dragonmaw Tour of Duty"
  tinsert(ACHID_ZONE_MISC["Twilight Highlands"], 5321) -- "King of the Mountain"
  -- As applicable, "City Defender", "Shave and a Haircut", "Fish or Cut Bait: <City>", "Let's Do Lunch: <City>":
  ACHID_ZONE_MISC["Orgrimmar"] = { 1006, 545, 5477, 5475 }
  ACHID_ZONE_MISC["Thunder Bluff"] = { 1006, 5849, 5843 }
  ACHID_ZONE_MISC["Undercity"] = { 1006, 545, 5850, 5844 }
  ACHID_ZONE_MISC["Silvermoon City"] = { 1006 }
  -- "Wrath of the Horde", faction leader kill, "For The Horde!":
  ACHID_ZONE_MISC["Stormwind City"] = { 603, 615, 619 }
  ACHID_ZONE_MISC["Ironforge"] = { 603, 616, 619 }
  ACHID_ZONE_MISC["Darnassus"] = { 603, 617, 619 }
  ACHID_ZONE_MISC["The Exodar"] = { 603, 618, 619 }
  -- "The Sunreavers", "Champion of the Horde":
  tinsert(ACHID_ZONE_MISC["Icecrown"], 3677)
  tinsert(ACHID_ZONE_MISC["Icecrown"], 2788)
  
  ACHID_ZONE_MISC["Frostfire Ridge"] = {
	8671,
	9606,
  }

end
-- "The Fishing Diplomat":
tinsert(ACHID_ZONE_MISC["Stormwind City"], "150:2")
tinsert(ACHID_ZONE_MISC["Orgrimmar"], "150:1")
-- "Old Crafty" and "Old Ironjaw":
tinsert(ACHID_ZONE_MISC["Orgrimmar"], 1836)
tinsert(ACHID_ZONE_MISC["Ironforge"], 1837)
-- "Big City Pet Brawlin' - Alliance":
tinsert(ACHID_ZONE_MISC["Stormwind City"], "6584:1")
tinsert(ACHID_ZONE_MISC["Ironforge"], "6584:2")
tinsert(ACHID_ZONE_MISC["Darnassus"], "6584:3")
tinsert(ACHID_ZONE_MISC["The Exodar"], "6584:4")
-- "Big City Pet Brawlin' - Horde":
tinsert(ACHID_ZONE_MISC["Orgrimmar"], "6621:1")
tinsert(ACHID_ZONE_MISC["Thunder Bluff"], "6621:2")
tinsert(ACHID_ZONE_MISC["Undercity"], "6621:3")
tinsert(ACHID_ZONE_MISC["Silvermoon City"], "6621:4")

-- Problem: Two zones named Nagrand. A change to the system is needed. For now, just put the new zone's in with the rest.
tinsert(ACHID_ZONE_MISC["Nagrand"], IsAlliance and 8927 or 8928)
tinsert(ACHID_ZONE_MISC["Nagrand"], 9615)

-- INSTANCES - ANY DIFFICULTY (any group size):
local ACHID_INSTANCES = {
-- Classic Dungeons
	["Ragefire Chasm"] = 629,
	["Wailing Caverns"] = 630,
	["Blackfathom Deeps"] = 632,
	["The Stockade"] = 633,		-- "Stormwind Stockade"
	["Gnomeregan"] = 634,
	["Razorfen Kraul"] = 635,
	["Razorfen Downs"] = 636,
	["Uldaman"] = 638,
	["Zul'Farrak"] = 639,
	["Maraudon"] = 640,
	["Sunken Temple"] = 641,
	["Blackrock Depths"] = 642,
	["Lower Blackrock Spire"] = 643,
	["Upper Blackrock Spire"] = { 1307, 2188 },	-- "Upper Blackrock Spire", "Leeeeeeeeeeeeeroy!"
	["Dire Maul"] = 644,
	["Stratholme"] = 646,
-- Classic Raids
	-- These are now Feats of Strength: ["Zul'Gurub"] = { 688, 560, 957 },	-- "Zul'Gurub", "Deadliest Catch", "Hero of the Zandalar"
	["Ruins of Ahn'Qiraj"] = 689,
	--["Onyxia's Lair"] = 684, -- This is now a Feat of Strength
	["Molten Core"] = 686,
	["Blackwing Lair"] = 685,
	["Temple of Ahn'Qiraj"] = 687,
-- Burning Crusade
	["Auchenai Crypts"] = 666,
	["The Mechanar"] = 658,
	-- This is now a Feat of Strength: ["Zul'Aman"] = 691,
	["The Blood Furnace"] = 648,
	["Hellfire Ramparts"] = 647,
	["Mana-Tombs"] = 651,
	["The Botanica"] = 659,
	["Shadow Labyrinth"] = 654,
	["Sunwell Plateau"] = 698,
	["Black Temple"] = 697,			-- "The Black Temple"
	["Hyjal Summit"] = 695,			-- "The Battle for Mount Hyjal"
	["Tempest Keep"] = 696,
	["Sethekk Halls"] = 653,
	["Old Hillsbrad Foothills"] = 652,	-- "The Escape From Durnholde"
	["The Black Morass"] = 655,		-- "Opening of the Dark Portal"
	["Magtheridon's Lair"] = 693,
	["Gruul's Lair"] = 692,
	["Karazhan"] = 690,
	["The Steamvault"] = 656,
	["Serpentshrine Cavern"] = { 694, 144 },	-- "Serpentshrine Cavern", "The Lurker Above"
	["The Shattered Halls"] = 657,
	["The Slave Pens"] = 649,
	["The Underbog"] = 650,			-- "Underbog"
	["Magisters' Terrace"] = 661,		-- "Magister's Terrace"
	["The Arcatraz"] = 660,
-- Lich King Dungeons
	["The Culling of Stratholme"] = 479,
	["Utgarde Keep"] = 477,
	["Drak'Tharon Keep"] = 482,
	["Gundrak"] = 484,
	["Ahn'kahet: The Old Kingdom"] = 481,
	["Halls of Stone"] = 485,
	["Utgarde Pinnacle"] = 488,
	["The Oculus"] = 487,
	["Halls of Lightning"] = 486,
	["The Nexus"] = 478,
	["The Violet Hold"] = 483,
	["Azjol-Nerub"] = 480,
	["Trial of the Champion"] = IsAlliance and 4296 or 3778,
	["The Forge of Souls"] = 4516,
	["Halls of Reflection"] = 4518,
	["Pit of Saron"] = 4517,
	
-- Cataclysm Dungeons
	-- Heroic only, but these dungeons are heroic only so it may as well always show up if suggesting for the zone:
	["Zul'Aman"] = { 5769, 5858, 5760, 5761, 5750 },  -- "Heroic: Zul'Aman", "Bear-ly Made It", "Ring Out!", "Hex Mix", "Tunnel Vision"
	["Zul'Gurub"] = { 5768, 5765, 5743, 5762, 5759, 5744 },  -- "Heroic: Zul'Gurub", "Here, Kitty Kitty...", "It's Not Easy Being Green", "Ohganot So Fast!", "Spirit Twister", "Gurubashi Headhunter"
-- Cataclysm Raids
	["Firelands"] = { 5802, 5828, 5855 }, -- "Firelands", "Glory of the Firelands Raider", "Ragnar-O's"

-- Pandaria Dungeons
	["Gate of the Setting Sun"] = 6945, -- "Mantid Swarm"
	["Stormstout Brewery"] = { 6400, 6402 }, -- "How Did He Get Up There?", "Ling-Ting's Herbal Journey"
	["Scarlet Monastery"] = 6946, -- "Empowered Spiritualist"
-- Pandaria Raids
	["Heart of Fear"] = { 6718, 6845, 6936, 6518, 6683, 6553, 6937, 6922 }, -- "The Dread Approach", "Nightmare of Shek'zeer", "Candle in the Wind", "I Heard You Like Amber...", "Less Than Three", "Like An Arrow to the Face", "Overzealous", "Timing is Everything"
	["Mogu'shan Vaults"] = { 6458, 6844, 6674, 6687, 6823, 6455, 7056, 6686 }, -- "Guardians of Mogu'shan", "The Vault of Mysteries", "Anything You Can Do, I Can Do Better...", "Getting Hot in Here", "Must Love Dogs", "Show Me Your Moves!", "Sorry, Were You Looking for This?", "Straight Six"
	["Terrace of Endless Spring"] = { 6689, 6824, 6717, 6825, 6933 }, -- "Terrace of Endless Spring", "Face Clutchers", "Power Overwhelming", "The Mind-Killer", "Who's Got Two Green Thumbs?"
	["Throne of Thunder"] = {
		8070, 8071, 8069, 8072, -- "Forgotten Depths", "Halls of Flesh-Shaping", "Last Stand of the Zandalari", "Pinnacle of Storms"
		8037, 8087, 8090, 8094, 8073, 8082, 8098, 8081, 8086 -- "Genetically Unmodified Organism", "Can't Touch This", "A Complete Circuit", "Lightning Overload", "Cage Match", "Head Case", "You Said Crossing the Streams Was Bad", "Ritualist Who?", "From Dusk 'til Dawn"
		-- 8089 "I Thought He Was Supposed to Be Hard?" is now a Feat of Strength
	},
	["Siege of Orgrimmar"] = {
		8454, 8458, 8459, 8461, 8462, -- "Glory of the Orgrimmar Raider", "Vale of Eternal Sorrows", "Gates of Retribution", "The Underhold", "Downfall"
		IsAlliance and 8679 or 8680 -- "Conqueror of Orgrimmar" or "Liberator of Orgrimmar"
	},
}
-- Battlegrounds
ACHID_INSTANCES["The Battle for Gilneas"] = 5258
ACHID_INSTANCES["Eye of the Storm"] = { 1171, 587, 1258, 211 }
ACHID_INSTANCES["Silvershard Mines"] = 7106
ACHID_INSTANCES["Strand of the Ancients"] = 2194
ACHID_INSTANCES["Twin Peaks"] = 5223  -- "Master of Twin Peaks"
ACHID_INSTANCES["Wildhammer Stronghold"] = 5223  -- Also part of Twin Peaks
ACHID_INSTANCES["Dragonmaw Stronghold"] = 5223  -- Also part of Twin Peaks
ACHID_INSTANCES["Temple of Kotmogu"] = 6981 -- "Master of Temple of Kotmogu"
ACHID_INSTANCES["Deepwind Gorge"] = 8360 -- "Master of Deepwind Gorge"
if (IsAlliance) then
	ACHID_INSTANCES["Alterac Valley"] = { 1167, 907, 226 }
	ACHID_INSTANCES["Arathi Basin"] = { 1169, 907 }
	ACHID_INSTANCES["Warsong Gulch"] = { 1172, 1259, 907 }
	ACHID_INSTANCES["Isle of Conquest"] = { 3857, 3845, 3846 }

else
	ACHID_INSTANCES["Alterac Valley"] = { 1167, 714, 226 }
	ACHID_INSTANCES["Arathi Basin"] = { 1169, 714 }
	ACHID_INSTANCES["Warsong Gulch"] = { 1172, 1259, 714 }
	ACHID_INSTANCES["Isle of Conquest"] = { 3957, 3845, 4176 }
end
-- For all battlegrounds:
local ACHID_BATTLEGROUNDS = { 238, 245, IsAlliance and 246 or 1005, 247, 229, 227, 231, 1785 }

-- INSTANCES - NORMAL ONLY (any group size):
local ACHID_INSTANCES_NORMAL = {
-- Classic Dungeons
	["The Deadmines"] = 628,
	["Shadowfang Keep"] = 631,
	["Scarlet Monastery"] = 637,
	["Scholomance"] = 645,
-- Cataclysm Dungeons
	["Lost City of the Tol'vir"] = 4848,
	["Blackrock Caverns"] = 4833,
	["Grim Batol"] = 4840,
	["The Vortex Pinnacle"] = 4847, -- Need to confirm zone name.
	["Halls of Origination"] = 4841,
	["The Stonecore"] = 4846,
	["Throne of the Tides"] = 4839,
-- Pandaria Dungeons
	["Mogu'shan Palace"] = 6755,
	["Shado-Pan Monastery"] = 6469,
	["Stormstout Brewery"] = 6457,
	["Temple of the Jade Serpent"] = 6757,
	["Scarlet Halls"] = 7413,
}

-- INSTANCES - HEROIC ONLY (any group size):
local ACHID_INSTANCES_HEROIC = {
-- Burning Crusade
	["Auchenai Crypts"] = 672,
	["The Blood Furnace"] = 668,
	["The Slave Pens"] = 669,
	["Hellfire Ramparts"] = 667,
	["Mana-Tombs"] = 671,
	["The Underbog"] = 670,			-- "Heroic: Underbog"
	["Old Hillsbrad Foothills"] = 673,	-- "Heroic: The Escape From Durnholde"
	["Magisters' Terrace"] = 682,		-- "Heroic: Magister's Terrace"
	["The Arcatraz"] = 681,
	["The Mechanar"] = 679,
	["The Shattered Halls"] = 678,
	["The Steamvault"] = 677,
	["The Botanica"] = 680,
	["The Black Morass"] = 676,		-- "Heroic: Opening of the Dark Portal"
	["Shadow Labyrinth"] = 675,
	["Sethekk Halls"] = 674,
-- Lich King Dungeons
	["Halls of Stone"] = { 496, 1866, 2154, 2155 },
	["Gundrak"] = { 495, 2040, 2152, 1864, 2058 },
	["Azjol-Nerub"] = { 491, 1860, 1296, 1297 },
	["Halls of Lightning"] = { 497, 2042, 1867, 1834 },
	["Utgarde Keep"] = { 489, 1919 },
	["The Nexus"] = { 490, 2037, 2036, 2150 },
	["Drak'Tharon Keep"] = { 493, 2039, 2057, 2151 },
	["Ahn'kahet: The Old Kingdom"] = { 492, 2056, 1862, 2038 }, --removed: 1861
	["The Oculus"] = { 498, 1868, 1871, 2044, 2045, 2046 },
	["The Violet Hold"] = { 494, 2153, 1865, 2041, 1816 },
	["The Culling of Stratholme"] = { 500, 1872, 1817 },
	["Utgarde Pinnacle"] = { 499, 1873, 2043, 2156, 2157 },
	["Trial of the Champion"] = { IsAlliance and 4298 or 4297, 3802, 3803, 3804 },
	["The Forge of Souls"] = { 4519, 4522, 4523 },
	["Halls of Reflection"] = { 4521, 4526 },
	["Pit of Saron"] = { 4520, 4524, 4525 },
-- Cataclysm Dungeons
	["Lost City of the Tol'vir"] = { 5291, 5292, 5066, 5290 },
	["Blackrock Caverns"] = { 5282, 5284, 5281, 5060, 5283 },
	["Shadowfang Keep"] = { 5505, 5093, 5503, 5504 },
	["Grim Batol"] = { 5298, 5062, 5297 },
	["The Vortex Pinnacle"] = { 5289, 5064, 5288 },
	["Halls of Origination"] = { 5296, 5065, 5293, 5294, 5295 },
	["The Deadmines"] = { 5083, 5370, 5369, 5368, 5367, 5366, 5371 },
	["The Stonecore"] = { 5063, 5287 },
	["Throne of the Tides"] = { 5061, 5285, 5286 },
-- Pandaria Dungeons
	["Gate of the Setting Sun"] = { 6759, 6479, 6476 },
	["Mogu'shan Palace"] = { 6478, 6756, 6713, 6736 },
	["Shado-Pan Monastery"] = { 6470, 6471, 6477, 6472 },
	["Siege of Niuzao Temple"] = { 6763, 6485, 6822, 6688 },
	["Stormstout Brewery"] = { 6456, 6420, 6089 },
	["Temple of the Jade Serpent"] = { 6758, 6475, 6460, 6671 },
	["Scarlet Halls"] = { 6760, 6684, 6427 },
	["Scarlet Monastery"] = { 6761, 6929, 6928 },
	["Scholomance"] = { 6762, 6531, 6394, 6396, 6821 },
-- Pandaria Raids
	["Heart of Fear"] = { 6729, 6726, 6727, 6730, 6725, 6728 },
	["Mogu'shan Vaults"] = { 6723, 6720, 6722, 6721, 6719, 6724 },
	["Terrace of Endless Spring"] = { 6733, 6731, 6734, 6732 },
	["Throne of Thunder"] = { 8124, 8067 }, -- "Glory of the Thundering Raider", "Heroic: Lei Shen"
	["Siege of Orgrimmar"] = {
		8463, 8465, 8466, 8467, 8468, 8469, 8470, -- "Heroic: Immerseus", "Heroic: Fallen Protectors", "Heroic: Norushen", "Heroic: Sha of Pride", "Heroic: Galakras", "Heroic: Iron Juggernaut", "Heroic: Kor'kron Dark Shaman",
		8471, 8472, 8478, 8479, 8480, 8481, 8482, -- "Heroic: General Nazgrim", "Heroic: Malkorok", "Heroic: Spoils of Pandaria", "Heroic: Thok the Bloodthirsty", "Heroic: Siegecrafter Blackfuse", "Heroic: Paragons of the Klaxxi", "Heroic: Garrosh Hellscream"
	},
}

-- INSTANCES - 10-MAN ONLY (normal or heroic):
local ACHID_INSTANCES_10 = {
-- Lich King Raids
	["Naxxramas"] = { 2146, 576, 578, 572, 1856, 2176, 2178, 2180, 568, 1996, 1997, 1858, 564, 2182, 2184,
		566, 574, 562 }, -- 2187 "The Undying" is now a Feat of Strength
	["Onyxia's Lair"] = { 4396, 4402, 4403, 4404 },
	["The Eye of Eternity"] = { 622, 1874, 2148, 1869 },
	["The Obsidian Sanctum"] = { 1876, 2047, 2049, 2050, 2051, 624 },
	["Ulduar"] = { 2957, 2894, -- 2903 "Champion of Ulduar" is now a Feat of Strength
		SUBZONES = {
			--["*Formation Grounds*The Colossal Forge*Razorscale's Aerie*The Scrapyard*"] = 2886, -- Siege
			["Formation Grounds"] = { 3097, 2905, 2907, 2909, 2911, 2913 },
			["Razorscale's Aerie"] = { 2919, 2923 },
			["The Colossal Forge"] = { 2925, 2927, 2930 },
			["The Scrapyard"] = { 2931, 2933, 2934, 2937, 3058 },

			--["*The Assembly of Iron*The Shattered Walkway*The Observation Ring*"] = 2888, -- Antechamber
			["The Assembly of Iron"] = { 2939, 2940, 2941, 2945, 2947 },
			["The Shattered Walkway"] = { 2951, 2953, 2955, 2959 },
			["The Observation Ring"] = { 3006, 3076 },

			--["*The Spark of Imagination*The Conservatory of Life*The Clash of Thunder*The Halls of Winter*"] = 2890, -- Keepers
			["The Halls of Winter"] = { 2961, 2963, 2967, 3182, 2969 },
			["The Clash of Thunder"] = { 2971, 2973, 2975, 2977 },
			["The Conservatory of Life"] = { 2979, 2980, 2985, 2982, 3177 },
			["The Spark of Imagination"] = { 2989, 3138, 3180 },

			--["*The Descent into Madness*The Prison of Yogg-Saron*"] = 2892, -- Descent
			["The Descent into Madness"] = { 2996, 3181 },
			["The Prison of Yogg-Saron"] = { 3009, 3157, 3008, 3012, 3014, 3015 },

			["The Celestial Planetarium"] = { 3036, 3003 }, -- Alganon
			  -- 3004 "He Feeds On Your Tears (10 player)" and 3316 "Herald of the Titans" are now Feats of Strength
		},
	},
	["Vault of Archavon"] = { 1722, 3136, 3836, 4016 },
	["Trial of the Crusader"] = { 3917, 3936, 3798, 3799, 3800, 3996, 3797 },
	["Icecrown Citadel"] = { 4580, 4601, 4534, 4538, 4577, 4535, 4536, 4537, 4578, 4581, 4539, 4579, 4582 },
}

-- INSTANCES - 25-MAN ONLY (normal or heroic):
local ACHID_INSTANCES_25 = {
-- Lich King Raids
	["Naxxramas"] = { 579, 565, 577, 575, 2177, 563, 567, 1857, 569, 573, 1859, 2139, 2181, 2183, 2185,
		2147, 2140, 2179 },
		-- made Feats of Strength: 2186
	["Onyxia's Lair"] = { 4397, 4405, 4406, 4407 },
	["The Eye of Eternity"] = { 623, 1875, 1870, 2149 },
	["The Obsidian Sanctum"] = { 625, 2048, 2052, 2053, 2054, 1877 },
	["Ulduar"] = { 2958, 2895, -- 2904 "Conqueror of Ulduar" is now a Feat of Strength
		SUBZONES = {
			--["*Formation Grounds*The Colossal Forge*Razorscale's Aerie*The Scrapyard*"] = 2887, -- Siege
			["Formation Grounds"] = { 3098, 2906, 2908, 2910, 2912, 2918 },
			["Razorscale's Aerie"] = { 2921, 2924 },
			["The Colossal Forge"] = { 2926, 2928, 2929 },
			["The Scrapyard"] = { 2932, 2935, 2936, 2938, 3059 },

			--["*The Assembly of Iron*The Shattered Walkway*The Observation Ring*"] = 2889, -- Antechamber
			["The Assembly of Iron"] = { 2942, 2943, 2944, 2946, 2948 },
			["The Shattered Walkway"] = { 2952, 2954, 2956, 2960 },
			["The Observation Ring"] = { 3007, 3077 },

			--["*The Spark of Imagination*The Conservatory of Life*The Clash of Thunder*The Halls of Winter*"] = 2891, -- Keepers
			["The Halls of Winter"] = { 2962, 2965, 2968, 3184, 2970 },
			["The Clash of Thunder"] = { 2972, 2974, 2976, 2978 },
			["The Conservatory of Life"] = { 3118, 2981, 2984, 2983, 3185 },
			["The Spark of Imagination"] = { 3237, 2995, 3189 },

			--["*The Descent into Madness*The Prison of Yogg-Saron*"] = 2893, -- Descent
			["The Descent into Madness"] = { 2997, 3188 },
			["The Prison of Yogg-Saron"] = { 3011, 3161, 3010, 3013, 3017, 3016 },

			["The Celestial Planetarium"] = { 3037, 3002 }, -- Alganon
			  -- 3005 "He Feeds On Your Tears (25 player)" is now a Feat of Strength
		},
	},
	["Vault of Archavon"] = { 1721, 3137, 3837, 4017 },
	["Trial of the Crusader"] = { 3916, 3937, 3815, 3816, 3997, 3813 }, -- removed 3814
	["Icecrown Citadel"] = { 4620, 4621, 4610, 4614, 4615, 4611, 4612, 4613, 4616, 4622, 4618, 4619, 4617 },
}

-- INSTANCES - NORMAL 10-MAN ONLY:
local ACHID_INSTANCES_10_NORMAL = {
	["Icecrown Citadel"] = 4532,
	["The Ruby Sanctum"] = 4817, -- Need to confirm zone name.
}

-- INSTANCES - HEROIC 10-MAN ONLY:
local ACHID_INSTANCES_10_HEROIC = {
	["Trial of the Crusader"] = 3918, -- 3808 "A Tribute to Skill (10 player)" is now a Feat of Strength
	["Icecrown Citadel"] = 4636,
	["The Ruby Sanctum"] = 4818, -- Need to confirm zone name.
-- Cataclysm Raids
	["Firelands"] = 5803,	-- "Heroic: Ragnaros" (can be 10 or 25 apparently but putting it here allows detection that it's a raid when getting Suggestions outside it)
}

-- INSTANCES - NORMAL 25-MAN ONLY:
local ACHID_INSTANCES_25_NORMAL = {
	["Icecrown Citadel"] = 4608,
	["The Ruby Sanctum"] = 4815, -- Need to confirm zone name.
}

-- INSTANCES - HEROIC 25-MAN ONLY:
local ACHID_INSTANCES_25_HEROIC = {
	["Trial of the Crusader"] = { 3812 }, -- 3817 "A Tribute to Skill (25 player)" is now a Feat of Strength
	["Icecrown Citadel"] = 4637,
	["The Ruby Sanctum"] = 4816, -- Need to confirm zone name.
-- Cataclysm Raids
	["Firelands"] = 5803,	-- "Heroic: Ragnaros" (can be 10 or 25 apparently but putting it here allows detection that it's a raid when getting Suggestions outside it)
}


-- Create reverse lookup table for L.SUBZONES:
local SUBZONES_REV = {}
for k,v in pairs(L.SUBZONES) do  SUBZONES_REV[v] = k;  end

local function ZoneLookup(zoneName, isSub, subz)
  zoneName = zoneName or subz or ""
  local trimz = strtrim(zoneName)
  return isSub and SUBZONES_REV[trimz] or LBZR[trimz] or LBZR[zoneName] or trimz
end


-- TRADESKILL ACHIEVEMENTS
----------------------------------------------------

local ACHID_TRADESKILL = {
	["Cooking"] = { 1563, 5845 },	-- "Hail to the Chef", "A Bunch of Lunch"
	["Fishing"] = { 1516, 5478, 5479, 5851 }, -- "Accomplished Angler", "The Limnologist", "The Oceanographer", "Gone Fishin'"
}

local ACHID_TRADESKILL_ZONE = {
	["Cooking"] = {
		["Dalaran"] = { 1998, IsAlliance and 1782 or 1783, 3217, 3296 },
			-- "Dalaran Cooking Award", "Our Daily Bread", "Chasing Marcia", "Cooking with Style"
		["Shattrath City"] = 906	-- "Kickin' It Up a Notch"
        },
	["Fishing"] = {
		["Dalaran"] = { 2096, 1958 },		-- "The Coin Master", "I Smell A Giant Rat"
		["Ironforge"] = { 1837 },		-- "Old Ironjaw"
		["Orgrimmar"] = {1836, "150:1"},	-- "Old Crafty", "The Fishing Diplomat"
		["Serpentshrine Cavern"] = 144,		-- "The Lurker Above"
		["Shattrath City"] = 905,		-- "Old Man Barlowned"
		["Stormwind City"] = { "150:2" },	-- "The Fishing Diplomat"
		["Terokkar Forest"] = { 905, 726 },	-- "Old Man Barlowned", "Mr. Pinchy's Magical Crawdad Box"
		--Feat of Strength: ["Zul'Gurub"] = 560,		-- "Deadliest Catch"

		-- "Master Angler of Azeroth":
		["The Cape of Stranglethorn"] = 306,
		["Northern Stranglethorn"] = 306, -- Need to confirm it belongs in both zones
		["Howling Fjord"] = 306,
		["Grizzly Hills"] = 306,
		["Borean Tundra"] = 306,
		["Sholazar Basin"] = 306,
		["Dragonblight"] = 306,
		["Crystalsong Forest"] = 306,
		["Icecrown"] = 306,
		["Zul'Drak"] = 306,
        }
}
if (IsAlliance) then
  tinsert(ACHID_TRADESKILL_ZONE["Fishing"]["Stormwind City"], 5476)	-- "Fish or Cut Bait: Stormwind"
  tinsert(ACHID_TRADESKILL_ZONE["Fishing"]["Ironforge"], 5847)		-- "Fish or Cut Bait: Ironforge"
  ACHID_TRADESKILL_ZONE["Fishing"]["Darnassus"] = 5848			-- "Fish or Cut Bait: Darnassus"
  ACHID_TRADESKILL_ZONE["Cooking"]["Stormwind City"] = 5474		-- "Let's Do Lunch: Stormwind"
  ACHID_TRADESKILL_ZONE["Cooking"]["Ironforge"] = 5841			-- "Let's Do Lunch: Ironforge"
  ACHID_TRADESKILL_ZONE["Cooking"]["Darnassus"] = 5842			-- "Let's Do Lunch: Darnassus"
else
  tinsert(ACHID_TRADESKILL_ZONE["Fishing"]["Orgrimmar"], 5477)		-- "Fish or Cut Bait: Orgrimmar"
  ACHID_TRADESKILL_ZONE["Fishing"]["Thunder Bluff"] = 5849		-- "Fish or Cut Bait: Thunder Bluff"
  ACHID_TRADESKILL_ZONE["Fishing"]["Undercity"] = 5850			-- "Fish or Cut Bait: Undercity"
  ACHID_TRADESKILL_ZONE["Cooking"]["Orgrimmar"] = 5475			-- "Let's Do Lunch: Orgrimmar"
  ACHID_TRADESKILL_ZONE["Cooking"]["Thunder Bluff"] = 5843		-- "Let's Do Lunch: Thunder Bluff"
  ACHID_TRADESKILL_ZONE["Cooking"]["Undercity"] = 5844			-- "Let's Do Lunch: Undercity"
end

local ACHID_TRADESKILL_BG = { Cooking = 1785 }	-- "Dinner Impossible"



-- SUGGESTIONS TAB CREATION AND HANDLING
----------------------------------------------------

local VARS
local frame, panel, sortdrop
local LocationsList, EditZoneOverride, subzdrop, subzdrop_menu, subzdrop_Update = {}
local diffdrop, raidsizedrop
local RefreshBtn, ResetBtn, NoSuggestionsLabel, ResultsLabel

WHAT = LocationsList

local function SortDrop_OnSelect(self, value)
  VARS.SuggestionsSort = value
  frame.sort = value
  frame:ForceUpdate(true)
end

local function OnLoad(v)
  VARS = v
  sortdrop:SetSelectedValue(VARS.SuggestionsSort or 0)
end

frame, panel = Overachiever.BuildNewTab("Overachiever_SuggestionsFrame", L.SUGGESTIONS_TAB,
                "Interface\\AddOns\\Overachiever_Tabs\\SuggestionsWatermark", L.SUGGESTIONS_HELP, OnLoad,
                ACHIEVEMENT_FILTER_INCOMPLETE)
frame.AchList_checkprev = true

sortdrop = TjDropDownMenu.CreateDropDown("Overachiever_SuggestionsFrameSortDrop", panel, {
  {
    text = L.TAB_SORT_NAME,
    value = 0
  },
  {
    text = L.TAB_SORT_COMPLETE,
    value = 1
  },
  {
    text = L.TAB_SORT_POINTS,
    value = 2
  },
  {
    text = L.TAB_SORT_ID,
    value = 3
  };
})
sortdrop:SetLabel(L.TAB_SORT, true)
sortdrop:SetPoint("TOPLEFT", panel, "TOPLEFT", -16, -22)
sortdrop:OnSelect(SortDrop_OnSelect)

local CurrentSubzone

local function Refresh_Add(...)
  local id, _, complete, nextid
  for i=1, select("#", ...) do
    id = select(i, ...)
    if (id) then

      if (type(id) == "table") then
        Refresh_Add(unpack(id))
        if (id.SUBZONES) then
          for subz, subzsuggest in pairs(id.SUBZONES) do
            if (subz == CurrentSubzone or strfind(subz, "*"..CurrentSubzone.."*", 1, true)) then
            -- Asterisks surround subzone names since they aren't used in any actual subzone names.
              Refresh_Add(subzsuggest)
            end
          end
        end

      elseif (type(id) == "string") then
        local crit
        id, crit = strsplit(":", id)
        id, crit = tonumber(id), tonumber(crit)
        _, _, _, complete = GetAchievementInfo(id)
        if (complete) then
          nextid, complete = GetNextAchievement(id)
          if (nextid) then
            local name = GetAchievementCriteriaInfo(id, crit)
            while (complete and GetAchievementCriteriaInfo(nextid, crit) == name) do
            -- Find first incomplete achievement in the chain that has this criteria:
              id = nextid
              nextid, complete = GetNextAchievement(id)
            end
            if (nextid and GetAchievementCriteriaInfo(nextid, crit) == name) then
              id = nextid
            end
          end
        end
        suggested[id] = crit
        -- Known limitation (of no consequence at this time due to which suggestions actually use this feature):
        -- If an achievement is suggested due to multiple criteria, only one of them is reflected by this.
        -- (A future fix may involve making it a table when there's more than one, though it would need to check
        -- against adding the same criteria number twice.)

      else
        _, _, _, complete = GetAchievementInfo(id)
        if (complete) then
          nextid, complete = GetNextAchievement(id)
          if (nextid) then
            while (complete) do  -- Find first incomplete achievement in the chain:
              id = nextid
              nextid, complete = GetNextAchievement(id)
            end
            id = nextid or id
          end
        end
        suggested[id] = true
      end

    end
  end
end

local TradeskillSuggestions

local Refresh_lastcount, Refresh_stoploop = 0

local function Refresh(self)
  if (not frame:IsVisible() or Refresh_stoploop) then  return;  end
  if (self == RefreshBtn or self == EditZoneOverride) then  PlaySound("igMainMenuOptionCheckBoxOn");  end
  Refresh_stoploop = true

  wipe(suggested)
  EditZoneOverride:ClearFocus()
  CurrentSubzone = ZoneLookup(GetSubZoneText(), true)
  local zone = LocationsList[ strtrim(strlower(EditZoneOverride:GetText())) ]
  if (zone) then
    zone = LocationsList[zone]
    EditZoneOverride:SetText(zone)
    if (self ~= subzdrop) then  subzdrop_Update(zone);  end
    local subz = subzdrop:GetSelectedValue()
    if (subz ~= 0) then  CurrentSubzone = subz;  end
  else
    zone = ZoneLookup(GetRealZoneText(), nil, CurrentSubzone)
    EditZoneOverride:SetTextColor(0.75, 0.1, 0.1)
    --Refresh_stoploop = true
    subzdrop:SetMenu(subzdrop_menu)
    --Refresh_stoploop = nil
    subzdrop:Disable()
  end

  local instype, heroicD, twentyfive, heroicR = Overachiever.GetDifficulty()

  -- Check for difficulty override:
  local val = diffdrop:GetSelectedValue()
  if (val ~= 0) then
    val = val == 2 and true or false
    heroicD = val
    heroicR = val
  end
  val = raidsizedrop:GetSelectedValue()
  if (val ~= 0) then
    twentyfive = val == 25 and true or false
  end

  -- Suggestions based on an open tradeskill window or whether a fishing pole is equipped:
  TradeskillSuggestions = GetTradeSkillLine()
  local tradeskill = LBIR[TradeskillSuggestions]
  if (not ACHID_TRADESKILL[tradeskill] and IsEquippedItemType("Fishing Poles")) then
    TradeskillSuggestions, tradeskill = LBI["Fishing"], "Fishing"
  end
  if (ACHID_TRADESKILL[tradeskill]) then
    Refresh_Add(ACHID_TRADESKILL[tradeskill])
    if (ACHID_TRADESKILL_ZONE[tradeskill]) then
      Refresh_Add(ACHID_TRADESKILL_ZONE[tradeskill][zone])
    end
    if (instype == "pvp") then  -- If in a battleground:
      Refresh_Add(ACHID_TRADESKILL_BG[tradeskill])
    end
  else
    TradeskillSuggestions = nil

  -- Suggestions for your location:
    if (instype) then  -- If in an instance:
      Refresh_Add(ACHID_INSTANCES[zone])
      if (instype == "pvp") then  -- If in a battleground:
        Refresh_Add(ACHID_BATTLEGROUNDS)
      end

      if (heroicD or heroicR) then
        if (twentyfive) then
          Refresh_Add(ACHID_INSTANCES_HEROIC[zone], ACHID_INSTANCES_25[zone], ACHID_INSTANCES_25_HEROIC[zone])
        else
          Refresh_Add(ACHID_INSTANCES_HEROIC[zone], ACHID_INSTANCES_10[zone], ACHID_INSTANCES_10_HEROIC[zone])
        end
      else
        if (twentyfive) then
          Refresh_Add(ACHID_INSTANCES_NORMAL[zone], ACHID_INSTANCES_25[zone], ACHID_INSTANCES_25_NORMAL[zone])
        else
          Refresh_Add(ACHID_INSTANCES_NORMAL[zone], ACHID_INSTANCES_10[zone], ACHID_INSTANCES_10_NORMAL[zone])
        end
      end

    else
      Refresh_Add(Overachiever.ExploreZoneIDLookup(zone), ACHID_ZONE_NUMQUESTS[zone], ACHID_ZONE_MISC[zone])
      -- Also look for instance achievements for an instance you're near if we can look it up easily (since many zones
      -- have subzones with the instance name when you're near the instance entrance and some instance entrances are
      -- actually in their own "zone" using the instance's zone name):
      Refresh_Add(ACHID_INSTANCES[CurrentSubzone] or ACHID_INSTANCES[zone])

      local ach10, ach25 = ACHID_INSTANCES_10[CurrentSubzone] or ACHID_INSTANCES_10[zone], ACHID_INSTANCES_25[CurrentSubzone] or ACHID_INSTANCES_25[zone]
      local achH10, achH25 = ACHID_INSTANCES_10_HEROIC[CurrentSubzone] or ACHID_INSTANCES_10_HEROIC[zone], ACHID_INSTANCES_25_HEROIC[CurrentSubzone] or ACHID_INSTANCES_25_HEROIC[zone]
      local achN10, achN25 = ACHID_INSTANCES_10_NORMAL[CurrentSubzone] or ACHID_INSTANCES_10_NORMAL[zone], ACHID_INSTANCES_25_NORMAL[CurrentSubzone] or ACHID_INSTANCES_25_NORMAL[zone]

      if (ach10 or ach25 or achH10 or achH25 or achN10 or achN25) then
      -- If there are 10-man or 25-man specific achievements, this is a raid:
        if (heroicR) then
          if (twentyfive) then
            Refresh_Add(ACHID_INSTANCES_HEROIC[CurrentSubzone] or ACHID_INSTANCES_HEROIC[zone], ach25, achH25)
          else
            Refresh_Add(ACHID_INSTANCES_HEROIC[CurrentSubzone] or ACHID_INSTANCES_HEROIC[zone], ach10, achH10)
          end
        else
          if (twentyfive) then
            Refresh_Add(ACHID_INSTANCES_NORMAL[CurrentSubzone] or ACHID_INSTANCES_NORMAL[zone], ach25, achN25)
          else
            Refresh_Add(ACHID_INSTANCES_NORMAL[CurrentSubzone] or ACHID_INSTANCES_NORMAL[zone], ach10, achN10)
          end
        end
      -- Not a raid (or at least no 10-man vs 25-man specific suggestions):
      elseif (heroicD) then
        Refresh_Add(ACHID_INSTANCES_HEROIC[CurrentSubzone] or ACHID_INSTANCES_HEROIC[zone])
      else
        Refresh_Add(ACHID_INSTANCES_NORMAL[CurrentSubzone] or ACHID_INSTANCES_NORMAL[zone])
      end
    end

    -- Suggestions from recent reminders:
    Overachiever.RecentReminders_Check()
    for id in pairs(RecentReminders) do
      suggested[id] = true
    end

  end

  local list, count = frame.AchList, 0
  wipe(list)
  local critlist = frame.AchList_criteria and wipe(frame.AchList_criteria)
  if (not critlist) then
    critlist = {}
    frame.AchList_criteria = critlist
  end
  for id,v in pairs(suggested) do
    count = count + 1
    list[count] = id
    if (v ~= true) then
      critlist[id] = v
    end
  end

  if (self ~= panel or Refresh_lastcount ~= count) then
    Overachiever_SuggestionsFrameContainerScrollBar:SetValue(0)
  end
  frame:ForceUpdate(true)
  Refresh_lastcount = count
  Refresh_stoploop = nil
end

function frame.SetNumListed(num)
  if (num > 0) then
    NoSuggestionsLabel:Hide()
    if (TradeskillSuggestions) then
      ResultsLabel:SetText(L.SUGGESTIONS_RESULTS_TRADESKILL:format(TradeskillSuggestions, num))
    else
      ResultsLabel:SetText(L.SUGGESTIONS_RESULTS:format(num))
    end
  else
    NoSuggestionsLabel:Show()
    if (TradeskillSuggestions) then
      NoSuggestionsLabel:SetText(L.SUGGESTIONS_EMPTY_TRADESKILL:format(TradeskillSuggestions))
    else
      NoSuggestionsLabel:SetText(L.SUGGESTIONS_EMPTY)
    end
    ResultsLabel:SetText(" ")
  end
end

RefreshBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
RefreshBtn:SetWidth(75); RefreshBtn:SetHeight(21)
--RefreshBtn:SetPoint("TOPLEFT", sortdrop, "BOTTOMLEFT", 16, -14)
RefreshBtn:SetText(L.SUGGESTIONS_REFRESH)
RefreshBtn:SetScript("OnClick", Refresh)

ResultsLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
ResultsLabel:SetPoint("TOPLEFT", RefreshBtn, "BOTTOMLEFT", 0, -8)
ResultsLabel:SetWidth(178)
ResultsLabel:SetJustifyH("LEFT")
ResultsLabel:SetText(" ")

panel:SetScript("OnShow", Refresh)

NoSuggestionsLabel = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
NoSuggestionsLabel:SetPoint("TOP", frame, "TOP", 0, -189)
NoSuggestionsLabel:SetText(L.SUGGESTIONS_EMPTY)
NoSuggestionsLabel:SetWidth(490)

frame:RegisterEvent("TRADE_SKILL_SHOW")
frame:RegisterEvent("TRADE_SKILL_CLOSE")
frame:SetScript("OnEvent", Refresh)


-- SUPPORT FOR OTHER ADDONS
----------------------------------------------------

-- Open suggestions tables up for other addons to read or manipulate:
Overachiever.SUGGESTIONS = {
	zone_numquests = ACHID_ZONE_NUMQUESTS,
	zone = ACHID_ZONE_MISC,
	instance = ACHID_INSTANCES,
	bg = ACHID_BATTLEGROUNDS,
	instance_normal = ACHID_INSTANCES_NORMAL,
	instance_heroic = ACHID_INSTANCES_HEROIC,
	instance_10 = ACHID_INSTANCES_10,
	instance_25 = ACHID_INSTANCES_25,
	instance_10_normal = ACHID_INSTANCES_10_NORMAL,
	instance_10_heroic = ACHID_INSTANCES_10_HEROIC,
	instance_25_normal = ACHID_INSTANCES_25_NORMAL,
	instance_25_heroic = ACHID_INSTANCES_25_HEROIC,
	tradeskill = ACHID_TRADESKILL,
	tradeskill_zone = ACHID_TRADESKILL_ZONE,
	tradeskill_bg = ACHID_TRADESKILL_BG,
}



-- ZONE/INSTANCE OVERRIDE INPUT
----------------------------------------------------

EditZoneOverride = CreateFrame("EditBox", "Overachiever_SuggestionsFrameZoneOverrideEdit", panel, "InputBoxTemplate")
EditZoneOverride:SetWidth(170); EditZoneOverride:SetHeight(16)
EditZoneOverride:SetAutoFocus(false)
EditZoneOverride:SetPoint("TOPLEFT", sortdrop, "BOTTOMLEFT", 22, -19)
do
  local label = EditZoneOverride:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
  label:SetPoint("BOTTOMLEFT", EditZoneOverride, "TOPLEFT", -6, 4)
  label:SetText(L.SUGGESTIONS_LOCATION)

  -- CREATE LIST OF VALID LOCATIONS:
  -- Add all zones to the list:
  local zonetab = {}
  for i=1,select("#",Overachiever.GetMapContinents_names()) do  zonetab[i] = { Overachiever.GetMapZones_names(i) };  end
  for i,tab in ipairs(zonetab) do
    for n,z in ipairs(tab) do  suggested[z] = true;  end  -- Already localized so no need for LBZ here.
  end
  zonetab = nil
  -- Add instances for which we have suggestions:
  local function addtolist(list, ...)
    local tab
    for i=1,select("#", ...) do
      tab = select(i, ...)
      for k,v in pairs(tab) do
	    list[ LBZ[k] or k ] = true  -- Add localized version of instance names.
		--print("adding: k = "..(LBZ[k] or k)..(LBZ[k] and "" or "no LBZ[k]"))
		if (Overachiever_Debug and not LBZ[k]) then  print("POSSIBLE ERROR - no LBZ lookup found for "..k);  end
	  end
    end
  end
  addtolist(suggested, ACHID_INSTANCES, ACHID_INSTANCES_NORMAL, ACHID_INSTANCES_HEROIC,
            ACHID_INSTANCES_10, ACHID_INSTANCES_25, ACHID_INSTANCES_10_NORMAL, ACHID_INSTANCES_25_NORMAL,
            ACHID_INSTANCES_10_HEROIC, ACHID_INSTANCES_25_HEROIC)
  addtolist(suggested, ACHID_ZONE_MISC); -- Required for "unlisted" zones like Molten Front (doesn't appear in GetMapContinents/GetMapZones scan)
  addtolist = nil
  -- Arrange into alphabetically-sorted array:
  local count = 0
  for k in pairs(suggested) do
    count = count + 1
    LocationsList[count] = k
	--print("adding "..k)
  end
  wipe(suggested)
  WHATWHAT = LocationsList
  sort(LocationsList)
  -- Cross-reference by lowercase key to place in the array:
  for i,v in ipairs(LocationsList) do  LocationsList[strlower(v)] = i;  end
end

EditZoneOverride:SetScript("OnEnterPressed", Refresh)

local function findFirstLocation(text)
  if (strtrim(text) == "") then  return;  end
  local len = strlen(text)
  for i,v in ipairs(LocationsList) do
    if (strsub(strlower(v), 1, len) == text) then  return i, v, len, text;  end
  end
end

EditZoneOverride:SetScript("OnEditFocusGained", function(self)
  self:SetTextColor(1, 1, 1)
  self:HighlightText()
  CloseMenus()
end)

EditZoneOverride:SetScript("OnChar", function(self)
  local i, v, len = findFirstLocation(strlower(self:GetText()))
  if (i) then
    self:SetText(v)
    self:HighlightText(len, strlen(v))
    self:SetCursorPosition(len)
  end
end)

EditZoneOverride:SetScript("OnTabPressed", function(self)
  local text = strlower(self:GetText())
  local text2, len
  if (text == "") then
    text2 = LocationsList[IsShiftKeyDown() and #LocationsList or 1]
    len = 0
  elseif (not LocationsList[text]) then
    len = self:GetUTF8CursorPosition()
    if (len == 0) then
      text2 = LocationsList[IsShiftKeyDown() and #LocationsList or 1]
    else
      text = strsub(text, 1, len)
      if (IsShiftKeyDown()) then
        for i = #LocationsList, 1, -1 do
          if (strsub(strlower(LocationsList[i]), 1, len) == text) then
            text2 = LocationsList[i]
            break;
          end
        end
      else
        local i
        i, text2, len = findFirstLocation(text)
      end
    end
  else
    local i, v
    i, v, len, text = findFirstLocation(text)
    if (i) then
      local pos = self:GetUTF8CursorPosition()
      text = strsub(text, 1, pos)
      len = strlen(text)
      local mod = IsShiftKeyDown() and -1 or 1
      repeat
        i = i + mod
        text2 = LocationsList[i]
        if (not text2) then  i = (mod == 1 and 0) or #LocationsList + 1;  end
      until (text2 and strsub(strlower(text2), 1, pos) == text)
    end
  end
  if (text2) then
    self:SetText(text2)
    self:HighlightText(len, strlen(text2))
    self:SetCursorPosition(len)
  end
end)

EditZoneOverride:SetScript("OnEnter", function(self)
  GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
  GameTooltip:AddLine(L.SUGGESTIONS_LOCATION_TIP, 1, 1, 1)
  GameTooltip:AddLine(L.SUGGESTIONS_LOCATION_TIP2, nil, nil, nil, 1)
  GameTooltip:Show()
end)

EditZoneOverride:SetScript("OnLeave", function(self)
  GameTooltip:Hide()
end)


subzdrop_menu = {  {  text = L.SUGGESTIONS_LOCATION_NOSUBZONE, value = 0  };  }
subzdrop = TjDropDownMenu.CreateDropDown("Overachiever_SuggestionsFrameSubzoneDrop", panel, subzdrop_menu)
subzdrop:SetLabel(L.SUGGESTIONS_LOCATION_SUBZONE, true)
subzdrop:SetPoint("LEFT", sortdrop, "LEFT")
subzdrop:SetPoint("TOP", EditZoneOverride, "BOTTOM", 0, -21)
subzdrop:SetDropDownWidth(158)
subzdrop:OnSelect(Refresh)

do
  local menu

  local function addtosubzlist(list, key, ...)
    local tab
    for i=1,select("#", ...) do
      tab = select(i, ...)
      tab = tab[key]
      tab = type(tab) == "table" and tab.SUBZONES
      if (tab) then
        for k in pairs(tab) do
          if (strsub(k, 1, 1) == "*") then
            for subz in gmatch(k, "%*([^%*]+)%*") do  list[ L.SUBZONES[subz] or subz ] = true;  end
          else
            list[ L.SUBZONES[k] or k ] = true
          end
        end
      end
    end
  end

  function subzdrop_Update(zone)
    menu = menu or {}
    if (menu[zone] == nil) then
      local tab = {}
      addtosubzlist(suggested, zone, ACHID_ZONE_MISC, ACHID_INSTANCES, ACHID_INSTANCES_10, ACHID_INSTANCES_25,
                ACHID_INSTANCES_10_NORMAL, ACHID_INSTANCES_25_NORMAL, ACHID_INSTANCES_10_HEROIC, ACHID_INSTANCES_25_HEROIC)
      -- Arrange into alphabetically-sorted array:
      local count = 0
      for k in pairs(suggested) do
        count = count + 1
        tab[count] = k
      end
      wipe(suggested)
      if (count > 0) then
        sort(tab)  -- Sort alphabetically.
        -- Turn into dropdown menu format:
        for i,name in ipairs(tab) do  tab[i] = {  text = name, value = name  };  end
        tinsert(tab, 1, {  text = L.SUGGESTIONS_LOCATION_NOSUBZONE, value = 0  })
        menu[zone] = tab
        subzdrop:SetMenu(tab)
        subzdrop:SetSelectedValue(0)
        subzdrop:Enable()
        return;
      else
        menu[zone] = false
      end
    end
    if (menu[zone]) then
      subzdrop:SetMenu(menu[zone])
      subzdrop:Enable()
    else
      subzdrop:SetMenu(subzdrop_menu)
      subzdrop:Disable()
    end
  end
end

local orig_subzdropBtn_OnClick = Overachiever_SuggestionsFrameSubzoneDropButton:GetScript("OnClick")
Overachiever_SuggestionsFrameSubzoneDropButton:SetScript("OnClick", function(...)
  Refresh()
  if (subzdrop:IsEnabled()) then  orig_subzdropBtn_OnClick(...);  end
end)


-- Override for Normal/Heroic and group size
diffdrop = TjDropDownMenu.CreateDropDown("Overachiever_SuggestionsFrameDiffDrop", panel, {
  {
    text = L.SUGGESTIONS_DIFFICULTY_AUTO,
    value = 0
  },
  {
    text = L.SUGGESTIONS_DIFFICULTY_NORMAL,
    value = 1
  },
  {
    text = L.SUGGESTIONS_DIFFICULTY_HEROIC,
    value = 2
  };
})
diffdrop:SetLabel(L.SUGGESTIONS_DIFFICULTY, true)
diffdrop:SetPoint("TOPLEFT", subzdrop, "BOTTOMLEFT", 0, -18)
diffdrop:OnSelect(Refresh)

raidsizedrop = TjDropDownMenu.CreateDropDown("Overachiever_SuggestionsFrameRaidSizeDrop", panel, {
  {
    text = L.SUGGESTIONS_RAIDSIZE_AUTO,
    value = 0
  },
  {
    text = L.SUGGESTIONS_RAIDSIZE_10,
    value = 10
  },
  {
    text = L.SUGGESTIONS_RAIDSIZE_25,
    value = 25
  };
})
raidsizedrop:SetLabel(L.SUGGESTIONS_RAIDSIZE, true)
raidsizedrop:SetPoint("TOPLEFT", diffdrop, "BOTTOMLEFT", 0, -18)
raidsizedrop:OnSelect(Refresh)



RefreshBtn:SetPoint("TOPLEFT", raidsizedrop, "BOTTOMLEFT", 16, -14)

ResetBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
ResetBtn:SetWidth(75); ResetBtn:SetHeight(21)
ResetBtn:SetPoint("LEFT", RefreshBtn, "RIGHT", 4, 0)
ResetBtn:SetText(L.SEARCH_RESET)
ResetBtn:SetScript("OnClick", function(self)
  PlaySound("igMainMenuOptionCheckBoxOff")
  EditZoneOverride:SetText("")
  Refresh()
end)



-- MISCELLANEOUS
----------------------------------------------------

--[[
local function grabFromCategory(cat, ...)
  wipe(suggested)
  -- Get achievements in the category except those with a previous one in the chain that are also in the category:
  local id, prev, p2
  for i = 1, GetCategoryNumAchievements(cat) do
    id = GetAchievementInfo(cat, i)
	if (id) then
      prev, p2 = nil, GetPreviousAchievement(id)
      while (p2 and GetAchievementCategory(p2) == cat) do
        prev = p2
        p2 = GetPreviousAchievement(id)
      end
      suggested[ (prev or id) ] = true
	end
  end
  -- Add achievements specified by function call (useful for meta-achievements in a different category):
  for i=1, select("#", ...) do
    id = select(i, ...)
    suggested[id] = true
  end
  -- Fold achievements into their meta-achievements on the list:
  local tab, _, critType, assetID = {}
  for id in pairs(suggested) do
    for i=1,GetAchievementNumCriteria(id) do
      _, critType, _, _, _, _, _, assetID = GetAchievementCriteriaInfo(id, i)
      if (critType == 8 and suggested[assetID]) then
        tab[assetID] = true -- Not removed immediately in case there are meta-achievements within meta-achievements
      end
    end
  end
  for assetID in pairs(tab) do  suggested[assetID] = nil;  end
  -- Format list:
  local count = 0
  wipe(tab)
  for id in pairs(suggested) do
    count = count + 1
    tab[count] = id
  end
  return tab
end
--]]

-- ULDUAR 10: Results from grabFromCategory(14961, 2957):
--	{ 2894, 2903, 2905, 2907, 2909, 2911, 2913, 2919, 2925, 2927, 2931, 2933, 2934, 2937, 2939, 2940, 2945, 2947, 2951, 2955, 2957, 2959, 2961, 2963, 2967, 2969, 2971, 2973, 2975, 2977, 2979, 2980, 2982, 2985, 2989, 2996, 3003, 3004, 3008, 3009, 3012, 3014, 3015, 3036, 3076, 3097, 3138, 3157, 3177, 3316 }
-- ULDUAR 25: Results from grabFromCategory(14962, 2958):
--	{ 2895, 2904, 2906, 2908, 2910, 2912, 2918, 2921, 2926, 2928, 2932, 2935, 2936, 2938, 2942, 2943, 2946, 2948, 2952, 2956, 2958, 2960, 2962, 2965, 2968, 2970, 2972, 2974, 2976, 2978, 2981, 2983, 2984, 2995, 2997, 3002, 3005, 3010, 3011, 3013, 3016, 3017, 3037, 3077, 3098, 3118, 3161, 3185, 3237 }

--[[
-- /run Overachiever.Debug_GetIDsInCat( GetAchievementCategory(GetTrackedAchievements()) )
function Overachiever.Debug_GetIDsInCat(cat)
  local tab = Overachiever_Settings.Debug_AchIDsInCat
  if (not tab) then  Overachiever_Settings.Debug_AchIDsInCat = {};  tab = Overachiever_Settings.Debug_AchIDsInCat;  end
  local catname = GetCategoryInfo(cat)
  tab[catname] = {}
  tab = tab[catname]
  local id, n
  for i=1,GetCategoryNumAchievements(cat) do
    id, n = GetAchievementInfo(cat, i)
    if (id) then
	  tab[n] = id
    end
  end
end
--]]

--[[ --]]
-- /run Overachiever.Debug_GetMissingAch()
local function getAchIDsFromTab(from, to)
  for k,v in pairs(from) do
    if (type(v) == "table") then
      getAchIDsFromTab(v, to)
    else
      if (type(v) == "string") then
        local id, crit = strsplit(":", v)
        id, crit = tonumber(id) or id, tonumber(crit) or crit
        to[id] = to[id] or {}
        to[id][crit] = true
      else
        to[v] = to[v] or false
      end
    end
  end
end
--local isAchievementInUI = Overachiever.IsAchievementInUI
--local function isPreviousAchievementInUI(id)
--  id = GetPreviousAchievement(id)
--  if (id) then
--    if (isAchievementInUI(id)) then  return true;  end
--    return isPreviousAchievementInUI(id)
--  end
--end
local FEAT_OF_STRENGTH_ID = 81;
local GUILD_FEAT_OF_STRENGTH_ID = 15093;

function Overachiever.Debug_GetMissingAch()
  wipe(suggested)
  getAchIDsFromTab(Overachiever.SUGGESTIONS, suggested)
  getAchIDsFromTab(OVERACHIEVER_ACHID, suggested)
  getAchIDsFromTab(OVERACHIEVER_EXPLOREZONEID, suggested)
  local count = 0
  for id, crit in pairs(suggested) do
    if (type(id) ~= "number") then
      print("Invalid ID type:",id,type(id))
      count = count + 1
    elseif (GetAchievementInfo(id)) then
      --if (not isAchievementInUI(id, true) and not isPreviousAchievementInUI(id)) then
      --  print(GetAchievementLink(id),"is not found in the UI for this character.")
      --  count = count + 1
      local cat = GetAchievementCategory(id)
      if (cat == FEAT_OF_STRENGTH_ID or cat == GUILD_FEAT_OF_STRENGTH_ID) then
        print(GetAchievementLink(id)," ("..id..") is a Feat of Strength.")
        count = count + 1
      elseif (crit) then
        local num = GetAchievementNumCriteria(id)
        for c in pairs(crit) do
          if (c > num) then
            print(GetAchievementLink(id),"is missing criteria #"..(tostring(c) or "<?>"))
            count = count + 1
          end
        end
      end
    else
      print("Missing ID:",id..(crit and " (with criteria)" or ""))
      count = count + 1
    end
  end
  print("Overachiever.Debug_GetMissingAch():",count,"problems found.")
end
--]]

