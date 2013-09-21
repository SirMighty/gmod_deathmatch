
--include( 'shared.lua' )
--include( 'cl_scoreboard.lua' )
--include( 'cl_targetid.lua' )
--include( 'cl_hudpickup.lua' )
--include( 'cl_spawnmenu.lua' )
--include( 'cl_deathnotice.lua' )
--include( 'cl_pickteam.lua' )
--include( 'cl_voice.lua' )

--Test start
CreateClientConVar("vtarget", "1", true, false)
surface.CreateFont("Calibri", ScreenScale(32), 400, true, false, "PlayerName")
function DrawPlayerInfo( )
 if( LocalPlayer():GetInfo("vtarget") == "1" ) then
	for k, v in pairs( player.GetAll( ) ) do	
	
		if( v != LocalPlayer( ) ) then
		
			if( v:Alive( ) ) then
			
				local alpha = 0
				
				local position = v:GetPos( )
				local position = Vector( position.x, position.y, position.z + 75 )
				local screenpos = position:ToScreen( )
				local dist = position:Distance( LocalPlayer( ):GetPos( ) )
				local dist = dist / 4
				local dist = math.floor( dist )
				
				if( dist > 100 ) then
				
					alpha = 255 - ( dist - 100 )
					
				else
				
					alpha = 255
					
				end
				
				if( alpha > 255 ) then
				
					alpha = 255
					
				elseif( alpha < 0 ) then
				
					alpha = 0
					
				end

				local color = Color(255,255,255, alpha)
				if( v:GetNWString("vTitle") == nil ) then
					draw.SimpleTextOutlined(v:Nick(), "PlayerName", screenpos.x, screenpos.y, Color(team.GetColor(v:Team()).r, team.GetColor(v:Team()).g, team.GetColor(v:Team()).b, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,alpha))
				else
					draw.SimpleTextOutlined(v:Nick(), "PlayerName", screenpos.x, screenpos.y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,alpha))
					--draw.SimpleText(v:GetNWString("vTitle"), "Trebuchet24", screenpos.x, screenpos.y+27, Color(255,255,255,alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,alpha))				
				end
				if( v:GetNWInt("chatopen") == 1 ) then
					draw.SimpleText("Typing", "Default", screenpos.x, screenpos.y+45, Color(255, 0, 0, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,alpha))
				end
					
					
				
				
			end
			
		end
		
	end
 end
end
hook.Add("HUDPaint", "vTargetPaint", DrawPlayerInfo)
hook.Add("HUDDrawTargetID", "vTargetRemove", function() return false end)
---Test end

function HUDHide( myhud )
	for k, v in pairs {"CHudHealth","CHudBattery", "CHudCrosshair"} do
		if myhud == v then return false end
	end
end

hook.Add("HUDShouldDraw","HUDHide",HUDHide)

