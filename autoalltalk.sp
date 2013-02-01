//	------------------------------------------------------------------------------------
//	Filename:		autoalltalk.sp
//	Author:			Malachi
//	Version:		(see PLUGIN_VERSION)
//	Description:
//					Plugin toggles alltalk off during active play, 
//					and on again at end of round and during setup.
// * Changelog (date/version/description):
// * 2013-01-19	-	0.1	-	initial release
//	------------------------------------------------------------------------------------

#pragma semicolon 1

#include <sourcemod>
#include <mapchooser>
#include <nextmap>

#define PLUGIN_VERSION	"0.1"
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
	
	HookEvent("teamplay_round_start", Hook_AlltalkOff);
	HookEvent("teamplay_setup_finished", Hook_AlltalkOff);

	HookEvent("teamplay_round_stalemate", Hook_AlltalkOn);
	HookEvent("teamplay_round_win", Hook_AlltalkOn);
	 		
}

// If this cvar changes, make sure its to a valid map name
// Since the cvar is already changed, we have to set it back
public Hook_g_hAutoAlltalkEnable(Handle:cvar, const String:oldVal[], const String:newVal[])
{
	if ( StrEqual(newVal, "0") || StrEqual(newVal, "1") )
	{
		if( StrEqual(newVal, "0"))
		{
			g_iPluginEnable = 0;
		}
		else
		{
			g_iPluginEnable = 1;
		}
	}
	else
	{
		SetConVarString(cvar, oldVal);
	}
}


// Turn alltalk ON
public Action:Hook_AlltalkOn(Handle:event, const String:name[], bool:dontBroadcast)
{
//	decl String:currentMap[64];
//	GetCurrentMap(currentMap, 64);
	
	if (g_iPluginEnable)
		SetConVarInt(g_hAllTalk, 1);
		
//    return Plugin_Continue;
}


// Turn alltalk OFF
public Action:Hook_AlltalkOff(Handle:event, const String:name[], bool:dontBroadcast)
{
	if (g_iPluginEnable)
		SetConVarInt(g_hAllTalk, 0);
		
//    return Plugin_Continue;
}


// Turn on alltalk on map start
public OnMapStart()
{
	SetConVarInt(g_hAllTalk, 1);
}
