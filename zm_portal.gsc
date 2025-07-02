#using scripts\zm\_zm_equipment; 
#using scripts\zm\_zm_hero_weapon; 
#using scripts\shared\lui_shared; 
#using scripts\zm\_zm_perks; 
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
#using scripts\shared\music_shared;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;

#using scripts\shared\ai\zombie_utility;

#using scripts\lilrobot\_inspectable_weapons;

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

#using scripts\zm\zm_usermap;

#using scripts\zm\zm_giant_cleanup_mgr;

// SPECIALISTS
//#using scripts\zm\_hb21_zm_hero_weapon;

// Sphynx's Console Commands
#using scripts\Sphynx\commands\_zm_commands;
#using scripts\Sphynx\commands\_zm_name_checker;

#using scripts\zm\_zm_t8_hud;

#precache( "triggerstring", "ZOMBIE_NEED_POWER" );
#precache( "triggerstring", "ZOMBIE_ELECTRIC_SWITCH");
#precache( "triggerstring", "ZOMBIE_ELECTRIC_SWITCH_OFF");
 
#precache( "triggerstring", "ZOMBIE_PERK_QUICKREVIVE","500" );
#precache( "triggerstring", "ZOMBIE_PERK_QUICKREVIVE","1500" );
#precache( "triggerstring", "ZOMBIE_PERK_FASTRELOAD","3000" );
#precache( "triggerstring", "ZOMBIE_PERK_DOUBLETAP","2000" );
#precache( "triggerstring", "ZOMBIE_PERK_JUGGERNAUT","2500" );
#precache( "triggerstring", "ZOMBIE_PERK_MARATHON", "2000" );
#precache( "triggerstring", "ZOMBIE_PERK_DEADSHOT", "1500" );
#precache( "triggerstring", "ZOMBIE_PERK_WIDOWSWINE", "4000" );
#precache( "triggerstring", "ZOMBIE_PERK_ADDITIONALPRIMARYWEAPON","4000" );
 
#precache( "triggerstring", "ZOMBIE_PERK_PACKAPUNCH","5000" );
#precache( "triggerstring", "ZOMBIE_PERK_PACKAPUNCH","1000" );
#precache( "triggerstring", "ZOMBIE_PERK_PACKAPUNCH_AAT","2500" );
#precache( "triggerstring", "ZOMBIE_PERK_PACKAPUNCH_AAT","500" );
 
#precache( "triggerstring", "ZOMBIE_RANDOM_WEAPON_COST","950" );
#precache( "triggerstring", "ZOMBIE_RANDOM_WEAPON_COST","10" );
 
#precache( "triggerstring", "ZOMBIE_UNDEFINED" );

#precache( "fx", "dlc0/factory/fx_laser_hotspot_factory" );
#precache( "fx", "dlc0/factory/fx_laserbeam_long_factory" );

#define PLAYTYPE_REJECT 1
#define PLAYTYPE_QUEUE 2
#define PLAYTYPE_ROUND 3
#define PLAYTYPE_SPECIAL 4
#define PLAYTYPE_GAMEEND 5

//*****************************************************************************
// MAIN
//*****************************************************************************

function main()
{
	SetDvar("r_extracam_custom_aspectratio", sprintf("{0}", 16.0 / 9.0));
	SetDvar("ai_disableSpawn", 1);
    SetDvar( "bg_fallDamageMinHeight", 999998 );
    SetDvar( "bg_fallDamageMaxHeight", 999999 );
    
    clientfield::register( "scriptmover", "model_change_color", VERSION_SHIP, GetMinBitCountForNum(2), "int" );

    VideoStart("loadingscreen", true);

    inspectable::add_inspectable_weapon( GetWeapon("t9_410ironhide"), 6.63 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_410ironhide_up"), 6.63 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_1911"), 3.33 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_1911_rdw_up"), 5 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_1911_ldw_up"), 5 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_ak47"), 5.83 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_ak47_up"), 5.83 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_rpk"), 5.83 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_rpk_up"), 5.83 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_ak74u"), 5.93 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_ak74u_up"), 5.93 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_amp63"), 3.33 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_amp63_rdw_up"), 3.16 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_amp63_ldw_up"), 3.16 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_aug"), 6.83 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_aug_up"), 6.83 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_aug_hbar"), 6.83 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_aug_hbar_up"), 6.83 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_bullfrog"), 4.36 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_bullfrog_up"), 4.36 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_c58"), 5.26 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_c58_up"), 5.26 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_hk21"), 5.26 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_hk21_up"), 5.26 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_carv2"), 8.1 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_carv2_up"), 8.1 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_diamatti"), 6.23 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_diamatti_up"), 6.23 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_dmr14"), 5.86 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_dmr14_up"), 5.86 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_m14classic"), 5.86 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_m14classic_up"), 5.86 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_em2"), 4.83 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_em2_up"), 4.83 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_fara83"), 6.86 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_fara83_up"), 6.86 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_ffar1"), 4.83 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_ffar1_up"), 4.83 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_gallo_sa12"), 4.33 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_gallo_sa12_up"), 4.33 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_grav"), 7.03 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_grav_up"), 7.03 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_galatz"), 7.03 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_galatz_up"), 7.03 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_groza"), 6.13 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_groza_up"), 6.13 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_hauer77"), 3.56 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_hauer77_up"), 3.56 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_krig6"), 4.33 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_krig6_up"), 4.33 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_ksp45"), 4.9 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_ksp45_up"), 4.9 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_lapa"), 4.9 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_lapa_up"), 4.9 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_lc10"), 5.26 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_lc10_up"), 5.26 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_lw3_tundra"), 7 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_lw3_tundra_up"), 7 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_m16"), 6.13 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_m16_up"), 6.13 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_m60"), 10 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_m60_up"), 10 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_m79"), 4.33 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_m79_up"), 4.33 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_m82"), 8.13 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_m82_up"), 8.13 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_mac10"), 6.13 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_mac10_up"), 6.13 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_magnum"), 5.1 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_magnum_up"), 5.1 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_marshal"), 6.43 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_marshal_rdw_up"), 5.93 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_marshal_ldw_up"), 5.93 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_mg82"), 9.73 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_mg82_up"), 9.73 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_milano821"), 6.03 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_milano821_up"), 6.03 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_mp5"), 4.33 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_mp5_up"), 4.33 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_mp5k"), 4.33 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_mp5k_up"), 4.33 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_nail_gun"), 5.63 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_nail_gun_up"), 5.63 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_ots9"), 3.83 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_ots9_up"), 3.83 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_pelington703"), 6.56 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_pelington703_up"), 6.56 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_ppsh41_base"), 7.56 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_ppsh41_base_up"), 7.56 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_ppsh41_drum"), 7.56 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_ppsh41_drum_up"), 7.56 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_qbz83"), 6.13 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_qbz83_up"), 6.13 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_rpd"), 6.23 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_rpd_up"), 6.23 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_rpg7"), 6.63 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_rpg7_up"), 6.63 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_stoner63"), 5.86 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_stoner63_up"), 3.76 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_streetsweeper"), 5.6 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_streetsweeper_up"), 5.6 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_swiss_k31_scope"), 6.23 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_swiss_k31_scope_up"), 6.23 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_swiss_k31_irons"), 6.23 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_swiss_k31_irons_up"), 6.23 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_tec9"), 4.9 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_tec9_up"), 4.9 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_type63"), 5.7 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_type63_up"), 5.7 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_xm4"), 5.16 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_xm4_up"), 4.6 );
	
	inspectable::add_inspectable_weapon( GetWeapon("t9_zrg20mm"), 6.67 );
	inspectable::add_inspectable_weapon( GetWeapon("t9_zrg20mm_up"), 6.67 );

    zm_usermap::main();

    zm_perks::spare_change();
    level.round_spawn_func = &portal_round_spawn;
    callback::on_spawned( &watch_max_ammo );

    thread setupMusic();

    level.laserEndpoints = [];

    level._effect["laser_spark"] = "dlc0/factory/fx_laser_hotspot_factory";
    level._effect["laser_beam"] = "dlc0/factory/fx_laserbeam_long_factory";

	//Replace starting weapon
	startingWeapon = "";
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

    level.loop_ele = 0;

	//thread ButtonInit();
	//thread DoorInit();
    thread Toilet();
    thread ElevatorInit();
	thread FanInit();
    thread CameraInit();
    thread CubeInit();
    thread BurnItems();
    thread Chamber00();
    //thread BrodesCore();
    //thread LaserChamber01();
    //thread Chamber01();
    //thread Chamber02();
    thread Hub();
    thread PAPDoor();
    thread EndGameButtons();
    //thread LaserChamber02();
    thread FaithPlateChamber();
    thread FaithPlateInit();
    thread PGChamber01();
}

function setupMusic()
{
    //zm_audio::musicState_Create("round_start", PLAYTYPE_ROUND, "null_sound");
    //zm_audio::musicState_Create("round_start_short", PLAYTYPE_ROUND, "null_sound");
    //zm_audio::musicState_Create("round_start_first", PLAYTYPE_ROUND, "beyond_light_intro");
    //zm_audio::musicState_Create("round_end", PLAYTYPE_ROUND, "null_sound");
    //zm_audio::musicState_Create("game_over", PLAYTYPE_GAMEEND, "null_sound");

    zm_audio::musicState_Create("portal_boss", PLAYTYPE_SPECIAL, "portal_boss");
    zm_audio::musicState_Create("tech_diff", PLAYTYPE_SPECIAL, "tech_diff");
    zm_audio::musicState_Create("main_01", PLAYTYPE_QUEUE, "main_01");
    zm_audio::musicState_Create("main_02", PLAYTYPE_QUEUE, "main_02");
}


function usermap_test_zone_init()
{
	zm_zonemgr::add_adjacent_zone( "start_zone", "start2_zone", "start_start2");
    zm_zonemgr::add_adjacent_zone( "start2_zone", "start3_zone", "start2_start3");
    zm_zonemgr::add_adjacent_zone( "start3_zone", "hub_elevator_zone", "start3_hub_elevator");
    zm_zonemgr::add_adjacent_zone( "hub_elevator_zone", "hub_zone", "hub_elevator_hub");
    zm_zonemgr::add_adjacent_zone( "hub_zone", "top_hub_zone", "top_hub");
    zm_zonemgr::add_adjacent_zone( "hub_zone", "hub2_zone", "hub_hub2");
    zm_zonemgr::add_adjacent_zone( "hub_zone", "office_zone", "hub_office");
    zm_zonemgr::add_adjacent_zone( "hub2_zone", "pump_zone", "hub2_pump");
    zm_zonemgr::add_adjacent_zone( "pump_zone", "power_zone", "pump_power");
    zm_zonemgr::add_adjacent_zone( "pump_zone", "fall_zone", "pump_fall");
    zm_zonemgr::add_adjacent_zone( "fall_zone", "pump_bottom_zone", "fall_pump_bottom");
    zm_zonemgr::add_adjacent_zone( "pump_bottom_zone", "pump_elevator_zone", "pump_bottom_pump_elevator");
    zm_zonemgr::add_adjacent_zone( "pump_elevator_zone", "fall_zone", "pump_elevator_fall");
    zm_zonemgr::add_adjacent_zone( "fall_zone", "40s_zone", "fall_40s");
    zm_zonemgr::add_adjacent_zone( "40s_zone", "pap_zone", "40s_pap");
    zm_zonemgr::add_adjacent_zone( "fall_zone", "boss_zone", "fall_boss");
    zm_zonemgr::add_adjacent_zone( "pump_bottom_zone", "pg1_zone", "pump_bottom_pg1");
    zm_zonemgr::add_adjacent_zone( "pg1_zone", "pg2_zone", "pg1_pg2");
    zm_zonemgr::add_adjacent_zone( "pg2_zone", "pg3_zone", "pg2_pg3");
    zm_zonemgr::add_adjacent_zone( "fall_zone", "lch1_zone", "fall_lch1" );
    zm_zonemgr::add_adjacent_zone( "lch1_zone", "lch2_zone", "lch1_lch2" );
    zm_zonemgr::add_adjacent_zone( "lch2_zone", "lch3_zone", "lch2_lch3" );
    zm_zonemgr::add_adjacent_zone( "lch3_zone", "lch4_zone", "lch3_lch4" );

    level flag::init( "always_on" );
	level flag::set( "always_on" );
}	

