import os
import sys
import zipfile
import vdf
import io
from valvebsp.bsp import *
from valvebsp.constants import *
import shutil
import bz2

if len(sys.argv) != 2:
    print("Usage: python res.py <path_to_bsp>")
    sys.exit(1)

file = sys.argv[1]
modpath = os.path.dirname(os.path.dirname(file))

#keys that point to textures
texturekeys = [ "$basetexture", "$basetexture2",
		      "$detail", "$detail1", "$detail2",
		      "$bumpmap", "$bumpmap2", "$bumpmask",
		      "$phongexponenttexture", "$phongwarptexture", 
		      "$envmapmask", "$selfillummask", "$selfillumtexture",
		      "$lightwarptexture", "$ambientoccltexture", "$blendmodulatetexture" ]

usesSoundscape = False # If the map has a _soundscape.txt file
assets = [] # We already have those assets so exclude those
reslist = [] # List of assets that the map uses
fastdl_path = "/var/www/html/fastdl/hl2ff/"

for txt in os.listdir("./lists"):
    with open("./lists/" + txt) as f:
        assets.extend([line.rstrip().lower() for line in f])

def parse_vmt(vmt_path):
    qcfile = dict
    try:
        with open(modpath + "/" + vmt_path.removesuffix("\n"), "r") as vmt:
            qcfile = vdf.parse(vmt)
        
        for tex in qcfile:
                for k, v in qcfile[tex].items():
                    if k.lower() in texturekeys:
                        newstr = "materials/" + v.replace("\\", "/")
                        if not newstr.endswith(".vtf"):
                            newstr = newstr + ".vtf"
                        addToList(newstr)
                        addToList(newstr.replace(".vtf", ".vmt"))
    except FileNotFoundError:
        print(f"vmt {vmt_path} does not exist")

def addToList(path):
    path = path.replace("//", "/")
    if not path.lower() in assets and not path.lower() in reslist and not path.lower().startswith("materials/editor/") and os.path.isfile(modpath + "/" + path):
        reslist.append(path.lower())
        if path.endswith(".vmt"):
            parse_vmt(path)
        if path.endswith(".mdl"):
            addToList(path.replace(".mdl", ".xbox.vtx"))
            addToList(path.replace(".mdl", ".dx80.vtx"))
            addToList(path.replace(".mdl", ".dx90.vtx"))
            addToList(path.replace(".mdl", ".sw.vtx"))
            addToList(path.replace(".mdl", ".phy"))
            addToList(path.replace(".mdl", ".vvd"))
            parse_vmt("materials/" + path.replace(".mdl", ".vmt"))

try:
    bsp = Bsp(file)
except FileNotFoundError:
    print(f"bsp {file} does not exist")
    sys.exit(1)

pakfile = zipfile.ZipFile(file)
 
for pak_file in pakfile.namelist():
    assets.append(pak_file.lower())
    if pak_file.endswith(".vmt"):
        qcfile = vdf.parse(io.TextIOWrapper(io.BytesIO(pakfile.read(pak_file)), encoding='UTF-8'))
        if qcfile.get("patch") is None:
            continue
        basepath = qcfile["patch"]["include"].lower().replace("\\", "/")
        addToList(basepath)
        if not basepath in assets:
            base = vdf.parse(open(modpath + "/" + basepath, "r"))
            keys = next(iter(base.values()))
            for k, v in qcfile["patch"]["replace"].items():
                keys[k] = v
            for k, v in keys.items():
                if k.lower() in texturekeys:
                    newstr = "materials/" + v.replace("\\", "/")
                    if not newstr.endswith(".vtf"):
                        newstr = newstr + ".vtf"
                    addToList(newstr)
                    addToList(newstr.replace(".vtf", ".vmt"))

for tex in bsp[43]: # 43: LUMP_TEXDATA_STRING_DATA
    addToList("materials/" + tex.lower() + ".vmt")

for ent in bsp[0]:  # 0: LUMP_ENTITIES
    entry_dict = {k: v for k, v in ent}
    classname = entry_dict.get("classname")
    model = entry_dict.get("model", "").lower()
    if classname in {"prop_static", "prop_dynamic", "prop_dynamic_override", "prop_physics", "prop_physics_override", "prop_ragdoll"}:
        addToList(model)
    elif classname == "env_sprite":
        sprite = model.replace(".spr", ".vmt")
        if "materials/" not in sprite:
            sprite = "materials/" + sprite
        addToList(sprite)
    elif classname == "info_overlay":
        addToList(entry_dict.get("material").lower())
    elif classname == "infodecal":
        texture = entry_dict.get("texture").lower()
        if "materials/" not in texture:
            texture = "materials/" + texture
        addToList(texture)
    elif classname == "ambient_generic":
        addToList("sound/" + entry_dict.get("message").lower())
    elif classname in {"env_soundscape", "env_soundscape_triggerable", "trigger_soundscape"}:
        usesSoundscape = True

# Make the res file
with open(modpath + "/maps/" + os.path.basename(file).replace(".bsp", ".res"), "w") as res:
    res.write("\"resources\"\n{\n")
    for asset in reslist:
        res.write(f'    "{asset}" "file"\n')
    res.write("}\n")

# Copy files to fastdl path and compress as bz2
for asset in reslist:
    if os.path.isfile(modpath + "/" + asset):
        try:
            os.makedirs(fastdl_path + os.path.dirname(asset))
        except FileExistsError:
            pass
        with open(modpath + "/" + asset, 'rb') as f_in, bz2.open(fastdl_path + asset + '.bz2', 'wb') as f_out:
            shutil.copyfileobj(f_in, f_out)

# copy the bsp to fastdl and compress as bz2
with open(modpath + "/maps/" + os.path.basename(file), 'rb') as f_in, bz2.open(fastdl_path + "maps/" + os.path.basename(file) + '.bz2', 'wb') as f_out:
    shutil.copyfileobj(f_in, f_out)