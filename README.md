# entloader
Fortress Forever project to dynamically make new entities on maps from other sourcemods to play on FF

## entload creator usage
Open the in-game console and type in `lua_dostring entload.devmode()`, Make sure you are running this command in a listen server with no other player on the server

You will then be given a Crowbar, Medkit, Knife, Umbrella and a Spanner. Each weapon has own functionality so let's go over them
- Crowbar: Spawns a FFA spawn
- Medkit: Spawns a medkit
- Knife: Spawns an armour kit
- Umbrella: Spawns a big pack backpack
- Spanner: Opens a menu to adjust certain entities

All weapons (except Spanner) will spawn themselves (Melees spawn something else) after pressing E 3 times in a second.

There's also chat commands to use, here's all commands with nessecary parameters:
- `-giveweapons`: Gives all other weapons like Shotgun or RPG
- `-setrot <x> [y] [z]`
- `-translate <x> [y] [z]`
- `-stack <amount> <x> [y] [z] [pitch] [yaw] [roll]`
- `-rotate <x> [y] [z]`
- `-spawn <classname> <targetname>`

## helpers usage
```sh
# make a new virtual environment
$ python -m venv env
# activate the venv
$ source env/bin/activate
# install requirements
(env) $ pip install -r requirements.txt
# make a entdef (entity defintion) out of a bsp
# the output will be at ./to_output/ 
(env) $ python3 to.py "/home/mv/.steam/steam/steamapps/sourcemods/hl2ctf/maps/ctf_lambdabunker.bsp"
# make a .res file out of a bsp
# output will be at ./res_output/
(env) $ python3 res.py "/home/mv/.steam/steam/steamapps/sourcemods/hl2ctf/maps/ctf_lambdabunker.bsp"
```