function custom_add_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_levelcommon_weapons.csv", 1);
}

function CameraInit()
{
    cameras = GetEntArray("portal_camera","targetname");
    foreach (camera in cameras)
    {
       camera thread Camera();
    }
}

function CubeInit()
{
    cubes = GetEntArray("portal_cube","targetname");
    foreach (cube in cubes)
    {
        cube clientfield::set( "model_change_color", 1 );
    }
}

function Camera()
{
    while (true)
    {
        foreach (player in GetPlayers())
        {
            if (!IsAlive(player))
                continue;
                
            eye = player GetTagOrigin("j_head");
            dir = VectorToAngles(eye - self.origin);
            self RotateTo(dir,0.1);
            wait(0.1);
        }
        WAIT_SERVER_FRAME;
    }
}

function Toilet()
{
    model = GetEnt("toilet", "targetname");
    trigger = GetEnt("toilet_trigger", "targetname");
    trigger SetCursorHint("HINT_NOICON");
	trigger SetHintString("");
    while(1)
    {
        trigger waittill("trigger", player);
        PlaySoundAtPosition("usetoilet_flush",model.origin +(0,0,5));
        exploder::exploder("flush");
        wait(2);
        PlaySoundAtPosition("usetoilet_thank",model.origin +(0,0,5));
        wait(4);
        exploder::exploder_stop("flush");
        wait(8);
    }
}

function BurnItems()
{
    grids = GetEntArray("burn_items","targetname");
    while(true)
    {
        foreach(grid in grids)
        {
            foreach (player in GetPlayers())
            {
                if (player IsTouching(grid))
                {
                    //IPrintLnBold("BURN");
                    if ((isDefined(level.portal_1_mesh) || isDefined(level.portal_2_mesh)) && player GetCurrentWeapon() == GetWeapon("portal_gun"))
                        doAnim = true;
                    else
                        doAnim = false;
                    if (isDefined(level.portal_1_mesh))
                    {
                        level.portal_1_mesh Delete();
                        PlaySoundAtPosition("portal_fizzle_01", level.portal_1.origin);
                    }
                    if (isDefined(level.portal_2_mesh))
                    {
                        level.portal_2_mesh Delete();
                        PlaySoundAtPosition("portal_fizzle_02", level.portal_2.origin);
                    }
                    if (doAnim)
                    {
                        player SetWeaponAmmoClip(GetWeapon("portal_gun"), 0);
                        wait(0.5333);
                        player SetWeaponAmmoClip(GetWeapon("portal_gun"), 6);
                        player SetWeaponAmmoStock(GetWeapon("portal_gun"), 84);
                    }
                }
            }
            //Add items and cubes as well
        }
        WAIT_SERVER_FRAME;
    }
}

function Chamber00()
{
    //open_trigger_1 = GetEnt("portal_door_1","targetname");
    door_1 = GetEnt("door1", "targetname");
	close_trigger_1 = GetEnt("close1", "targetname");
    vox_1 = GetEnt("vox_1", "targetname");
    portal_1_chamber_0 = GetEnt("portal_1_chamber_0", "targetname");
    portal_2_chamber_0 = GetEnt("portal_2_chamber_0", "targetname");

    button = GetEnt("button_01","targetname");
    door = GetEnt("portal_door_01", "targetname");
    model = GetEnt("item_dropper_model_1", "targetname");

    true_sign = GetEnt("doorstate_true_01", "targetname");
    false_sign = GetEnt("doorstate_false_01", "targetname");

    button thread Button(door,true_sign,false_sign);

    door_1 thread DoorOpen(true);
    level waittill("initial_blackscreen_passed");
    foreach (player in GetPlayers())
    {
        player util::show_hud(false);
    }
    VideoStop("loadingscreen");
    thread PlayAnnouncerSound("announcer_00",30.72);
    wait(31);
    level thread zm_audio::sndMusicSystem_PlayState("tech_diff");
    
    thread PlacePortalManually(portal_1_chamber_0,1,true);
    thread PlacePortalManually(portal_2_chamber_0,2,true);

	//CHAMBER 01 ENTER
    //open_trigger_1 waittill("trigger", player);
	close_trigger_1 waittill("trigger", player);
	door_1 thread DoorOpen(false);
    
    thread PlayAnnouncerSound("announcer_01",11.938);
    model thread Dropper();
    VideoStart("laser_portal", true);
    
    //CHAMBER 0 EXIT
    vox_1 waittill("trigger", player);
    thread PlayAnnouncerSound("announcer_02",7.835);
    thread Chamber01();
}

function Chamber01()
{
    vox_2 = GetEnt("vox_2", "targetname");
    vox_3 = GetEnt("vox_3", "targetname");
    entrance = GetEnt("portal_door_02", "targetname");
    exit = GetEnt("portal_door_03", "targetname");
    entrance_trig = GetEnt("portal_door_02_open_trig", "targetname");
    close_trig = GetEnt("portal_door_02_close_trig", "targetname");
    chamber_01_start = GetEnt("chamber_01_start", "targetname");

    switch_01_trig = GetEnt("chamber_01_switch_01_trigger", "targetname");
    switch_02_trig = GetEnt("chamber_01_switch_02_trigger", "targetname");
    switch_03_trig = GetEnt("chamber_01_switch_03_trigger", "targetname");

    orange_portal_chamber_02 = GetEnt("orange_portal_chamber_02", "targetname");

    true_sign = GetEnt("doorstate_true_02", "targetname");
    false_sign = GetEnt("doorstate_false_02", "targetname");


    button = GetEnt("button_02","targetname");

    button thread Button(exit, true_sign, false_sign);

    entrance DoorOpen(false);
    vox_2 waittill("trigger", player);
    thread PlayAnnouncerSound("announcer_03",14.05);
    entrance_trig waittill("trigger", player);
    entrance DoorOpen(true);
    close_trig waittill("trigger", player);
    entrance DoorOpen(false);
    chamber_01_start waittill("trigger", player);
    thread PlacePortalManually(orange_portal_chamber_02, 2,true);
    VideoStop("laser_portal");
    switch_01_trig thread SwitchChamber01();
    switch_02_trig thread SwitchChamber01();
    switch_03_trig thread SwitchChamber01();
    vox_3 waittill("trigger", player);
    thread PlayAnnouncerSound("announcer_04",17.293);
    thread Chamber02();
}

function Chamber02()
{
    door = GetEnt("portal_door_04", "targetname");
    vox_4 = GetEnt("portal_door_04_trigger", "targetname");
    trigger = GetEnt("portal_door_04_trigger", "targetname");
    trigger_close = GetEnt("portal_door_04_trigger_close", "targetname");
    door2 = GetEnt("portal_door_05", "targetname");
    trigger2 = GetEnt("portal_door_05_trigger", "targetname");
    trap_arms = GetEntArray("intro3_arm", "targetname");
    rubble = GetEnt("intro3_rubble","targetname");
    trap_trigger = GetEnt("trap_trigger", "targetname");
    level thread zm_audio::sndMusicSystem_StopAndFlush();
    music::setmusicstate("none");

    VideoStart("animal_king",true);

    vox_4 waittill("trigger", player);
    thread Chamber2Vox();
    trigger waittill("trigger", player);
    door thread DoorOpen(true);
    trigger_close waittill("trigger", player);
    door thread DoorOpen(false);
    VideoStop("animal_king");
    

    trigger2 waittill("trigger", player);
    door2 thread DoorOpen(true);

    thread BrodesCore();

    foreach(arm in trap_arms)
    {
        floors = GetEntArray(arm.target, "targetname");
        foreach(floor in floors)
        {
            floor EnableLinkTo();
            floor LinkTo(arm,"arm64x64_export_013");
        }
    }
    trap_trigger waittill("trigger", player);
    rubble thread scene::play("fxanim_intro3_rubble",rubble);
    foreach(arm in trap_arms)
    {
        arm thread scene::play("fxanim_intro3_arm", arm);
    }

    trigger_pickup = GetEnt("trigger_pickup", "targetname");
    pistol = GetEnt(trigger_pickup.target, "targetname");
    trigger_pickup SetCursorHint("HINT_NOICON");
    trigger_pickup SetHintString("Hold ^3[{+activate}]^7 to pick up weapon");
    trigger_pickup waittill("trigger", player);
    pistol Delete();
    trigger_pickup Delete();
    player GiveWeapon(GetWeapon("t9_1911"));
    player SwitchToWeapon(GetWeapon("t9_1911"));
    SetDvar("ai_disableSpawn", 0);
    player util::show_hud(true);
    level flag::set("start_start2");
    level flag::set("start2_start3");
    door3 = GetEnt("portal_door_06", "targetname");
    trigger3 = GetEnt("portal_door_06_trigger", "targetname");
    trigger_close3 = GetEnt("portal_door_06_trigger_close", "targetname");
    trigger3 waittill("trigger", player);
    door3 thread DoorOpen(true);
    trigger_close3 waittill("trigger", player);
    door3 thread DoorOpen(false);
    //thread Hub();
}

function Chamber2Vox()
{
    PlaySoundAtPosition("ding_on",(0,0,0));
    wait(0.19);
    PlaySoundAtPosition("announcer_05",(0,0,0));
}

function BrodesCore()
{
    core = GetEnt("brodes_core","targetname");
    origin = util::spawn_model("tag_origin",core.origin, core.angles);
    core EnableLinkTo();
    core LinkTo(origin);
    core thread scene::play("fxanim_brodes_idle", core);
    origin MoveX(157,1.5);
    while (true)
    {
        foreach (player in GetPlayers())
        {
            if (!IsAlive(player))
                continue;

            eye = player GetTagOrigin("tag_eye");
            dir = VectorNormalize(eye - core.origin);
            angles = VectorToAngles(dir);
            origin.angles = angles;
        }
        WAIT_SERVER_FRAME;
    }
}

function EquipPortalGun()
{
	self endon("death");
	self endon("disconnect");
    level.CurrentPortalGun = "portal_gun_blue";
    //self zm_weapons::weapon_give(GetWeapon("portal_gun"),false,false,true,true);
    self thread zm_equipment::show_hint_text( "Press ^3[{+actionslot 1}]^7 to wield the Handheld Portal Device.");
	while(self.sessionstate == "playing")
	{
		if(self ActionSlotOneButtonPressed() && self GetCurrentWeapon() != GetWeapon(level.CurrentPortalGun))
		{
			self zm_weapons::weapon_give(GetWeapon(level.CurrentPortalGun),false,false,true,true);
        }
        WAIT_SERVER_FRAME;
    }
}

function Hub()
{
    enter_trigger = GetEnt("enter_hub_trig", "targetname");
    underground_doors = GetEntArray("underground_door", "targetname");
    double_doors = GetEntArray("double_door", "targetname");
    enter_trigger waittill("trigger", player);
    level flag::set("hub_elevator_hub");
    level flag::set("top_hub");
    level flag::set("hub_hub2");
    SetDvar("ai_disableSpawn", 0);
    player util::show_hud(true);
    player GiveWeapon(GetWeapon("t9_1911"));
    level thread zm_audio::sndMusicSystem_PlayState("main_01");
    foreach (underground_door in underground_doors)
    {
        underground_door thread UndergroundDoors();
    }
    foreach (double_door in double_doors)
    {
        double_door thread DoubleDoors();
    }
    thread Borealis();
    thread LaserTrap();
    thread EasterEggDoor();

    switch_01_trig = GetEnt("water_trigger_1", "targetname");
    switch_02_trig  = GetEnt("water_trigger_2", "targetname");
    water = GetEnt("water_sink","targetname");
    level.water_switch_count = 0;
    switch_01_trig thread WaterSwitch();
    switch_02_trig thread WaterSwitch();
    while(level.water_switch_count != 2)
    {
        foreach (player in GetPlayers())
        {
            if (player IsTouching(water))
            {
                player DoDamage(player.health + 1000, player.origin);
            }
        }
        WAIT_SERVER_FRAME;
    }
    water MoveZ(-258,20);
    timer = 0;
    level flag::set("pump_fall");
    level flag::set("fall_pump_bottom");
    while (timer < 20)
    {
        foreach (player in GetPlayers())
        {
            if (player IsTouching(water))
            {
                player DoDamage(player.health + 1000, player.origin);
            }
        }
        wait(.5);
        timer += 0.5;
    }
}

