import os
import sys
import hashlib
import re
from valvebsp.bsp import *
from valvebsp.constants import *

spawns = {
    "info_player_deathmatch": "global",  # HL2:DM
    "gmod_player_start":      "global",  # Old GMod
    # Hidden: Source
    "info_hidden_spawn":            "hidden",
    "info_marine_spawn":            "marine",
    # Day of Defeat: Source
    "info_player_allies":           "bluespawn",
    "info_player_axis":             "redspawn",
    # Counter-Strike: Source
    "info_player_counterterrorist": "bluespawn",
    "info_player_terrorist":        "redspawn",
    # Goldeneye: Source
    "info_player_mi6":              "optblue",
    "info_player_janus":            "optred",
    # Battlegrounds 2 & 3
    "info_player_american":         "bluespawn",
    "info_player_british":          "redspawn",
    # Zombie Panic: Source
    "info_player_human":            "bluespawn",
    "info_player_zombie":           "redspawn",
    # Half-Life 2: Capture The Flag
    "ctf_combine_player_spawn":     "bluespawn",
    "ctf_rebel_player_spawn":       "redspawn",
    # NEOTOKYO
    "info_player_attacker":         "bluespawn",
    "info_player_defender":         "redspawn",
}
'''
weapon_rpg
weapon_357
weapon_ar2
weapon_crossbow
weapon_crowbar
weapon_pistol
weapon_shotgun
weapon_slam
weapon_smg1
weapon_stunstick
'''
other = {
    # Half-Life 2: Deathmatch
    "item_ammo_357":          "#keep",
    "item_ammo_357_large":    "#keep",
    "item_ammo_ar2":          "#keep",
    #"item_ammo_ar2_altfire":  "#keep",
    "item_ammo_ar2_large":    "#keep",
    "item_ammo_crate":        "#keep",
    "item_ammo_crossbow":     "#keep",
    "item_ammo_pistol":       "#keep",
    "item_ammo_pistol_large": "#keep",
    "item_ammo_smg1":         "#keep",
    #"item_ammo_smg1_grenade": "#keep",
    "item_ammo_smg1_large":   "#keep",
    "item_ar2_grenade":       "#keep",
    "item_box_buckshot":      "#keep",
    "item_rpg_round":         "#keep",
    "item_battery":           "#keep",
    "item_healthkit":         "#keep",
    "item_healthvial":        "#keep",
    "weapon_frag":            "#keep",
    #"weapon_rpg":      "ff_weapon_rpg",
    #"weapon_357":      "ff_weapon_flamethrower",
    #"weapon_ar2":      "ff_weapon_autorifle",
    #"weapon_crossbow": "ff_weapon_sniperrifle",
    #"weapon_crowbar":  "ff_weapon_crowbar",
    #"weapon_pistol":   "ff_weapon_railgun",
    #"weapon_shotgun":  "ff_weapon_supershotgun",
    #"weapon_smg1":     "ff_weapon_supernailgun",
    #"weapon_slam"
    # Half-Life 2: Capture The Flag
    "ctf_combine_flag": "blue_flag",
    "ctf_rebel_flag":   "red_flag",
    "ctf_flag_capture": "ifyouseethis_thisisanerror"
}

'''
Following entities will need to be parsed thru to determine which team they are on:
aoc_spawnpoint              # Age of Chivalry, grouped spawn system
dys_spawn_point             # Dystopia, grouped spawn system
'''

if len(sys.argv) != 2:
    print("Usage: python to.py <path_to_bsp>")
    sys.exit(1)

file = sys.argv[1]

if not os.path.isfile(file):
    print(f"this file does not exist")
    sys.exit(1)

bsp = Bsp(file)
name = os.path.splitext(os.path.basename(file))[0]
ent_targets = []

for ent in bsp[0]:
    target = [v for k, v in ent if k == 'classname']
    if target and target[0] in spawns:
        ent_targets.append(ent)
    if target and target[0] in other:
        ent_targets.append(ent)

with open(file, "rb") as f:
    file_hash = hashlib.md5()
    while chunk := f.read(8192):
        file_hash.update(chunk)

