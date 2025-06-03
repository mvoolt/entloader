--[[
ctf_2fort.bsp
MD5: d9721908825617c5a20be79d30cb10c7
Sourced from <to be filled> (?.?? MiB)
]]
IncludeScript("base_entloader")
IncludeScript("entload_gameplay")
local ctf_2fort = {
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "1360 -1776 388",
        angles = "0 218.5 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "1456 -1776 388",
        angles = "0 213.5 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "1456 -1888 388",
        angles = "0 180 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "1360 -1888 388",
        angles = "0 180 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "1360 -2000 388",
        angles = "0 164 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "1456 -2000 388",
        angles = "0 157 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "-1360 1808 386",
        angles = "0 36.5 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "-1456 1808 386",
        angles = "0 33.5 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "-1456 1904 386"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "-1360 1904 386"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "-1360 2000 386",
        angles = "0 323.5 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "-1460 2000 386",
        angles = "0 327.5 0"
    },
    {
        classname = "info_ff_script",
        targetname = "red_entcap",
        origin = "0 995.5 444"
    },
    {
        classname = "info_ff_script",
        targetname = "blue_entcap",
        origin = "-2 -996 444"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "1552 1328 383",
        angles = "0 150 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "1648 1328 383",
        angles = "0 155.5 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "1552 1424 383",
        angles = "0 179.5 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "1648 1424 383",
        angles = "0 179.5 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "1552 1520 383",
        angles = "0 219.5 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "redspawn",
        origin = "1648 1520 383",
        angles = "0 212 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "-1648 -1520 386",
        angles = "0 41 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "-1552 -1520 386",
        angles = "0 46 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "-1648 -1424 386"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "-1560 -1424 386"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "-1648 -1328 386",
        angles = "0 331.5 0"
    },
    {
        classname = "info_ff_teamspawn",
        targetname = "bluespawn",
        origin = "-1552 -1328 386",
        angles = "0 316.5 0"
    },
    {
        classname = "info_ff_script",
        targetname = "blue_flag",
        origin = "320 -3136 -82",
        angles = "0 180.5 0"
    },
    {
        classname = "info_ff_script",
        targetname = "red_flag",
        origin = "-328 3136 -82"
    }
}

function startup()
    entload.init(ctf_2fort)
    SetPlayerLimit(Team.kRed,    0)
    SetPlayerLimit(Team.kBlue,   0)
    SetPlayerLimit(Team.kGreen,  -1)
    SetPlayerLimit(Team.kYellow, -1)

	for i = Team.kBlue, Team.kGreen do
        GetTeam(i):SetClassLimit(Player.kCivilian, -1)
	end
end

function player_spawn(_)
	ServerCommand("toggle sv_cheats 1")
    ServerCommand("ent_remove_all point_camera")
	ServerCommand("toggle sv_cheats 0")
	player_spawn = nil
	ConsoleToAll("console spam fixed now get back to the game :)")
	-- this hack is horrible i htink i'm gonna vomit
end
