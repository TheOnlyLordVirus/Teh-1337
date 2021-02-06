#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

levelFifty()
{
	if (level.players.size > 1)
	{
		self iprintlnbold("^1Too many ^7players in your game!");
		return;
	}

	self maps\mp\gametypes\_persistence::statSet("rankxp", 1262500, false);
	self maps\mp\gametypes\_persistence::statSetInternal("PlayerStatsList", "rankxp", 1262500);
	self.pers["rank"] = 49;
	
	self setRank(49);
	self maps\mp\gametypes\_rank::updateRankAnnounceHUD();
	self iprintlnbold("^5Level 50 Given!");
}

setPrestiges(value)
{
	self.pers["plevel"] = value;
	self.pers["prestige"] = value;
	self setdstat("playerstatslist", "plevel", "StatValue", value);
	self maps\mp\gametypes\_persistence::statSet("plevel", value, true);
	self maps\mp\gametypes\_persistence::statSetInternal("PlayerStatsList", "plevel", value);

	self setRank(self.pers["rank"], value);
	self maps\mp\gametypes\_rank::updateRankAnnounceHUD();

	self freezeControlsAllowLook(false);
	self iprintlnbold("^5Prestige " + value + " Given!");
}

UnlockAll()
{
	if (level.players.size > 1)
	{
		self iprintlnbold("^1Too many ^7players in your game!");
		return;
	}

	perks = [];
	perks[1] = "PERKS_SLEIGHT_OF_HAND";
	perks[2] = "PERKS_GHOST";
	perks[3] = "PERKS_NINJA";
	perks[4] = "PERKS_HACKER";
	perks[5] = "PERKS_LIGHTWEIGHT";
	perks[6] = "PERKS_SCOUT";
	perks[7] = "PERKS_STEADY_AIM";
	perks[8] = "PERKS_DEEP_IMPACT";
	perks[9] = "PERKS_MARATHON";
	perks[10] = "PERKS_SECOND_CHANCE";
	perks[11] = "PERKS_TACTICAL_MASK";
	perks[12] = "PERKS_PROFESSIONAL";
	perks[13] = "PERKS_SCAVENGER";
	perks[14] = "PERKS_FLAK_JACKET";
	perks[15] = "PERKS_HARDLINE";
	for (i = 1; i < 16; i++) //all perks
	{
		perk = perks[i];
		for (j = 0; j < 3; j++) //3 challenges per perk
		{
			self maps\mp\gametypes\_persistence::unlockItemFromChallenge("perkpro " + perk + " " + j);
		}
	}

	setDvar("allItemsUnlocked", "1");
	setDvar("allEmblemsUnlocked", "1");

	self iprintlnbold("All perks ^2unlocked");
}

giveCODPoints()
{
	if (level.players.size > 1)
	{
		self iprintlnbold("^1Too many ^7players in your game!");
		return;
	}
	
	self maps\mp\gametypes\_persistence::statSet("codpoints", 100000000, false);
	self maps\mp\gametypes\_persistence::statSetInternal("PlayerStatsList", "codpoints", 100000000);
	self maps\mp\gametypes\_persistence::setPlayerStat("PlayerStatsList", "CODPOINTS", 100000000);
	self.pers["codpoints"] = 100000000;
	self iprintlnbold("CoD Points ^2given");
}

rankedGame()
{
	if (!level.rankedMatchEnabled)
	{
		level.rankedMatch = true;
		level.contractsEnabled = true;
		setDvar("onlinegame", 1);
		setDvar("xblive_rankedmatch", 1);
		setDvar("xblive_privatematch", 0);
		self iprintlnbold("Ranked match ^2enabled");
		level.rankedMatchEnabled = true;
	}
	
	else 
	{
		self iprintlnbold("Ranked match ^1already ^7enabled");
	}
}
