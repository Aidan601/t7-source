#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\_zm_utility.gsh;

#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;

#using scripts\shared\ai\zombie_utility;

//Perks
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
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
//#using scripts\zm\_zm_powerup_weapon_minigun;

//Traps
#using scripts\zm\_zm_trap_electric;

#using scripts\zm\_zm_unitrigger;

#using scripts\zm\zm_usermap;

#precache( "fx", "_donut/portal/blue_orb" );
#precache( "fx", "_donut/portal/portal_gun_flash" );
#precache( "fx", "_donut/portal/portal_gun_spark_blue" );
#precache( "fx", "_donut/portal/portal_gun_spark_orange" );
//*****************************************************************************
// MAIN
//*****************************************************************************

function main()
{
	SetDvar("r_extracam_custom_aspectratio", sprintf("{0}", 16.0 / 9.0));
	SetDvar("ai_disableSpawn", 1);
	SetDvar("sprint_shake_enabled", 0);
	SetDvar("player_fallImpact_shake_enabled", 0);
	SetDvar("player_sprintCameraBob", 0);
	SetDvar("bg_weaponBobAmplitudeBase", 0);

    //clientfield::register("clientuimodel", "portal_1_loc_x", VERSION_SHIP, GetMinBitCountForNum( 250 ), "float");
    clientfield::register("toplayer", "portal_muzzle_fx", 21000, 1, "counter");
    clientfield::register("toplayer", "portal_color_fx", 21000, 1, "counter");
	zm_usermap::main();

    level._effect["portal_gun_flash"] = "_donut/portal/portal_gun_flash";
    level._effect["spark_blue"] = "_donut/portal/portal_gun_spark_blue";
    level._effect["spark_orange"] = "_donut/portal/portal_gun_spark_orange";
    level._effect["portal_gun_blue_orb"] = "_donut/portal/blue_orb";

    //Replace starting weapon
	startingWeapon = "portal_gun";
	weapon = getWeapon(startingWeapon);
	level.start_weapon = (weapon);
	
	level._zombie_custom_add_weapons =&custom_add_weapons;
	
	//Setup the levels Zombie Zone Volumes
	level.zones = [];
	level.zone_manager_init_func =&usermap_test_zone_init;
	init_zones[0] = "start_zone";
	level thread zm_zonemgr::manage_zones( init_zones );

	level.pathdist_type = PATHDIST_ORIGINAL;
    
    
    level.portal_1 = struct::get("portal_1_struct", "targetname");
    level.portal_2 = struct::get("portal_2_struct", "targetname");

    thread PortalGunFireTrace();
	callback::on_connect( &PortalGunGravitySystem);
}

function usermap_test_zone_init()
{
	level flag::init( "always_on" );
	level flag::set( "always_on" );
}	

function custom_add_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_levelcommon_weapons.csv", 1);
}

