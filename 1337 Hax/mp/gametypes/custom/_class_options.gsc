#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

randomCamo()
{
	numEro = randomIntRange(1, 16);
	
	weap = self getCurrentWeapon();
	
	myclip = self getWeaponAmmoClip(weap);
    mystock = self getWeaponAmmoStock(weap);
	
	self takeWeapon(weap);
	weaponOptions = self calcWeaponOptions(numEro, 0, 0, 0, 0);
	self GiveWeapon(weap, 0, weaponOptions);
	self switchToWeapon(weap);
	self setSpawnWeapon(weap);
	
	self setweaponammoclip(weap, myclip);
    self setweaponammostock(weap, mystock);
	self.camo = numEro;
	self setPlayerCustomDvar("camo", self.camo);
}

changeCamo(num)
{
	weap = self getCurrentWeapon();
	
	myclip = self getWeaponAmmoClip(weap);
    mystock = self getWeaponAmmoStock(weap);
	
	self takeWeapon(weap);
	weaponOptions = self calcWeaponOptions(num, 0, 0, 0, 0);
	self GiveWeapon(weap, 0, weaponOptions);
	self switchToWeapon(weap);
	self setSpawnWeapon(weap);
	
	self setweaponammoclip(weap, myclip);
    self setweaponammostock(weap, mystock);
	
	self.camo = num;
	self setPlayerCustomDvar("camo", self.camo);
	
	self waittill("death");
	self.camo = 0;
}

givePlayerPerk(perkDesk)
{
	switch (perkDesk)
	{
		case "lightweightPro":
			self thread toggleLightweightPro();
			break;
		case "flakJacketPro":
			self thread toggleFlakJacketPro();
			break;
		case "scoutPro":
			self thread toggleScoutPro();
			break;
		case "sleightOfHandPro":
			self thread toggleSleightOfHandPro();
			break;
		case "ninjaPro":
			self thread toggleNinjaPro();
			break;
		case "hackerPro":
			self thread toggleHackerPro();
			break;
		case "tacticalMaskPro":
			self thread toggleTacticalMaskPro();
			break;
		default:
			self iprintln("^1Error: an invalid perk attempted to be given to a player.");
			break;
	}
}

toggleLightweightPro()
{
	if (self HasPerk("specialty_fallheight") && self hasPerk("specialty_movefaster"))
	{
		self UnSetPerk("specialty_fallheight");
		self UnSetPerk("specialty_movefaster");
		self setPlayerCustomDvar("lightweight", "0");
	}
	else 
	{
		self SetPerk("specialty_fallheight");
		self SetPerk("specialty_movefaster");
		self setPlayerCustomDvar("lightweight", "1");
		self maps\mp\gametypes\_hud_util::showPerk( 0, "perk_lightweight_pro", 10);
		wait 1;
		self maps\mp\gametypes\_hud_util::hidePerk( 0, 1);
	}
}

toggleFlakJacketPro()
{
	if (self HasPerk("specialty_flakjacket") && self hasPerk("specialty_fireproof") && self hasPerk("specialty_pin_back"))
	{
		self UnSetPerk("specialty_flakjacket");
		self UnSetPerk("specialty_fireproof");
		self UnSetPerk("specialty_pin_back");
		self setPlayerCustomDvar("flakJacket", "0");
	}
	else 
	{
		self SetPerk("specialty_flakjacket");
		self SetPerk("specialty_fireproof");
		self SetPerk("specialty_pin_back");
		self setPlayerCustomDvar("flakJacket", "1");

		self maps\mp\gametypes\_hud_util::showPerk( 0, "perk_flak_jacket_pro", 10);
		wait 1;
		self maps\mp\gametypes\_hud_util::hidePerk( 0, 1);
	}
}