function NewHUD()
	local ply = LocalPlayer()
	local HP = ply:Health()
	local Armor = ply:Armor()

	if(HP < 0) then
		HP = 0
	end

	if(Armor < 0) then
		Armor = 0
	end

	local CROSSHAIR_COLOR = Color(255,0,0,255)

	--Fadenkreuz
	draw.RoundedBox(0, (ScrW() / 2) - 15, (ScrH() / 2), 10, 1, CROSSHAIR_COLOR)
	draw.RoundedBox(0, (ScrW() / 2) + 5, (ScrH() / 2), 10, 1, CROSSHAIR_COLOR)

	draw.RoundedBox(0, (ScrW() / 2) - 1, (ScrH() / 2), 1, 1, CROSSHAIR_COLOR)

	draw.RoundedBox(0, (ScrW() / 2) - 1, (ScrH() / 2) - 15, 1, 10, CROSSHAIR_COLOR)
	draw.RoundedBox(0, (ScrW() / 2) - 1, (ScrH() / 2) + 5, 1, 10, CROSSHAIR_COLOR)

	--HealthBox
	draw.RoundedBox(8, 50, ScrH() - 140, 320, 115, Color(50, 50, 50, 150))

	--HP and Armor
	draw.RoundedBox( 2, 60, ScrH() - 100, 300, 40, Color(255, 255, 255, 50) )
	draw.RoundedBox( 2, 60, ScrH() - 100, math.Clamp(HP, 0, 200)*2, 40, Color( 255, 0, 0, 255) )
	draw.RoundedBox( 2, 60, ScrH() - 100 + 40 + 5, math.Clamp(Armor, 0, 200)*2, 20, Color( 255, 255, 0, 128) )
	draw.SimpleText( "HP: " .. HP, "Trebuchet24", 60, ScrH() - 120, Color(255, 0, 0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	--Teamscore
	draw.SimpleText( "" .. team.GetScore(1), "DermaLarge", ScrW() / 2 - 15, 2, Color( 0, 0, 255, 220 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
	draw.SimpleText( "/", "DermaLarge", ScrW() / 2, 2, Color( 50, 50, 50, 220 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	draw.SimpleText( "" .. team.GetScore(2) .. "", "DermaLarge", ScrW() / 2 + 15, 2, Color( 255, 150, 0, 220 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
end

hook.Add("HUDPaint", "NewHUD", NewHUD)

function set_team()
 
local frame = vgui.Create( "DFrame" )
frame:SetPos( ScrW() / 2 - 100, ScrH() / 2 - 100 ) --Set the window in the middle of the players screen/game window
frame:SetSize( 210, 202 ) --Set the size
frame:SetTitle( "Change Team" ) --Set title
frame:SetVisible( true )
frame:SetDraggable( false )
frame:ShowCloseButton( true )
frame:MakePopup()
 

Blue_Team = vgui.Create( "DButton", frame )
Blue_Team:SetPos( 10, 30 ) --Place it half way on the tall and 5 units in horizontal
Blue_Team:SetSize( 190, 80 )
Blue_Team:SetText( "Blue Team" )
Blue_Team.DoClick = function() --Make the player join team 1
    RunConsoleCommand( "blue" )
    frame:Close()
end 
 
Orange_Team = vgui.Create( "DButton", frame )
Orange_Team:SetPos( 10, 110 ) --Place it next to our previous one
Orange_Team:SetSize( 190, 80 )
Orange_Team:SetText( "Orange Team" )
Orange_Team.DoClick = function() --Make the player join team 2
    RunConsoleCommand( "orange" )
    frame:Close()
end

end

concommand.Add( "team_menu", set_team )
 

--[[---------------------------------------------------------
   Name: gamemode:Initialize( )
   Desc: Called immediately after starting the gamemode 
-----------------------------------------------------------]]
function GM:Initialize( )

	GAMEMODE.ShowScoreboard = false
	print( "--------- cl_initialize --------------" )
	set_team()	
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
   Name: gamemode:PlayerDeath( )
   Desc: Called when a player dies. If the attacker was
		  a player then attacker will become a Player instead
		  of an Entity. 		 
-----------------------------------------------------------]]
function GM:PlayerDeath( ply, attacker )
end

--[[---------------------------------------------------------
   Name: gamemode:PlayerBindPress( )
   Desc: A player pressed a bound key - return true to override action		 
-----------------------------------------------------------]]
function GM:PlayerBindPress( pl, bind, down )

	return false	
	
end

--[[---------------------------------------------------------
   Name: gamemode:HUDShouldDraw( name )
   Desc: return true if we should draw the named element
-----------------------------------------------------------]]
function GM:HUDShouldDraw( name )

	-- Allow the weapon to override this
	local ply = LocalPlayer()
	if ( IsValid( ply ) ) then
	
		local wep = ply:GetActiveWeapon()
		
		if (wep && wep:IsValid() && wep.HUDShouldDraw != nil) then
		
			return wep.HUDShouldDraw( wep, name )
			
		end
		
	end

	return true;
end

--[[---------------------------------------------------------
   Name: gamemode:HUDPaint( )
   Desc: Use this section to paint your HUD
-----------------------------------------------------------]]
function GM:HUDPaint()

	hook.Run( "HUDDrawTargetID" )
	hook.Run( "HUDDrawPickupHistory" )
	hook.Run( "DrawDeathNotice", 0.85, 0.04 )

end

--[[---------------------------------------------------------
   Name: gamemode:HUDPaintBackground( )
   Desc: Same as HUDPaint except drawn before
-----------------------------------------------------------]]
function GM:HUDPaintBackground()
end

--[[---------------------------------------------------------
   Name: gamemode:GUIMouseReleased( mousecode )
   Desc: The mouse was double clicked
-----------------------------------------------------------]]
function GM:GUIMouseDoublePressed( mousecode, AimVector )
	-- We don't capture double clicks by default, 
	-- We just treat them as regular presses
	GAMEMODE:GUIMousePressed( mousecode, AimVector )
end

--[[---------------------------------------------------------
   Name: gamemode:ShutDown( )
   Desc: Called when the Lua system is about to shut down
-----------------------------------------------------------]]
function GM:ShutDown( )
end


--[[---------------------------------------------------------
   Name: gamemode:RenderScreenspaceEffects( )
   Desc: Bloom etc should be drawn here (or using this hook)
-----------------------------------------------------------]]
function GM:RenderScreenspaceEffects()
end

--[[---------------------------------------------------------
   Name: gamemode:GetTeamColor( ent )
   Desc: Return the color for this ent's team
		This is for chat and deathnotice text
-----------------------------------------------------------]]
function GM:GetTeamColor( ent )

	local team = TEAM_UNASSIGNED
	--if (ent.Team) then team = ent:Team() end
	return GAMEMODE:GetTeamNumColor( ent.team )

end


--[[---------------------------------------------------------
   Name: gamemode:GetTeamNumColor( num )
   Desc: returns the colour for this team num
-----------------------------------------------------------]]
function GM:GetTeamNumColor( num )

	return team.GetColor( num )

end

--[[---------------------------------------------------------
   Name: gamemode:OnChatTab( str )
   Desc: Tab is pressed when typing (Auto-complete names, IRC style)
-----------------------------------------------------------]]
function GM:OnChatTab( str )

	local LastWord
	for word in string.gmatch( str, "%a+" ) do
	     LastWord = word;
	end
	
	if (LastWord == nil) then return str end
	
	playerlist = player.GetAll()
	
	for k, v in pairs( playerlist ) do
		
		local nickname = v:Nick()
		
		if ( string.len(LastWord) < string.len(nickname) &&
			 string.find( string.lower(nickname), string.lower(LastWord) ) == 1 ) then
				
			str = string.sub( str, 1, (string.len(LastWord) * -1) - 1)
			str = str .. nickname
			return str
			
		end		
		
	end
		
	return str;

end

--[[---------------------------------------------------------
   Name: gamemode:StartChat( teamsay )
   Desc: Start Chat.
   
		 If you want to display your chat shit different here's what you'd do:
			In StartChat show your text box and return true to hide the default
			Update the text in your box with the text passed to ChatTextChanged
			Close and clear your text box when FinishChat is called.
			Return true in ChatText to not show the default chat text
			
-----------------------------------------------------------]]
function GM:StartChat( teamsay )
	return false
end

--[[---------------------------------------------------------
   Name: gamemode:FinishChat()
-----------------------------------------------------------]]
function GM:FinishChat()
end

--[[---------------------------------------------------------
   Name: gamemode:ChatTextChanged( text)
-----------------------------------------------------------]]
function GM:ChatTextChanged( text )
end


--[[---------------------------------------------------------
   Name: ChatText
   Allows override of the chat text
-----------------------------------------------------------]]
function GM:ChatText( playerindex, playername, text, filter )

	if ( filter == "chat" ) then
		Msg( playername, ": ", text, "\n" )
	else
		Msg( text, "\n" )
	end
	
	return false

end

--[[---------------------------------------------------------
   Name: gamemode:PostProcessPermitted( str )
   Desc: return true/false depending on whether this post process should be allowed
-----------------------------------------------------------]]
function GM:PostProcessPermitted( str )

	return true

end


--[[---------------------------------------------------------
   Name: gamemode:PostRenderVGUI( )
   Desc: Called after VGUI has been rendered
-----------------------------------------------------------]]
function GM:PostRenderVGUI()
end

--[[---------------------------------------------------------
   Name: gamemode:PreRender( )
   Desc: Called before all rendering
		 Return true to NOT render this frame for some reason (danger!)
-----------------------------------------------------------]]
function GM:PreRender()
	return false;
end

--[[---------------------------------------------------------
   Name: gamemode:PostRender( )
   Desc: Called after all rendering
-----------------------------------------------------------]]
function GM:PostRender()

end

--[[---------------------------------------------------------
   Name: gamemode:GetVehicles( )
   Desc: Gets the vehicles table..
-----------------------------------------------------------]]
function GM:GetVehicles()

	return vehicles.GetTable()
	
end

--[[---------------------------------------------------------
   Name: gamemode:RenderScene( )
   Desc: Render the scene
-----------------------------------------------------------]]
function GM:RenderScene( origin, angle, fov )
end

--[[---------------------------------------------------------
   Name: CalcVehicleThirdPersonView
-----------------------------------------------------------]]
function GM:CalcVehicleView( Vehicle, ply, view )

	if ( Vehicle.GetThirdPersonMode == nil ) then
		-- This hsouldn't ever happen.
		return
	end

	--
	-- If we're not in third person mode - then get outa here stalker
	--
	if ( !Vehicle:GetThirdPersonMode() ) then return view end

	-- Don't roll the camera 
	-- view.angles.roll = 0

	local mn, mx = Vehicle:GetRenderBounds()
	local radius = (mn - mx):Length()
	local radius = radius + radius * Vehicle:GetCameraDistance();

	-- Trace back from the original eye position, so we don't clip through walls/objects
	local TargetOrigin = view.origin + ( view.angles:Forward() * -radius )
	local WallOffset = 4;
		  
	local tr = util.TraceHull( 
	{
		start	= view.origin,
		endpos	= TargetOrigin,
		filter	= Vehicle,
		mins	= Vector( -WallOffset, -WallOffset, -WallOffset ),
		maxs	= Vector( WallOffset, WallOffset, WallOffset ),
	}) 
	
	view.origin			= tr.HitPos
	view.drawviewer		= true

	--
	-- If the trace hit something, put the camera there.
	--
	if ( tr.Hit && !tr.StartSolid) then
		view.origin = view.origin + tr.HitNormal * WallOffset
	end

	return view

end

--[[---------------------------------------------------------
   Name: CalcView
   Allows override of the default view
-----------------------------------------------------------]]
function GM:CalcView( ply, origin, angles, fov, znear, zfar )
	
	local Vehicle	= ply:GetVehicle()
	local Weapon	= ply:GetActiveWeapon()
	
	local view = {}
	view.origin 		= origin
	view.angles			= angles
	view.fov 			= fov
	view.znear			= znear
	view.zfar			= zfar
	view.drawviewer		= false

	--
	-- Let the vehicle override the view
	--
	if ( IsValid( Vehicle ) ) then return GAMEMODE:CalcVehicleView( Vehicle, ply, view ) end

	--
	-- Let drive possibly alter the view
	--
	if ( drive.CalcView( ply, view ) ) then return view end
	
	--
	-- Give the player manager a turn at altering the view
	--
	player_manager.RunClass( ply, "CalcView", view )

	-- Give the active weapon a go at changing the viewmodel position
	
	if ( IsValid( Weapon ) ) then
	
		local func = Weapon.GetViewModelPosition
		if ( func ) then
			view.vm_origin,  view.vm_angles = func( Weapon, origin*1, angles*1 ) -- Note: *1 to copy the object so the child function can't edit it.
		end
		
		local func = Weapon.CalcView
		if ( func ) then
			view.origin, view.angles, view.fov = func( Weapon, ply, origin*1, angles*1, fov ) -- Note: *1 to copy the object so the child function can't edit it.
		end
	
	end
	
	return view
	
end

--
-- If return true: 		Will draw the local player
-- If return false: 	Won't draw the local player
-- If return nil:	 	Will carry out default action
--
function GM:ShouldDrawLocalPlayer( ply )

	return player_manager.RunClass( ply, "ShouldDrawLocal" )

end

--[[---------------------------------------------------------
   Name: gamemode:AdjustMouseSensitivity()
   Desc: Allows you to adjust the mouse sensitivity.
		 The return is a fraction of the normal sensitivity (0.5 would be half as sensitive)
		 Return -1 to not override.
-----------------------------------------------------------]]
function GM:AdjustMouseSensitivity( fDefault )

	local ply = LocalPlayer()
	if (!ply || !ply:IsValid()) then return -1 end

	local wep = ply:GetActiveWeapon()
	if ( wep && wep.AdjustMouseSensitivity ) then
		return wep:AdjustMouseSensitivity()
	end

	return -1
	
end

--[[---------------------------------------------------------
   Name: gamemode:ForceDermaSkin()
   Desc: Return the name of skin this gamemode should use.
		 If nil is returned the skin will use default
-----------------------------------------------------------]]
function GM:ForceDermaSkin()

	--return "example"
	return nil
	
end

--[[---------------------------------------------------------
   Name: gamemode:PostPlayerDraw()
   Desc: The player has just been drawn.
-----------------------------------------------------------]]
function GM:PostPlayerDraw( ply )

	
end

--[[---------------------------------------------------------
   Name: gamemode:PrePlayerDraw()
   Desc: The player is just about to be drawn.
-----------------------------------------------------------]]
function GM:PrePlayerDraw( ply )

	
end

--[[---------------------------------------------------------
   Name: gamemode:GetMotionBlurSettings()
   Desc: Allows you to edit the motion blur values
-----------------------------------------------------------]]
function GM:GetMotionBlurValues( x, y, fwd, spin )

	-- fwd = 0.5 + math.sin( CurTime() * 5 ) * 0.5

	return x, y, fwd, spin
	
end


--[[---------------------------------------------------------
   Name: gamemode:InputMouseApply()
   Desc: Allows you to control how moving the mouse affects the view angles
-----------------------------------------------------------]]
function GM:InputMouseApply( cmd, x, y, angle )
	
	--angle.roll = angle.roll + 1	
	--cmd:SetViewAngles( Ang )
	--return true
	
end


--[[---------------------------------------------------------
   Name: gamemode:OnAchievementAchieved()
-----------------------------------------------------------]]
function GM:OnAchievementAchieved( ply, achid )
	
	chat.AddText( ply, Color( 230, 230, 230 ), " earned the achievement ", Color( 255, 200, 0 ), achievements.GetName( achid ) );
	
end

--[[---------------------------------------------------------
   Name: gamemode:PreDrawSkyBox()
   Desc: Called before drawing the skybox. Return true to not draw the skybox.
-----------------------------------------------------------]]
function GM:PreDrawSkyBox()
	
	--return true;
	
end

--[[---------------------------------------------------------
   Name: gamemode:PostDrawSkyBox()
   Desc: Called after drawing the skybox
-----------------------------------------------------------]]
function GM:PostDrawSkyBox()
	
end

--
-- Name: GM:PostDraw2DSkyBox
-- Desc: Called right after the 2D skybox has been drawn - allowing you to draw over it.
-- Arg1:
-- Ret1:
--
function GM:PostDraw2DSkyBox()

end

--[[---------------------------------------------------------
   Name: gamemode:PreDrawOpaqueRenderables()
   Desc: Called before drawing opaque entities
-----------------------------------------------------------]]
function GM:PreDrawOpaqueRenderables( bDrawingDepth, bDrawingSkybox )
	
	--	return true;
	
end

--[[---------------------------------------------------------
   Name: gamemode:PreDrawOpaqueRenderables()
   Desc: Called before drawing opaque entities
-----------------------------------------------------------]]
function GM:PostDrawOpaqueRenderables( bDrawingDepth, bDrawingSkybox )
		
end

--[[---------------------------------------------------------
   Name: gamemode:PreDrawOpaqueRenderables()
   Desc: Called before drawing opaque entities
-----------------------------------------------------------]]
function GM:PreDrawTranslucentRenderables( bDrawingDepth, bDrawingSkybox )
	
	-- return true
	
end

--[[---------------------------------------------------------
   Name: gamemode:PreDrawOpaqueRenderables()
   Desc: Called before drawing opaque entities
-----------------------------------------------------------]]
function GM:PostDrawTranslucentRenderables( bDrawingDepth, bDrawingSkybox )
		
end

--[[---------------------------------------------------------
   Name: gamemode:CalcViewModelView()
   Desc: Called to set the view model's position
-----------------------------------------------------------]]
function GM:CalcViewModelView( Weapon, ViewModel, OldEyePos, OldEyeAng, EyePos, EyeAng )
		
	--OldEyePos = OldEyePos + VectorRand() * 2
	--ViewModel:SetPos( OldEyePos, OldEyeAng )
		
	if ( !IsValid( Weapon ) ) then return end
	if ( Weapon.CalcViewModelView == nil ) then return end
		
	Weapon:CalcViewModelView( ViewModel, OldEyePos, OldEyeAng, EyePos, EyeAng )
	
end

--[[---------------------------------------------------------
   Name: gamemode:PreDrawViewModel()
   Desc: Called before drawing the view model
-----------------------------------------------------------]]
function GM:PreDrawViewModel( ViewModel, Player, Weapon )
		
	if ( !IsValid( Weapon ) ) then return false end

	player_manager.RunClass( Player, "PreDrawViewModel", ViewModel, Weapon )

	if ( Weapon.PreDrawViewModel == nil ) then return false end
	return Weapon:PreDrawViewModel( ViewModel, Weapon, Player )
	
end

--[[---------------------------------------------------------
   Name: gamemode:PostDrawViewModel()
   Desc: Called after drawing the view model
-----------------------------------------------------------]]
function GM:PostDrawViewModel( ViewModel, Player, Weapon )

	if ( !IsValid( Weapon ) ) then return false end

	if ( Weapon.UseHands || !Weapon:IsScripted() ) then

		local hands = LocalPlayer():GetHands()
		if ( IsValid( hands ) ) then hands:DrawModel() end

	end

	player_manager.RunClass( Player, "PostDrawViewModel", ViewModel, Weapon )

	if ( Weapon.PostDrawViewModel == nil ) then return false end		
	return Weapon:PostDrawViewModel( ViewModel, Weapon, Player )
	
end

--[[---------------------------------------------------------
   Name: gamemode:DrawPhysgunBeam()
   Desc: Return false to override completely
-----------------------------------------------------------]]
function GM:DrawPhysgunBeam( ply, weapon, bOn, target, boneid, pos )

	-- Do nothing
	return true

end

--[[---------------------------------------------------------
   Name: gamemode:NetworkEntityCreated()
   Desc: Entity is created over the network
-----------------------------------------------------------]]
function GM:NetworkEntityCreated( ent )

end

--[[---------------------------------------------------------
   Name: gamemode:CreateMove( command )
   Desc: Allows the client to change the move commands 
			before it's send to the server
-----------------------------------------------------------]]
function GM:CreateMove( cmd )

	if ( drive.CreateMove( cmd ) ) then return true end

	if ( player_manager.RunClass( LocalPlayer(), "CreateMove", cmd ) ) then return true end

end

--[[---------------------------------------------------------
   Name: gamemode:PreventScreenClicks()
   Desc: The player is hovering over a ScreenClickable world
-----------------------------------------------------------]]
function GM:PreventScreenClicks( cmd )

	--
	-- Returning true in this hook will prevent screen clicking sending IN_ATTACK
	-- commands to the weapons. We want to do this in the properties system, so 
	-- that you don't fire guns when opening the properties menu. Holla!
	--

	return false

end

--[[---------------------------------------------------------
   Name: gamemode:GUIMousePressed( mousecode )
   Desc: The mouse has been pressed on the game screen
-----------------------------------------------------------]]
function GM:GUIMousePressed( mousecode, AimVector )

end

--[[---------------------------------------------------------
   Name: gamemode:GUIMouseReleased( mousecode )
   Desc: The mouse has been released on the game screen
-----------------------------------------------------------]]
function GM:GUIMouseReleased( mousecode, AimVector )

end

function GM:PreDrawHUD()

end

function GM:PostDrawHUD()

end

function GM:DrawOverlay()

end

function GM:DrawMonitors()

end

function GM:PreDrawEffects()

end

function GM:PostDrawEffects()

end

function GM:PreDrawHalos()

end

function GM:CloseDermaMenus()

end

function GM:CreateClientsideRagdoll( entity, ragdoll )

end