//PORTALS AND PORTAL GUN LOGIC
function Portal_CheckEachFrame()
{
	portal_radius_player = 65; // tweak this value to match the portal size
    portal_radius_ent = 80;
	while (isDefined(level.portal_1_mesh) && isDefined(level.portal_2_mesh))
	{
		// Players
		foreach (player in GetPlayers())
        {
            //if (!IsAlive(player))
                //continue;

            // For portal_1
            dot_now = Portal_GetDotProduct(level.portal_1, player);
            dist_to_portal1 = Distance(player.origin, level.portal_1.origin);

            //IPrintLnBold("BLUE: "+ dot_now);

            if (!IsDefined(player.lastPortal1Dot))
            {
                player.lastPortal1Dot = dot_now;
            }
            else
            {
                if (dist_to_portal1 < portal_radius_player)
                {
                    level.portal_1_surface NotSolid();
                    if (abs(level.portal_1.angles[0]) > 89) // Pitch near +/-90, facing up or down
                    {
                        Portal_TeleportPlayer(player, level.portal_1, level.portal_2, level.portal_2_surface);
                    }
                    else if ((player.lastPortal1Dot > 0 && dot_now < 0) || (player.lastPortal1Dot < 0 && dot_now > 0))
                    {
                        Portal_TeleportPlayer(player, level.portal_1, level.portal_2, level.portal_2_surface);
                    }
                }
                else
                {
                    level.portal_1_surface Solid();
                }
                player.lastPortal1Dot = dot_now;
            }

            // For portal_2
            dot_now2 = Portal_GetDotProduct(level.portal_2, player);
            dist_to_portal2 = Distance(player.origin, level.portal_2.origin);

            //IPrintLnBold("ORANGE: "+ dot_now2);

            if (!IsDefined(player.lastPortal2Dot))
            {
                player.lastPortal2Dot = dot_now2;
            }
            else
            {
                if (dist_to_portal2 < portal_radius_player)
                {
                    level.portal_2_surface NotSolid();
                    if (abs(level.portal_2.angles[0]) > 89) // Pitch near +/-90, facing up or down
                    {
                        Portal_TeleportPlayer(player, level.portal_2, level.portal_1, level.portal_1_surface);
                    }
                    else if ((player.lastPortal2Dot > 0 && dot_now2 < 0) || (player.lastPortal2Dot < 0 && dot_now2 > 0))
                    {
                        Portal_TeleportPlayer(player, level.portal_2, level.portal_1, level.portal_1_surface);
                    }
                }
                else
                {
                    level.portal_2_surface Solid();
                }
                player.lastPortal2Dot = dot_now2;
            }
        }

		// Entities (e.g., cubes, grenades, etc.)
		ents = GetEntArray("grenade", "classname");
		// Add more entity types as needed

		foreach (ent in ents)
		{
			if (!IsDefined(ent))
				continue;

			// For portal_1
			dot_now = Portal_GetDotProduct(level.portal_1, ent);
			dist_to_portal1 = Distance(ent.origin, level.portal_1.origin);

			//if (!IsDefined(ent.lastPortal1Dot))
			//{
				//ent.lastPortal1Dot = dot_now;
			//}
			//else
			//{
				if (dist_to_portal1 < portal_radius_ent)
				{
					//ent NotSolid();
					Portal_TeleportEnt(ent, level.portal_1, level.portal_2);
					//if ((ent.lastPortal1Dot > 0 && dot_now < 0) || (ent.lastPortal1Dot < 0 && dot_now > 0))
					//{
					//	IPrintLnBold("TELEPORT");
					//	Portal_TeleportEnt(ent, level.portal_1, level.portal_2);
					//}
				}
				else
				{
					//ent Solid();
				}
				//ent.lastPortal1Dot = dot_now;
			//}

			// For portal_2
			dot_now2 = Portal_GetDotProduct(level.portal_2, ent);
			dist_to_portal2 = Distance(ent.origin, level.portal_2.origin);

			//if (!IsDefined(ent.lastPortal2Dot))
			//{
				//ent.lastPortal2Dot = dot_now2;
			//}
			//else
			//{
				if (dist_to_portal2 < portal_radius_ent)
				{
					//ent NotSolid();
					Portal_TeleportEnt(ent, level.portal_2, level.portal_1);
					//if ((ent.lastPortal2Dot > 0 && dot_now2 < 0) || (ent.lastPortal2Dot < 0 && dot_now2 > 0))
					//{
					//	Portal_TeleportEnt(ent, level.portal_2, level.portal_1);
					//}
				}
				else
				{
					//ent Solid();
				}
				//ent.lastPortal2Dot = dot_now2;
			//}
		}
		WAIT_SERVER_FRAME;
	}
    level.portalThreadsStarted = false;
    //PLAY SOUND
}

function Portal_GetDotProduct(portal, player)
{
	vecToPlayer = player.origin - portal.origin;
	portalForward = AnglesToForward(portal.angles);
	return VectorDot(vecToPlayer, portalForward);
}

