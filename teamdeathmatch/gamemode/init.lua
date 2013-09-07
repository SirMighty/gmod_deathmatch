--AddCSLuaFile( "cl_init.lua" ) --Tell the server that the client needs to download cl_init.lua
--AddCSLuaFile( "shared.lua" ) --Tell the server that the client needs to download shared.lua


include( 'shared.lua' )
include( 'player.lua' )
include( 'npc.lua' )
include( 'variable_edit.lua' )

GM.PlayerSpawnTime = {}

function blue( ply )
 
    ply:SetTeam( 1 )
    ply:Spawn()
    ply:StripWeapons()
    ply:Give( "weapon_crossbow" )
    ply:Give( "weapon_crowbar" )
    ply.GiveAmmo(50, "XBowBolt")
 
end
concommand.Add( "blue", blue )
 
function orange( ply )
 
    ply:SetTeam( 2 )
    ply:Spawn()
    ply:StripWeapons()
    ply:Give( "weapon_pistol" )
    ply:Give( "weapon_stunstick" )
    ply.GiveAmmo(100, "Pistol")
end
concommand.Add( "orange", orange )

function banane( ply )
	print( "DU BIST BANANE!!" )
end

concommand.Add( "banane", banane)




 
--[[---------------------------------------------------------
   Name: gamemode:Initialize( )
   Desc: Called immediately after starting the gamemode 
-----------------------------------------------------------]]
function GM:Initialize( )
	print( "--------------------------------------------------" )
	print( "- Team Deathmatch by mightymadTV and RatPat ------" )
	print( "--------------------------------------------------" )
end


--[[---------------------------------------------------------
   Name: gamemode:InitPostEntity( )
   Desc: Called as soon as all map entities have been spawned
-----------------------------------------------------------]]
function GM:InitPostEntity( )	
end


--[[---------------------------------------------------------
   Name: gamemode:Think( )
   Desc: Called every frame
-----------------------------------------------------------]]
function GM:Think( )
end


--[[---------------------------------------------------------
   Name: gamemode:ShutDown( )
   Desc: Called when the Lua system is about to shut down
-----------------------------------------------------------]]
function GM:ShutDown( )
end

--[[---------------------------------------------------------
   Name: gamemode:DoPlayerDeath( )
   Desc: Carries out actions when the player dies 		 
-----------------------------------------------------------]]
function GM:DoPlayerDeath( ply, attacker, dmginfo )

	ply:CreateRagdoll()
	
	ply:AddDeaths( 1 )
	
	if ( attacker:IsValid() && attacker:IsPlayer() ) then
	
		if ( attacker == ply ) then
			attacker:AddFrags( -1 )
		else
			attacker:AddFrags( 1 )
		end
		
	end
	
end


--[[---------------------------------------------------------
   Name: gamemode:EntityTakeDamage( ent, info )
   Desc: The entity has received damage	 
-----------------------------------------------------------]]
function GM:EntityTakeDamage( ent, info )
end


--[[---------------------------------------------------------
   Name: gamemode:CreateEntityRagdoll( entity, ragdoll )
   Desc: A ragdoll of an entity has been created
-----------------------------------------------------------]]
function GM:CreateEntityRagdoll( entity, ragdoll )
end


-- Set the ServerName every 30 seconds in case it changes..
-- This is for backwards compatibility only - client can now use GetHostName()
local function HostnameThink()

	SetGlobalString( "ServerName", GetHostName() )

end

timer.Create( "HostnameThink", 30, 0, HostnameThink )

--[[---------------------------------------------------------
	Show the default team selection screen
-----------------------------------------------------------]]
function GM:ShowTeam( ply )

	if (!GAMEMODE.TeamBased || true) then return end
	
	local TimeBetweenSwitches = GAMEMODE.SecondsBetweenTeamSwitches or 10
	if ( ply.LastTeamSwitch && RealTime()-ply.LastTeamSwitch < TimeBetweenSwitches ) then
		ply.LastTeamSwitch = ply.LastTeamSwitch + 1;
		ply:ChatPrint( Format( "Please wait %i more seconds before trying to change team again", (TimeBetweenSwitches - (RealTime()-ply.LastTeamSwitch)) + 1 ) )
		return false
	end
	
	-- For clientside see cl_pickteam.lua
	ply:SendLua( "GAMEMODE:ShowTeam()" )

end

--
-- CheckPassword( steamid, networkid, server_password, password, name )
--
-- Called every time a non-localhost player joins the server. steamid is their 64bit
-- steamid. Return false and a reason to reject their join. Return true to allow
-- them to join. 
--
function GM:CheckPassword( steamid, networkid, server_password, password, name )

	-- The server has sv_password set
	if ( server_password != "" ) then

		-- The joining clients password doesn't match sv_password
		if ( server_password != password ) then
			return false, "#GameUI_ServerRejectBadPassword"
		end

	end
	
	--
	-- Returning true means they're allowed to join the server
	--
	return true

end