function EndGameButtons()
{
    button_1 = GetEnt("final_button_01", "targetname");
    button_2 = GetEnt("final_button_02", "targetname");
    platforms = GetEntArray("final_platforms", "targetname");
    clip = GetEnt("final_platform_clip", "targetname");
    final_door_1 = GetEnt("final_door_1", "targetname");
    final_door_2 = GetEnt("final_door_2", "targetname");
    final_door_3 = GetEnt("final_door_3", "targetname");
    final_door_4 = GetEnt("final_door_4", "targetname");
    final_top_clip = GetEnt("final_top_clip", "targetname");
    final_door_1 EnableLinkTo();
    final_door_1 LinkTo(platforms[0]);
    final_door_2 EnableLinkTo();
    final_door_2 LinkTo(platforms[0]);
    clip EnableLinkTo();
    clip LinkTo(platforms[0]);
    button_1 thread Button(undefined, undefined, undefined);
    button_2 thread Button(undefined, undefined, undefined);
    level.FinalButtons = 0;
    min_z = -4894;
    max_z = -4159.75;
    while (1)
    {
        temp = level.FinalButtons;
        foreach (platform in platforms)
        {
            if (temp == 2 && platform.origin[2] < max_z)
                platform MoveZ(9.79, 0.2);
            else if (temp != 2 && platform.origin[2] > min_z)
                platform MoveZ(-9.79, 0.2);
        }
        if (platform.origin[2] >= max_z)
        {
            final_top_clip Hide();
        }
        else
        {
            final_top_clip Show();
        }
        //IPrintLnBold(temp);
        wait(0.2);
    }
}

function EasterEggDoor()
{
    button = GetEnt("ee_button", "targetname");
    door = GetEnt("easter_egg_door", "targetname");
    button Button(door, undefined, undefined);
}

function WaterSwitch()
{
    model = GetEnt(self.target, "targetname");
    origin = GetEnt(model.target, "targetname");
    self SetCursorHint("HINT_NOICON");
    self SetHintString("");
    level flag::wait_till("power_on");
    level flag::set("fall_40s");
    self waittill("trigger", player);
    level.water_switch_count++;
    model EnableLinkTo();
    model LinkTo(origin);
    origin RotateRoll(-65,1);
    PlaySoundAtPosition("paint_switch",model.origin);
}

function Borealis()
{
    trigger = GetEnt("borealis_trigger", "targetname");
    button = GetEnt(trigger.target,"targetname");
    borealis = GetEnt("borealis", "targetname");
    intercoms = GetEntArray("johnson_intercom", "targetname");
    trigger SetCursorHint("HINT_NOICON");
    trigger SetHintString("");
    foreach (intercom in intercoms)
    {
        intercom thread IntercomJohnson();
    }
    button thread scene::play("fxanim_underground_switch_up", button);
    trigger waittill("trigger", player);
    button thread scene::play("fxanim_underground_switch_down", button);
    wait(1);
    button thread scene::play("fxanim_underground_switch_up", button);
    borealis Delete();
    
}

function IntercomJohnson()
{
    self SetCursorHint("HINT_NOICON");
    self SetHintString("");
    press = false;
    while(1)
    {
        self waittill("trigger", player);
        if (press == false)
        {
            press = true;
            player.score += 100;
        }
        PlaySoundAtPosition("misc_tests_"+self.script_int,(0,0,0));
        wait(13);
    }
}

function UndergroundDoors()
{
    trigger = GetEnt(self.target, "targetname");
    clip = GetEnt(trigger.target, "targetname");
    trigger SetCursorHint("HINT_NOICON");
    trigger SetHintString("Hold ^3[{+activate}]^7 to open door [Cost: " + trigger.script_int + "]");
    self thread scene::init("fxanim_underground_door_open", self);
    while (1)
    {
        trigger waittill("trigger", player);
        if (player.score >= trigger.script_int)
        {
            self thread scene::play("fxanim_underground_door_open", self);
            player PlayLocalSound("zmb_cha_ching");
            player.score -= trigger.script_int;
            trigger Delete();
            clip.origin = (0,0,0);
            clip NotSolid();
            clip Hide();
            clip Delete();
            if (isDefined(trigger.script_string))
            {
                level flag::set(trigger.script_string);
            }
            break;
        }
        else
        {
            player PlayLocalSound("zmb_no_cha_ching");
        }
    }
}

function DoubleDoors()
{
    trigger = GetEnt(self.target, "targetname");
    clip = GetEnt(trigger.target, "targetname");
    trigger SetCursorHint("HINT_NOICON");
    trigger SetHintString("Hold ^3[{+activate}]^7 to open Door [Cost: " + trigger.script_int + "]");
    self thread scene::init("fxanim_sliding_door_double_open", self);
    while (1)
    {
        trigger waittill("trigger", player);
        if (player.score >= trigger.script_int)
        {
            self thread scene::play("fxanim_sliding_door_double_open", self);
            player PlayLocalSound("zmb_cha_ching");
            player.score -= trigger.script_int;
            trigger Delete();
            clip Delete();
            if (isDefined(trigger.script_string))
            {
                level flag::set(trigger.script_string);
            }
            break;
        }
        else
        {
            player PlayLocalSound("zmb_no_cha_ching");
        }
    }
}

function LaserTrap()
{
    trigger = GetEnt("trap_switch_trigger", "targetname");
    model = GetEnt(trigger.target, "targetname");
    emitter = GetEnt(model.target, "targetname");
    trigger SetCursorHint("HINT_NOICON");
    model thread scene::play("fxanim_underground_switch_up", model);
    trigger SetHintString("Requires power.");
    level flag::wait_till("power_on");
    trigger SetHintString("Hold ^3[{+activate}]^7 to purchase Trap [Cost: 1500]");
    while(true)
    {
        trigger waittill("trigger", player);
        if (player.score >= 1500)
        {
            player PlayLocalSound("zmb_cha_ching");
            player.score -= 1500;
            model thread scene::play("fxanim_underground_switch_down", model);
            trigger SetHintString("The trap is active.");
            wait(1);
            emitter thread LaserEmitter(99);
            thread LaserTrapTimer();
            wait(30);
            trigger SetHintString("The trap is cooling down.");
            wait(60);
            model thread scene::play("fxanim_underground_switch_up", model);
            trigger Show();
        }
        else
            player PlayLocalSound("zmb_no_cha_ching");
    }
}

function LaserTrapTimer()
{
    wait(30);
    level.active = false;
}

function LaserFaithChamber()
{
    emitter = GetEnt("laser_emitter_3", "targetname");
    catcher = GetEnt("laser_catcher_3", "targetname");
    emitter thread LaserEmitter(3);
    catcher thread LaserCatcher(undefined,undefined,3);
    thread CatcherArms1();
    catcher = GetEnt("laser_catcher_4", "targetname");
    catcher thread LaserCatcher(undefined,undefined,4);
    thread CatcherArms2();
    trigger = GetEnt("switch_888_trigger", "targetname");
    trigger thread SwitchFaith01();
}

function CatcherArms1()
{
    arms = GetEntArray("telescope_arm_1", "targetname");
    clip = GetEnt("telescope_arm_1_clip", "targetname");
    clip EnableLinkTo();
    clip LinkTo(arms[0],"panel_top");
    prev_state = false;
    while (1)
    {
        current_state = isDefined(level.Chm03_1) && level.Chm03_1;
        if (current_state != prev_state)
        {
            prev_state = current_state;
            foreach (arm in arms)
            {
                if (current_state)
                    arm thread scene::play("fxanim_telescope_arm_128_256", arm);
                else
                    arm thread scene::init("fxanim_telescope_arm_128_256", arm);
            }
        }
        WAIT_SERVER_FRAME;
    }
}

function CatcherArms2()
{
    arms = GetEntArray("telescope_arm_2", "targetname");
    clip = GetEnt("telescope_arm_2_clip", "targetname");
    arms_2 = GetEntArray("telescope_arm_3", "targetname");
    clip_2 = GetEnt("telescope_arm_3_clip","targetname");
    clip EnableLinkTo();
    clip LinkTo(arms[0],"panel_top");
    clip_2 EnableLinkTo();
    clip_2 LinkTo(arms_2[0],"panel_top");
    prev_state = false;
    while (1)
    {
        current_state = isDefined(level.Chm03_2) && level.Chm03_2;
        if (current_state != prev_state)
        {
            prev_state = current_state;
            foreach (arm in arms)
            {
                if (current_state)
                    arm thread scene::init("fxanim_telescope_arm_128", arm);
                else
                    arm thread scene::play("fxanim_telescope_arm_128", arm);
            }
            foreach (arm_2 in arms_2)
            {
                if (current_state)
                    arm_2 thread scene::init("fxanim_telescope_arm_128", arm_2);
                else
                    arm_2 thread scene::play("fxanim_telescope_arm_128", arm_2);
            }
            //wait(1);
        }
        WAIT_SERVER_FRAME;
    }
}

function LaserChamber01()
{
    emitter = GetEnt("laser_emitter", "targetname");
    catcher = GetEnt("laser_catcher", "targetname");
    trigger = GetEnt("lch_door_trigger_0", "targetname");
    door = GetEnt(trigger.target, "targetname");
    level.platform_1 = false;
    thread Platform();
    trigger waittill("trigger", player);
    door DoorOpen(true);
    emitter thread LaserEmitter(0);
    catcher thread LaserCatcher(undefined,undefined,0);
    trigger_1 = GetEnt("lch_door_trigger_1", "targetname");
    door_1 = GetEnt(trigger_1.target, "targetname");
    trigger_1 waittill("trigger", player);
    door_1 DoorOpen(true);
    thread LaserChamber02();
}

function LaserChamber02()
{
    door = GetEnt("portal_door_07", "targetname");
    trigger = GetEnt("portal_door_07_trigger", "targetname");
    trigger_close = GetEnt("portal_door_07_trigger_close", "targetname");
    arms = GetEntArray("9arm_destroyed", "targetname");
    rubble1 = GetEnt("9arm_rubble_01", "targetname");
    rubble2 = GetEnt("9arm_rubble_02", "targetname");
    
    true_sign_1 = GetEnt("doorstate_true_03", "targetname");
    false_sign_1 = GetEnt("doorstate_false_03", "targetname");
    true_sign_2 = GetEnt("doorstate_true_04", "targetname");
    false_sign_2 = GetEnt("doorstate_false_04", "targetname");

    //door DoorOpen(false);
    foreach (arm in arms)
    {
        arm thread scene::play("fxanim_9arms_destroyed_idle", arm);
    }
    trigger waittill("trigger", player);
    door DoorOpen(true);
    foreach (arm in arms)
    {
        floor = GetEnt(arm.target, "targetname");
        floor EnableLinkTo();
        anim_index = arm.script_int;
        anim_name = "fxanim_9arms_destroyed_0" + anim_index;
        arm thread scene::play(anim_name, arm);
        floor LinkTo(arm,"arm64x64_export_013");
    }
    rubble1 thread scene::play("fxanim_9arm_rubble_01", rubble1);
    rubble2 thread scene::play("fxanim_9arm_rubble_01", rubble2);

    emitter_1 = GetEnt("laser_emitter_1", "targetname");
    emitter_2 = GetEnt("laser_emitter_2", "targetname");
    catcher_1 = GetEnt("laser_catcher_1", "targetname");
    catcher_2 = GetEnt("laser_catcher_2", "targetname");
    exit_door = GetEnt("portal_door_08", "targetname");
    level.Chm02_1 = false;
    level.Chm02_2 = false;
    emitter_1 thread LaserEmitter(1);
    emitter_2 thread LaserEmitter(2);
    catcher_1 thread LaserCatcher(true_sign_1, false_sign_1,1);
    catcher_2 thread LaserCatcher(true_sign_2, false_sign_2,2);
    //trigger_close waittill("trigger", player);
    //door DoorOpen(false);

    //thread FaithPlateChamber();

    while(1)
    {
        // Track previous state to detect changes
        if (!isDefined(level._chm02_both_prev))
            level._chm02_both_prev = false;

        both_active = level.Chm02_1 && level.Chm02_2;

        if (both_active != level._chm02_both_prev)
        {
            level._chm02_both_prev = both_active;
            if (both_active)
            {
            exit_door DoorOpen(true);
            }
            else
            {
            exit_door DoorOpen(false);
            }
        }
        WAIT_SERVER_FRAME;
    }
}

