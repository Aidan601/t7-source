// Decompiled by Serious. Credits to Scoba for his original tool, Cerberus, which I heavily upgraded to support remaining features, other games, and other platforms.
#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace zm_genesis_teleporter;

/*
	Name: __init__sytem__
	Namespace: zm_genesis_teleporter
	Checksum: 0xE154829C
	Offset: 0x2B8
	Size: 0x34
	Parameters: 0
	Flags: AutoExec
*/
autoexec function __init__sytem__()
{
	system::register("zm_genesis_teleporter", &__init__, undefined, undefined);
}

/*
	Name: __init__
	Namespace: zm_genesis_teleporter
	Checksum: 0x34FC89D8
	Offset: 0x2F8
	Size: 0xE4
	Parameters: 0
	Flags: Linked
*/
function __init__()
{
	visionset_mgr::register_overlay_info_style_transported("zm_genesis", 15000, 15, 2);
	visionset_mgr::register_overlay_info_style_postfx_bundle("zm_factory_teleport", 15000, 1, "pstfx_zm_wormhole");
	clientfield::register("toplayer", "player_shadowman_teleport_hijack_fx", 15000, 1, "int", &player_shadowman_teleport_hijack_fx, 0, 0);
	level thread setup_teleport_aftereffects();
	level thread wait_for_black_box();
	level thread wait_for_teleport_aftereffect();
}

/*
	Name: setup_teleport_aftereffects
	Namespace: zm_genesis_teleporter
	Checksum: 0x1FE45154
	Offset: 0x3E8
	Size: 0x126
	Parameters: 0
	Flags: Linked
*/
function setup_teleport_aftereffects()
{
	util::waitforclient(0);
	level.teleport_ae_funcs = [];
	if(getlocalplayers().size == 1)
	{
		level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_fov;
	}
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_shellshock;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_shellshock_electric;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_bw_vision;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_red_vision;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_flashy_vision;
	level.teleport_ae_funcs[level.teleport_ae_funcs.size] = &teleport_aftereffect_flare_vision;
}

