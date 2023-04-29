class X2Item_SquadSightPCS extends X2Item config(SquadSightPCS);

var config bool DoesBscPCSNerfMobility, DoesAdvPCSNerfMobility, DoesSupPCSNerfMobility;

var config int SellValue_Comm, SellValue_Rare, SellValue_Epic;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Resources;

	Resources.AddItem(CreatePCS_SquadSight('CommonPCS_SquadSight',	default.SellValue_Comm, 0));
	Resources.AddItem(CreatePCS_SquadSight('RarePCS_SquadSight',		default.SellValue_Rare, 1));
	Resources.AddItem(CreatePCS_SquadSight('EpicPCS_SquadSight',		default.SellValue_Epic, 2));

	return Resources;
}

static function X2DataTemplate CreatePCS_SquadSight(name TemplateName, int SellValue, int Tier)
{
	local X2EquipmentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, TemplateName);

	Template.LootStaticMesh = StaticMesh'UI_3D.Loot.AdventPCS';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_CombatSim_Perception";
	Template.ItemCat = 'combatsim';
	Template.TradingPostValue = SellValue;
	Template.bAlwaysUnique = false;
	Template.Tier = Tier;

	Template.StatBoostPowerLevel = Tier + 1;

	Template.bUseBoostIncrement = true;
	Template.InventorySlot = eInvSlot_CombatSim;

	if (Tier == 0)
	{
		Template.Abilities.AddItem('SquadSight_Buff_Bsc');

		if (default.DoesBscPCSNerfMobility == true)
		{
			Template.Abilities.AddItem('SquadSight_Nerf_Bsc');
		}

	}

    else if (Tier == 1)
	{
		Template.Abilities.AddItem('SquadSight_Buff_Adv');

		if (default.DoesAdvPCSNerfMobility == true)
		{
			Template.Abilities.AddItem('SquadSight_Nerf_Bsc');
		}
	}

        else if (Tier == 2)
	{
		Template.Abilities.AddItem('SquadSight_Buff_Sup');
				
		if (default.DoesSupPCSNerfMobility == true)
		{
			Template.Abilities.AddItem('SquadSight_Nerf_Sup');
		}
	}

	Template.BlackMarketTexts = class'X2Item_DefaultResources'.default.PCSBlackMarketTexts;

	return Template;
}