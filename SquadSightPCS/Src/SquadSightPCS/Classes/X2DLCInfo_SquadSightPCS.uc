class X2DLCInfo_SquadSightPCS extends X2DownloadableContentInfo;

var config array<LootTable> LootTables, LootEntry;

static event OnLoadedSavedGame(){}
static event InstallNewCampaign(XComGameState StartState){}

static event OnPostTemplatesCreated()
{
	AddLootTables();
}

static function AddLootTables()
{
	local X2LootTableManager	LootManager;
	local LootTable				LootBag;
	local LootTableEntry		Entry;
	
	LootManager = X2LootTableManager(class'Engine'.static.FindClassDefaultObject("X2LootTableManager"));

	foreach default.LootEntry(LootBag)
	{
		if ( LootManager.default.LootTables.Find('TableName', LootBag.TableName) != INDEX_NONE )
		{
			foreach LootBag.Loots(Entry)
			{
				class'X2LootTableManager'.static.AddEntryStatic(LootBag.TableName, Entry, false);
			}
		}	
	}
}

	static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name Type;

	Type = name(InString);
	switch(Type)
	{
		case 'TR_PCS_BSC_SQUADSIGHT_BUFF':	OutString = string(int(100 * class'X2Ability_SquadSightPCS'.default.BscSquadSightPCS_RangePenalityNegated));	return true; break;
		case 'TR_PCS_ADV_SQUADSIGHT_BUFF':	OutString = string(int(100 * class'X2Ability_SquadSightPCS'.default.AdvSquadSightPCS_RangePenalityNegated));	return true; break;
		case 'TR_PCS_SUP_SQUADSIGHT_BUFF':	OutString = string(int(100 * class'X2Ability_SquadSightPCS'.default.SupSquadSightPCS_RangePenalityNegated));	return true; break;

		case 'TR_PCS_BSC_MOBILITY_DEBUFF':		OutString = string(class'X2Ability_SquadSightPCS'.default.BscSquadSightPCS_MobilityNegate);			return true; break;
		case 'TR_PCS_ADV_MOBILITY_DEBUFF':		OutString = string(class'X2Ability_SquadSightPCS'.default.AdvSquadSightPCS_MobilityNegate);			return true; break;
		case 'TR_PCS_SUP_MOBILITY_DEBUFF':		OutString = string(class'X2Ability_SquadSightPCS'.default.SupSquadSightPCS_MobilityNegate);			return true; break;

		default: return false; break;
	}
}