lua_output  = "--[[\n"
lua_output += f"{os.path.basename(file)}\n"
lua_output += f"MD5: {file_hash.hexdigest()}\n"
lua_output += f"Sourced from <to be filled> (?.?? MiB)\n"
lua_output += f"]]\n"
lua_output += "IncludeScript(\"base_entloader\")\n"
lua_output += "IncludeScript(\"entload_gameplay\")\n"
lua_output += f"local {name} = {{\n"

for ent in ent_targets:
    entry_dict = {k: v for k, v in ent}
    ogname = entry_dict.get("classname")
    origin = entry_dict.get("origin", "")
    angles = entry_dict.get("angles", "0 0 0")
    if ogname in spawns:
        classname = "info_ff_teamspawn"
        match ogname:
            case "info_es_spawn": # Eternal Silence, UNTESTED
                team = entry_dict.get("TeamNum")
                #0 : "Neutral"
                if team == "2": # United Terran Forces (UTF)
                    targetname = "bluespawn"
                elif team == "3": # Neo-Galactic Militia (NGM)
                    targetname = "redspawn"
            case "ins_spawnpoint": # Insurgency: Modern Infantry Combat, UNTESTED
                team = entry_dict.get("team") # for some reason maps can flip between these???? WHY?, either way refer to the map's imc2 file
                                              # only official maps that do flip teams are ins_baghdad and ins_karam
                if team == "1": # Team 1 (usually US Marines)
                    targetname = "bluespawn"
                elif team == "2": # Team 2 (usually Iraqi Insurgents)
                    targetname = "redspawn"
            #case "aoc_spawnpoint": # Age of Chivalry
            #case "dys_spawn_point": # Dystopia
            case _:
                targetname = spawns[entry_dict.get("classname", "info_player_deathmatch")]
    if ogname in other:
        classname = "info_ff_script"
        match ogname:
            case "ctf_combine_flag" | "ctf_rebel_flag":
                if entry_dict.get("SpawnWithCaptureEnabled", "0") == "1":
                    captouse = ""
                    if ogname == "ctf_combine_flag": captouse = "blue_entcap"
                    if ogname == "ctf_rebel_flag": captouse = "red_entcap"

                    lua_output += f"    {{\n        classname = \"{classname}\",\n"
                    lua_output += f"        targetname = \"{captouse}\",\n"
                    lua_output += f"        origin = \"{origin}\""
                    if not angles == "0 0 0": lua_output += f",\n        angles = \"{angles}\""
                    lua_output += "\n    },\n"
                targetname = other[entry_dict.get("classname")]
            case "ctf_flag_capture":
                team = entry_dict.get("team")
                if team == "2": # Combine
                    targetname = "blue_entcap"
                elif team == "3": # Rebels
                    targetname = "red_entcap"
            case _:
                supposedtargetname = other[entry_dict.get("classname")]
                if supposedtargetname == "#keep":
                    targetname = entry_dict.get("classname")
                else:
                    targetname = other[entry_dict.get("classname")]

    #lua_output += f"-- {entry_dict.get("classname", "unknown")}\n"
    lua_output += f"    {{\n        classname = \"{classname}\",\n"
    lua_output += f"        targetname = \"{targetname}\",\n"
    lua_output += f"        origin = \"{origin}\""
    if not angles == "0 0 0": lua_output += f",\n        angles = \"{angles}\""
    lua_output += "\n    },\n"


lua_output = lua_output.rstrip(",\n") + "\n}\n\n"
lua_output += "function startup()\n"
lua_output += f"    entload.init({name})\n"
lua_output += "    SetPlayerLimit(Team.kRed,    0)\n"
lua_output += "    SetPlayerLimit(Team.kBlue,   0)\n"
lua_output += "    SetPlayerLimit(Team.kGreen,  -1)\n"
lua_output += "    SetPlayerLimit(Team.kYellow, -1)\n\n"
lua_output += "	for i = Team.kBlue, Team.kGreen do\n"
lua_output += "        GetTeam(i):SetClassLimit(Player.kCivilian, -1)\n"
lua_output += "	end\n"
lua_output += "end\n"

#print(lua_output)

os.makedirs("to_output", exist_ok=True)

with open("to_output/" + name + ".lua", "w") as out:
    out.write(lua_output)
