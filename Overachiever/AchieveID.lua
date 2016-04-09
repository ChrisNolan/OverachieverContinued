
OVERACHIEVER_ACHID = {
	WorldExplorer = 46,		-- "World Explorer"
	LoveCritters = 1206,		-- "To All The Squirrels I've Loved Before"
	LoveCritters2 = 2557,		-- "To All The Squirrels Who Shared My Life"
	LoveCritters3 = 5548,		-- "To All the Squirrels Who Cared for Me"
	LoveCritters4 = 6350,		-- "To All the Squirrels I Once Caressed?"
	PestControl = 2556,		-- "Pest Control"
	WellRead = 1244,		-- "Well Read"
	HigherLearning = 1956,		-- "Higher Learning"

	TastesLikeChicken = 1832,	-- "Takes Like Chicken"
	HappyHour = 1833,		-- "It's Happy Hour Somewhere"
	CataclysmicallyDelicious = 5753,-- "Cataclysmically Delicious"
	DrownYourSorrows = 5754,	-- "Drown Your Sorrows"
	PandarenCuisine = 7329,		-- "Pandaren Cuisine"
	PandarenDelicacies = 7330,	-- "Pandaren Delicacies"

	RightAsRain = 5779,		-- "You'll Feel Right as Rain"

	Scavenger = 1257,		-- "The Scavenger"
	OutlandAngler = 1225,		-- "Outland Angler"
	NorthrendAngler = 1517,		-- "Northrend Angler"
	Limnologist = 5478,		-- "The Limnologist"
	Oceanographer = 5479,		-- "The Oceanographer"
	PandarianAngler = 7611,		-- "Pandarian Angler"

	GourmetOutland = 1800,		-- "The Outland Gourmet"
	GourmetNorthrend = 1779,	-- "The Northrend Gourmet" (last part)
	GourmetCataclysm = 5473,	-- "The Cataclysmic Gourmet" (last part)
	GourmetPandaren = 7327,		-- "The Pandaren Gourmet" (last part)
	--GourmetWinter = 1688,		-- "The Winter Veil Gourmet"

	MediumRare = 1311,		-- "Medium Rare"
	BloodyRare = 1312,		-- "Bloody Rare"
	NorthernExposure = 2256,	-- "Northern Exposure"
	Frostbitten = 2257,		-- "Frostbitten"
	Glorious = 7439,		-- "Glorious!"

	StoodInTheFire = 5518,		-- "Stood in the Fire"
	SurveyingTheDamage = 4827,	-- "Surveying the Damage"
	WhaleShark = 4975,		-- "From Hell's Heart I Stab at Thee"

	LetItSnow = 1687,		-- "Let It Snow"
	FistfulOfLove = 1699,		-- "Fistful of Love"
	BunnyMaker = 2422,		-- "Shake Your Bunny-Maker"
	CheckYourHead = 291,		-- "Check Your Head"
	TurkeyLurkey = 3559,		-- "Turkey Lurkey"

	-- Statistics:
	Stat_ConsumeDrinks = 346,	-- "Beverages consumed"
	Stat_ConsumeFood = 347,		-- "Food eaten"
};


-- Look up the achievement ID of the given zone's exploration achievement, whatever the localization.
-- Using zone names alone isn't reliable because the achievement names don't always use the zone's name as given by
-- functions like GetRealZoneText() with some localizations.

local LBZ = LibStub("LibBabble-SubZone-3.0");
LBZ = LBZ:GetReverseLookupTable()