toggleScoutPro()
{
	if (self HasPerk("specialty_holdbreath") && self hasPerk("specialty_fastweaponswitch"))
	{
		self UnSetPerk("specialty_holdbreath");
		self UnSetPerk("specialty_fastweaponswitch");
		self setPlayerCustomDvar("scout", "0");
	}
	else 
	{
		self SetPerk("specialty_holdbreath");
		self SetPerk("specialty_fastweaponswitch");
		self setPlayerCustomDvar("scout", "1");
		self maps\mp\gametypes\_hud_util::showPerk( 0, "perk_scout_pro", 10);
		wait 1;
		self maps\mp\gametypes\_hud_util::hidePerk( 0, 1);
	}
}

toggleSleightOfHandPro()
{
	if (self HasPerk("specialty_fastreload") && self hasPerk("specialty_fastads"))
	{
		self UnSetPerk("specialty_fastreload");
		self UnSetPerk("specialty_fastads");
		self setPlayerCustomDvar("sleightOfHand", "0");
	}
	else 
	{
		self SetPerk("specialty_fastreload");
		self SetPerk("specialty_fastads");
		self setPlayerCustomDvar("sleightOfHand", "1");
		self maps\mp\gametypes\_hud_util::showPerk( 0, "perk_sleight_of_hand_pro", 10);
		wait 1;
		self maps\mp\gametypes\_hud_util::hidePerk( 0, 1);
	}
}

toggleNinjaPro()
{
	if (self HasPerk("specialty_quieter") && self hasPerk("specialty_loudenemies"))
	{
		self UnSetPerk("specialty_quieter");
		self UnSetPerk("specialty_loudenemies");
		self setPlayerCustomDvar("ninja", "0");
	}
	else 
	{
		self SetPerk("specialty_quieter");
		self SetPerk("specialty_loudenemies");
		self setPlayerCustomDvar("ninja", "1");
		self maps\mp\gametypes\_hud_util::showPerk( 0, "perk_ninja_pro", 10);
		wait 1;
		self maps\mp\gametypes\_hud_util::hidePerk( 0, 1);
	}
}

toggleHackerPro()
{
	if (self HasPerk("specialty_detectexplosive") && self hasPerk("specialty_showenemyequipment") && self hasPerk("specialty_disarmexplosive") && self hasPerk("specialty_nomotionsensor"))
	{
		self UnSetPerk("specialty_detectexplosive");
		self UnSetPerk("specialty_showenemyequipment");
		self UnSetPerk("specialty_disarmexplosive");
		self UnSetPerk("specialty_nomotionsensor");
		self setPlayerCustomDvar("hacker", "0");
	}
	else 
	{
		self SetPerk("specialty_detectexplosive");
		self SetPerk("specialty_showenemyequipment");
		self SetPerk("specialty_disarmexplosive");
		self SetPerk("specialty_nomotionsensor");
		self setPlayerCustomDvar("hacker", "1");
		self maps\mp\gametypes\_hud_util::showPerk( 0, "perk_hacker_pro", 10);
		wait 1;
		self maps\mp\gametypes\_hud_util::hidePerk( 0, 1);
	}
}

toggleTacticalMaskPro()
{
	if (self HasPerk("specialty_gas_mask") && self hasPerk("specialty_stunprotection") && self hasPerk("specialty_shades"))
	{
		self UnSetPerk("specialty_gas_mask");
		self UnSetPerk("specialty_stunprotection");
		self UnSetPerk("specialty_shades");
		self setPlayerCustomDvar("tacMask", "0");
	}
	else 
	{
		self SetPerk("specialty_gas_mask");
		self SetPerk("specialty_stunprotection");
		self SetPerk("specialty_shades");
		self setPlayerCustomDvar("tacMask", "1");
		self maps\mp\gametypes\_hud_util::showPerk( 0, "perk_tactical_mask_pro", 10);
		wait 1;
		self maps\mp\gametypes\_hud_util::hidePerk( 0, 1);
	}
}