function Portal_TeleportPlayer(player, first_portal, second_portal, second_portal_surface)
{
    if (IsDefined(player.justTeleported) && player.justTeleported)
    	return;

    second_portal_surface NotSolid();
    portal_forward_1 = AnglesToForward(first_portal.angles);

    //CALCULATE NEW POSITION
    local_offset = player.origin - first_portal.origin;
    offset_in_portal1_space = RotateVectorByInverseAngles(local_offset, first_portal.angles);
	offset_in_portal2_space = ( -offset_in_portal1_space[0], -offset_in_portal1_space[1], offset_in_portal1_space[2] );
    rotated_offset = RotateVectorByAngles(offset_in_portal2_space, second_portal.angles);
    player SetOrigin(second_portal.origin + rotated_offset);

    //CALCULATE NEW ANGLES
    player_view = player GetPlayerAngles();
    view_delta = player_view - first_portal.angles;
    view_delta = (view_delta[0], view_delta[1] + 180, view_delta[2]);
    new_angles = second_portal.angles + view_delta;
    if (portal_forward_1[2] > 0.99)
        new_angles = (math::clamp(second_portal.angles[0], -80, 70), second_portal.angles[1], second_portal.angles[2]);
    else
        new_angles = (math::clamp(new_angles[0], -80, 70), new_angles[1], new_angles[2]);
    player SetPlayerAngles(new_angles);

    // CALCULATE NEW VELOCITY
    velocity = player GetVelocity();
    speed = GetBiggestAbsComponent(velocity);
    portal_forward_2 = AnglesToForward(second_portal.angles);
    new_velocity = portal_forward_2 * speed;
    //IPrintLnBold(new_velocity);
    if (portal_forward_2[2] > 0.99 && new_velocity[2] < 280)
    {
        new_velocity = (new_velocity[0], new_velocity[1], 280);
    }
    player SetVelocity(new_velocity);

    PlaySoundAtPosition("portal_enter", player.origin);

    // Debounce
    player.justTeleported = true;
    wait .3;
    second_portal_surface Solid();
    player.justTeleported = false;
}

function Portal_TeleportEnt(entity, first_portal, second_portal)
{	

	if (IsDefined(entity.justTeleported) && entity.justTeleported)
    	return;

    //CALCULATE NEW POSITION
    local_offset = entity.origin - first_portal.origin;
    offset_in_portal1_space = RotateVectorByInverseAngles(local_offset, first_portal.angles);
	offset_in_portal2_space = ( -offset_in_portal1_space[0], -offset_in_portal1_space[1], offset_in_portal1_space[2] );
    rotated_offset = RotateVectorByAngles(offset_in_portal2_space, second_portal.angles);
    entity.origin = second_portal.origin + rotated_offset;

    //CALCULATE NEW ANGLES
    player_view = entity.angles;
    view_delta = player_view - first_portal.angles;
    view_delta = (view_delta[0], view_delta[1] + 180, view_delta[2]);
    entity.angles = second_portal.angles + view_delta;

    //CALCULATE NEW VELOCITY
	velocity = level.LastBombVelocity;
    speed = GetBiggestAbsComponent(velocity);
    portal_forward = AnglesToForward(second_portal.angles);
    new_velocity = portal_forward * speed;

	if (entity.classname == "grenade")
	{
		entity Launch(new_velocity);
        if (level.BombTeleport == false)
        {
            level.BombTeleport = true;
            wait (1);
            level.BombTeleport = false;
        }
	}
}

