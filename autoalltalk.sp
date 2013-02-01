//	------------------------------------------------------------------------------------
//	Filename:		autoalltalk.sp
//	Author:			Malachi
//	Version:		(see PLUGIN_VERSION)
//	Description:
//					Plugin toggles alltalk off during active play, 
//					and on again at end of round and during setup.
// * Changelog (date/version/description):
// * 2013-01-19	-	0.1	-	initial release
// * 2013-01-19	-	0.2	-	add debug msgs, seperate functions
//	------------------------------------------------------------------------------------

#pragma semicolon 1

#include <sourcemod>
#include <mapchooser>
//#include <nextmap>

#define PLUGIN_VERSION	"0.2"
#define DEFAULT_ENABLED	"1"


new Handle:g_hAllTalk = INVALID_HANDLE;
new Handle:g_hAutoAlltalkEnable = INVALID_HANDLE;
new g_iPluginEnable;

public Plugin:myinfo = 
{
	name = "Auto Alltalk",
	author = "Malachi",
	description = "Toggles alltalk off during gameplay",
	version = PLUGIN_VERSION,
	url = "www.necrophix.com"
}


public OnPluginStart()
{
	g_hAutoAlltalkEnable = CreateConVar("sm_autoalltalk", DEFAULT_ENABLED, "Auto Alltalk: Enable=1, Disable=0", FCVAR_PLUGIN);
	if (g_hAutoAlltalkEnable != INVALID_HANDLE)
	{
		HookConVarChange(g_hAutoAlltalkEnable, Hook_g_hAutoAlltalkEnable);
	}

	SetConVarBounds(g_hAutoAlltalkEnable, ConVarBound_Upper, true, 1.0);		
	SetConVarBounds(g_hAutoAlltalkEnable, ConVarBound_Lower, true, 0.0);		

	g_iPluginEnable = GetConVarInt (g_hAutoAlltalkEnable);
	
	g_hAllTalk = FindConVar("sv_alltalk");
	
	HookEvent("teamplay_round_start", Hook_RoundStart);
	HookEvent("teamplay_setup_finished", Hook_SetupFinished);
	HookEvent("teamplay_round_stalemate", Hook_RoundStalemate);
	HookEvent("teamplay_round_win", Hook_RoundWin); 
	HookEvent("teamplay_round_active", Hook_RoundActive); 
	 		
}

// If this cvar changes, make sure its to a valid map name
// Since the cvar is already changed, we have to set it back
public Hook_g_hAutoAlltalkEnable(Handle:cvar, const String:oldVal[], const String:newVal[])
{
	if ( StrEqual(newVal, "0") || StrEqual(newVal, "1") )
	{
		if( StrEqual(newVal, "0"))
		{
			PrintToServer("sm_autoalltalk=0");
			g_iPluginEnable = 0;
		}
		else
		{
			PrintToServer("sm_autoalltalk=1");
			g_iPluginEnable = 1;
		}
	}
	else
	{
		SetConVarString(cvar, oldVal);
	}
}


// Round Active, turn alltalk xxx
public Action:Hook_RoundActive(Handle:event, const String:name[], bool:dontBroadcast)
{
	PrintToServer("[autoalltalk.smx] Notify: Round Active.");
	return Plugin_Continue;
}


// Round start, turn alltalk OFF
// Only do this for ctf?
public Action:Hook_RoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	if (g_iPluginEnable)
	{
		PrintToServer("[autoalltalk.smx] Round Start: Turning off alltalk.");
		SetConVarInt(g_hAllTalk, 0);
	}
	else
	{
		PrintToServer("[autoalltalk.smx] Plugin Disabled: Round Start.");
	}
	return Plugin_Continue;
}


// Setup finished, turn alltalk OFF
public Action:Hook_SetupFinished(Handle:event, const String:name[], bool:dontBroadcast)
{
	if (g_iPluginEnable)
	{
		PrintToServer("[autoalltalk.smx] Setup Finished: Turning off alltalk.");
		SetConVarInt(g_hAllTalk, 0);
	}
	else
	{
		PrintToServer("[autoalltalk.smx] Plugin Disabled: Setup Finished.");
	}
	return Plugin_Continue;
}


// Round win, turn alltalk ON
public Action:Hook_RoundStalemate(Handle:event, const String:name[], bool:dontBroadcast)
{
	if (g_iPluginEnable)
	{
		PrintToServer("[autoalltalk.smx] Round Stalemate: Turning on alltalk.");
		SetConVarInt(g_hAllTalk, 1);
	}
	else
	{
		PrintToServer("[autoalltalk.smx] Plugin Disabled: Round Stalemate.");
	}
	return Plugin_Continue;
}


// End of round, turn alltalk ON
public Action:Hook_RoundWin(Handle:event, const String:name[], bool:dontBroadcast)
{
	if (g_iPluginEnable)
	{
		PrintToServer("[autoalltalk.smx] Round Win: Turning on alltalk.");
		SetConVarInt(g_hAllTalk, 1);
	}
	else
	{
		PrintToServer("[autoalltalk.smx] Plugin Disabled: Round Win.");
	}
	return Plugin_Continue;
}


// Turn on alltalk on map start - do we need this?
//public OnMapStart()
//{
//	SetConVarInt(g_hAllTalk, 1);
//}