givePlayerAttachment(attachment)
{
    weapon = self GetCurrentWeapon();

    opticAttach = "";
    underBarrelAttach = "";
    clipAttach = "";
	attachmentAttach = "";

    opticWeap = "";
    underBarrelWeap = "";
    clipWeap = "";
	attachmentWeap = "";

	weaponToArray = strTok(weapon, "_");
	for (i = 0; i < weaponToArray.size; i++)
	{
		if (isAttachmentOptic(weaponToArray[i]))
		{
			opticAttach = weaponToArray[i];
		}

		if (isAttachmentUnderBarrel(weaponToArray[i]))
		{
			underBarrelAttach = weaponToArray[i];
		}

		if (isAttachmentClip(weaponToArray[i]))
		{
			clipAttach = weaponToArray[i];
		}

        if (weaponToArray[i] != "mp" && !isAttachmentClip(weaponToArray[i]) && !isAttachmentUnderBarrel(weaponToArray[i]) && !isAttachmentOptic(weaponToArray[i]) && weaponToArray[i] != weaponToArray[0])
        {
            attachmentWeap = weaponToArray[i];
        }
	}

	baseWeapon = weaponToArray[0];
	number = weaponNameToNumber(baseWeapon);

	itemRow = tableLookupRowNum("mp/statsTable.csv", level.cac_numbering, number);
	compatibleAttachments = tableLookupColumnForRow("mp/statstable.csv", itemRow, level.cac_cstring);
	if (!isSubStr(compatibleAttachments, attachment))
	{
		return;
	}

	if (attachmentWeap == attachment)
	{
		return;
	}

	if (isSubStr(baseWeapon, "dw"))
	{
		baseWeapon = getSubStr(baseWeapon, 0, baseWeapon.size - 2);
	}

	if (isSubStr(attachment, "dw"))
	{
		newWeapon = baseWeapon + "dw_mp";

		if (isDefined(self.camo))
		{
			weaponOptions = self calcWeaponOptions(self.camo, 0, 0, 0, 0);
		}
		
		else 
		{
			self.camo = 0;
			weaponOptions = self calcWeaponOptions(self.camo, 0, 0, 0, 0);
		}

		self takeWeapon(weapon);
		self GiveWeapon(newWeapon, 0, weaponOptions);
		self setSpawnWeapon(newWeapon);
		return;
	}

    if (isAttachmentOptic(attachment))
    {
        opticWeap = attachment + "_";
    }
    else if(isAttachmentUnderBarrel(attachment))
    {
        underBarrelWeap = attachment + "_";
    }
    else if(isAttachmentClip(attachment))
    {
        clipWeap = attachment + "_";
    }
	else if(!isAttachmentOptic(attachment) && !isAttachmentUnderBarrel(attachment) && !isAttachmentClip(attachment))
	{
		attachmentWeap = attachment + "_";
	}

	if (opticAttach == attachment)
	{
		opticAttach = "";
		opticWeap = "";
	}

	if (underBarrelAttach == attachment)
	{
		underBarrelAttach = "";
		underBarrelWeap = "";
	}

	if (clipAttach == attachment)
	{
		clipAttach = "";
		clipWeap = "";
	}

	if (attachmentWeap != "")
	{
		if (!isAttachmentOptic(attachmentWeap) && !isAttachmentUnderBarrel(attachmentWeap) && !isAttachmentClip(attachmentWeap))
		{
			if (!isAttachmentOptic(attachment) && !isAttachmentUnderBarrel(attachment) && !isAttachmentClip(attachment))
			{
				attachmentWeap = attachment + "_";
			}
		}
	}

	if (opticAttach != "" && opticWeap == "")
    {
        opticWeap = opticAttach + "_";
    }

    if (underBarrelAttach != "" && underBarrelWeap == "")
    {
        underBarrelWeap = underBarrelAttach + "_";
    }

    if (clipAttach != "" && clipWeap == "")
    {
        clipWeap = clipAttach + "_";
    }

	if (attachmentWeap != "")
	{
		if(!isSubStr(attachmentWeap, "_"))
        {
			attachmentWeap = attachmentWeap + "_";
        }
    }
	
    self takeWeapon(weapon);

	newWeapon = baseWeapon + "_" + opticWeap + underBarrelWeap + clipWeap + attachmentWeap + weaponToArray[weaponToArray.size - 1];
    
	if (isDefined(self.camo))
	{
		weaponOptions = self calcWeaponOptions(self.camo, 0, 0, 0, 0);
	}
	else 
	{
		self.camo = 15;
		weaponOptions = self calcWeaponOptions(self.camo, 0, 0, 0, 0);
	}

    self GiveWeapon(newWeapon, 0, weaponOptions);
    self setSpawnWeapon(newWeapon);
}

