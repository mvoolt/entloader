IncludeScript("base_entloader");
IncludeScript("entload_gameplay");
local ctftest = {
{
classname="info_ff_script",
targetname="red_entcap",
origin=Vector(1220.3,-448.437,125.325)
},{
classname="info_ff_script",
targetname="blue_flag",
origin=Vector(854.970337,-422.159210,50)
}
}

function startup()
    entload.init(LoadMapData())
    entload.init(ctftest)
    SetPlayerLimit(Team.kRed,    0)
    SetPlayerLimit(Team.kGreen,  0)
    SetPlayerLimit(Team.kBlue,   0)
    SetPlayerLimit(Team.kYellow, 0)
end
