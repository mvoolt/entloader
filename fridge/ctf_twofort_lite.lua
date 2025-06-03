--[[
ctf_twofort_lite.bsp
MD5: b18eb22c46b01d369257ebb3d002fc36
Sourced from <to be filled> (?.?? MiB)
]]
IncludeScript("base_entloader")
IncludeScript("entload_gameplay")
local ctf_twofort_lite = {
    {
        classname = "info_ff_script",
        targetname = "blue_entcap",
        origin = "0 2400 152",
        angles = "0 270 0"
    },
    {
        classname = "info_ff_script",
        targetname = "blue_flag",
        origin = "0 2400 152",
        angles = "0 270 0"
    },
    {
        classname = "info_ff_script",
        targetname = "red_entcap",
        origin = "0 -2400 152",
        angles = "0 90 0"
    },
    {
        classname = "info_ff_script",
        targetname = "red_flag",
        origin = "0 -2400 152",
        angles = "0 90 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "-768 1344 164",
        angles = "0 315 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "-704 1408 164",
        angles = "0 315 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "704 1408 164",
        angles = "0 225 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "768 1344 164",
        angles = "0 225 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "768 1024 164",
        angles = "0 135 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "704 960 164",
        angles = "0 135 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "-704 960 164",
        angles = "0 45 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "-768 1024 164",
        angles = "0 45 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "-768 -1344 164",
        angles = "0 45 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "-704 -1408 164",
        angles = "0 45 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "-704 -960 164",
        angles = "0 315 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "-768 -1024 164",
        angles = "0 315 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "704 -960 164",
        angles = "0 225 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "768 -1024 164",
        angles = "0 225 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "704 -1408 164",
        angles = "0 135 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "768 -1344 164",
        angles = "0 135 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "448 2368 0",
        angles = "0 270 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "320 2368 0",
        angles = "0 270 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "-320 2368 0",
        angles = "0 270 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "-448 2368 0",
        angles = "0 270 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "-592 1520 0",
        angles = "0 90 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "592 1520 0",
        angles = "0 90 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "-592 -1520 0",
        angles = "0 270 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "592 -1520 0",
        angles = "0 270 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "448 -2368 0",
        angles = "0 90 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "320 -2368 0",
        angles = "0 90 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "-320 -2368 0",
        angles = "0 90 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "-448 -2368 0",
        angles = "0 90 0"
    },
    {
        classname = "info_ff_script",
        targetname = "upjet",
        origin = Vector(-897.714,1180.38,0.0312653)
    },
    {
        classname = "info_ff_script",
        targetname = "upjet",
        origin = Vector(897.714,1184.89,0.0312653)
    },
    {
        classname = "info_ff_script",
        targetname = "upjet",
        origin = Vector(897.714,-1184.82,0.0312653)
    },
    {
        classname = "info_ff_script",
        targetname = "upjet",
        origin = Vector(-897.714,-1185.55,0.0312653)
    }
}

function startup()
    entload.init(ctf_twofort_lite)
    SetPlayerLimit(Team.kRed,    0)
    SetPlayerLimit(Team.kBlue,   0)
    SetPlayerLimit(Team.kGreen,  -1)
    SetPlayerLimit(Team.kYellow, -1)

	for i = Team.kBlue, Team.kGreen do
        GetTeam(i):SetClassLimit(Player.kCivilian, -1)
	end
end
