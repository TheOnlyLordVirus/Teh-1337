#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_globallogic_score;

// Custom files thanks to @CenturyMD on Twitter
#include maps\mp\gametypes\custom\_account_options;
#include maps\mp\gametypes\custom\_class_options;

///////////////////
///Mod Menu Stuff///
/////////////////////
init()
{
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	while(true)
	{
		level waittill("connected",player);
		if(!isDefined(player.pers["postGameChallenges"]))player.pers["postGameChallenges"]=0;
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon("Stop_Menu");
	self endon("disconnect");
	self.FirstOpen = true;
	
	while(true)
	{
		self waittill("spawned_player");
		self iPrintlnBold("^6Created ^5By^7: ^6Lord ^5Virus");
		self thread startMenu();
		self waittill("death");
		if(self.MenuOpen)
		{
			self closeMenu();
		}
	}
}

startMenu()
{
	// End thread on disconnect.
	self endon("stop_menu");
	self endon("death");
	self endon("disconnect");
	
	// Walk durring grace.
	self freezecontrols(false);
	
	// The menu starts closed in memory.
	self.MenuOpen = false;
	self.MenuIndex = 0;
	self.CurrentMenu = undefined;
	
	// Loop every 300 milliseconds.
	while(true)
	{
		// Not in the menu.
		if(!self.MenuOpen)
		{
			// Aim and knife to open menu.
			if(self meleebuttonpressed() && self adsbuttonpressed() && !self.MenuOpen)
			{
				self thread openMenu();
				wait 0.3;
			}
			
			// Noclip.
			else if(self ActionSlotThreeButtonPressed())
			{
				self ToggleNoclip();
				wait 0.3;
			}
			
			// Godmode.
			else if(self ActionSlotTwoButtonPressed())
			{
				self ToggleGodMode();
				wait 0.3;
			}
		}
		
		// In the menu.
		if(self.MenuOpen)
		{
			// Scroll up.
			if(self ActionSlotOneButtonPressed())
			{
				self scrollUp();
				wait 0.1;
			}
			
			// Scroll down.
			else if(self ActionSlotTwoButtonPressed())
			{
				self scrollDown();
				wait 0.1;
			}
			
			// Select option.
			else if(self JumpButtonPressed())
			{
				self thread [[self.menuAction[self.CurrentMenu].functions[self.MenuIndex]]](self.menuAction[self.CurrentMenu].input[self.MenuIndex]);
				wait 0.3;
			}
			
			// Knife to close or go back.
			else if(self meleebuttonpressed() && !(self adsbuttonpressed()) && self.MenuOpen)
			{
				if(self.CurrentMenu == "main")
				{
					self closeMenu();
				}
				
				else
				{
					menuIndex = 0;
					self.MenuScrollBar.y = -160;
					self drawMenuText(self.menuAction[self.CurrentMenu].parent);
				}
				
				wait 0.3;
			}
		}
		
		// Wait a 300 milliseconds.
		wait 0.01;
	}
}

////////////////////
///Random Functions//
//////////////////////

// Opens the mod menu.
openMenu()
{
	self freezecontrols(false);
	self iprintln("^5Menu opening");
	self.CurrentMenu = "main";
	self.MenuOpen = true;
	
	// Create all hud elements on first menu load.
	if(self.FirstOpen)
	{
		createMenus();
		self.FirstOpen = false;
		self.MenuBackground = createRectangle("CENTER", "", 180, -70, 200, 300, (0, 0, 0), "white", 1, .7);
		self.MenuHeaderBackground = createRectangle("CENTER", "", 180, -205, 200, 30, (0, 150, 200), "white", 1, 1);
		self.MenuScrollBar = createRectangle("CENTER", "", 180, self.MenuScrollStartYPos, 200, 20, (0, 150, 200), "white", 1, 1);
		self.HeaderText = self createText("big", 3, "CENTER", "", 180, -205, 2, 1, 230, "^2Teh 1337"); 
		self.CurrentMenuText = self createText("default", 2, "CENTER", "", 180, -180, 2, 1, 230, "^1" + self.menuAction[self.CurrentMenu].title);
		self buildMenuText();
	}
	
	// Show elements.
	else
	{
		self.MenuBackground.alpha = .7;
		self.MenuHeaderBackground.alpha = 1;
		self.MenuScrollBar.alpha = 1;
		self.HeaderText.alpha = 1;
		self drawMenuText(self.CurrentMenu);
		self.CurrentMenuText.alpha = 1;
		for(i = 0; i < self.Options.size; i++)
		{
			self.Options[i].alpha = 1;
		}
	}
}

// Closes the mod menu.
closeMenu()
{
	self.MenuOpen = false;
	self.MenuIndex = 0;
	self iprintln("^1Menu closing");
	self.MenuBackground.alpha = 0;
	self.MenuHeaderBackground.alpha = 0;
	self.MenuScrollBar.alpha = 0;
	self.HeaderText.alpha = 0;
	self.CurrentMenuText.alpha = 0;
	
	for(i = 0; i < self.Options.size; i++)
	{
		self.Options[i].alpha = 0;
	}
}

// Scrolling...
scrollUp()
{
	if(self.MenuIndex > 0)
	{
		self.MenuIndex--;
		self.MenuScrollBar moveOverTime(.15);
		self.MenuScrollBar.y = self.MenuScrollBar.y - 20;
	}
	
	else
	{
		self.MenuIndex = self.menuAction[self.CurrentMenu].options.size - 1;
		self.MenuScrollBar.y = self.MenuScrollStartYPos + ((self.menuAction[self.CurrentMenu].options.size - 1) * 20);
	}
}

scrollDown()
{
	if(self.MenuIndex < self.menuAction[self.CurrentMenu].options.size - 1)
	{
		self.MenuIndex++;
		self.MenuScrollBar moveOverTime(.15);
		self.MenuScrollBar.y = self.MenuScrollBar.y + 20;
	}
	
	else
	{
		self.MenuIndex = 0;
		self.MenuScrollBar.y = self.MenuScrollStartYPos;
	}
}

// Create all of the elements for the mod menu text.
buildMenuText()
{
	y = -160;
	for(i = 0; i < self.MenuOptionCount; i++)
	{
		self.Options[i] = self createText("objective", 2, "CENTER", "", 180, y, 2, 1, 230, "^6" + self.menuAction["main"].options[i]);
		y += 20;
	}
	
	self.MenuIndex = 0;
	self.MenuScrollBar moveOverTime(.15);
	self.MenuScrollBar.y = self.MenuScrollStartYPos;
}

// Change the textElem's text within the "CurrentMenuText" array of textElem's 
drawMenuText(menu)
{
	self.CurrentMenuText setText("^1" + self.menuAction[menu].title);
	
	for(i = 0; i < self.MenuOptionCount; i++)
	{
		if(i < self.menuAction[menu].options.size)
		{
			self.Options[i] setText("^6" + self.menuAction[menu].options[i]);
		}
		
		else
		{
			self.Options[i] setText("");
		}
	}
	
	// Reset scroll bar.
	self.CurrentMenu = menu;
	self.MenuIndex = 0;
	self.MenuScrollBar moveOverTime(.15);
	self.MenuScrollBar.y = self.MenuScrollStartYPos;
}

// Not my code but very useful, thanks to whoever wrote this function that creates structs. 
addMenu(menu, title, parent)
{
    if(!isDefined(self.menuAction))
	self.menuAction = [];
    self.menuAction[menu] = spawnStruct();
    self.menuAction[menu].title = title;
    self.menuAction[menu].parent = parent;
    self.menuAction[menu].options = [];
    self.menuAction[menu].functions = [];
}
 
addOption(menu, opt, func, inp)
{
    m = self.menuAction[menu].options.size;
    self.menuAction[menu].options[m] = opt;
    self.menuAction[menu].functions[m] = func;
	self.menuAction[menu].input[m] = inp;
}

// Create all of the menus.
createMenus()
{
	self.MenuOptionCount = 12;
	self.MenuScrollStartYPos = -160;
	
	// Main menu.
	MainMenu = "main";
    self addMenu(MainMenu, "Main Menu", undefined);
	self addOption(MainMenu, "Account Menu", ::drawMenuText, "account");
    self addOption(MainMenu, "Main Mods", ::drawMenuText, "mod");
	self addOption(MainMenu, "Fun Menu", ::drawMenuText, "fun");
	self addOption(MainMenu, "Messages Menu", ::drawMenuText, "message");
	self addOption(MainMenu, "Weapons Menu", ::drawMenuText, "weapon");
	self addOption(MainMenu, "Class Menu", ::drawMenuText, "class");
	self addOption(MainMenu, "Bullets Menu", ::drawMenuText, "bullet");
	self addOption(MainMenu, "Killstreak Menu", ::drawMenuText, "killstreak");
	self addOption(MainMenu, "Aimbot Menu", ::drawMenuText, "aimbot");
	self addOption(MainMenu, "Host Menu", ::drawMenuText, "host");
	self addOption(MainMenu, "Game Settings", ::drawMenuText, "game");
	self addOption(MainMenu, "Client Menu", ::drawMenuText, "client");
	
	// Account menu.
	MenuName = "account";
    self addMenu(MenuName, "Account Menu", MainMenu);
	self addOption(MenuName, "Level 50", ::levelFifty, undefined);
    self addOption(MenuName, "Prestige 15", ::setPrestiges, 15);
	self addOption(MenuName, "Max Cod Points", ::giveCODPoints, undefined);
	self addOption(MenuName, "Unlock All", ::UnlockAll, undefined);
	self addOption(MenuName, "Ranked Match", ::rankedGame, undefined);
	
	// Main mods menu.
	MenuName = "mod";
    self addMenu(MenuName, "Main Mods", MainMenu);
	self addOption(MenuName, "Godmode", ::ToggleGodMode, undefined);
    self addOption(MenuName, "No Clip", ::ToggleNoclip, undefined);
	self addOption(MenuName, "Feild Of View", ::ToggleFOV, 120);
	self addOption(MenuName, "Infinite Ammo", ::ToggleInfiniteAmmo, undefined);
	self addOption(MenuName, "Cheaters Infections", ::InfectCheats, undefined);
	self addOption(MenuName, "Suicide", ::selfSuicide, undefined);
	
	// Fun menu.
	MenuName = "fun";
    self addMenu(MenuName, "Fun Menu", MainMenu);
	self addOption(MenuName, "Fly Jet", ::startPlaneThread, undefined);
    self addOption(MenuName, "Disco Sun", ::discoSun, undefined);
	
	// Messages menu.
	MenuName = "message";
    self addMenu(MenuName, "Messages Menu", MainMenu);
	self addOption(MenuName, "Creator Love", ::GlobaliPrintlnBold, "^6Created by^7: ^5^FLord Virus");
    self addOption(MenuName, "Fuck You", ::GlobaliPrintlnBold, "^1Fuck you");
	self addOption(MenuName, "Lol", ::GlobaliPrintlnBold, "^5Lol");
	self addOption(MenuName, "Whos Hacking?", ::GlobaliPrintlnBold, "^2Whos ^FHacking?");
	self addOption(MenuName, "Modding Is Fun!", ::GlobaliPrintlnBold, "^5Modding is fun!");
	self addOption(MenuName, "With Great Power...", ::GlobaliPrintlnBold, "^2With great power comes great responsibility.");
	self addOption(MenuName, "Don't Be A Dick", ::GlobaliPrintlnBold, "^5Don't Be A Dick");
	self addOption(MenuName, "Special Thanks", ::GlobaliPrintlnBold, "^5Special thanks to @CenturyMD on Twitter for his attatchment and rank GSC scripts!");
	self addOption(MenuName, "Message 9", ::GlobaliPrintlnBold, "This is the default message, you can change it in _clientids.gsc");
	self addOption(MenuName, "Message 10", ::GlobaliPrintlnBold, "This is the default message, you can change it in _clientids.gsc");
	self addOption(MenuName, "Message 11", ::GlobaliPrintlnBold, "This is the default message, you can change it in _clientids.gsc");
	self addOption(MenuName, "Message 12", ::GlobaliPrintlnBold, "This is the default message, you can change it in _clientids.gsc");
	
	// Weapons menu.
	MenuName = "weapon";
    self addMenu(MenuName, "Weapons Menu", MainMenu);
	self addOption(MenuName, "Primary Weapons", ::drawMenuText, "primary");
	self addOption(MenuName, "Secondary Weapons", ::drawMenuText, "secondary");
	self addOption(MenuName, "Glitch Weapons", ::drawMenuText, "glitch");
	self addOption(MenuName, "Take Current Weapon", ::takeUserWeapon, undefined);
	self addOption(MenuName, "Drop Current Weapon", ::dropUserWeapon, undefined);
	self addOption(MenuName, "Give All", ::giveAll, undefined); // Need to create a toggle of sorts, will not reset on Take All.
	self addOption(MenuName, "Take All", ::takeAll, undefined);
	
	///////////////////////
	// Weapons sub menus //
	////////////////////////
	
	MenuName = "primary";
    self addMenu(MenuName, "Primary Weapons", "weapon");
	self addOption(MenuName, "Sub-Machine Guns", ::drawMenuText, "smg");
    self addOption(MenuName, "Large Machine Guns", ::drawMenuText, "lmg");
	self addOption(MenuName, "Assault Rifles", ::drawMenuText, "assault");
	self addOption(MenuName, "Shotguns", ::drawMenuText, "shotgun");
	self addOption(MenuName, "Sniper Rifles", ::drawMenuText, "sniper");

	MenuName = "secondary";
    self addMenu(MenuName, "Secondary Weapons", "weapon");
	self addOption(MenuName, "Pistols", ::drawMenuText, "pistol");
	self addOption(MenuName, "Launchers", ::drawMenuText, "launcher");
	self addOption(MenuName, "Special Weapons", ::drawMenuText, "special");
	
	MenuName = "glitch";
    self addMenu(MenuName, "Glitch Weapons", "weapon");
	self addOption(MenuName, "Syrette", ::giveUserWeapon, "syrette_mp");
	self addOption(MenuName, "Briefcase Bomb", ::giveUserWeapon, "briefcase_bomb_mp");
	self addOption(MenuName, "Autoturret", ::giveUserWeapon, "autoturret_mp");
	self addOption(MenuName, "ASP", ::giveUserWeapon, "asplh_mp");
	self addOption(MenuName, "M1911", ::giveUserWeapon, "m1911lh_mp");
	self addOption(MenuName, "Makarov", ::giveUserWeapon, "makarovlh_mp");
	self addOption(MenuName, "Python", ::giveUserWeapon, "pythonlh_mp");
	self addOption(MenuName, "CZ75", ::giveUserWeapon, "cz75lh_mp");
	
	MenuName = "smg";
    self addMenu(MenuName, "Sub-Machine Guns", "primary");
	self addOption(MenuName, "MP5K", ::giveUserWeapon, "mp5k_mp");
	self addOption(MenuName, "Skorpion", ::giveUserWeapon, "skorpion_mp");
	self addOption(MenuName, "MAC11", ::giveUserWeapon, "mac11_mp");
	self addOption(MenuName, "AK74u", ::giveUserWeapon, "ak74u_mp");
	self addOption(MenuName, "UZI", ::giveUserWeapon, "uzi_mp");
	self addOption(MenuName, "PM63", ::giveUserWeapon, "pm63_mp");
	self addOption(MenuName, "MPL", ::giveUserWeapon, "mpl_mp");
	self addOption(MenuName, "Spectre", ::giveUserWeapon, "spectre_mp");
	self addOption(MenuName, "Kiparis", ::giveUserWeapon, "kiparis_mp");
	
	MenuName = "lmg";
    self addMenu(MenuName, "Large Machine Guns", "primary");
	self addOption(MenuName, "HK21", ::giveUserWeapon, "hk21_mp");
	self addOption(MenuName, "RPK", ::giveUserWeapon, "rpk_mp");
	self addOption(MenuName, "M60", ::giveUserWeapon, "m60_mp");
	self addOption(MenuName, "Stoner63", ::giveUserWeapon, "stoner63_mp");
	
	MenuName = "assault";
    self addMenu(MenuName, "Assault Rifles", "primary");
	self addOption(MenuName, "M16", ::giveUserWeapon, "m16_mp");
	self addOption(MenuName, "Enfield", ::giveUserWeapon, "enfield_mp");
	self addOption(MenuName, "M14", ::giveUserWeapon, "m14_mp");
	self addOption(MenuName, "Famas", ::giveUserWeapon, "famas_mp");
	self addOption(MenuName, "Galil", ::giveUserWeapon, "galil_mp");
	self addOption(MenuName, "AUG", ::giveUserWeapon, "aug_mp");
	self addOption(MenuName, "FN FAL", ::giveUserWeapon, "fnfal_mp");
	self addOption(MenuName, "AK47", ::giveUserWeapon, "ak47_mp");
	self addOption(MenuName, "Commando", ::giveUserWeapon, "commando_mp");
	self addOption(MenuName, "G11", ::giveUserWeapon, "g11_mp");
	
	MenuName = "shotgun";
    self addMenu(MenuName, "Shotguns", "primary");
	self addOption(MenuName, "Olympia", ::giveUserWeapon, "rottweil72_mp");
	self addOption(MenuName, "Stakeout", ::giveUserWeapon, "ithaca_grip_mp");
	self addOption(MenuName, "SPAS-12", ::giveUserWeapon, "spas_mp");
	self addOption(MenuName, "HS10", ::giveUserWeapon, "hs10_mp");
	
	MenuName = "sniper";
    self addMenu(MenuName, "Snipers", "primary");
	self addOption(MenuName, "Dragunov", ::giveUserWeapon, "dragunov_mp");
	self addOption(MenuName, "WA2000", ::giveUserWeapon, "wa2000_mp");
	self addOption(MenuName, "L96A1", ::giveUserWeapon, "l96a1_mp");
	self addOption(MenuName, "PSG1", ::giveUserWeapon, "psg1_mp");
	
	MenuName = "pistol";
    self addMenu(MenuName, "Pistols", "secondary");
	self addOption(MenuName, "ASP", ::giveUserWeapon, "asp_mp");
	self addOption(MenuName, "M1911", ::giveUserWeapon, "m1911_mp");
	self addOption(MenuName, "Makarov", ::giveUserWeapon, "makarov_mp");
	self addOption(MenuName, "Python", ::giveUserWeapon, "python_mp");
	self addOption(MenuName, "CZ75", ::giveUserWeapon, "cz75_mp");
	
	MenuName = "launcher";
    self addMenu(MenuName, "Launchers", "secondary");
	self addOption(MenuName, "M72 LAW", ::giveUserWeapon, "m72_law_mp");
	self addOption(MenuName, "RPG", ::giveUserWeapon, "rpg_mp");
	self addOption(MenuName, "Strela-3", ::giveUserWeapon, "strela_mp");
	self addOption(MenuName, "China Lake", ::giveUserWeapon, "china_lake_mp");
	
	MenuName = "special";
    self addMenu(MenuName, "Special Weapons", "secondary");
	self addOption(MenuName, "Ballistic Knife", ::giveUserWeapon, "knife_ballistic_mp");
	self addOption(MenuName, "Crossbow", ::giveUserWeapon, "crossbow_explosive_mp");
	
	////////////////////////

	MenuName = "class";
    self addMenu(MenuName, "Class Menu", MainMenu);
	self addOption(MenuName, "Attachments", ::drawMenuText, "attachment");
    self addOption(MenuName, "Camos", ::drawMenuText, "camo");
	self addOption(MenuName, "Grenades", ::drawMenuText, "grenade");
	self addOption(MenuName, "Tactical", ::drawMenuText, "tactical");
	self addOption(MenuName, "Equipment", ::drawMenuText, "equipment");
	self addOption(MenuName, "Perks", ::drawMenuText, "perk");
	
	MenuName = "attachment";
	self addMenu(MenuName, "Attachments", "class");
	self addOption(MenuName, "Give Silencer", ::givePlayerAttachment, "silencer");
	self addOption(MenuName, "Toggle Extended Clip", ::givePlayerAttachment, "extclip");
	self addOption(MenuName, "Toggle Variable Zoom", ::givePlayerAttachment, "vzoom");
	self addOption(MenuName, "Toggle IR", ::givePlayerAttachment, "ir");
	self addOption(MenuName, "Toggle ACOG", ::givePlayerAttachment, "acog");
	self addOption(MenuName, "Toggle Flamethrower", ::givePlayerAttachment, "ft");
	self addOption(MenuName, "Toggle Masterkey", ::givePlayerAttachment, "mk");
	self addOption(MenuName, "Toggle Grenade Launcher", ::givePlayerAttachment, "gl");
	self addOption(MenuName, "Toggle Dual Mag", ::givePlayerAttachment, "dualclip");
	self addOption(MenuName, "Toggle Dual Wield", ::givePlayerAttachment, "dw");
	self addOption(MenuName, "Remove all attachments", ::removeAllAttachments, undefined);
	
	//

    MenuName = "camo";
	self addMenu(MenuName, "Camos", "class");
	self addOption(MenuName, "Camos", ::drawMenuText, "camoone");
	self addOption(MenuName, "More Camos", ::drawMenuText, "camotwo");
	self addOption(MenuName, "Random Camo", ::randomCamo, undefined);
    
	MenuName = "camoone";
	self addMenu(MenuName, "Camos", "camo");
	self addOption(MenuName, "None", ::changeCamo, 0);
	self addOption(MenuName, "Dusty", ::changeCamo, 1);
	self addOption(MenuName, "Ice", ::changeCamo, 2);
	self addOption(MenuName, "Red", ::changeCamo, 3);
	self addOption(MenuName, "Olive", ::changeCamo, 4);
	self addOption(MenuName, "Nevada", ::changeCamo, 5);
	self addOption(MenuName, "Sahara", ::changeCamo, 6);
	self addOption(MenuName, "ERDL", ::changeCamo, 7);
	self addOption(MenuName, "Tiger", ::changeCamo, 8);
	self addOption(MenuName, "Berlin", ::changeCamo, 9);
	self addOption(MenuName, "Warsaw", ::changeCamo, 10);
	self addOption(MenuName, "Siberia", ::changeCamo, 11);
	
	MenuName = "camotwo";
	self addMenu(MenuName, "Camos", "camo");
	self addOption(MenuName, "Yukon", ::changeCamo, 12);
	self addOption(MenuName, "Woodland", ::changeCamo, 13);
	self addOption(MenuName, "Flora", ::changeCamo, 14);
	self addOption(MenuName, "Gold", ::changeCamo, 15);
	
	//
	
	MenuName = "perk";
	self addMenu(MenuName, "Perks", "class");
	self addOption(MenuName, "Lightweight Pro", ::givePlayerPerk, "lightweightPro");
	self addOption(MenuName, "Flak Jacket Pro", ::givePlayerPerk, "flakJacketPro");
	self addOption(MenuName, "Scout Pro", ::givePlayerPerk, "scoutPro");
	self addOption(MenuName, "Sleight of Hand Pro", ::givePlayerPerk, "sleightOfHandPro");
	self addOption(MenuName, "Ninja Pro", ::givePlayerPerk, "ninjaPro");
	self addOption(MenuName, "Hacker Pro", ::givePlayerPerk, "hackerPro");
	self addOption(MenuName, "Tactical Mask Pro", ::givePlayerPerk, "tacticalMaskPro");

	//
	
	MenuName = "grenade";
	self addMenu(MenuName, "Grenades", "class");
	self addOption(MenuName, "Frag", ::giveGrenade, "frag_grenade_mp");
	self addOption(MenuName, "Semtex", ::giveGrenade, "sticky_grenade_mp");
	self addOption(MenuName, "Tomahawk", ::giveGrenade, "hatchet_mp");
    
	MenuName = "equipment";
	self addMenu(MenuName, "Equipment", "class");
	self addOption(MenuName, "Camera Spike", ::giveUserWeapon, "camera_spike_mp");
	self addOption(MenuName, "C4", ::giveUserWeapon, "satchel_charge_mp");
	self addOption(MenuName, "Tactical Insertion", ::giveUserWeapon, "tactical_insertion_mp");
	self addOption(MenuName, "Jammer", ::giveUserWeapon, "scrambler_mp");
	self addOption(MenuName, "Motion Sensor", ::giveUserWeapon, "acoustic_sensor_mp");
	self addOption(MenuName, "Claymore", ::giveUserWeapon, "claymore_mp");

	MenuName = "tactical";
	self addMenu(MenuName, "Tacticals", "class");
	self addOption(MenuName, "Willy Pete", ::giveUserTacticals, "willy_pete_mp");
	self addOption(MenuName, "Nova Gas", ::giveUserTacticals, "tabun_gas_mp");
	self addOption(MenuName, "Flashbang", ::giveUserTacticals, "flash_grenade_mp");
	self addOption(MenuName, "Concussion", ::giveUserTacticals, "concussion_grenade_mp");
	self addOption(MenuName, "Decoy", ::giveUserTacticals, "nightingale_mp");
	
	////////////////////////
	
	// Bullets menu.
	MenuName = "bullet";
    self addMenu(MenuName, "Bullets Menu", MainMenu);
	self addOption(MenuName, "Toggle Magic Bullets", ::ToggleMagicBullets, undefined);
    self addOption(MenuName, "RPG", ::changeProjectile, "rpg_mp");
	self addOption(MenuName, "China Lake", ::changeProjectile, "china_lake_mp");
	self addOption(MenuName, "M72 Law", ::changeProjectile, "m72_law_mp");
	self addOption(MenuName, "Strela", ::changeProjectile, "strela_mp");
	self addOption(MenuName, "L96A1", ::changeProjectile, "l96a1_mp");
	
	// Killstreaks menu.
	MenuName = "killstreak";
    self addMenu(MenuName, "Killstreaks Menu", MainMenu);
	self addOption(MenuName, "Spy Plane", ::giveUserKillstreak, "radar_mp");
	self addOption(MenuName, "RC-XD", ::giveUserKillstreak, "rcbomb_mp");
	self addOption(MenuName, "Counter-Spy Plane", ::giveUserKillstreak, "counteruav_mp");
	self addOption(MenuName, "Sam Turret", ::giveUserKillstreak, "tow_turret_drop_mp");
	self addOption(MenuName, "Carepackage", ::giveUserKillstreak, "supply_drop_mp");
	self addOption(MenuName, "Napalm Strike", ::giveUserKillstreak, "napalm_mp");
	self addOption(MenuName, "Sentry Gun", ::giveUserKillstreak, "autoturret_mp");
	self addOption(MenuName, "Mortar Team", ::giveUserKillstreak, "mortar_mp");
	self addOption(MenuName, "Valkyrie Rocket", ::giveUserKillstreak, "m220_tow_mp");
	self addOption(MenuName, "Blackbird", ::giveUserKillstreak, "radardirection_mp");
	self addOption(MenuName, "Minigun", ::giveUserKillstreak, "minigun_mp");
	
	// Aimbot menu.
	MenuName = "aimbot";
    self addMenu(MenuName, "Aimbot Menu", MainMenu);
	self addOption(MenuName, "Option 1", undefined, undefined);
    self addOption(MenuName, "Option 2", undefined, undefined);
	self addOption(MenuName, "Option 3", undefined, undefined);
	self addOption(MenuName, "Option 4", undefined, undefined);
	self addOption(MenuName, "Option 5", undefined, undefined);
	self addOption(MenuName, "Option 6", undefined, undefined);
	self addOption(MenuName, "Option 7", undefined, undefined);
	self addOption(MenuName, "Option 8", undefined, undefined);
	self addOption(MenuName, "Option 9", undefined, undefined);
	self addOption(MenuName, "Option 10", undefined, undefined);
	self addOption(MenuName, "Option 11", undefined, undefined);
	self addOption(MenuName, "Option 12", undefined, undefined);
	
	// Host menu.
	MenuName = "host";
    self addMenu(MenuName, "Host Menu", MainMenu);
	self addOption(MenuName, "Option 1", undefined, undefined);
    self addOption(MenuName, "Option 2", undefined, undefined);
	self addOption(MenuName, "Option 3", undefined, undefined);
	self addOption(MenuName, "Option 4", undefined, undefined);
	self addOption(MenuName, "Option 5", undefined, undefined);
	self addOption(MenuName, "Option 6", undefined, undefined);
	self addOption(MenuName, "Option 7", undefined, undefined);
	self addOption(MenuName, "Option 8", undefined, undefined);
	self addOption(MenuName, "Option 9", undefined, undefined);
	self addOption(MenuName, "Option 10", undefined, undefined);
	self addOption(MenuName, "Option 11", undefined, undefined);
	self addOption(MenuName, "Option 12", undefined, undefined);
	
	// Game settings.
	MenuName = "game";
    self addMenu(MenuName, "Game Settings", MainMenu);
	self addOption(MenuName, "Super Jump", ::ToggleSuperJump, undefined);
    self addOption(MenuName, "Speed Lobby", ::ToggleGameSpeed, undefined);
	self addOption(MenuName, "Timescale", ::ToggleTimeScale, undefined);
	self addOption(MenuName, "Matrix Bullets", ::ToggleMatrixBullets, undefined);
	
	// Client menu.
	MenuName = "client";
    self addMenu(MenuName, "Client Menu", MainMenu);
	self addOption(MenuName, "Option 1", undefined, undefined);
    self addOption(MenuName, "Option 2", undefined, undefined);
	self addOption(MenuName, "Option 3", undefined, undefined);
	self addOption(MenuName, "Option 4", undefined, undefined);
	self addOption(MenuName, "Option 5", undefined, undefined);
	self addOption(MenuName, "Option 6", undefined, undefined);
	self addOption(MenuName, "Option 7", undefined, undefined);
	self addOption(MenuName, "Option 8", undefined, undefined);
	self addOption(MenuName, "Option 9", undefined, undefined);
	self addOption(MenuName, "Option 10", undefined, undefined);
	self addOption(MenuName, "Option 11", undefined, undefined);
	self addOption(MenuName, "Option 12", undefined, undefined);
}

GlobaliPrintln(message)
{
	for(i = 0; i < level.players.size; i++)
	{
		level.players[i] iprintln(message);
	}
}

GlobaliPrintlnBold(message)
{
	for(i = 0; i < level.players.size; i++)
	{
		level.players[i] iprintlnbold(message);
	}
}

/////////////
///Main Mods//
///////////////

InfectCheats()
{
	setDvar("compassSize", 1.4 );
	setDvar("compassRadarPingFadeTime", "9999");
	setDvar("compassSoundPingFadeTime", "9999");
	setDvar("compassRadarUpdateTime", "0.001");
	setDvar("compassFastRadarUpdateTime", "0.001");
	setDvar("compassRadarLineThickness", "0");
	setDvar("compassMaxRange", "9999");
	setDvar("uav_debug", "1" );
	setDvar("forceuav_debug", "1");
	setDvar("compassRadarUpdateTime", 0.001);
	setDvar("cg_footsteps", 1);
	setDvar("scr_game_forceuav", 1);
	setDvar("cg_enemyNameFadeOut" , 900000);
	setDvar("cg_enemyNameFadeIn" , 0 );
	setDvar("cg_drawThroughWalls" , 1 );
	setDvar("cg_everyoneHearsEveryone", "1");
	setDvar("cg_chatWithOtherTeams", "1");
	setDvar("cg_deadChatWithTeam", "1");
	setDvar("cg_deadHearAllLiving", "1");
	setDvar("cg_deadHearTeamLiving", "1");
	setDvar("cg_drawTalk", "ALL");
	setDvar("cg_scoreboardPingText" , "1");
	setDvar("cg_ScoresPing_MaxBars", "6");
	setDvar("player_burstFireCooldown", "0");
	setDvar("cg_drawFPS", 1);
	setDvar("player_sprintUnlimited", 1);
	self iPrintln("^6Cheater Infections Enabled!");
}

///////////////////////

ToggleGodMode()
{
	if(!self.godmode)
	{
		self enableInvulnerability();
		self.godmode = true;
		self iprintln("Godmode: ^2ON");
	}
	
	else
	{	
		self disableInvulnerability();
		self.godmode = false;
		self iprintln("Godmode: ^1OFF");
	}
}

///////////////////////

ToggleNoclip()
{
	if(!self.noclip)
	{
		self.noclip = true;
		thread noclipActivate();
		self iprintlnbold("^5Press [{+frag}] to move.");
		self iPrintln("NoClip: ^2ON^7");
	}
	
	else
	{
		self.noclip = false;
		self iPrintln("NoClip: ^1OFF^7");
	}
}

noclipActivate()
{
	self endon("disconnect");
	self endon("death");
	clipModel = spawn("script_origin", self.origin);
	self linkTo(clipModel);
	thread clipDeath(clipModel);
	
	// Move forward.
	while(self.noclip)
	{
		if(self fragbuttonpressed() && !(self adsbuttonpressed()))
		{
			clipModel.origin += (anglesToForward(self getPlayerAngles()) * 25);
		}
		
		else if (self fragbuttonpressed() && self adsbuttonpressed())
		{
			clipModel.origin += (anglesToForward(self getPlayerAngles()) * 50);
		}
			
		wait .05;
	}
	
	// Disable noclip.
	self unlink();
	clipModel delete();
}

clipDeath(model)
{
	self waittill("death");
	if(isDefined(model))
		model delete();
}

///////////////////////

ToggleFOV(value)
{	
	if(!self.fov)
	{
		self iprintln("Feild Of View: ^5" + value);
		self setClientDvar("cg_fov", value);
		self thread giveFovOnDeath(value);
		self.fov = true;
	}
	
	else
	{
		self iprintln("Feild Of View: ^1OFF");
		self setClientDvar("cg_fov", 65);
		self.fov = false;
	}
}

giveFovOnDeath(value)
{
	while(self.fov)
	{
		self waittill("spawned_player");
		if(self.fov)
		{
			wait .5;
			self iprintln("Feild Of View: ^5" + value);
			self setClientDvar("cg_fov", value);
		}
	}
}

///////////////////////

selfSuicide()
{
	self closeMenu();
	self suicide();
}

///////////////////////

// Not my code, bless who-ever made this :)
giveAll()
{
	self endon("death");
	gunPos = 0;
	isReady = true;
	guns = strtok("python_mp;cz75_mp;m14_mp;m16_mp;g11_lps_mp;famas_mp;ak74u_mp;mp5k_mp;mpl_mp;pm63_mp;spectre_mp;cz75dw_mp;ithaca_mp;rottweil72_mp;spas_mp;hs10_mp;aug_mp;galil_mp;commando_mp;fnfal_mp;dragunov_mp;l96a1_mp;rpk_mp;hk21_mp;m72_law_mp;china_lake_mp;crossbow_explosive_mp;knife_ballistic_mp", ";");
	self giveWeapon( guns[0] );
	self switchToWeapon( guns[0] );
	self iprintln("All Weapons: ^5Given");
	self.giveAll = true;
	
	while(self.giveAll)
	{
		self waittill( "weapon_change" );
		if( isReady == true )
		{
			isReady = false;
			gunPos++;
			if( gunPos >= guns.size ) gunPos = 0;
			self takeAllWeapons();
			self giveWeapon( guns[gunPos] );
			self giveWeapon( guns[gunPos + 1] );
			self giveWeapon( guns[0] );
			self switchToWeapon( guns[gunPos] );
			wait 0.1;
			isReady = true;
		}
		wait 0.01;
	}
}

///////////////////////

takeAll()
{
	self.giveAll = false;
	for(i = 0; i < 10; i++)
	{
		self takeAllWeapons();
		wait 0.1;
	}
	self iprintln("All Weapons: ^5Taken");
}

///////////////////////

giveUserWeapon(weapon)
{
	self GiveWeapon(weapon);
	self GiveStartAmmo(weapon);
	self SwitchToWeapon(weapon);
}

///////////////////////

takeUserWeapon()
{
	self TakeWeapon(self GetCurrentWeapon());
}

///////////////////////

dropUserWeapon()
{
	self dropItem(self GetCurrentWeapon());
}

///////////////////////

ToggleInfiniteAmmo()
{
	if(!self.infiniteAmmo)
	{
		self iprintln("Infinte Ammo: ^2ON");
		self.infiniteAmmo = true;
		self thread giveInfAmmo();
	}
	
	else
	{
		self iprintln("Infinte Ammo: ^1OFF");
		self.infiniteAmmo = false;
	}
}

giveInfAmmo()
{
	while(self.infiniteAmmo)
	{
		currentWeapon = self getcurrentweapon();
        if (currentWeapon != "none" && (self attackbuttonpressed() || self adsbuttonpressed()))
        {
            self setweaponammoclip(currentWeapon, weaponclipsize(currentWeapon));
            self givemaxammo(currentWeapon);
        }
		
		wait .1;
	}
}

///////////////////////

ToggleSuperJump()
{
	self endon("disconnect");

	if(!level.superJump || !isDefined(level.superJump))
	{
		GlobaliPrintln("Super Jump: ^2ON");
		level.superJump = true;
		
		for(i = 0; i < level.players.size; i++)
		{
			level.players[i] thread detectSuperJump();
		}
	}
	
	else
	{
		GlobaliPrintln("Super Jump ^1OFF");
		level.superJump = false;
	}
}

detectSuperJump()
{
	while(level.SuperJump)
	{
		// If they jump.
		if(self JumpButtonPressed())
		{
			// A slow upwards velocity over a 20th of a second.
			for(i = 0; i < 10; i++)
			{
				self setVelocity(self getVelocity() + (0, 0, 999));
				wait 0.05;
			}
			
			// Disable fall damage.
			// This will wait the correct amount of time to give you god mode when you hit the ground.
			if(!self.godMode || !isDefined(self.godMode))
			{
				wait 1;
				self enableInvulnerability();
				wait .2;
				self disableInvulnerability();
			}
			
			// They are in god mode, no need to disable fall damage.
			else
			{
				wait 1.2;
			}
		}
		
		// Halt loop.
		wait 0.05;
	}
}

///////////////////////

ToggleGameSpeed()
{
	if(level.gameSpeed == 190 || !isDefined(level.gameSpeed))
	{
		GlobaliPrintln("Gamespeed: ^5400");
		level.gameSpeed = 400;
		setDvar("g_speed", "400");
	}
	
	else if (level.gameSpeed == 400)
	{
		GlobaliPrintln("Gamespeed: ^5600");
		level.gameSpeed = 600;
		setDvar("g_speed", "800");
	}
	
	else if (level.gameSpeed == 600)
	{
		GlobaliPrintln("Gamespeed: ^5800");
		level.gameSpeed = 800;
		setDvar("g_speed", "800");
	}
	
	else
	{
		GlobaliPrintln("Gamespeed: ^5Default");
		level.gameSpeed = 190;
		setDvar("g_speed", "190");
	}
}

///////////////////////

ToggleTimeScale()
{
	if(level.timeScale == 1 || !isDefined(level.timeScale))
	{
		GlobaliPrintln("Timescale: ^52");
		level.timeScale = 2;
		setDvar("timescale", "2");
	}
	
	else if(level.timeScale == 2)
	{
		GlobaliPrintln("Timescale: ^51.5");
		level.timeScale = 1.5;
		setDvar("timescale", "1.5");
	}
	
	else if(level.timeScale == 1.5)
	{
		GlobaliPrintln("Timescale: ^50.5");
		level.timeScale = .5;
		setDvar("timescale", ".5");
	}
	
	else if(level.timeScale == .5)
	{
		GlobaliPrintln("Timescale: ^50.2");
		level.timeScale = .2;
		setDvar("timescale", ".2");
	}
	
	else
	{
		GlobaliPrintln("Gamespeed: ^5Default");
		level.timeScale = 1;
		setDvar("timescale", "1");
	}
}

///////////////////////

ToggleMatrixBullets()
{
	if(!level.matrixBullets || !isDefined(level.matrixBullets))
	{
		GlobaliPrintln("Matrix Bullets: ^5Classic");
		level.matrixBullets = "classic";
		setDvar("cg_tracerlength", "999");
		setDvar("cg_tracerspeed", "150");
		setDvar("cg_tracerwidth", "15");
		setDvar("cg_tracerScrewRadius", "0.15");
	}
	
	else if(level.matrixBullets == "classic")
	{
		GlobaliPrintln("Matrix Bullets: ^5Screwed");
		level.matrixBullets = "screwed";
		setDvar("cg_tracerlength", "999");
		setDvar("cg_tracerspeed", "150");
		setDvar("cg_tracerwidth", "10");
		setDvar("cg_tracerScrewRadius", "5");
	}
	
	else
	{
		GlobaliPrintln("Matrix Bullets: ^1OFF");
		level.matrixBullets = false;
		setDvar("cg_tracerlength", "100");
		setDvar("cg_tracerspeed", "7500");
		setDvar("cg_tracerwidth", "3");
		setDvar("cg_tracerScrewRadius", "0.15");
	}
}

///////////////////////

ToggleMagicBullets()
{
	if(!self.MagicBullets)
	{
		if(!self.infiniteAmmo)
		{
			ToggleInfiniteAmmo();
		}
		
		if(self.BulletType == "")
		{
			self.BulletType = "rpg_mp";
		}
		
		self iPrintln("Magic Bullets: ^2ON");
		self.MagicBullets = true;
		self thread detectShot();
	}
	
	else
	{
		if(self.infiniteAmmo)
		{
			ToggleInfiniteAmmo();
		}
		self iPrintln("Magic Bullets: ^1OFF");
		self.MagicBullets = false;
	}
}

detectShot()
{
	while(self.MagicBullets)
	{
		self waittill("weapon_fired");
		firing = GetCursorPos();
		MagicBullet(self.BulletType, self getTagOrigin("tag_eye"), firing, self);
		wait 0.01;
	}
}

changeProjectile(bulletType)
{
	self iprintln("Projectile: ^2" + bulletType);
	self.BulletType = bulletType;
}

///////////////////////

discoSun()
{
	if(!self.discoSun)
	{
		self.discoSun = true;
		while (self.discoSun)
		{
			setDvar("r_lightTweakSunColor", "1 0 0 1");
			wait .12;
			setDvar("r_lightTweakSunColor", "1 .501960 0 1");
			wait .12;
			setDvar("r_lightTweakSunColor", "1 1 0 1");
			wait .12;
			setDvar("r_lightTweakSunColor", ".501960 0 1 1");
			wait .12;
			setDvar("r_lightTweakSunColor", "0 1 0 1");
			wait .12;
			setDvar("r_lightTweakSunColor", "0 1 .501960 1");
			wait .12;
			setDvar("r_lightTweakSunColor", "0 1 1 1");
			wait .12;
			setDvar("r_lightTweakSunColor", "0 .501960 1 1");
			wait .12;
			setDvar("r_lightTweakSunColor", "0 0 1 1");
			wait .12;
			setDvar("r_lightTweakSunColor", ".501960 0 1 1");
			wait .12;
			setDvar("r_lightTweakSunColor", "1 0 1 1");
			wait .12;
			setDvar("r_lightTweakSunColor", "1 0 .501960 1");
			wait .12;
			if(!self.discoSun)
			{
				setDvar("r_lightTweakSunColor", "0.991101 0.982251 0.955973 1");
			}
		}
	}

	else
	{
		self.discoSun = false;
	}
}

///////////////////////


startPlaneThread()
{
	self closeMenu();
	self endon("death");
	self iprintlnbold("^5Hold [{+smoke}] to Enter Plane!");
	self.inPlane = false;
	
	while(true)
	{
		if(!self.inPlane)
		{
			if(self SecondaryOffHandButtonPressed())
			{
				wait 1;
				if(self SecondaryOffHandButtonPressed())
				{
					self.inPlane = true;
					self thread doFlyplane();
					wait 1.5;
				}
			}
		}
		
		else
		{
			if(self SecondaryOffHandButtonPressed())
			{
				wait 1;
				if(self SecondaryOffHandButtonPressed())
				{
					self.inPlane = false;
					self thread doExitplane();
					wait 1;
				}
			}
		}
		wait 0.01;
	}
}

doFlyplane()
{
	self endon("planeout");
	self endon("death");
	
	self.originalWeapons = self GetWeaponsList();
	self.originalPos = self.origin;
	self thread doShoot();
	self takeAllWeapons(); 
	
	// Create plane object.
	self.myplane = spawn("script_model",self.origin);
	self.myplane.angles = self.angles;
	self.myplane setModel("t5_veh_jet_f4_gearup");
	
	// Delete plane on death.
	self thread delond(self.myplane);
	
	// Give godmode.
	self EnableInvulnerability();
	
	self linkto(self.myplane, "tag_origin", (-900,0,175),(0,0,0));
	self hide();
	self setClientUIVisibilityFlag("hud_visible",0);
	
	// Aim cross hairs.
	self.mcross = self createFontString("default", 2);
	self.mcross setPoint("CENTER","CENTER",0,0);
	self.mcross setText("^1+");
	
	// Destroy crosshairs on death.
	self thread dond(self.mcross);
	
	self iprintln("^1Press [{+frag}] to Toggle Weapons ^7|^3 Press [{+speed_throw}] to Shoot ^7|^2 Press [{+attack}] to Fly! ^7|^5 Hold [{+smoke}] to Exit!");
	
	// Fly forward.
	while(true)
	{
		self.myplane.angles = self getplayerangles();
		
		if(self AttackButtonPressed())
		{	
			self.myplane moveto(self.myplane.origin + anglestoforward(self getplayerangles())* 120, 0.015);
		}
		
		wait 0.01;
	}
}

doShoot()
{
	self endon("death");
	self endon("planeout");
	
	self.gunselc = 0;
	self.pguns = [];
	self.pguns[0] = "rpg_mp";
	self.pguns[1] = "strela_mp";
	self.pguns[2] = "m72_law_mp";
	self.pguns[3] = "m202_flash_mp";
	
	while(true)
	{
		// Shoot projectile.
		if(self ADSButtonPressed())
		{
			firing = GetCursorPos();
			MagicBullet(self.pguns[self.gunselc], self.myplane.origin + anglestoforward(self getplayerangles()) * 50, firing, self);
		}
		
		// Change projectile. 
		if(self FragButtonPressed())
		{
			if(self.gunselc == self.pguns.size - 1) 
			{	
				self.gunselc = 0;
			}
			
			else
			{
				self.gunselc++;
			}
			
			self iprintlnbold("Gun is now: ^1" + self.pguns[self.gunselc]);
			wait 1;
		}
		
		wait 0.1;
	}
}

doExitplane()
{
	self notify("planeout");
	self iprintln("\nHold [{+smoke}] to Enter Plane!");
	self unlink();
	self.myplane delete();
	self.mcross destroy();
	self show();
	self setClientUIVisibilityFlag("hud_visible", 1);
	self setorigin(self.originalPos);
	self DisableInvulnerability();
	
	for(i=0; i <= self.originalWeapons.size; i++)
	{
		self giveweapon(self.originalWeapons[i]);
	}
}

// Delete on death.
delond(ent)
{
	self waittill("death");
	ent delete();
}

// Destroy on death.
dond(elem)
{
	self waittill("death");
	elem destroy();
}

vector_scal(vec, scale)
{
	vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
	return vec;
}

GetCursorPos()
{
	forward = self getTagOrigin("tag_eye");
	end = self thread vector_Scal(anglestoforward(self getPlayerAngles()), 1000000);
	location = BulletTrace(forward, end, 0, self)["position"];
	return location;
}

///////////////////////

/////////////
///Hud Stuff//
///////////////

changeFontScaleOverTime(time, scale)
{
    start = self.fontscale;
    frames = (time/.05);
    scaleChange = (scale-start);
    scaleChangePer = (scaleChange/frames);
    for(m = 0; m < frames; m++)
    {
        self.fontscale+= scaleChangePer;
        wait .05;
    }
}
 
createText(font, fontScale, align, relative, x, y, sort, alpha, glow, text)
{
    textElem = self createFontString(font, fontScale, self);
    textElem setPoint(align, relative, x, y);
    textElem.sort = sort;
    textElem.alpha = alpha;
    textElem.glowColor = glow;
    textElem.glowAlpha = 1;
    textElem setText(text);
    //self thread destroyOnDeath(textElem);
    return textElem;
}

// Draws a rectangle to the screen.
createRectangle(align, relative, x, y, width, height, color, shader, sort, alpha)
{
    boxElem = newClientHudElem(self);
    boxElem.elemType = "bar";
    if(!level.splitScreen)
    {
        boxElem.x = -2;
        boxElem.y = -2;
    }
    boxElem.width = width;
    boxElem.height = height;
    boxElem.align = align;
    boxElem.relative = relative;
    boxElem.xOffset = 0;
    boxElem.yOffset = 0;
    boxElem.children = [];
    boxElem.sort = sort;
    boxElem.color = color;
    boxElem.alpha = alpha;
    boxElem setParent(level.uiParent);
    boxElem setShader(shader, width, height);
    boxElem.hidden = false;
    boxElem setPoint(align, relative, x, y);
    //self thread destroyOnDeath(boxElem);
    return boxElem;
}