function LaserEmitter(laserIndex)
{
    state = true;
    new_state = false;
    level.active = true;
    dir = GetEnt(self.target, "targetname");
    tag_laser_pos = self GetTagOrigin("tag_laser");
    spark = util::spawn_model("tag_origin", (0, 0, 0));
    lasers = [];
    lasers[0] = util::spawn_model("tag_origin", tag_laser_pos);
    lasers[1] = util::spawn_model("tag_origin", (99999, 99999, 99999));
    lasers[2] = util::spawn_model("tag_origin", (99999, 99999, 99999));

    lasers[0].angles = dir.angles;
    foreach(las in lasers)
    {
        PlayFXOnTag(level._effect["laser_beam"], las, "tag_origin");
    }
    PlayFXOnTag(level._effect["laser_spark"], spark, "tag_origin");
    spark Hide();
    level.NextDamagePlayer = 0;
    level.NextDamageZombie = 0;

    if(laserIndex == 99)
        thread LaserTrapTimer();

    foreach (player in GetPlayers())
    {
        while (level.active)
        {
            foreach(las in lasers)
                las.origin = (99999, 99999, 99999);

            last_portal = false;
            origin = dir.origin;
            angles = dir.angles;
            ignore_ent = undefined;
            traces = [];

            for(i = 0; i < 3; i++)
            {
                dist = 20;
                if(i > 0 && last_portal)
                    dist = 5;

                start = origin + (AnglesToForward(angles) * dist);
                end = origin + (AnglesToForward(angles) * 9999);
                traces[i] = BulletTrace(start, end, true, ignore_ent);

                lasers[i].origin = origin;
                lasers[i].angles = angles;

                hitEnt = traces[i]["entity"];
                if(isDefined(hitEnt) && hitEnt.targetname == "portal_cube" && hitEnt.model == "m_0a7141f5_reflection_cube" && i < 2)
                {
                    origin = hitEnt.origin;
                    angles = hitEnt.angles - (0,90,0);
                    ignore_ent = hitEnt;
                    last_portal = false;
                    continue;
                }

                portal1_dist = Distance(traces[i]["position"], level.portal_1.origin);
                portal2_dist = Distance(traces[i]["position"], level.portal_2.origin);
                if((portal1_dist <= 32 || portal2_dist <= 32) && i < 2)
                {
                    if(portal1_dist <= 32)
                        other_portal = level.portal_2;
                    else
                        other_portal = level.portal_1;
                    origin = other_portal.origin;
                    angles = other_portal.angles;
                    ignore_ent = undefined;
                    last_portal = true;
                    continue;
                }

                for(j = i+1; j < 3; j++)
                    lasers[j].origin = (99999, 99999, 99999);
                break;
            }

            final_trace = traces[traces.size - 1];
            spark.origin = final_trace["position"];
            level.laserEndpoints[laserIndex] = spark.origin;
            spark Show();

            for(k = 0; k < traces.size; k++)
            {
                tr = traces[k];
                if(!isDefined(tr) || !isDefined(tr["entity"]))
                    continue;
                ent = tr["entity"];
                if (k == 0)
                    dmg = 33;
                else
                    dmg = 50;
                if(isDefined(level.pap_clip) && ent == level.pap_clip)
                {
                    level.pap_clip.origin = (0,0,0);
                    level.pap_clip NotSolid();
                    level.pap_clip Hide();
                    level.pap_clip Delete();
                    if(isDefined(level.pap_boards))
                    {
                        foreach(board in level.pap_boards)
                        {
                            if(isDefined(board))
                            {
                                board = (0,0,0);
                                board NotSolid();
                                board Hide();
                                board Delete();
                            }
                        }
                    }
                    level.pap_clip = undefined;
                    level.pap_boards = undefined;
                    level flag::set("40s_pap");
                    continue;
                }
                if(IsPlayer(ent))
                {
                    if(level.NextDamagePlayer < GetTime())
                    {
                        ent DoDamage(dmg, tr["position"]);
                        if(k == 0)
                            PlaySoundAtPosition("pl_burnpain", ent.origin);
                        level.NextDamagePlayer = GetTime() + 500;
                    }
                }
                if(ent zombie_utility::is_zombie())
                {
                    ent DoDamage(50, tr["position"]);
                    PlaySoundAtPosition("pl_burnpain", ent.origin);
                    level.NextDamageZombie = GetTime() + 200;
                    death = ent.health <= 0;
                    player show_hit_marker(death);
                }
            }

            WAIT_SERVER_FRAME;
        }
    }
    spark Hide();
    foreach(las in lasers)
    {
        las Hide();
    }
    spark Delete();
    foreach(las in lasers)
    {
        las Delete();
    }
}

function LaserCatcher(true_sign, false_sign, index)
{
    radius = 24; // Adjust to your catcher's size
    state = false;
    new_state = false;
    indicators = GetEntArray(self.target, "targetname"); 
    if (isDefined(indicators))
    {
        foreach (indicator in indicators)
        {
            indicator clientfield::set("model_change_color", 1);
        }
        true_sign Hide();
    }
    while(1)
    {
        if (isDefined(level.laserEndpoints))
        {
            foreach (endpoint in level.laserEndpoints)
            {
                if (!isDefined(endpoint)) continue;
                dist = Distance(self.origin, endpoint);
                if (dist <= radius)
                {
                    new_state = true;
                    break;
                }
                new_state = false;
            }
            if (state != new_state)
            {
                state = new_state;
                if (state)
                {
                    self clientfield::set("model_change_color", 2);
                    self thread scene::play("fxanim_laser_catcher_spin", self);
                    PlaySoundAtPosition("laser_node_power_on",self.origin);
                    if (isDefined(indicators))
                    {
                        foreach (indicator in indicators)
                        {
                            indicator clientfield::set("model_change_color", 2);
                        }
                        true_sign Show();
                        false_sign Hide();
                    }
                    
                }
                else
                {
                    self clientfield::set("model_change_color", 1);
                    self thread scene::play("fxanim_laser_catcher_idle", self);
                    PlaySoundAtPosition("laser_node_power_off",self.origin);
                    if (isDefined(indicators))
                    {
                        foreach (indicator in indicators)
                        {
                            indicator clientfield::set("model_change_color", 1);
                        }
                        true_sign Hide();
                        false_sign Show();
                    }
                }
                if (index == 0)
                    level.platform_1 = state;
                else if (index == 1)
                    level.Chm02_1 = state;
                else if (index == 2)
                    level.Chm02_2 = state;
                else if (index == 3)
                    level.Chm03_1 = state;
                else if (index == 4)
                    level.Chm03_2 = state;
            }
        }
        WAIT_SERVER_FRAME;
    }
}

function Platform()
{
    platform = GetEnt("laser_platform", "targetname");
    clip = GetEnt("platform_clip", "targetname");
    min_z = 1637;
    max_z = 1747;

    current_z = min_z;
    clip EnableLinkTo();
    clip LinkTo(platform);
    while (1)
    {
        if (level.platform_1 && platform.origin[2] < max_z)
            platform MoveZ(7.3, 0.2);
        else if (!level.platform_1 && platform.origin[2] > min_z)
            platform MoveZ(-7.3, 0.2);
        
        wait(0.2);
    }
}

function FaithPlateChamber()
{
    button = GetEnt("button_03", "targetname");
    switch_trig = GetEnt("faith_switch_trig", "targetname");
    door = GetEnt("faith_door", "targetname");
    door_true = GetEnt("door_state_true_22", "targetname");
    door_false = GetEnt("door_state_false_22", "targetname");
    trigger = GetEnt("test_trigger", "targetname");
    cube = GetEnt("portal_cube_test", "targetname");
    button thread Button(door, door_true, door_false);
    switch_trig thread SwitchFaith01();

    trigger_4 = GetEnt("lch_door_trigger_4", "targetname");
    door_4 = GetEnt(trigger_4.target, "targetname");
    trigger_4 waittill("trigger", player);
    door_4 DoorOpen(true);
    thread LaserFaithChamber();
}

function PGChamber01()
{
    trigger = GetEnt("pg1_trigger_enter","targetname");
    button = GetEnt("button_pg1", "targetname");
    door = GetEnt("door_pg1","targetname");
    door_true = GetEnt("door_state_true_pg1", "targetname");
    door_false = GetEnt("door_state_false_pg1", "targetname");
    dropper = GetEnt("item_dropper_pg1", "targetname");
    orange_origin = GetEnt("orange_portal_pg1", "targetname");
    portal_gun_trigger = GetEnt("blue_portal_gun_pickup_trigger","targetname");
    close_trigger = GetEnt("pg1_close_door", "targetname");

    button thread Button(door, door_true, door_false);
    trigger waittill("trigger", player);
    level flag::set("pump_bottom_pg1");
    dropper thread Dropper();
    model = GetEnt(portal_gun_trigger.target, "targetname");
    portal_gun_trigger SetCursorHint("HINT_NOICON");
    portal_gun_trigger SetHintString("Hold ^3[{+activate}]^7 to pick up Handheld Portal Device");
    portal_gun_trigger waittill("trigger", player);
    portal_gun_trigger Delete();
    model Delete();
    player thread EquipPortalGun();
    wait(1);
    thread PlacePortalManually(orange_origin,2,true);
    close_trigger waittill("trigger", player);
    //door thread DoorOpen(false);
    thread PGChamber02();
}

function PGChamber02()
{
    button_1 = GetEnt("button_pg2_1", "targetname");
    button_2 = GetEnt("button_pg2_2", "targetname");
    door = GetEnt("door_pg2","targetname");
    door_true_1 = GetEnt("door_state_true_pg2_1", "targetname");
    door_false_1 = GetEnt("door_state_false_pg2_1", "targetname");
    door_true_2 = GetEnt("door_state_true_pg2_2", "targetname");
    door_false_2 = GetEnt("door_state_false_pg2_2", "targetname");
    orange_origin = GetEnt("orange_portal_pg2", "targetname");
    close_trigger = GetEnt("pg2_close_door", "targetname");

    level flag::set("pg1_pg2");

    button_1 thread Button(door, door_true_1, door_false_1);
    button_2 thread Button(door, door_true_2, door_false_2);
    thread PlacePortalManually(orange_origin,2,true);
    level.doubleDoor = 0;
    close_trigger thread DoubleDoor();
    while (level.doubleDoor != -1)
    {
        if(level.doubleDoor == 2)
        {
            door thread DoorOpen(true);
            while(level.doubleDoor == 2)
            {
                WAIT_SERVER_FRAME;
            }
            door thread DoorOpen(false);
        }
        WAIT_SERVER_FRAME;
    }    
    //door thread DoorOpen(false);
}

