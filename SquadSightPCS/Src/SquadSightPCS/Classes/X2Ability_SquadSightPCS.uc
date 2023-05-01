//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_SquadSightPCS.uc
//  AUTHOR:  TRNEEDANAME  --  28/04/2023
//  PURPOSE: Create the Ability tied to the PCS     
//---------------------------------------------------------------------------------------


class X2Ability_SquadSightPCS extends X2Ability config(SquadSightPCS);

var config float			BscSquadSightPCS_RangePenalityNegated;
var config int				BscSquadSightPCS_MobilityNegate;

var config float			AdvSquadSightPCS_RangePenalityNegated;
var config int				AdvSquadSightPCS_MobilityNegate;

var config float			SupSquadSightPCS_RangePenalityNegated;
var config int				SupSquadSightPCS_MobilityNegate;

var config bool DoesSquadSightPCS_Bsc_GrantSquadSight, DoesSquadSightPCS_Adv_GrantSquadSight, DoesSquadSightPCS_Sup_GrantSquadSight;


static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(SquadSight_Buff_Bsc());
	Templates.AddItem(SquadSight_Buff_Adv());
	Templates.AddItem(SquadSight_Buff_Sup());

	Templates.AddItem(SquadSight_Nerf_Bsc());
	Templates.AddItem(SquadSight_Nerf_Adv());
	Templates.AddItem(SquadSight_Nerf_Sup());


	return Templates;
}


static function X2AbilityTemplate SquadSight_Buff_Bsc()
{

	local X2AbilityTemplate								Template;
	local X2Effect_SquadSightPCS_RangeModifiers			HitModEffect;
	local X2Effect_Persistent							PersistentEffect;
	local X2Condition_PlayerTurns						TurnsCondition;
	local XComGameState_Unit							Unit;


	Template = CreatePassiveAbility('SquadSight_Buff_Bsc', "img:///UILibrary_PerkIcons.UIPerk_long_watch",, false);



	// This effect handles the reduction of aim penalties due to range tables/squadsight
	HitModEffect = new class'X2Effect_SquadSightPCS_RangeModifiers';
	HitModEffect.BuildPersistentEffect(1, true, false, false);
	HitModEffect.bLimitToLongRange = true;
	HitModEffect.RangePenaltyPercentNegated = default.BscSquadSightPCS_RangePenalityNegated;
	HitModEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, false,, Template.AbilitySourceName);
	Template.AddTargetEffect(HitModEffect);


	// This effect stays on the unit indefinitely
	PersistentEffect = new class'X2Effect_Persistent';
	PersistentEffect.EffectName = 'BipodEffect';
	PersistentEffect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin);


	// This condition guarantees the player has started more than 1 turn. the first turn of the game does not count, as there was no "previous" turn.
	TurnsCondition = new class'X2Condition_PlayerTurns';
	TurnsCondition.NumTurnsCheck.CheckType = eCheck_GreaterThan;
	TurnsCondition.NumTurnsCheck.Value = 1;
	Template.AddShooterEffect(PersistentEffect);

	if (default.DoesSquadSightPCS_Bsc_GrantSquadSight == true)
	{
		if (!Unit.HasAbilityFromAnySource('Squadsight'))
		{
			Template.AdditionalAbilities.AddItem('Squadsight');
		}
	}

	return Template;
}

	static function X2AbilityTemplate SquadSight_Nerf_Bsc()
{

	local X2AbilityTemplate											Template;
	local X2Effect_PersistentStatChange								Effect;


	Template = CreatePassiveAbility('SquadSight_Nerf_Bsc',,, false);


	// Create a persistent stat change effect that adds [default: -1] mobility
	Effect = new class 'X2Effect_PersistentStatChange';
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.AddPersistentStatChange(eStat_Mobility, default.BscSquadSightPCS_MobilityNegate);
	Template.AddTargetEffect(Effect);


	// Add UI stat markups corresponding to effect stat boosts
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, default.BscSquadSightPCS_MobilityNegate);


	return Template;
}


// Bipod: Advanced Bonus - Passive:
static function X2AbilityTemplate SquadSight_Buff_Adv()
{

	local X2AbilityTemplate								Template;
	local X2Effect_SquadSightPCS_RangeModifiers			HitModEffect;
	local X2Effect_Persistent							PersistentEffect;
	local X2Condition_PlayerTurns						TurnsCondition;
	local XComGameState_Unit							Unit;
	
	Template = CreatePassiveAbility('SquadSight_Buff_Adv', "img:///UILibrary_PerkIcons.UIPerk_long_watch",, false);
	
	// This effect handles the reduction of aim penalties due to range tables/squadsight
	HitModEffect = new class'X2Effect_SquadSightPCS_RangeModifiers';
	HitModEffect.BuildPersistentEffect(1, true, false, false);
	HitModEffect.bLimitToLongRange = true;
	HitModEffect.RangePenaltyPercentNegated = default.AdvSquadSightPCS_RangePenalityNegated;
	HitModEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, false,, Template.AbilitySourceName);
	Template.AddTargetEffect(HitModEffect);


	// This effect stays on the unit indefinitely
	PersistentEffect = new class'X2Effect_Persistent';
	PersistentEffect.EffectName = 'BipodEffect';
	PersistentEffect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, false,, Template.AbilitySourceName);

	// This condition guarantees the player has started more than 1 turn. the first turn of the game does not count, as there was no "previous" turn.
	TurnsCondition = new class'X2Condition_PlayerTurns';
	TurnsCondition.NumTurnsCheck.CheckType = eCheck_GreaterThan;
	TurnsCondition.NumTurnsCheck.Value = 1;
	
	if (default.DoesSquadSightPCS_Adv_GrantSquadSight == true)
	{
		if (!Unit.HasAbilityFromAnySource('Squadsight'))
		{
			Template.AdditionalAbilities.AddItem('Squadsight');
		}
	}

	Template.AddShooterEffect(PersistentEffect);

	return Template;
}