function PortalGunGravitySystem()
{
    self.holdingCube = undefined;
    isCarrying = false;
    holdingDistance = 55; // Initial hold distance in front of player
    weapon = GetWeapon("portal_gun");
    carryWeapon = GetWeapon("portal_gun_carry");
    origin = Spawn("script_origin", (0,0,0));

    while (1)
    {
        // Pick up or drop/throw
        if (self UseButtonPressed())
        {
            // If not holding, try to pick up
            if (!IsDefined(self.holdingCube))
            {
                cube = GetLookedAtCube(self, 100);
                if (IsDefined(cube))
                {
                    
                    isCarrying = true;
                    // If carrying the portal gun, switch to carry weapon
                    if (self GetCurrentWeapon() == weapon) 
                    {
                        self GiveWeapon(carryWeapon);
                        self SwitchToWeaponImmediate(carryWeapon);
                        self TakeWeapon(weapon);
                        PlaySoundAtPosition("object_use", self.origin);
                        origin PlayLoopSound("object_use_lp");
                    }
                    self.holdingCube = cube;
                    cube.isBeingHeld = true; // Mark as held
                    cube NotSolid();
                    start_cube_angles = cube.angles;
					start_player_angles = self GetPlayerAngles();
					angle_offset = (
						0, // Pitch
						start_cube_angles[1] - start_player_angles[1],
						0  // Roll
					);
                    self thread GravityHoldLoop(angle_offset, holdingDistance);
                    wait(1.033); // Pickup anim duration
                }
                else
                {
                    if (self GetCurrentWeapon() == weapon) 
                    {
                        self SetWeaponAmmoClip(self GetCurrentWeapon(), 0);
                        PlaySoundAtPosition("object_use_failure", self.origin);
                        wait(.5333);
                        self SetWeaponAmmoClip(self GetCurrentWeapon(), 6);
                    }
                }
            }
            // If holding, drop or throw
            else
            {
                cube = self.holdingCube;
                cube Solid();
                if (isCarrying)
                {
                    isCarrying = false;
                    self.holdingCube = undefined;
                    cube.isBeingHeld = false;
                    cube PhysicsLaunch(cube.origin,(0,0,0));
                    if (self GetCurrentWeapon() == carryWeapon) 
                    {
                        self GiveWeapon(weapon);
                        self SetWeaponAmmoClip(weapon, 0);
                        self SetWeaponAmmoStock(weapon, 0);
                        self SwitchToWeapon(weapon);
                        self TakeWeapon(carryWeapon);
                        origin StopLoopSound(1);
                        PlaySoundAtPosition("object_use_stop", self.origin);
                        wait(0.1);
                        self SetWeaponAmmoClip(weapon, 6);
                        self SetWeaponAmmoStock(weapon, 84);
                    }
                    wait(0.633); // Drop anim duration
                }
            }
        }
        WAIT_CLIENT_FRAME;
    }
}

// While holding, update cube to float at adaptive position in front of view
function GravityHoldLoop(angle_offset, holdingDistance)
{
    player = self;
    cube = player.holdingCube;

    while (IsDefined(player.holdingCube) && player.holdingCube == cube)
    {
        // Set min/max height relative to player's feet
        player_feet = player.origin[2];
        min_height = player_feet + 20;      // 20 units above player's feet
        max_height = player_feet + 350;     // 350 units above player's feet
        
        // Adaptive holding position
        eye = player GetTagOrigin("tag_eye");
        angles = player GetPlayerAngles();
        forward = AnglesToForward(angles);

        pitch = angles[0];
        heightOffset = 0;
        if (pitch < 0)
            heightOffset = RemapVal(pitch, 0, -30, 0, 24)-30; // Look up
        else
            heightOffset = RemapVal(pitch, 0, 30, 0, -16)-30;  // Look down

        holdPos = eye + (forward * holdingDistance);
        holdPos = (holdPos[0], holdPos[1], math::clamp(holdPos[2], min_height, max_height));

        cube.origin = holdPos;

        if (IsDefined(player) && IsDefined(player GetVelocity()))
        {
            velocity = player GetVelocity();
            if (GetBiggestAbsComponent(velocity) > 300)
                cube NotSolid();
            else
                cube Solid();
        }

    // Make cube face the player (forward vector points at player's eye)
    direction_to_player = player GetTagOrigin("tag_eye") - cube.origin;
    cube_to_player_angles = VectorToAngles(direction_to_player);
    if (cube.targetname == "mjpw_core_origin" || cube.targetname == "noah_core_origin" || cube.targetname == "saint_core_origin")
        cube.angles = cube_to_player_angles;
    else if (cube.model == "m_0a7141f5_reflection_cube")
        cube.angles = (0, cube_to_player_angles[1] - 90, 0); // rotate -90 degrees yaw
    else if (cube.model == "m_0a7141f5_radio_reference")
        cube.angle = (0, cube_to_player_angles[1] + 90, 0); // rotate 90 degrees yaw
    else
        cube.angles = (0, cube_to_player_angles[1], 0); // only yaw, no pitch

    WAIT_CLIENT_FRAME;
    }
}