function DoubleDoor()
{
    //level.doubleDoor = 0;
    self waittill("trigger", player);
    level flag::set("pg2_pg3");
    thread PGChamber03();
}

function PGChamber03()
{
    orange_origin = GetEnt("orange_portal_pg3", "targetname");
    door_trigger = GetEnt("door_pg3_trigger","targetname");
    door = GetEnt(door_trigger.target, "targetname");
    clip = GetEnt(door.target, "targetname");
    portal_gun_trigger = GetEnt("portal_gun_pickup_trigger", "targetname");
    model = GetEnt(portal_gun_trigger.target, "targetname");
    door_trigger Hide();
    thread PlacePortalManually(orange_origin, 2, true);

    portal_gun_trigger SetCursorHint("HINT_NOICON");
    portal_gun_trigger SetHintString("Hold ^3[{+activate}]^7 to pick up Handheld Portal Device");
    while (1)
    {
        portal_gun_trigger waittill("trigger", player);
        portal_gun_trigger Delete();
        model Delete();
        player TakeWeapon(GetWeapon("portal_gun_blue"));
        level.CurrentPortalGun = "portal_gun";
        self thread zm_equipment::show_hint_text( "Press ^3[{+actionslot 1}]^7 to wield the Handheld Portal Device.");
    }

    door_trigger SetCursorHint("HINT_NOICON");
    door_trigger SetHintString("Hold ^3[{+activate}]^7 to open Door [Cost: 2000]");
    while (1)
    {
        door_trigger waittill("trigger", player);
        if (player.score >= 2000)
        {
            player PlayLocalSound("zmb_cha_ching");
            player.score -= 2000;
            door thread DoorOpen(true);
            door_trigger Hide();
            clip Hide();
            break;
        }
        else
        {
            player PlayLocalSound("zmb_no_cha_ching");
        }
    }
}

function Dropper()
{
    dropper_origin = GetEnt(self.target, "targetname");
    self thread scene::play("fxanim_item_dropper_open", self);
    wait(1);
    cube = Spawn("script_model", dropper_origin.origin);
    cube SetModel("m_0a7141f5_metal_box_clean");
    cube clientfield::set("model_change_color", 1);
    cube.origin = dropper_origin.origin;
    cube.angles = (0, 0, 0);
    cube.targetname = "portal_cube";
    cube PhysicsLaunch(cube.origin, (0, 0, 0));
    wait(1);
    self thread scene::play("fxanim_item_dropper_close", self);
    wait(1);
}

function SwitchFaith01()
{
    model = GetEnt(self.target, "targetname");
    dropper = GetEnt(model.target, "targetname");
    dropper_origin = GetEnt(dropper.target, "targetname");
    self SetCursorHint("HINT_NOICON");
	self SetHintString("");
    model thread scene::play("fxanim_portal_switch_up", model);
    while(true)
    {
        self waittill("trigger", player);
        if (isDefined(level.SwitchCube1))
            level.SwitchCube1 Delete();
        model thread scene::play("fxanim_portal_switch_down", model);
        dropper thread scene::play("fxanim_item_dropper_open", dropper);
        wait(1);
        cube = Spawn("script_model", dropper_origin.origin);
        if (dropper.script_int == 1)
            cube SetModel("m_0a7141f5_reflection_cube");
        else
            cube SetModel("m_0a7141f5_metal_box_clean");
        cube.origin = dropper_origin.origin;
        cube.angles = (0, 0, 0);
        cube.targetname = "portal_cube";
        cube NotSolid();
        cube PhysicsLaunch(cube.origin, (0, 0, 0));
        level.SwitchCube1 = cube;
        model thread scene::play("fxanim_portal_switch_up", model);
        wait(1);
        dropper thread scene::play("fxanim_item_dropper_close", dropper);
        wait(1);
    }
}

function PAPDoor()
{
    level.pap_clip = GetEnt("pap_clip", "targetname");
    level.pap_boards = GetEntArray("pap_boards", "targetname");
}

function FaithPlateInit()
{
    triggers = GetEntArray("faith_plate_trigger", "targetname");
    foreach (trigger in triggers)
        trigger thread FaithPlate();
}

function FaithPlate()
{
    model = GetEnt(self.target, "targetname");
    target = GetEnt(model.target, "targetname");
    model thread scene::init("fxanim_faith_plate_launch_up", model);
    self thread FaithWatchCubes(model, target);
    while(1)
    {
        self waittill("trigger", player);
        if (model.model == "faith_plate")
            model thread scene::play("fxanim_faith_plate_launch_angle", model);
        else
            model thread scene::play("fxanim_faith_plate_128_launch", model);
        player SetOrigin(player.origin + (0,0,5));
        if (IsDefined(model.script_int))
            player SetVelocity(LaunchToTarget(self.origin,target.origin,model.script_int));
        else
            player SetVelocity(LaunchToTarget(self.origin,target.origin,2.4));
        wait(3.33);
    }
}

function FaithWatchCubes(model,target)
{
    while (1)
    {
        cubes = GetEntArray("portal_cube", "targetname");
        foreach (cube in cubes)
        {
            if (cube IsTouching(self))
            {
                if (model.model == "faith_plate")
                    model thread scene::play("fxanim_faith_plate_launch_up", model);
                else
                    model thread scene::play("fxanim_faith_plate_128_launch", model);
                old_origin = cube.origin;
                old_angles = cube.angles;
                old_model = cube.model;
                cube Delete();
                new_cube = Spawn("script_model", old_origin);
                new_cube SetModel(old_model);
                new_cube.origin = old_origin;
                new_cube.angles = old_angles;
                new_cube.targetname = "portal_cube";
                new_cube NotSolid();
                new_cube PhysicsLaunch(new_cube.origin, LaunchToTarget(new_cube.origin, target.origin, 2)*0.12);
                level.SwitchCube1 = new_cube;
                wait(.2);
            }  
        }
        WAIT_SERVER_FRAME;
    }
}

function LaunchToTarget(plate_origin, target_pos, flight_time)
{
    g = 800; // Gravity (adjust for your engine)
    start_pos = plate_origin + (0, 0, 10); // Slight lift above plate
    delta = target_pos - start_pos;

    vx = delta[0] / flight_time;
    vy = delta[1] / flight_time;
    vz = (delta[2] / flight_time) + 0.5 * g * flight_time;

    velocity = (vx, vy, vz);

    return velocity;
}

function SwitchChamber01()
{
    model = GetEnt(self.target, "targetname");
    struct = GetEnt(model.target, "targetname");
    wall = GetEnt(struct.target, "targetname");
    indicators = GetEntArray(wall.target, "targetname");
    self SetCursorHint("HINT_NOICON");
	self SetHintString("");
    foreach (indicator in indicators)
    {
        indicator clientfield::set("model_change_color", 1);
    }
    model thread scene::play("fxanim_portal_switch_up", model);
    while(true)
    {
        self waittill("trigger", player);
        if (level.portal_1_mesh.origin != model.origin)
        {
            model thread scene::play("fxanim_portal_switch_down", model);
            wait(1);
            thread PlacePortalManually(struct, 1,true);
            model thread scene::play("fxanim_portal_switch_up", model);
            foreach (indicator in indicators)
            {
                indicator clientfield::set("model_change_color", 2);
            }
            level.chamber1struct = struct;
            // Wait for the portal mesh to move away before allowing another switch
            while (level.chamber1struct == struct)
                WAIT_SERVER_FRAME;
            foreach (indicator in indicators)
            {
                indicator clientfield::set("model_change_color", 1);
            }
        }
    }
}

function DoorOpen(state)
{
    clip = GetEnt(self.target, "targetname");
    if(state)
    {
        if (self.model == "sliding_door_double_noglass")
            self thread scene::play("fxanim_sliding_door_double_open", self);
        else
            self thread scene::play("fxanim_portal_door_open", self);
        clip Hide();
    }
    else
    {
        clip Show();
        if (self.model == "sliding_door_double_noglass")
            self thread scene::play("fxanim_sliding_door_double_close", self);
        else
            self thread scene::play("fxanim_portal_door_close", self);
    }
}

function Button(door,true_sign,false_sign)
{
    true_sign Hide();
    trigger = GetEnt(self.target, "targetname");
    indicators = GetEntArray(trigger.target, "targetname");
    up_anim = "";
    down_anim = "";
    if (self.model == "underground_floor_button")
    {
        up_anim = "fxanim_underground_floor_button_up";
        down_anim = "fxanim_underground_floor_button_down";
    }
    else
    {
        up_anim = "fxanim_portal_button_up";
        down_anim = "fxanim_portal_button_down";
    }
    if (door.model == "sliding_door_double_noglass")
        door thread scene::play("fxanim_sliding_door_double_close", door);
    else
        door thread scene::play("fxanim_portal_door_close", door);
    self thread scene::play(up_anim, self);
    if (isDefined(indicators))
    {
        foreach (indicator in indicators)
            indicator clientfield::set( "model_change_color", 1 );
    }
    while(true)
    {
        players = GetPlayers();
        cubes = GetEntArray("portal_cube", "targetname");
        
        foreach (cube in cubes)
        {
            if (cube IsTouching(trigger))
            {
                self thread scene::play(down_anim, self);
                if (door == undefined)
                    level.FinalButtons += 1;
                else if (isDefined(door.script_int) && door.script_int == 2)
                    level.doubleDoor += 1;
                else
                    door thread DoorOpen(true);
                cube clientfield::set( "model_change_color", 2 );
                //IPrintLnBold(level.FinalButtons);
                true_sign Show();
                false_sign Hide();
                if (isDefined(indicators))
                {
                    foreach (indicator in indicators)
                        indicator clientfield::set( "model_change_color", 2 );
                }
                while(cube IsTouching(trigger) && isDefined(cube))
                    WAIT_SERVER_FRAME;
                cube clientfield::set( "model_change_color", 1 );
                true_sign Hide();
                false_sign Show();
                if (isDefined(indicators))
                {
                    foreach (indicator in indicators)
                        indicator clientfield::set( "model_change_color", 1 );
                }
                self thread scene::play(up_anim, self);
                if (door == undefined)
                    level.FinalButtons -= 1;
                else if (isDefined(door.script_int) && door.script_int == 2)
                    level.doubleDoor -= 1;
                else
                    door thread DoorOpen(false);
            }
        }

        foreach (player in players)
        {
            if (player IsTouching(trigger))
            {
                self thread scene::play(down_anim, self);
                if (door == undefined)
                    level.FinalButtons += 1;
                else if (isDefined(door.script_int) && door.script_int == 2)
                    level.doubleDoor += 1;
                else
                    door thread DoorOpen(true);
                foreach (indicator in indicators)
                    indicator clientfield::set( "model_change_color", 2 );
                true_sign Show();
                false_sign Hide();
                while(player IsTouching(trigger))
                {
                    WAIT_SERVER_FRAME;
                }
                foreach (indicator in indicators)
                    indicator clientfield::set( "model_change_color", 1 );
                true_sign Hide();
                false_sign Show();
                self thread scene::play(up_anim, self);
                if (door == undefined)
                    level.FinalButtons -= 1;
                else if (isDefined(door.script_int) && door.script_int == 2)
                    level.doubleDoor -= 1;
                else
                    door thread DoorOpen(false);
            }
        }
        WAIT_SERVER_FRAME;
    }
}

function ElevatorInit()
{
    elevators = GetEntArray("portal_elevator","targetname");
    foreach( trigger in elevators )
    {
        trigger thread Elevator();
    }
    loop_elevator = GetEnt("portal_elevator_loop", "targetname");
    loop_elevator thread LoopElevator();
    pg_elevator = GetEnt("pg_elevator", "targetname");
    pg_elevator thread PGElevator();
    underground_elevators = GetEntArray("underground_elevator","targetname");
    foreach( trigger in underground_elevators )
    {
        trigger thread UndergroundElevator();
    }
    underground_elevator_back_forth = GetEnt("underground_elevator_back_forth","targetname");
    underground_elevator_back_forth thread UndergroundElevatorBackForth();
}

