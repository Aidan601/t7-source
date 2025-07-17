#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\zm\_load;
#using scripts\zm\_zm_weapons;

//Perks
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_doubletap2;
#using scripts\zm\_zm_perk_deadshot;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_sleight_of_hand;
#using scripts\zm\_zm_perk_staminup;

//Powerups
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_free_perk;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_nuke;

//Traps
#using scripts\zm\_zm_trap_electric;

#using scripts\zm\zm_usermap;

function main()
{
	clientfield::register("toplayer", "portal_muzzle_fx", 21000, 1, "counter", &toggle_flash_portal_gun, 0,0);
	clientfield::register("toplayer", "portal_color_fx", 21000, 1, "counter", &toggle_color_portal_gun, 0,0);

	zm_usermap::main();

	level._effect["portal_gun_flash"] = "_donut/portal/portal_gun_flash";
	level._effect["portal_gun_blue_orb"] = "_donut/portal/blue_orb";

	//setDvar( "cg_focalDistance", 0.10 );

	callback::on_localclient_connect( &on_player_connect ); //Wait for the player to connect 
	util::waitforclient( 0 );

	include_weapons();
	
	util::waitforclient( 0 );
}

function include_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_levelcommon_weapons.csv", 1);
}

function on_player_connect( localclientnum ) 
{   
	cam_01 = GetEnt( localclientnum, "portal_camera", "targetname" ); // add your script origin targetname
	cam_01 SetExtraCam( 0, 2560, 1440 );
	level.portal_1 = struct::get("portal_1_struct", "targetname");
	level.portal_2 = struct::get("portal_2_struct", "targetname");
	for(;;)
	{
		// Portal world positions and angles
		portal1_pos = level.portal_1.origin;
		portal1_angles = level.portal_1.angles;
		portal2_pos = level.portal_2.origin;
		portal2_angles = level.portal_2.angles;
		
		//IPrintLnBold(self clientfield::get("portal_1_loc_x"));

		player_eye_pos = GetLocalClientEyePos(localclientnum);
		player_angles = GetCamAnglesByLocalClientNum(localclientnum);

		// Step 1: Get offset from portal1 to player
		local_offset = player_eye_pos - portal1_pos;
		// Step 2: Transform offset to portal1's local space (inverse rotate)
		offset_in_portal1_space = RotateVectorByInverseAngles(local_offset, portal1_angles);
		// Step 3: Mirror for portal (classic portal games flip the Z, but depends on your implementation)
		offset_in_portal2_space = ( -offset_in_portal1_space[0], -offset_in_portal1_space[1], offset_in_portal1_space[2] );
		// Step 4: Transform from portal2 local space to world space (rotate)
		rotated_offset = RotateVectorByAngles(offset_in_portal2_space, portal2_angles);
		// Step 5: Place camera at portal2, offset by rotated value
		cam_01.origin = portal2_pos + rotated_offset;
		// Step 6: Correct angles. "Relative" to portal1, mirrored, then added to portal2's
		local_view_angles = player_angles - portal1_angles;
		local_view_angles = ( local_view_angles[0], local_view_angles[1] + 180, local_view_angles[2] );
		cam_01.angles = local_view_angles + portal2_angles;
		// FOV
		playerFOV = GetLocalClientFOV(localclientnum);
		cameraFOV = getFOV(playerFOV);
		cam_01 SetExtraCamFocalLength(0, cameraFOV);
		//level.portal_1 Delete();
		//level.portal_2 Delete();
		WAIT_CLIENT_FRAME;
	}
}

function RotateVectorByAngles(vec, angles) 
{
    forward = AnglesToForward(angles);
    right = AnglesToRight(angles);
    up = AnglesToUp(angles);

    return (vec[0] * forward) + (vec[1] * right) + (vec[2] * up);
}

function RotateVectorByInverseAngles(vec, angles) 
{
    return RotateVectorByAngles(vec, -angles);
}


function getFOV(x)
{
	 return 66.9 + (-1.02 * x) + (0.00464 * x * x);
}

function testfunction()
{
	//IPrintLnBold("CALLBACK");
}

function toggle_flash_portal_gun(localClientNum, n_old_val, n_new_val, b_new_ent, b_initial_snap, str_field_name, b_was_time_jump)
{
	if(n_new_val == 1)
	{
		PlayViewmodelFX(localClientNum,level._effect["portal_gun_flash"],"tag_flash");
	}
}

function toggle_color_portal_gun(localClientNum, n_old_val, n_new_val, b_new_ent, b_initial_snap, str_field_name, b_was_time_jump)
{
	if(n_new_val == 1)
	{
		PlayViewmodelFX(localClientNum,level._effect["portal_gun_blue_orb"],"tag_orb_fx");
	}
}