// Helper: Ray trace to find the valid cube the player is looking at
function GetLookedAtCube(player, maxDist)
{
    eye = player GetTagOrigin("tag_eye");
	angles = player GetPlayerAngles();
    forward = AnglesToForward(angles);
    end = eye + (forward * maxDist);
    trace = BulletTrace(eye, end, false, player);

    if (!IsDefined(trace))
    {
        //IPrintLnBold("No entity hit by trace.");
        return undefined;
    }
    if (IsDefined(trace["entity"]))
    {
        ent = trace["entity"];
        if (IsDefined(ent.targetname))
            //IPrintLnBold("Trace hit entity targetname: " + ent.targetname);

        // Only allow pick up if not already held and is a valid cube
        if ((ent.targetname == "portal_cube" || ent.targetname == "pickup_object") && !ent.isBeingHeld)
        {
            // Delete the old entity and create a new one with the same properties to fix physic objects teleporting
            old_ent = ent;
            new_ent = Spawn(old_ent.classname, old_ent.origin);
            if (isDefined(old_ent.model))
                new_ent SetModel(old_ent.model);
            if (isDefined(old_ent.angles))
                new_ent.angles = old_ent.angles;
            if (isDefined(old_ent.targetname))
                new_ent.targetname = old_ent.targetname;
            if (isDefined(old_ent.script_int))
                new_ent.script_int = old_ent.script_int;
            if (isDefined(old_ent.isBeingHeld))
                new_ent.isBeingHeld = old_ent.isBeingHeld;
            if (isDefined(old_ent.portalClone))
                new_ent.portalClone = old_ent.portalClone;
            if (isDefined(old_ent.portalClone2))
                new_ent.portalClone2 = old_ent.portalClone2;
            new_ent clientfield::set( "model_change_color", 1 );
            old_ent.origin = (0,0,0);
            old_ent Delete();
            ent = new_ent;
            ent Solid();
            return ent;
        }
        else if ((ent.targetname == "saint_core" || ent.targetname == "noah_core" || ent.targetname == "mjpw_core") && !ent.isBeingHeld)
        {
            //IPrintLnBold("Valid cube for gravity gun detected: " + ent.targetname);
            temp = GetEnt(ent.target,"targetname");
            //if (isDefined(temp) && isDefined(temp.model) && temp.model == "tag_origin_core")
            //{
            //    ent Unlink();
            //    new_origin = Spawn("tag_origin_core", ent.origin);
            //    new_origin.angles = ent.angles;
            //    new_origin.targetname = temp.targetname;
            //    ent LinkTo(new_origin);
            //    temp.origin = (0,0,0);
            //    temp Delete();
            //    IPrintLnBold("temp1");
            //    return new_origin;
            //}
            temp2 = GetEnt(temp.target,"targetname");
            //if (isDefined(temp2) && isDefined(temp2.model) && temp2.model == "tag_origin_core")
            //{
            //    ent Unlink();
            //    new_origin = Spawn("tag_origin_core", ent.origin);
            //    new_origin.angles = ent.angles;
            //    new_origin.targetname = temp2.targetname;
            //    ent LinkTo(new_origin);
            //    temp2.origin = (0,0,0);
            //    temp2 Delete();
            //    IPrintLnBold("temp2");
            //    return new_origin;
            //}
            return temp2;
        }
        else
        {
            //IPrintLnBold("Entity is not a valid cube or is already held.: " + ent.targetname);
            return undefined;
        }
    }
    else
    {
        //IPrintLnBold("Trace did not hit a valid entity.");
    }
    return undefined;
}