function Elevator()
{
    elevator = GetEnt(self.target, "targetname");
    close_trigger = GetEnt(elevator.target, "targetname");
    platform = GetEnt(close_trigger.target, "targetname");
    door_clip = GetEnt(platform.target, "targetname");
    clip = GetEnt(door_clip.target, "targetname");

	elevator thread scene::play("fxanim_elevator_b_leave", elevator);
	self waittill("trigger", player);
	elevator thread scene::play("fxanim_elevator_b_arrive", elevator);
    door_clip Hide();
	close_trigger waittill("trigger", player);
    origin = Spawn("script_origin", elevator.origin);
    elevator EnableLinkTo();
    elevator LinkTo(origin);
	elevator thread scene::play("fxanim_elevator_b_close", elevator);
    door_clip Show();
    door_clip EnableLinkTo();
    clip EnableLinkTo();
    door_clip LinkTo(platform);
    clip LinkTo(platform);
    platform SetMovingPlatformEnabled(true);
    elevator SetMovingPlatformEnabled(true);
    origin SetMovingPlatformEnabled(true);
    wait(1.16);
    origin MoveZ(platform.script_int,5);
    platform MoveZ(platform.script_int,5);
    origin PlayLoopSound("elevator_depart");
    wait(5);
    origin StopLoopSound(1);
    wait(1);
    elevator thread scene::play("fxanim_elevator_b_open", elevator);
    door_clip Hide();
}

function PGElevator()
{
    elevator = GetEnt(self.target, "targetname");
    close_trigger = GetEnt(elevator.target, "targetname");
    platform = GetEnt(close_trigger.target, "targetname");
    door_clip = GetEnt(platform.target, "targetname");
    clip = GetEnt(door_clip.target, "targetname");

	elevator thread scene::play("fxanim_elevator_b_leave", elevator);
    while(1)
    {
        self waittill("trigger", player);
        elevator thread scene::play("fxanim_elevator_b_arrive", elevator);
        door_clip Hide();
        close_trigger waittill("trigger", player);
        origin = Spawn("script_origin", elevator.origin);
        elevator EnableLinkTo();
        elevator LinkTo(origin);
        elevator thread scene::play("fxanim_elevator_b_close", elevator);
        door_clip Show();
        door_clip EnableLinkTo();
        clip EnableLinkTo();
        door_clip LinkTo(platform);
        clip LinkTo(platform);
        platform SetMovingPlatformEnabled(true);
        elevator SetMovingPlatformEnabled(true);
        origin SetMovingPlatformEnabled(true);
        wait(1.16);
        origin MoveZ(platform.script_int,5);
        platform MoveZ(platform.script_int,5);
        origin PlayLoopSound("elevator_depart");
        wait(2);
        level thread lui::screen_flash(1, 2, 1, 1, "black");
        wait(1);
        level.loop_ele = 1;
        wait(2);
        origin StopLoopSound(1);
        origin MoveZ(platform.script_int * -1,0.1);
        platform MoveZ(platform.script_int * -1,0.1);
        wait(0.1);
        elevator thread scene::play("fxanim_elevator_b_leave", elevator);
    }
}

function LoopElevator()
{
    elevator = GetEnt(self.target, "targetname");
    close_trigger = GetEnt(elevator.target, "targetname");
    platform = GetEnt(close_trigger.target, "targetname");
    door_clip = GetEnt(platform.target, "targetname");
    clip = GetEnt(door_clip.target, "targetname");
    struct = GetEnt("ele_origin", "targetname");
    
	elevator thread scene::play("fxanim_elevator_b_leave", elevator);
	self waittill("trigger", player);
	elevator thread scene::play("fxanim_elevator_b_arrive", elevator);
    door_clip Hide();
	close_trigger waittill("trigger", player);
    origin = Spawn("script_origin", elevator.origin);
    elevator EnableLinkTo();
    elevator LinkTo(origin);
    struct EnableLinkTo();
    struct LinkTo(origin);
	elevator thread scene::play("fxanim_elevator_b_close", elevator);
    door_clip Show();
    door_clip EnableLinkTo();
    clip EnableLinkTo();
    door_clip LinkTo(platform);
    clip LinkTo(platform);
    platform SetMovingPlatformEnabled(true);
    elevator SetMovingPlatformEnabled(true);
    origin SetMovingPlatformEnabled(true);
    wait(1.16);
    origin MoveZ(platform.script_int,5);
    platform MoveZ(platform.script_int,5);
    origin PlayLoopSound("elevator_depart");
    origin RotateYaw(180,5);
    platform RotateYaw(180,5);
    level flag::set("start3_hub_elevator");
    zm_zonemgr::disable_zone("start_zone");
    zm_zonemgr::disable_zone("start2_zone");
    zm_zonemgr::disable_zone("start3_zone");
    SetDvar("ai_disableSpawn", 1);
    foreach (zombie in getaispeciesarray(level.zombie_team, "all"))
    {
        if (isDefined(zombie) && zombie zombie_utility::is_zombie())
        {
            zombie Kill();
        }
    }
    wait(5);
    origin StopLoopSound(1);
    wait(1);
    elevator thread scene::play("fxanim_elevator_b_open", elevator);
    door_clip Hide();
    while(1)
    {
        if (level.loop_ele != 1)
            wait(0.1);
        else
        {
            level.loop_ele = 0;
            elevator thread scene::play("fxanim_elevator_b_close", elevator);
            door_clip Show();
            foreach (player in GetPlayers())
            {
                if (IsAlive(player))
                {
                    player SetOrigin(struct.origin);
                    player SetPlayerAngles(struct.angles);
                }
            }
            wait(3);
            elevator thread scene::play("fxanim_elevator_b_open", elevator);
            door_clip Hide();
        }
    }
}


function UndergroundElevator()
{
    top_door = GetEnt(self.target,"targetname");
    bottom_door = GetEnt(top_door.target,"targetname");
    elevator = GetEnt(bottom_door.target, "targetname");
    leave_trigger = GetEnt(elevator.target, "targetname");
    platform = GetEnt(leave_trigger.target, "targetname");
    clip_door = GetEnt(platform.target, "targetname");
    clip = GetEnt(clip_door.target, "targetname");
    platform EnableLinkTo();
    platform LinkTo(elevator);
    clip_door EnableLinkTo();
    clip_door LinkTo(elevator);
    clip EnableLinkTo();
    clip LinkTo(elevator);
    self waittill("trigger", player);
    top_door MoveZ(68,1);
    bottom_door MoveZ(-68,1);
    PlaySoundAtPosition("underground_elevator_door_open", elevator.origin);
    wait(1);
    clip_door Hide();
    leave_trigger waittill("trigger", player);
    if (isDefined(leave_trigger.script_int) && leave_trigger.script_int == 1)
        multipier = -1;
    else
        multipier = 1;
    clip_door Show();
    top_door MoveZ(-68,1);
    bottom_door MoveZ(68,1);
    PlaySoundAtPosition("underground_elevator_door_close", elevator.origin);
    wait(2);
    PlaySoundAtPosition("elevator_start", elevator.origin);
    elevator PlayLoopSound("elevator_loop");
    top_door MoveZ(-734*multipier, 5);
    bottom_door MoveZ(-734*multipier, 5);
    elevator MoveZ(-734*multipier, 5);
    wait(2);
    level thread lui::screen_flash(1, 2, 1, 1, "black");
    wait(1);
    foreach (player in GetPlayers())
    {
        if (IsAlive(player))
        {
            //BOSS ROOM
            if (elevator.script_int == 1)
            {
                boss_spawn = GetEnt("boss_spawn", "targetname");
                level flag::set("fall_boss");
                player SetOrigin(boss_spawn.origin);
                player SetPlayerAngles(boss_spawn.angles);
                thread Boss();
                thread BossSpawn();
                boss_switch = GetEnt("boss_switch_trigger", "targetname");
                boss_switch thread SwitchBoss();
            }
            //
            if (elevator.script_int == 2)
            {
                boss_spawn = GetEnt("lch_origin", "targetname");
                level flag::set("fall_lch1");
                player SetOrigin(boss_spawn.origin);
                player SetPlayerAngles(boss_spawn.angles);
                thread LaserChamber01();
            }
        }
    }
    elevator StopLoopSound(1);
    clip_door Hide();
    top_door MoveZ(68,1);
    bottom_door MoveZ(-68,1);
    PlaySoundAtPosition("underground_elevator_door_open", elevator.origin);
}

function UndergroundElevatorBackForth()
{
    top_door = GetEnt(self.target,"targetname");
    bottom_door = GetEnt(top_door.target,"targetname");
    elevator = GetEnt(bottom_door.target, "targetname");
    leave_trigger = GetEnt(elevator.target, "targetname");
    platform = GetEnt(leave_trigger.target, "targetname");
    clip_door = GetEnt(platform.target, "targetname");
    clip = GetEnt(clip_door.target, "targetname");
    level.UpDown = 1;
    leave_trigger EnableLinkTo();
    leave_trigger LinkTo(elevator);
    platform EnableLinkTo();
    platform LinkTo(elevator);
    clip_door EnableLinkTo();
    clip_door LinkTo(elevator);
    clip EnableLinkTo();
    clip LinkTo(elevator);
    top_door EnableLinkTo();
    bottom_door EnableLinkTo();
    thread ElevatorUpButton(top_door,bottom_door,elevator,leave_trigger,platform,clip_door,clip);
    //thread ElevatorDownButton(top_door,bottom_door,elevator,leave_trigger,platform,clip_door,clip);

    leave_trigger SetCursorHint("HINT_NOICON");
    level flag::wait_till("power_on");
    self waittill("trigger", player);
    top_door MoveZ(68,1);
    bottom_door MoveZ(-68,1);
    PlaySoundAtPosition("underground_elevator_door_open", elevator.origin);
    wait(1);
    clip_door Hide();
    while(1)
    {
        leave_trigger SetHintString("Hold ^3[{+activate}]^7 to purchase Elevator [Cost: 500]");
        leave_trigger waittill("trigger", player);
        if (player.score >= 500 && level.BFElevatorReady)
        {
            player PlayLocalSound("zmb_cha_ching");
            player.score -= 500;
            MoveUpDownElevator(top_door,bottom_door,elevator,leave_trigger,platform,clip_door,clip);
        }
        else if (player.score < 500)
        {
            player PlayLocalSound("zmb_no_cha_ching");
        }
    }
}

function MoveUpDownElevator(top_door,bottom_door,elevator,leave_trigger,platform,clip_door,clip)
{
    clip_top = GetEnt("clip_top", "targetname");
    level.BFElevatorReady = false;
    clip_top Hide();
    clip_door Show();
    leave_trigger Hide();
    top_door MoveZ(-68,1);
    bottom_door MoveZ(68,1);
    PlaySoundAtPosition("underground_elevator_door_close", elevator.origin);
    wait(2);
    top_door LinkTo(elevator);
    bottom_door LinkTo(elevator);
    PlaySoundAtPosition("elevator_start", elevator.origin);
    elevator PlayLoopSound("elevator_loop");
    //top_door MoveZ(838*level.UpDown, 5);
    //bottom_door MoveZ(838*level.UpDown, 5);
    elevator MoveZ(838*level.UpDown, 5);
    elevator RotateYaw(-90*level.UpDown,5);
    //top_door RotateYaw(-90*level.UpDown,5);
    //bottom_door RotateYaw(-90*level.UpDown,5);
    wait(5);
    elevator StopLoopSound(1);
    top_door Unlink();
    bottom_door Unlink();
    wait(1);
    clip_door Hide();
    top_door MoveZ(68,1);
    bottom_door MoveZ(-68,1);
    PlaySoundAtPosition("underground_elevator_door_open", elevator.origin);
    leave_trigger Show();
    leave_trigger SetHintString("Elevator is cooling down.");
    clip_top Show();
    wait(20);
    level.UpDown = level.UpDown * -1;
    level.BFElevatorReady = true;
}