/*
	Name: wait_for_black_box
	Namespace: zm_genesis_teleporter
	Checksum: 0x912D161A
	Offset: 0x518
	Size: 0x100
	Parameters: 0
	Flags: Linked
*/
function wait_for_black_box()
{
	while(1)
	{
		level waittill(#"black_box_start", localclientnum);
		/#
			assert(isdefined(localclientnum));
		#/
		savedvis = getvisionsetnaked(localclientnum);
		playsound(0, "evt_teleport_2d_fnt", (0, 0, 0));
		visionsetnaked(localclientnum, "default", 0);
		while(secondclientnum != localclientnum)
		{
			level waittill(#"black_box_end", secondclientnum);
		}
		visionsetnaked(localclientnum, savedvis, 0);
	}
}

/*
	Name: wait_for_teleport_aftereffect
	Namespace: zm_genesis_teleporter
	Checksum: 0xC454FCD8
	Offset: 0x620
	Size: 0xC6
	Parameters: 0
	Flags: Linked
*/
function wait_for_teleport_aftereffect()
{
	while(1)
	{
		level waittill(#"tae", localclientnum);
		if(getdvarstring("genesisAftereffectOverride") == "-1")
		{
			self thread [[level.teleport_ae_funcs[randomint(level.teleport_ae_funcs.size)]]](localclientnum);
		}
		else
		{
			self thread [[level.teleport_ae_funcs[int(getdvarstring("genesisAftereffectOverride"))]]](localclientnum);
		}
	}
}

/*
	Name: teleport_aftereffect_shellshock
	Namespace: zm_genesis_teleporter
	Checksum: 0xA60904FE
	Offset: 0x6F0
	Size: 0x14
	Parameters: 1
	Flags: Linked
*/
function teleport_aftereffect_shellshock(localclientnum)
{
	wait(0.05);
}

/*
	Name: teleport_aftereffect_shellshock_electric
	Namespace: zm_genesis_teleporter
	Checksum: 0x2EA1AF97
	Offset: 0x710
	Size: 0x14
	Parameters: 1
	Flags: Linked
*/
function teleport_aftereffect_shellshock_electric(localclientnum)
{
	wait(0.05);
}

/*
	Name: teleport_aftereffect_fov
	Namespace: zm_genesis_teleporter
	Checksum: 0x86C61373
	Offset: 0x730
	Size: 0x0
	Parameters: 1
	Flags: Linked
*/
function teleport_aftereffect_fov()
{
System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at System.Collections.Generic.List`1.get_Item(Int32 index)
   at Cerberus.Logic.Decompiler.FindElseIfStatements() in D:\Modding\Call of Duty\t89-dec\Cerberus.Logic\Decompiler\Decompiler.cs:line 606
   at Cerberus.Logic.Decompiler..ctor(ScriptExport function, ScriptBase script) in D:\Modding\Call of Duty\t89-dec\Cerberus.Logic\Decompiler\Decompiler.cs:line 210
/*
No Output
*/

	/* ======== */

/* 
	Stack: 
*/
	/* ======== */

/* 
	Blocks: 
	Cerberus.Logic.BasicBlock at 0x0730, end at 0x0731
	Cerberus.Logic.DevBlock at 0x0762, end at 0x0782
	Cerberus.Logic.IfBlock at 0x07BA, end at 0x0808
*/
	/* ======== */

}

/*Unknown Op Code (0x0B28) at 07F0*/
/*
	Name: teleport_aftereffect_bw_vision
	Namespace: zm_genesis_teleporter
	Checksum: 0x41A1454
	Offset: 0x818
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function teleport_aftereffect_bw_vision(localclientnum)
{
	/#
		println("");
	#/
	savedvis = getvisionsetnaked(localclientnum);
	visionsetnaked(localclientnum, "cheat_bw_invert_contrast", 0.4);
	wait(1.25);
	visionsetnaked(localclientnum, savedvis, 1);
}

/*
	Name: teleport_aftereffect_red_vision
	Namespace: zm_genesis_teleporter
	Checksum: 0x16E56DE9
	Offset: 0x8C0
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function teleport_aftereffect_red_vision(localclientnum)
{
	/#
		println("");
	#/
	savedvis = getvisionsetnaked(localclientnum);
	visionsetnaked(localclientnum, "zombie_turned", 0.4);
	wait(1.25);
	visionsetnaked(localclientnum, savedvis, 1);
}

/*
	Name: teleport_aftereffect_flashy_vision
	Namespace: zm_genesis_teleporter
	Checksum: 0xD7C7FC32
	Offset: 0x968
	Size: 0xDC
	Parameters: 1
	Flags: Linked
*/
function teleport_aftereffect_flashy_vision(localclientnum)
{
	/#
		println("");
	#/
	savedvis = getvisionsetnaked(localclientnum);
	visionsetnaked(localclientnum, "cheat_bw_invert_contrast", 0.1);
	wait(0.4);
	visionsetnaked(localclientnum, "cheat_bw_contrast", 0.1);
	wait(0.4);
	wait(0.4);
	wait(0.4);
	visionsetnaked(localclientnum, savedvis, 5);
}

/*
	Name: teleport_aftereffect_flare_vision
	Namespace: zm_genesis_teleporter
	Checksum: 0x97AE5704
	Offset: 0xA50
	Size: 0x9C
	Parameters: 1
	Flags: Linked
*/
function teleport_aftereffect_flare_vision(localclientnum)
{
	/#
		println("");
	#/
	savedvis = getvisionsetnaked(localclientnum);
	visionsetnaked(localclientnum, "flare", 0.4);
	wait(1.25);
	visionsetnaked(localclientnum, savedvis, 1);
}

/*
	Name: player_shadowman_teleport_hijack_fx
	Namespace: zm_genesis_teleporter
	Checksum: 0xFA4265BD
	Offset: 0xAF8
	Size: 0xDE
	Parameters: 7
	Flags: Linked
*/
function player_shadowman_teleport_hijack_fx(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
	self notify(#"player_shadowman_teleport_hijack_fx");
	self endon(#"player_shadowman_teleport_hijack_fx");
	if(newval)
	{
		if(isdemoplaying() && demoisanyfreemovecamera())
		{
			return;
		}
		self thread function_bad0a94c(localclientnum);
		self thread postfx::playpostfxbundle("pstfx_zm_wormhole");
	}
	else
	{
		self notify(#"player_shadowman_teleport_hijack_fx_done");
	}
}

/*
	Name: function_bad0a94c
	Namespace: zm_genesis_teleporter
	Checksum: 0xB1C6ACF3
	Offset: 0xBE0
	Size: 0x4C
	Parameters: 1
	Flags: Linked
*/
function function_bad0a94c(localclientnum)
{
	self util::waittill_any("player_shadowman_teleport_hijack_fx", "player_shadowman_teleport_hijack_fx_done");
	self postfx::exitpostfxbundle();
}