function CheckCubesInPortals()
{
    while (level.portal_1 && level.portal_2 && level.portal_1_mesh && level.portal_2_mesh)
    {
        cubes = GetEntArray("portal_cube", "targetname");
        foreach (cube in cubes)
        {
            // Portal 1 -> Portal 2
            if (cube IsTouching(level.portal_1_mesh))
            {
                result = Portal_TransformRelative(cube, level.portal_1, level.portal_2);
                clone_pos = result[0];
                clone_angles = result[1];

                if (!IsDefined(cube.portalClone))
                {
                    cube.portalClone = Spawn("script_model", clone_pos);
                    cube.portalClone SetModel(cube.model);
                    cube.portalClone.angles = clone_angles;
                    //cube.portalClone CloneCubePropertiesFrom(cube);
                }
                else
                {
                    cube.portalClone.origin = clone_pos;
                    cube.portalClone.angles = clone_angles;
                }
            }
            else if (IsDefined(cube.portalClone))
            {
                cube.portalClone Delete();
                cube.portalClone = undefined;
            }

            // Portal 2 -> Portal 1
            if (cube IsTouching(level.portal_2_mesh))
            {
                result = Portal_TransformRelative(cube, level.portal_2, level.portal_1);
                clone_pos = result[0];
                clone_angles = result[1];

                if (!IsDefined(cube.portalClone2))
                {
                    cube.portalClone2 = Spawn("script_model", clone_pos);
                    cube.portalClone2 SetModel(cube.model);
                    cube.portalClone2.angles = clone_angles;
                    //cube.portalClone2 CloneCubePropertiesFrom(cube);
                }
                else
                {
                    cube.portalClone2.origin = clone_pos;
                    cube.portalClone2.angles = clone_angles;
                }
            }
            else if (IsDefined(cube.portalClone2))
            {
                cube.portalClone2 Delete();
                cube.portalClone2 = undefined;
            }
        }
        WAIT_CLIENT_FRAME;
    }
}

// Returns: array(position, angles)
function Portal_TransformRelative(cube, portal_from, portal_to)
{
    //NEW POSITION
    local_offset = cube.origin - portal_from.origin;
    offset_in_portal1_space = RotateVectorByInverseAngles(local_offset, portal_from.angles);
    offset_in_portal2_space = ( -offset_in_portal1_space[0], -offset_in_portal1_space[1], offset_in_portal1_space[2] );
    rotated_offset = RotateVectorByAngles(offset_in_portal2_space, portal_to.angles+(0,180,0));
    final_pos = portal_to.origin + rotated_offset;

    //NEW ANGLES
    local_view_angles = cube.angles - portal_from.angles;
	local_view_angles = ( local_view_angles[0], local_view_angles[1] + 180, local_view_angles[2] );
	final_angles = local_view_angles + portal_to.angles;

    return array(final_pos, final_angles);
}

function PlacePortalManually(struct,portal_type,screenshake)
{
    // Simulate a trace struct:
    trace = [];
    trace["position"] = struct.origin; // example coordinates
    trace["normal"] = AnglesToForward(struct.angles);         // example normal (facing up)
    trace["fraction"] = .5;           // hit something
    trace["entity"] = GetEnt(struct.target,"targetname"); // must be set to a script_brushmodel
    players = GetPlayers();
    if (screenshake)
    {
        ScreenShake(struct.origin,10,10,0,.5);
    }
    foreach (player in players)
    {
        thread PlacePortal(player, portal_type, trace, undefined);
    }
}