function ElevatorUpButton(top_door,bottom_door,elevator,leave_trigger,platform,clip_door,clip)
{
    trigger = GetEnt("ele_up_button", "targetname");
    model = GetEnt(trigger.target,"targetname");
    trigger SetCursorHint("HINT_NOICON");
    trigger SetHintString("Power is required.");
    model thread scene::play("fxanim_underground_switch_up", model);
    level flag::wait_till("power_on");
    trigger SetHintString("Hold ^3[{+activate}]^7 to call Elevator");
    trigger thread WatchTriggerElevator(1);
    while(1)
    {
        trigger waittill("trigger", player);
        if (level.BFElevatorReady)
        {
            thread MoveUpDownElevator(top_door,bottom_door,elevator,leave_trigger,platform,clip_door,clip);
            model thread scene::play("fxanim_underground_switch_down", model);
            wait(1);
            model thread scene::play("fxanim_underground_switch_up", model);
        }
    }
}

//function ElevatorDownButton(top_door,bottom_door,elevator,leave_trigger,platform,clip_door,clip)
//{
//    trigger = GetEnt("ele_down_button", "targetname");
//    model = GetEnt(trigger.target, "targetname");
//    trigger SetCursorHint("HINT_NOICON");
//    trigger SetHintString("Power is required.");
//    level flag::wait_till("power_on");
//    trigger SetHintString("Hold ^3[{+activate}]^7 to call Elevator");
//    trigger thread WatchTriggerElevator(-1);
//    while(1)
//    {
//        trigger waittill("trigger", player);
//        if (level.BFElevatorReady)
//        {
//            thread MoveUpDownElevator(top_door,bottom_door,elevator,leave_trigger,platform,clip_door,clip);
//            model thread scene::play("fxanim_underground_switch_down", model);
//            wait(1);
//            model thread scene::play("fxanim_underground_switch_up", model);
//        }
//    }
//}

function WatchTriggerElevator(value)
{
    while(1)
    {
        if (level.BFElevatorReady == false || level.UpDown == value)
            self Hide();
        else
            self Show();
      wait(.1);
    }
}

function FanInit()
{
	fans = GetEntArray("elevator_blades","targetname");
    foreach(fan in fans)
    {
        fan thread Fan();
    }
}

function Fan()
{
    while(1)
	{
		self RotateYaw(360,3);
		wait(3);
	}
}

//BOSS LOGIC

function BossSpawn()
{
    spawners = GetEntArray("boss_zombie_spawner", "targetname");
    if(!spawners.size)
    {
        spawners = level.zombie_spawners;
    }
    zombies = [];
    max_count = 10;
    while(level.BossWave != -1)
    {
        zombies = array::remove_dead(zombies, 0);
        zombies = array::remove_undefined(zombies, 0);
        while(zombies.size < max_count)
        {
            s_spawn_point = array::random(spawners);
            ai = zombie_utility::spawn_zombie(spawners[0], "arena_zombie", s_spawn_point, level.round_number);
            if(isdefined(ai))
            {
                array::add(zombies, ai, 0);
            }
            zombies = array::remove_dead(zombies, 0);
            zombies = array::remove_undefined(zombies, 0);
            WAIT_SERVER_FRAME;
        }
        wait(0.5);
    }
}

function Boss()
{
	boss = GetEnt("brodes_boss","targetname");
	boss_triggers = GetEntArray("boss_damage_trigger","targetname");
    boss_clip = GetEntArray("boss_clip", "targetname");
	arms = GetEnt("brodes_arms", "targetname");
    boss thread scene::play("fxanim_brodes_boss_idle", boss);
    origin = util::spawn_model("brodes_core",boss.origin, boss.angles);
    arms_origin = util::spawn_model("tag_origin",arms.origin, arms.angles);
	arms EnableLinkTo();
    boss EnableLinkTo();
    arms_origin EnableLinkTo();
    boss LinkTo(origin);
	arms LinkTo(arms_origin);
    arms_origin LinkTo(origin);
	level.BossWave = 3;
	level.BossStunned = false;
    level.CoreHit = false;
    level.CoreFall = false;
    level.BombTeleport = false;
	boss.health = 60000;

    level.core_1 = GetEnt("saint_core","targetname");
	level.core_2 = GetEnt("mjpw_core","targetname");
	level.core_3 = GetEnt("noah_core","targetname");
	level.core_1 thread WatchCoreHealth(boss);
	level.core_2 thread WatchCoreHealth(boss);
	level.core_3 thread WatchCoreHealth(boss);

	foreach(trigger in boss_triggers)
	{
        trigger EnableLinkTo();
        trigger LinkTo(origin);
        trigger thread BossDamage(boss);
	}
    foreach(clip in boss_clip)
    {
        clip EnableLinkTo();
        clip LinkTo(origin);
    }
	arms thread BossAnims(boss);
    
	wasStunned = false;
    while (level.BossWave != 0)
    {
        if (!level.BossStunned)
        {
            // If just unstunned, snap angle
            if (wasStunned)
            {
                foreach (player in GetPlayers())
                {
                    eye = player GetTagOrigin("j_head");
                    dir = VectorToAngles(eye - origin.origin);
                    dir = (origin.angles[0],dir[1],dir[2]);
                    origin RotateTo(dir,0.1);
                    wait(0.1);
                }
                wasStunned = false;
            }
            else
            {
                foreach (player in GetPlayers())
                {
                    eye = player GetTagOrigin("j_head");
                    dir = VectorToAngles(eye - origin.origin);
                    dir = (origin.angles[0],dir[1],dir[2]);
                    origin RotateTo(dir,0.1);
                    wait(0.1);
                }
            }
            WAIT_SERVER_FRAME;
        }
        else
        {
            wasStunned = true;
            wait(.1);
        }
    }
    arms_origin thread ArmSpin();
    while (level.BossWave != -1)
    {
        // If just unstunned, snap angle
        if (wasStunned)
        {
            foreach (player in GetPlayers())
            {
                eye = player GetTagOrigin("tag_eye");
                dir = VectorNormalize(eye - origin.origin);
                angles = VectorToAngles(dir);
                origin.angles = (origin.angles[0], angles[1], origin.angles[2]);
            }
            wasStunned = false;
        }
        else
        {
            foreach (player in GetPlayers())
            {
                eye = player GetTagOrigin("tag_eye");
                dir = VectorNormalize(eye - origin.origin);
                angles = VectorToAngles(dir);
                origin.angles = (origin.angles[0], angles[1], origin.angles[2]);
            }
        }
        WAIT_SERVER_FRAME;
    }
}

function ArmSpin()
{
    self Unlink();
    while (level.BossWave != -1)
    {
        self RotateYaw(self.angles[2] + 360,2);
        wait 2;
    }
}

function BossDamage(boss)
{
	temp = boss.health;
	while (level.BossWave != 0)
	{
		self waittill("damage", damage, attacker, dir, point, mod, model, tag, part, weapon, flags, inflictor, chargeLevel);
		boss.health = temp;
        foreach (player in GetPlayers())
		{
			if (!(level.BossStunned) && (weapon == GetWeapon("portal_grenade_zm") || weapon == GetWeapon("portal_grenade")) && level.BombTeleport)
            {
                level.BossStunned = true;
                player show_hit_marker(false);
                //IPrintLnBold(model);
            }	
		}
        WAIT_SERVER_FRAME;
	}
    while (level.BossWave != -1)
    {
        self waittill("damage", damage, attacker, dir, point, mod, model, tag, part, weapon, flags, inflictor, chargeLevel);
        boss.health = boss.health - damage;
        foreach (player in GetPlayers())
		{
            death = boss.health <= 0;
            player show_hit_marker(death);
            if (death)
                level.BossWave = -1;
        }
    }
}

function BossAnims(boss)
{
	wait(2);
    //thread ee_ending();
    level thread zm_audio::sndMusicSystem_PlayState("portal_boss");
	self thread scene::play("fxanim_brodes_arms_intro", self);
	wait(5.7);
	self thread scene::play("fxanim_brodes_arms_pounce", self);
	boss thread scene::play("fxanim_brodes_boss_idle_to_panel_down", boss);
	wait(2.733);
	
	foreach (player in GetPlayers())
    {
        //FIRST PHASE
        while (level.BossWave != 0)
		{
            while(!(level.BossStunned))
			{
                if (level.CoreFall)
                {
                    while (level.CoreFall)
                    {
                        wait(.2);
                        //IPrintLnBold("LOOP");
                    }
                    if (level.BossWave <= 0)
                        break;
                    //level.BossStunned = true;
                    boss thread scene::play("fxanim_brodes_boss_hit_from_above_stunned", boss);
                    self thread scene::play("fxanim_brodes_arms_groundtobomb", self);
                    wait(1.8);
                    self thread scene::play("fxanim_brodes_arms_lift", self);
                    wait(1.9);
                    boss thread scene::play("fxanim_brodes_boss_from_stunned_1", boss);
                    self thread scene::play("fxanim_brodes_arms_lower", self);
                    wait(2.33);
                    //level.BossStunned = false;
                    boss thread scene::play("fxanim_brodes_boss_idle_to_panel_down", boss);
                    self thread scene::play("fxanim_brodes_arms_bombtoground", self);
                    wait(1.8);
                }
                //START BOMBING
				i = 0;
				while(i < 5)
				{
					boss thread ShootGrenade();
					boss thread scene::play("fxanim_brodes_boss_low_defense_fire", boss);
					if (CheckDamageDuringWait(1))
						break;
					i++;
				}
				if (CheckDamageDuringWait(4))
					break;
				self thread scene::play("fxanim_brodes_arms_groundtobomb", self);
				if (CheckDamageDuringWait(1.36))
					break;
				self thread scene::play("fxanim_brodes_arms_bombtoground", self);
                if (CheckDamageDuringWait(1.36))
					break;
                //IPrintLnBold("IDK2");
			}
            if (level.BossWave <= 0)
                break;
			boss thread scene::play("fxanim_brodes_boss_hit_from_above_stunned", boss);
			self thread scene::play("fxanim_brodes_arms_groundtobomb", self);
			wait(1.8);
			self thread scene::play("fxanim_brodes_arms_lift", self);
            level.CoreHit = true;
			if (CheckCoreFallDuringWait(12.133))
            {

            }
            //IPrintLnBold("IDK");
            level.CoreHit = false;
			level.BossStunned = false;
			boss thread scene::play("fxanim_brodes_boss_from_stunned_1", boss);
			self thread scene::play("fxanim_brodes_arms_lower", self);
			wait(1.33);
		}
        self thread scene::play("fxanim_brodes_arms_lift", self);
        boss thread scene::play("fxanim_brodes_boss_idle_core_3", boss);
        //IPrintLnBold("RAISE");
        wait(1.9);

        //FINAL PHASE
        while(level.BossWave != -1)
        {
            //IPrintLnBold("START BOMBING");
            //START BOMBING
			i = 0;
			while(i < 8)
			{
				boss thread ShootGrenade(); //TODO: CREATE CLUSTER GRENADES MAYBE
				//boss thread scene::play("fxanim_brodes_boss_low_defense_fire", boss);
				if (CheckDeathDuringWait(0.6))
					break;
				i++;
			}
			if (CheckDeathDuringWait(1))
				break;
			self thread scene::play("fxanim_brodes_arms_shrink", self);
			if (CheckDeathDuringWait(.5))
				break;
			self thread scene::play("fxanim_brodes_arms_expand", self);
            if (CheckDeathDuringWait(.5))
				break;
            WAIT_SERVER_FRAME;
        }
        boss thread scene::play("fxanim_brodes_boss_hit_from_above_stunned", boss);
        level thread zm_audio::sndMusicSystem_StopAndFlush();
        music::setmusicstate("none");
    }
    //TODO: END GAME SCRIPTS GO HERE
}

