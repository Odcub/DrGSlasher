CreateConVar( "dbd_basetemplate_health", 1500, {FCVAR_ARCHIVE, FCVAR_USERINFO })

CreateConVar( "dbd_basetemplate_damage", 	50, {FCVAR_ARCHIVE, FCVAR_USERINFO })

CreateConVar( "dbd_basetemplate_speed", 300, {FCVAR_ARCHIVE, FCVAR_USERINFO })

CreateConVar( "dbd_basetemplate_wipespeed_decrease", 250, {FCVAR_ARCHIVE, FCVAR_USERINFO })

CreateConVar( "dbd_basetemplate_lungespeedadd", 250, {FCVAR_ARCHIVE, FCVAR_USERINFO })

CreateConVar( "dbd_basetemplate_lungetime", 1, {FCVAR_ARCHIVE, FCVAR_USERINFO })

CreateConVar( "dbd_basetemplate_wanderdistance", 	3000, {FCVAR_ARCHIVE, FCVAR_USERINFO })

CreateConVar( "dbd_basetemplate_spotdur", 8, {FCVAR_ARCHIVE, FCVAR_USERINFO })

CreateConVar( "dbd_basetemplate_bloodlust", 1, {FCVAR_ARCHIVE, FCVAR_USERINFO })

CreateConVar( "dbd_basetemplate_climb", 1, {FCVAR_ARCHIVE, FCVAR_USERINFO })

CreateConVar( "dbd_basetemplate_bloodlust_time", 8, {FCVAR_ARCHIVE, FCVAR_USERINFO })

CreateConVar( "dbd_basetemplate_bloodlust_add", 50, {FCVAR_ARCHIVE, FCVAR_USERINFO })

CreateConVar( "dbd_basetemplate_bloodlust_max", 3, {FCVAR_ARCHIVE, FCVAR_USERINFO })

CreateConVar( "dbd_basetemplate_stepsndlvl", 70, {FCVAR_ARCHIVE, FCVAR_USERINFO })

CreateConVar( "dbd_basetemplate_randomc", 0, {FCVAR_ARCHIVE, FCVAR_USERINFO }) 

CreateConVar( "dbd_basetemplate_cankickdoors", 0, {FCVAR_ARCHIVE, FCVAR_USERINFO })

CreateConVar( "dbd_basetemplate_checklockers", 1, {FCVAR_ARCHIVE, FCVAR_USERINFO })

-----------------------------------------
hook.Add("Initialize","DBD basetemplate",function()
-----------------------------------------
end)

hook.Add( "PopulateToolMenu", "DrGSlasher_Settings", function()
	spawnmenu.AddToolMenuOption( "DrGSlasher", "BASE TEMPLATE", "Custom_MenuTEMPLATE", "Settings", "", "", function( panel )

		panel:ClearControls()

		panel:Help(" ")
		panel:Help("			---------- Main settings ----------			")

		panel:NumSlider( "Health", "dbd_basetemplate_health", 1, 10000 )
		panel:ControlHelp("Sets their HP to this amount (Default : 1500)")
		
		panel:NumSlider( "Damage", "dbd_basetemplate_damage", 1, 1000 )
		panel:ControlHelp("Sets their Melee Damage to this amount (Default : 50)")

		panel:NumSlider( "Move Speed", "dbd_basetemplate_speed", 50, 1000 )
		panel:ControlHelp("Sets their Movement speed to this amount (Default : 300)")
		
		panel:NumSlider( "Wipe Speed Decrease", "dbd_basetemplate_wipespeed_decrease", 0, 300 )
		panel:ControlHelp("Decreases this amount of move speed while playing their wipe animation (Default : 250)")

		panel:NumSlider( "Lunge Speed Add", "dbd_basetemplate_lungespeedadd", 0, 600,0 )
		panel:ControlHelp("Sets how much speed is added when lunging (Default : 250)")
		
		panel:NumSlider( "Lunge Time", "dbd_basetemplate_lungetime", 1, 5 )
		panel:ControlHelp("Coup de grace (Default : 1)")
		
		panel:NumSlider( "Bloodlust Time", "dbd_basetemplate_bloodlust_time", 5, 60,0 )
		panel:ControlHelp("how long until a new bloodlust level is added (Default : 8)")
		
		panel:NumSlider( "Bloodlust Speed Add", "dbd_basetemplate_bloodlust_add", 0, 100,0 )
		panel:ControlHelp("How much speed does each level add (Default : 50)")
		
		panel:NumSlider( "Max bloodlust levels", "dbd_basetemplate_bloodlust_max", 1, 20,0 )
		panel:ControlHelp("Maxmimum amount of levels allowed for bloodlust (Default : 3)")

		panel:NumSlider( "Wander Distance", "dbd_basetemplate_wanderdistance", 1, 5000 )
		panel:ControlHelp("Sets how far they can wander (Default : 3000)")
		
		panel:NumSlider(  "Lose Duration", "dbd_basetemplate_spotdur", 5, 60,0 )
		panel:ControlHelp("how long until they lose an enemy when not visible (Default : 8)")
		
		panel:NumSlider( "Footstep Sound Level", "dbd_basetemplate_stepsndlvl", 40, 100,0 )
		panel:ControlHelp("How far can the footstep sound be heard (Default : 70)")
		
		panel:CheckBox( "Climb Ledges","dbd_basetemplate_climb")
		panel:ControlHelp("Should they be able to climb ledges?")


		panel:CheckBox("Kick Doors", "dbd_basetemplate_cankickdoors")
		panel:ControlHelp("Should they kick open locked doors?")

		panel:CheckBox("Check Lockers", "dbd_basetemplate_checklockers")
		panel:ControlHelp("Enables/Disables locker interactions.")
 

	end )
end )