function PlacePortal(player, portal_type, trace, flash)
{
    //IPrintLnBold("PLACE");
    // Safety: Check for valid trace and surface
    if (!IsDefined(trace))
    {
        //IPrintLnBold("PlacePortal: trace is not defined");
        return;
    }
    if (!IsDefined(trace["position"]))
    {
        //IPrintLnBold("PlacePortal: trace[position] is not defined");
        return;
    }
    if (trace["fraction"] >= 1.0)
    {
        //IPrintLnBold("PlacePortal: trace[fraction] is " + trace["fraction"]);
        thread PortalSpark(flash, trace["position"],portal_type);
        return;
    }
    if (!IsDefined(trace["entity"]))
    {
        //IPrintLnBold("PlacePortal: trace[entity] is not defined");
        thread PortalSpark(flash, trace["position"],portal_type);
        return;
    }
    if (trace["entity"].classname != "script_brushmodel" && trace["entity"].targetname != "wall")
    {
        thread PortalSpark(flash, trace["position"],portal_type);
       //IPrintLnBold("Entity: " + (isDefined(trace["entity"]) ? trace["entity"].targetname : "undefined"));
        return;
    }

    //Play Sound
    if (portal_type == 1)
        PlaySoundAtPosition("portal_fizzle_01",level.portal_1.origin);
    else
        PlaySoundAtPosition("portal_fizzle_02",level.portal_2.origin);

    portal_origin = trace["position"];
    surface_normal = trace["normal"];

    // Calculate proper up vector
    world_up = (0,0,1);
    dot = abs(VectorDot(surface_normal, world_up));
    if (dot > 0.99)
        up = (0,1,0);
    else
        up = VectorNormalize(world_up - surface_normal * VectorDot(world_up, surface_normal));

    right = VectorNormalize(VectorCross(up, surface_normal));
    up = VectorCross(surface_normal, right);

    portal_angles = VectorToAngles(surface_normal); // You can swap to AxisToAngles later

    // If placing on ground/ceiling, set the X rotation (pitch) to match player view
    if (abs(surface_normal[2]) > 0.99) // Nearly straight up or down
    {
        player_pitch = player GetPlayerAngles()[1];
        portal_angles = (portal_angles[0], player_pitch, portal_angles[2]);
    }

    // Assign portal surface
    if (portal_type == 1)
        level.portal_1_surface = trace["entity"];
    else
        level.portal_2_surface = trace["entity"];

    // Set portal struct origin/angles
    if (portal_type == 1)
    {
        level.portal_1.origin = portal_origin;
        level.portal_1.angles = portal_angles;
    }
    else
    {
        level.portal_2.origin = portal_origin;
        level.portal_2.angles = portal_angles;
    }

    // Spawn portal mesh if not already present
    if (!IsDefined(level.portal_1_mesh) && portal_type == 1)
        level.portal_1_mesh = Spawn("script_model", portal_origin);
    if (!IsDefined(level.portal_2_mesh) && portal_type == 2)
        level.portal_2_mesh = Spawn("script_model", portal_origin);

    // Move mesh to new position and orientation
    if (portal_type == 1)
    {
        level.portal_1_mesh.origin = portal_origin;
        level.portal_1_mesh.angles = portal_angles + (0,0,0);
    }
    else
    {
        level.portal_2_mesh.origin = portal_origin;
        level.portal_2_mesh.angles = portal_angles + (0,0,0);
    }

    if (IsDefined(level.portal_1_mesh))
        level.portal_1_mesh StopLoopSound(1);
    if (IsDefined(level.portal_2_mesh))
        level.portal_2_mesh StopLoopSound(1);

    // Portal model selection
    if (IsDefined(level.portal_1_mesh))
    {
        if (IsDefined(level.portal_2_mesh))
        {
            level.portal_1_mesh SetModel("portal_1_closed");
            level.portal_2_mesh PlayLoopSound("wpn_portal_ambient_lp");
            level.portal_1_mesh PlayLoopSound("wpn_portal_ambient_lp");
        }
        else
            level.portal_1_mesh SetModel("portal_1_closed");
    }
    if (IsDefined(level.portal_2_mesh))
    {
        if (IsDefined(level.portal_1_mesh))
        {
            level.portal_2_mesh SetModel("portal_2_closed");
            level.portal_2_mesh PlayLoopSound("wpn_portal_ambient_lp");
            level.portal_1_mesh PlayLoopSound("wpn_portal_ambient_lp");
        }
        else
            level.portal_2_mesh SetModel("portal_2_closed");
    }

    //Play Sound
    if (portal_type == 1)
        PlaySoundAtPosition("portal_open_blue",portal_origin);
    else
        PlaySoundAtPosition("portal_open_red",portal_origin);

    // Start portal threads if needed
    if ((!IsDefined(level.portalThreadsStarted) || !level.portalThreadsStarted) && IsDefined(level.portal_1_mesh) && IsDefined(level.portal_2_mesh))
    {
        thread Portal_CheckEachFrame();
        //thread CheckCubesInPortals();
        level.portalThreadsStarted = true;
    }
}