function WatchCoreHealth(boss)
{
	trigger = GetEnt(self.target, "targetname");
    origin = GetEnt(trigger.target, "targetname");
    incinerator_trigger = GetEnt("incinerator_trigger","targetname");

    origin.origin = self.origin;
    origin.angles = self.angles;
    //self NotSolid();
    self EnableLinkTo();
    self.health = 15000;
    self LinkTo(origin);
	trigger EnableLinkTo();
	trigger LinkTo(origin);
	temp = self.health;

    if (self.script_int == 1)
    {
        origin LinkTo(boss,"core_2");
        self thread scene::play("fxanim_core_1_pincher_idle", self);
    }
    else if (self.script_int == 2)
    {
        origin LinkTo(boss,"core_1");
        self thread scene::play("fxanim_core_2_pincher_idle", self);
    }
    else if (self.script_int == 3)
    {
        origin LinkTo(boss,"core_3");
        self thread scene::play("fxanim_core_3_pincher_idle", self);
    }

	while (self.health > 0)
	{
		trigger waittill("damage", damage, attacker, dir, point, mod, model, tag, part, weapon, flags, inflictor, chargeLevel);
		if (level.BossStunned && level.CoreHit)
		{
			foreach (player in GetPlayers())
			{
				if (attacker == player)
                {
                    //IPrintLnBold(damage);
                    self.health = self.health - damage;
                    death = self.health <= 0;
                    player show_hit_marker(death);
                    if (death)
                        level.CoreFall = true;
                }
			}
		}
        WAIT_SERVER_FRAME;
	}
    //trigger Unlink();
    //trigger Delete();
    origin Unlink();
    //self Solid();
    //self LinkTo(origin);
    origin PhysicsLaunch(origin.origin, (0, 0, 0));
    if (self.script_int == 1)
    {
        self thread scene::play("fxanim_core_1_idle", self);
        origin PlayLoopSound("noah_core_vox",1);
    }
    else if (self.script_int == 2)
    {
        self thread scene::play("fxanim_core_2_idle", self);
        origin PlayLoopSound("saint_core_vox",1);
    }
    else
    {
        self thread scene::play("fxanim_core_3_idle", self);
        origin PlayLoopSound("mjpw_core_vox",1);
    }

    temp = level.BossWave;
    while(level.BossWave == temp)
    {
        if (self IsTouching(incinerator_trigger) && level.CoreFall)
        {
            origin StopLoopSound(1);
            wait(.1);
            origin Delete();
            level.BossWave--;
            level.CoreFall = false;
            self Delete();
            IPrintLnBold("ININCERATE");
        }
        WAIT_SERVER_FRAME;
    }

}


function CheckDamageDuringWait(val)
{
    i = 0;
    while(i < 5*val)
    {
        if (level.BossStunned)
            return true;
        else
        {
            wait(.2);
        }
        i++;
        WAIT_SERVER_FRAME;
    }
    return false;
}

function CheckCoreFallDuringWait(val)
{
    i = 0;
    while(i < 5*val)
    {
        if (level.CoreFall)
        {
            return true;
        }
        else
        {
            wait(.2);
        }
        i++;
        WAIT_SERVER_FRAME;
    }
    return false;
}

function CheckDeathDuringWait(val)
{
    i = 0;
    while(i < 5*val)
    {
        if (level.BossWave == -1)
        {
            return true;
        }
        else
        {
            wait(.2);
        }
        i++;
        WAIT_SERVER_FRAME;
    }
    return false;
}

function ShootGrenade()
{
	foreach (player in GetPlayers())
	{
		base_target_pos = player.origin;
		v_velocity = player GetVelocity();
		// Predict player's future position (tweak 1.0-1.5 for desired prediction)
		predicted_target_pos = base_target_pos + (v_velocity);

		dir = VectorToAngles(predicted_target_pos - self.origin);
		dir = AnglesToForward(dir);

		launch_offset = (dir * 5);

		launch_pos = self GetTagOrigin("grenade") + launch_offset;

		dist = Distance(launch_pos, predicted_target_pos);

		// Launch directly at predicted position, with a vertical boost for arc
		velocity = dir * (dist)*1.5;
		velocity = velocity + (0, 0, 120);

		level.LastBombVelocity = velocity;

		thread BombLogic(self MagicGrenadeType(GetWeapon("portal_grenade"), launch_pos, velocity));
		//PlaySoundAtPosition("wpn_grenade_fire_mechz", self.origin);
	}
}

function BombLogic(bomb)
{	
    return bomb;
}

function SwitchBoss()
{
    model = GetEnt("boss_switch", "targetname");
    incinerator = GetEnt(model.target, "targetname");
    clip = GetEnt(incinerator.target, "targetname");
    self SetCursorHint("HINT_NOICON");
	self SetHintString("");
    model thread scene::play("fxanim_portal_switch_up", model);
    while(true)
    {
        self waittill("trigger", player);
        model thread scene::play("fxanim_portal_switch_down", model);
        incinerator thread scene::play("fxanim_incinerator_open", incinerator);
        clip Hide();
        wait(7);
        clip show();
        model thread scene::play("fxanim_portal_switch_up", model);
        incinerator thread scene::play("fxanim_incinerator_close", incinerator);
    }
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
    //weapon = GetWeapon("portal_gun");
    self.holdingCube = undefined;
    isLowReady = false;
    holdingDistance = 55; // Initial hold distance in front of player

    //self thread PortalGunInit();

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
                    //IPrintLnBold("Picked up cube: " + cube);
                    //self SetLowReady(true);   // Pickup anim
					//self AllowSprint(false);
                    isLowReady = true;
                    self.holdingCube = cube;
                    //cube NotSolid();
                    cube.isBeingHeld = true; // Mark as held
                    // Save offset and angles for relative holding
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
                    //IPrintLnBold("No cube found for pickup, playing reload anim.");
                    //self SetWeaponAmmoClip(weapon, 0);
                    wait(.5333);
                }
            }
            // If holding, drop or throw
            else
            {
                cube = self.holdingCube;
                if (isLowReady)
                {
                    // Drop gently by default
                    //IPrintLnBold("Dropping cube.");
                    //self SetLowReady(false); // Drop anim
					//self AllowSprint(true);
                    isLowReady = false;
                    self.holdingCube = undefined;
                    //cube Solid();
                    cube.isBeingHeld = false;
                    cube PhysicsLaunch(cube.origin,(0,0,0));
					
                    wait(0.733); // Drop anim duration
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
            temp2 = GetEnt(temp.target,"targetname");
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
        thread PlacePortal(player, portal_type, trace);
    }
}

function PlacePortal(player, portal_type, trace)
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
        PlaySoundAtPosition("portal_invalid_surface", trace["position"]);
        return;
    }
    if (!IsDefined(trace["entity"]))
    {
        //IPrintLnBold("PlacePortal: trace[entity] is not defined");
        PlaySoundAtPosition("portal_invalid_surface", trace["position"]);
        return;
    }
    if (trace["entity"].classname != "script_brushmodel" && trace["entity"].targetname != "wall")
    {
        PlaySoundAtPosition("portal_invalid_surface", trace["position"]);
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
        thread CheckCubesInPortals();
        level.portalThreadsStarted = true;
    }
}

function PortalGunInit()
{
    action = false;
    portal_gun = GetWeapon("portal_gun");
    portal_gun_blue = GetWeapon("portal_gun_blue");
    portal_gun_blue_fire = GetWeapon("portal_gun_blue_fire");
    portal_gun_orange = GetWeapon("portal_gun_orange");
    portal_gun_orange_fire = GetWeapon("portal_gun_orange_fire");
    while(1)
    {
        if(self AttackButtonPressed())
        {
            weapon = self GetCurrentWeapon();
            if((weapon == portal_gun || weapon == portal_gun_blue_fire || weapon == portal_gun_blue) && !action)
            {
                action = true;
                self GiveWeapon(portal_gun_blue_fire);
                self SwitchToWeaponImmediate(portal_gun_blue_fire);
                self TakeWeapon(weapon);
                self SetLowReady(true);
                IPrintLnBold("Blue portal fired!");
                wait(.3);
                self SetLowReady(false);
                self GiveWeapon(portal_gun_blue);
                self SwitchToWeaponImmediate(portal_gun_blue);
                self TakeWeapon(portal_gun_blue_fire);
                action = false;
            }
        }
        if(self ADSButtonPressed())
        {
            weapon = self GetCurrentWeapon();
            if((weapon == portal_gun || weapon == portal_gun_blue_fire || weapon == portal_gun_blue) && !action)
            {
                action = true;
                self GiveWeapon(portal_gun_orange_fire);
                self SwitchToWeaponImmediate(portal_gun_orange_fire);
                self TakeWeapon(weapon);
                self SetLowReady(true);
                IPrintLnBold("Orange portal fired!");
                wait(.3);
                self SetLowReady(false);
                self GiveWeapon(portal_gun_orange);
                self SwitchToWeaponImmediate(portal_gun_orange);
                self TakeWeapon(portal_gun_orange_fire);
                action = false;
            }
        }
        WAIT_SERVER_FRAME;
    }
}

function PortalGunFireTrace()
{
    weapon = GetWeapon("portal_gun");
    weapon_2 = GetWeapon("portal_gun_blue");

    while (true)
    {
        foreach (player in GetPlayers())
        {
            if (player GetCurrentWeapon() == weapon || player GetCurrentWeapon() == weapon_2)
            {
                portal_type = 0;

                if (player AttackButtonPressed())
                {
                    portal_type = 1;
                    PlaySoundAtPosition("wpn_portal_gun_fire_blue", player.origin);
                }
                else if (player AdsButtonPressed() && player GetCurrentWeapon() == weapon)
                {
                    portal_type = 2;
                    PlaySoundAtPosition("wpn_portal_gun_fire_red", player.origin);
                }

                if (portal_type > 0)
                {
                    eye = player GetTagOrigin("tag_eye");
                    angles = player GetPlayerAngles();
                    forward = AnglesToForward(angles);
                    end = eye + (forward * 99999999);

                    trace = BulletTrace(eye, end, false, player,true,false);

                    thread PlacePortal(player, portal_type, trace);

                    wait(0.2); // prevent rapid double-placing
                }
            }
        }
        WAIT_CLIENT_FRAME;
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

function show_hit_marker( death )
{
    if( isdefined( self ) && isdefined( self.hud_damagefeedback ) )
    {
        material = (death ? "damage_feedback_glow_orange" : "damage_feedback");
        self.hud_damagefeedback SetShader( material, 24, 48 );
        self.hud_damagefeedback.alpha = 1;
        self.hud_damagefeedback FadeOverTime( 1 );
        self.hud_damagefeedback.alpha = 0;
	}
}

function returnTrue()
{
	return true;
}

function PlayAnnouncerSound(sound,time)
{
    PlaySoundAtPosition("ding_on",(0,0,0));
    wait(0.19);
    PlaySoundAtPosition(sound,(0,0,0));
    wait(time);
    PlaySoundAtPosition("ding_off",(0,0,0));
    wait(0.19);
}

function triggerZone(ztar)
{
	runit = GetEnt(ztar, "targetname");
	runit waittill ("trigger", player);
	level flag::set(ztar);
	break;
}

function watch_max_ammo(){
	self endon("bled_out");
	self endon("spawned_player");
	self endon("disconnect");
	for(;;){
		self waittill("zmb_max_ammo");
		foreach(weapon in self GetWeaponsList(1))
		{
			if(isdefined(weapon.clipsize) && weapon.clipsize > 0)
			{
				self SetWeaponAmmoClip(weapon, weapon.clipsize);
			}
		}
	}
}

// Force all zombies to run each round
function portal_round_spawn()
{
        level.zombie_force_run = 9999;
        zm::round_spawning();
}