static function X2AbilityTemplate SquadSight_Nerf_Adv()
{

	local X2AbilityTemplate											Template;
	local X2Effect_PersistentStatChange								Effect;


	Template = CreatePassiveAbility('SquadSight_Nerf_Adv',,, false);


	// Create a persistent stat change effect that adds [default: -1] mobility
	Effect = new class 'X2Effect_PersistentStatChange';
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.AddPersistentStatChange(eStat_Mobility, default.AdvSquadSightPCS_MobilityNegate);
	Template.AddTargetEffect(Effect);


	// Add UI stat markups corresponding to effect stat boosts
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, default.AdvSquadSightPCS_MobilityNegate);


	return Template;
}

static function X2AbilityTemplate SquadSight_Buff_Sup()
{

	local X2AbilityTemplate								Template;
	local X2Effect_SquadSightPCS_RangeModifiers			HitModEffect;
	local X2Effect_Persistent							PersistentEffect;
	local X2Condition_PlayerTurns						TurnsCondition;
	local XComGameState_Unit							Unit;

	
	Template = CreatePassiveAbility('SquadSight_Buff_Sup', "img:///UILibrary_PerkIcons.UIPerk_long_watch",, false);
	
	// This effect handles the reduction of aim penalties due to range tables/squadsight
	HitModEffect = new class'X2Effect_SquadSightPCS_RangeModifiers';
	HitModEffect.BuildPersistentEffect(1, true, false, false);
	HitModEffect.bLimitToLongRange = true;
	HitModEffect.RangePenaltyPercentNegated = default.SupSquadSightPCS_RangePenalityNegated;
	HitModEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, false,, Template.AbilitySourceName);
	Template.AddTargetEffect(HitModEffect);


	// This effect stays on the unit indefinitely
	PersistentEffect = new class'X2Effect_Persistent';
	PersistentEffect.EffectName = 'BipodEffect';
	PersistentEffect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, false,, Template.AbilitySourceName);

	// This condition check that the unit did not move last turn before allowing the bonus to be applied
	
	// This condition guarantees the player has started more than 1 turn. the first turn of the game does not count, as there was no "previous" turn.
	TurnsCondition = new class'X2Condition_PlayerTurns';
	TurnsCondition.NumTurnsCheck.CheckType = eCheck_GreaterThan;
	TurnsCondition.NumTurnsCheck.Value = 1;

	if (default.DoesSquadSightPCS_Sup_GrantSquadSight == true)
	{
		if (!Unit.HasAbilityFromAnySource('Squadsight'))
		{
			Template.AdditionalAbilities.AddItem('Squadsight');
		}
	}

	Template.AddShooterEffect(PersistentEffect);

	return Template;
}

    static function X2AbilityTemplate SquadSight_Nerf_Sup()
{

	local X2AbilityTemplate											Template;
	local X2Effect_PersistentStatChange								Effect;


	Template = CreatePassiveAbility('SquadSight_Nerf_Sup',,, false);


	// Create a persistent stat change effect that adds [default: -1] mobility
	Effect = new class 'X2Effect_PersistentStatChange';
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.AddPersistentStatChange(eStat_Mobility, default.SupSquadSightPCS_MobilityNegate);
	Template.AddTargetEffect(Effect);


	// Add UI stat markups corresponding to effect stat boosts
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, default.SupSquadSightPCS_MobilityNegate);


	return Template;
}

static function X2AbilityTemplate CreatePassiveAbility(name AbilityName, optional string IconString, optional name IconEffectName = AbilityName, optional bool bDisplayIcon = true)
{
	
	local X2AbilityTemplate					Template;
	local X2Effect_Persistent				IconEffect;
	

	`CREATE_X2ABILITY_TEMPLATE (Template, AbilityName);
	Template.IconImage = IconString;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bCrossClassEligible = false;
	Template.bUniqueSource = true;
	Template.bIsPassive = true;

	// Dummy effect to show a passive icon in the tactical UI for the SourceUnit
	IconEffect = new class'X2Effect_Persistent';
	IconEffect.BuildPersistentEffect(1, true, false);
	IconEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocHelpText, Template.IconImage, bDisplayIcon,, Template.AbilitySourceName);
	IconEffect.EffectName = IconEffectName;
	Template.AddTargetEffect(IconEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}