function PortalGunFireTrace()
{
    weapon = GetWeapon("portal_gun");
    weapon_2 = GetWeapon("portal_gun_blue");

    blue_fire = GetWeapon("portal_gun_blue_fire");
    orange_fire = GetWeapon("portal_gun_orange_fire");

    while (true)
    {
        foreach (player in GetPlayers())
        {
            if (player GetCurrentWeapon() == weapon || player GetCurrentWeapon() == weapon_2)
            {
                portal_type = 0;
                flash = player GetTagOrigin("tag_flash");
                if (player AttackButtonPressed())
                {
                    portal_type = 1;
                    PlaySoundAtPosition("wpn_portal_gun_fire_blue", player.origin);
                    player SetWeaponAmmoClip(player GetCurrentWeapon(), 6);
                    player clientfield::increment_to_player("portal_color_fx", 1);
                }
                else if (player AdsButtonPressed())
                {
                    portal_type = 2;
                    PlaySoundAtPosition("wpn_portal_gun_fire_red", player.origin);
                    player clientfield::increment_to_player("portal_muzzle_fx", 1);
                }

                if (portal_type > 0)
                {
                    eye = player GetTagOrigin("tag_eye");
                    angles = player GetPlayerAngles();
                    forward = AnglesToForward(angles);
                    end = eye + (forward * 99999999);

                    trace = BulletTrace(eye, end, false, player,true,false);

                    thread PlacePortal(player, portal_type, trace, flash);
                }

                if (portal_type == 2)
                {
                    MagicBullet(orange_fire, flash,trace["position"],player);
                    player SetLowReady(true);
                    wait(.5);
                    player SetLowReady(false);
                }
                else if (portal_type == 1)
                {
                    MagicBullet(blue_fire, flash,trace["position"],player);
                    wait(.5);
                }
            }
        }
        WAIT_CLIENT_FRAME;
    }
}

function PortalSpark(start,end,portal_type)
{
    travel_dist = Distance(start, end);
    travel_speed = 3500;
    travel_time = travel_dist / travel_speed;
    if (travel_time < 10)
    {
        wait(travel_time);
        PlaySoundAtPosition("portal_invalid_surface", end);
        if (portal_type == 1)
            PlayFX( level._effect["spark_blue"],end);
        else
            PlayFX( level._effect["spark_orange"],end);
    }
}
//HELPER FUNCTIONS

// Simple utility: remap pitch for adaptive holding height
function RemapVal(val, A, B, C, D)
{
    if (A == B)
    {
        if (val >= B)
            return D;
        else
            return C;
    }
    return C + (D - C) * (val - A) / (B - A);
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
    return RotateVectorByAngles(vec, (angles[0] * -1, angles[1] * -1, angles[2] * -1));
}

function GetRelativePortalRotation(portal1, portal2) 
{
    yaw_diff = portal2.angles[1] - portal1.angles[1] + 180;
    return (0, yaw_diff, 0);
}

function GetBiggestAbsComponent(vec)
{
    absX = abs(vec[0]);
    absY = abs(vec[1]);
    absZ = abs(vec[2]);
    if (absX >= absY && absX >= absZ)
        return absX;
    else if (absY >= absX && absY >= absZ)
        return absY;
    else
        return absZ;
}

function returnTrue()
{
	return true;
}