removeAllAttachments()
{
	weapon = self GetCurrentWeapon();

	weaponToArray = strTok(weapon, "_");
	baseWeapon = weaponToArray[0];
	newWeapon = baseWeapon + "_mp";

	if (isSubStr(baseWeapon, "dw"))
	{
		baseWeaponOnly = getSubStr(baseWeapon, 0, baseWeapon.size - 2);
		newWeapon = baseWeaponOnly + "_mp";

		if (isDefined(self.camo))
		{
			weaponOptions = self calcWeaponOptions(self.camo, 0, 0, 0, 0);
		}
		else 
		{
			self.camo = 15;
			weaponOptions = self calcWeaponOptions(self.camo, 0, 0, 0, 0);
		}
		
		self TakeWeapon(weapon);
		self GiveWeapon(newWeapon, 0, weaponOptions);
		self setSpawnWeapon(newWeapon);
		return;
	}

	self TakeWeapon(weapon);

	if (isDefined(self.camo))
	{
		weaponOptions = self calcWeaponOptions(self.camo, 0, 0, 0, 0);
	}
	else 
	{
		self.camo = 15;
		weaponOptions = self calcWeaponOptions(self.camo, 0, 0, 0, 0);
	}

    self GiveWeapon(newWeapon, 0, weaponOptions);
	self setSpawnWeapon(newWeapon);
}

isAttachmentOptic(attachment)
{
	switch (attachment)
	{
		case "vzoom":
		case "acog":
		case "ir":
		case "reflex":
		case "elbit":
			return true;
		default:
			return false;
	}
}

isAttachmentUnderBarrel(attachment)
{
	if (isSubStr(attachment, "mk") || isSubStr(attachment, "ft") || isSubStr(attachment, "gl"))
	{
		return true;
	}

	return false;
}

isAttachmentClip(attachment)
{
	if (isSubStr(attachment, "extclip") || isSubStr(attachment, "dualclip"))
	{
		return true;
	}

	return false;
}

giveUserKillstreak(killstreak)
{
	self maps\mp\gametypes\_hardpoints::giveKillstreak(killstreak);
}

weaponNameToNumber(weaponName)
{
    weaponNameLower = toLower(weaponName);
	switch (weaponNameLower)
    {
        //MP
        case "mp5k":
            return 15;
        case "skorpion":
            return 18;
        case "mac11":
            return 14;
        case "ak74u":
            return 12;
        case "uzi":
            return 20;
        case "pm63":
            return 17;
        case "mpl":
            return 16;
        case "spectre":
            return 19;
        case "kiparis":
            return 13;
        //AR
        case "m16":
            return 35;
        case "enfield":
            return 29;
        case "m14":
            return 34;
        case "famas":
            return 30;
        case "galil":
            return 33;
        case "aug":
            return 27;
        case "fnfal":
            return 31;
        case "ak47":
            return 26;
        case "commando":
            return 28;
        case "g11":
            return 32;
        //Shotgun
        case "rottweil72":
            return 49;
        case "ithaca":
            return 48;
        case "spas":
            return 50;
        case "hs10":
            return 47;
        //LMG
        case "hk21":
            return 37;
        case "rpk":
            return 39;
        case "m60":
            return 38;
        case "stoner63":
            return 40;
        //Sniper
        case "dragunov":
            return 42;
        case "wa2000":
            return 45;
        case "l96a1":
            return 43;
        case "psg1":
            return 44;
        //Pistol
        case "asp":
            return 1;
        case "m1911":
            return 3;
        case "makarov":
            return 4;
        case "python":
            return 5;
        case "cz75":
            return 2;
        //Launcher
        case "m72_law":
            return 53;
        case "rpg":
            return 54;
        case "strela":
            return 55;
        case "china_lake":
            return 57;
        //Special
        case "crossbow_explosive":
            return 56;
        default:
            return 0;
    }
}

