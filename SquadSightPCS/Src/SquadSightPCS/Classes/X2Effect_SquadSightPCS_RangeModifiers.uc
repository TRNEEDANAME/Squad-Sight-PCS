//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_SquadSightPCS_RangeModifiers.uc
//  AUTHOR:  TRNEEDANAME  --  28/04/2023
//  PURPOSE: Create the effect for the PCS. Copied from Proficiency Class     
//---------------------------------------------------------------------------------------

class X2Effect_SquadSightPCS_RangeModifiers extends X2Effect_Persistent;

var float				RangePenaltyPercentNegated;
var bool				bLimitToLongRange;				// Greater than 10 tiles
var bool				bLimitToSquadSightRange;		// Greater than unit's vision range

var array<name>			RequiredEffectNames;


function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local XComGameState_Item	SourceWeapon;
	local X2WeaponTemplate		WeaponTemplate;
	local ShotModifierInfo		ShotInfo;
    local int					i, Tiles, NormalRange, SquadsightMod;
	local float					WeaponModifier, SquadsightModifier;
	local array<int>			RangeTable;
	local bool					bEffectCheck;

	if (AbilityState != none)
	{
		SourceWeapon = AbilityState.GetSourceWeapon();    
		if (SourceWeapon != none)
		{
			// Attack must come from correct SourceWeapon
			if (AbilityState.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
				return;

			if (RequiredEffectNames.length == 0)
			{
				bEffectCheck = true;
			}

			else
			{
				for (i = 0; i < RequiredEffectNames.Length; ++i)
				{
					if (Attacker.AffectedByEffectNames.Find(RequiredEffectNames[i]) != Index_None)
					{
						bEffectCheck = true;
						break;
			}	}	}

			if (bEffectCheck)
			{
				WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
				RangeTable = WeaponTemplate.RangeAccuracy;
				Tiles = Attacker.TileDistanceBetween(Target);
				NormalRange = `UNITSTOTILES(`METERSTOUNITS(Attacker.GetVisibilityRadius()));

				if (Tiles >= NormalRange || !bLimitToSquadSightRange)
				{
					if (Tiles >= 10 || !bLimitToLongRange)
					{
						if (Tiles < RangeTable.Length)
						{
							if (RangeTable[Tiles] < 0)
							{
								WeaponModifier = -RangeTable[Tiles];

							}	
						}

						else // Use last value
						{
							if (RangeTable[RangeTable.Length - 1] < 0)
							{
								WeaponModifier = -RangeTable[RangeTable.Length - 1];
							}	
						}	
					}


					// Adjust tiles down to Squadsight range
					Tiles -= NormalRange;
					SquadsightMod = -class'X2AbilityToHitCalc_StandardAim'.default.SQUADSIGHT_DISTANCE_MOD;
					if (Tiles >= 0)
					{
						SquadsightModifier = MAX(SquadsightMod * Tiles, SquadsightMod);
					}

					WeaponModifier += SquadsightModifier;
					WeaponModifier *= RangePenaltyPercentNegated;
				
					if (int(WeaponModifier) > 0)
					{
						ShotInfo.Value = int(WeaponModifier);
						ShotInfo.ModType = eHit_Success;
						ShotInfo.Reason = FriendlyName;
						ShotModifiers.AddItem(ShotInfo);
					}	
				}	
			}	
		}	
	}	
}