OVERACHIEVER_EXPLOREZONEID = {
-- Kalimdor:
	["Ashenvale"] = 845,
	["Azshara"] = 852,
	["Darkshore"] = 844,
	["Desolace"] = 848,
	["Durotar"] = 728,
	["Dustwallow Marsh"] = 850,
	["Felwood"] = 853,
	["Feralas"] = 849,
	["Moonglade"] = 855,
	["Mulgore"] = 736,
	["Northern Barrens"] = 750,
	["Silithus"] = 856,
	["Southern Barrens"] = 4996,
	["Stonetalon Mountains"] = 847,
	["Tanaris"] = 851,
	["Teldrassil"] = 842,
	["Thousand Needles"] = 846,
	["Un'Goro Crater"] = 854,
	["Winterspring"] = 857,
   -- Burning Crusade:
	["Azuremyst Isle"] = 860,
	["Bloodmyst Isle"] = 861,
   -- Cataclysm:
	["Mount Hyjal"] = 4863,
	["Uldum"] = 4865,
-- Eastern Kingdoms:
	["Arathi Highlands"] = 761,
	["Badlands"] = 765,
	["Blasted Lands"] = 766,
	["Burning Steppes"] = 775,
	["The Cape of Stranglethorn"] = 4995,
	["Deadwind Pass"] = 777,
	["Dun Morogh"] = 627,
	["Duskwood"] = 778,
	["Eastern Plaguelands"] = 771,
	["Elwynn Forest"] = 776,
	["Hillsbrad Foothills"] = 772,
	["The Hinterlands"] = 773,
	["Loch Modan"] = 779,
	["Northern Stranglethorn"] = 781,
	["Redridge Mountains"] = 780,
	["Searing Gorge"] = 774,
	["Silverpine Forest"] = 769,
	["Swamp of Sorrows"] = 782,
	["Tirisfal Glades"] = 768,
	["Western Plaguelands"] = 770,
	["Westfall"] = 802,
	["Wetlands"] = 841,
	-- Zone removed: ["Alterac Mountains"] = 760,
   -- Burning Crusade:
	["Eversong Woods"] = 859,
	["Ghostlands"] = 858,
	["Isle of Quel'Danas"] = 868,
   -- Cataclysm:
	--["Tol Barad"] = 4867,           -- This achievement ("Explore Tol Barad") was removed from the game
	--["Tol Barad Peninsula"] = 4867, -- due to it being buggy. Note that it may return in a future patch.
	["Twilight Highlands"] = 4866,
	-- Vashj'ir:
	["Vashj'ir"] = 4825,
	["Kelp'thar Forest"] = 4825,
	["Shimmering Expanse"] = 4825,
	["Abyssal Depths"] = 4825,
-- Outland:
	["Blade's Edge Mountains"] = 865,
	["Hellfire Peninsula"] = 862,
	--["Nagrand"] = 866, -- PROBLEM: Name conflict. Two zones with same name now. New/adjusted system needed.
	["Netherstorm"] = 843,
	["Shadowmoon Valley"] = 864,
	["Terokkar Forest"] = 867,
	["Zangarmarsh"] = 863,
-- Northrend:
	["Borean Tundra"] = 1264,
	["Crystalsong Forest"] = 1457,
	["Dragonblight"] = 1265,
	["Grizzly Hills"] = 1266,
	["Howling Fjord"] = 1263,
	["Icecrown"] = 1270,
	["Sholazar Basin"] = 1268,
	["The Storm Peaks"] = 1269,
	["Zul'Drak"] = 1267,
-- Other Cataclysm-related:
	["Deepholm"] = 4864,
-- Pandaria:
	["The Jade Forest"] = 6351,
	["Krasarang Wilds"] = 6975,
	["Kun-Lai Summit"] = 6976,
	["Valley of the Four Winds"] = 6969,
	["Townlong Steppes"] = 6977,
	["Dread Wastes"] = 6978,
	["Vale of Eternal Blossoms"] = 6979,
-- Draenor
	["Frostfire Ridge"] = 8937,
	["Shadowmoon Valley"] = 8938,
	["Gorgrond"] = 8939,
	["Talador"] = 8940,
	["Spires of Arak"] = 8941,
	["Nagrand"] = 8942,
	["Tanaan Jungle"] = 10260,
};
-- "Explore Cataclysm": 4868

function Overachiever.ExploreZoneIDLookup(zoneName)
  local z = LBZ[zoneName] or zoneName
  return OVERACHIEVER_EXPLOREZONEID[z];
end


-- !! These categories no longer exist!! :
OVERACHIEVER_CATEGORY_HEROIC = {
	[14921] = true, -- Lich King Dungeon
	[14923] = true, -- Lich King 25-Player Raid
};
-- !! These categories no longer exist!! :
OVERACHIEVER_CATEGORY_25 = {
	[14923] = true,			-- Lich King 25-Player Raid
	[14962] = true,			-- Secrets of Ulduar 25-Player Raid
	[15002] = true,			-- Call of the Crusade 25-Player Raid
	[15042] = true,			-- Fall of the Lich King 25-Player Raid
};

OVERACHIEVER_HEROIC_CRITERIA = {
	[1658] =			-- "Champions of the Frozen Wastes"
		{ [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true, [10] = true, [11] = true, [12] = true,
		  [13] = true, [14] = true, [15] = true },
};