checkGivenPerks()
{
	if (self getPlayerCustomDvar("lightweight") == "1")
	{
		self SetPerk("specialty_fallheight");
		self SetPerk("specialty_movefaster");
	}

	if (self getPlayerCustomDvar("flakJacket") == "1")
	{
		self SetPerk("specialty_flakjacket");
		self SetPerk("specialty_fireproof");
		self SetPerk("specialty_pin_back");
	}

	if (self getPlayerCustomDvar("scout") == "1")
	{
		self SetPerk("specialty_holdbreath");
		self SetPerk("specialty_fastweaponswitch");
	}

	if (self getPlayerCustomDvar("sleightOfHand") == "1")
	{
		self SetPerk("specialty_fastreload");
		self SetPerk("specialty_fastads");
	}

	if (self getPlayerCustomDvar("ninja") == "1")
	{
		self SetPerk("specialty_quieter");
		self SetPerk("specialty_loudenemies");
	}

	if (self getPlayerCustomDvar("hacker") == "1")
	{
		self SetPerk("specialty_detectexplosive");
		self SetPerk("specialty_showenemyequipment");
		self SetPerk("specialty_disarmexplosive");
		self SetPerk("specialty_nomotionsensor");
	}

	if (self getPlayerCustomDvar("tacMask") == "1")
	{
		self SetPerk("specialty_gas_mask");
		self SetPerk("specialty_stunprotection");
		self SetPerk("specialty_shades");
	}
}

giveGrenade(grenade)
{
	primaryWeapons = self GetWeaponsListPrimaries();
	offHandWeapons = array_exclude(self GetWeaponsList(), primaryWeapons);
	offHandWeapons = array_remove(offHandWeapons, "knife_mp");

	for (i = 0; i < offHandWeapons.size; i++)
	{
		weapon = offHandWeapons[i];
		if (isHackWeapon(weapon) || isLauncherWeapon(weapon))
		{
			continue;
		}

		switch (weapon)
		{
			case "frag_grenade_mp":
			case "sticky_grenade_mp":
			case "hatchet_mp":
				self TakeWeapon(weapon);
				self GiveWeapon(grenade);
				self GiveStartAmmo(grenade);
				break;
			default:
				break;
		}
	}
}

giveUserTacticals(tactical)
{
	prim = self GetWeaponsListPrimaries();
	offHand = array_exclude(self GetWeaponsList(), prim);

	for (i = 0; i < offHand.size; i++)
	{
		weap = offHand[i];
		switch (weap)
		{
			case "willy_pete_mp":
			case "tabun_gas_mp":
			case "flash_grenade_mp":
			case "concussion_grenade_mp":
			case "nightingale_mp":
				self TakeWeapon(weap);
				self GiveWeapon(tactical);
				self GiveStartAmmo(tactical);
				break;
			default:
				break;
		}
	}
}

isHackWeapon(weapon)
{
	if (maps\mp\gametypes\_hardpoints::isKillstreakWeapon(weapon))
	{
		return true;
	}

	if (weapon == "briefcase_bomb_mp")
	{
		return true;
	}

	return false;
}

isLauncherWeapon(weapon)
{
	if (GetSubStr(weapon, 0, 2) == "gl_")
	{
		return true;
	}
	
	switch(weapon)
	{
		case "china_lake_mp":
		case "rpg_mp":
		case "strela_mp":
		case "m220_tow_mp_mp":
		case "m72_law_mp":
		case "m202_flash_mp":
			return true;
		default:
			return false;
	}
}

setPlayerCustomDvar(dvar, value) 
{
	dvar = self getXUID() + "_" + dvar;
	setPlayerCustomDvar(dvar, value);
}

getPlayerCustomDvar(dvar) 
{
	dvar = self getXUID() + "_" + dvar;
	return getDvar(dvar);
}