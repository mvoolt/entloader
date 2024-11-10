weaponmodels = {
  ff_weapon_assaultcannon   = "models/weapons/assaultcannon/w_assaultcannon.mdl",
  ff_weapon_autorifle       = "models/weapons/autorifle/w_autorifle.mdl",
  ff_weapon_flamethrower    = "models/weapons/flamethrower/w_flamethrower.mdl",
  ff_weapon_grenadelauncher = "models/weapons/grenadelauncher/w_grenadelauncher.mdl",
  ff_weapon_ic              = "models/weapons/incendiarycannon/w_incendiarycannon.mdl",
  ff_weapon_jumpgun         = "models/weapons/railgun/w_railgun.mdl",
  ff_weapon_nailgun         = "models/weapons/nailgun/w_nailgun.mdl",
  ff_weapon_pipelauncher    = "models/weapons/pipelauncher/w_pipelauncher.mdl",
  ff_weapon_railgun         = "models/weapons/railgun/w_railgun.mdl",
  ff_weapon_rpg             = "models/weapons/rpg/w_rpg.mdl",
  ff_weapon_shotgun         = "models/weapons/shotgun/w_shotgun.mdl",
  ff_weapon_sniperrifle     = "models/weapons/sniperrifle/w_sniperrifle.mdl",
  ff_weapon_supernailgun    = "models/weapons/supernailgun/w_supernailgun.mdl",
  ff_weapon_supershotgun    = "models/weapons/supershotgun/w_supershotgun.mdl",
  ff_weapon_tommygun        = "models/weapons/tommygun/w_tommygun.mdl",
  ff_weapon_tranq           = "models/weapons/tranq/w_tranq.mdl"
}

markerffscript = {
  bigpack     = "models/items/backpack/backpack.mdl",
  armorkit    = "models/items/armour/armour.mdl",
  healthkit   = "models/items/healthkit.mdl",
  ball        = "models/items/ball/ball.mdl",
  entcap      = "models/props_c17/substation_stripebox01a.mdl",
  blue_flag   = {mdl = "models/flag/flag.mdl", skin = 0},
  red_flag    = {mdl = "models/flag/flag.mdl", skin = 1},
  yellow_flag = {mdl = "models/flag/flag.mdl", skin = 2},
  green_flag  = {mdl = "models/flag/flag.mdl", skin = 3}
}
for k,v in pairs(weaponmodels) do markerffscript[k] = v end

markernotffscript = {
 info_ff_teamspawn = "models/editor/playerstart.mdl",
 path_mapguide     = "models/editor/camera.mdl",
 ff_minecart       = "models/props/ff_dustbowl/minecart.mdl",
 ff_miniturret     = "models/buildable/respawn_turret/respawn_turret.mdl"
}

function copyvector(vector)
  if (type(vector) == "userdata" and tostring(vector):sub(1,6) == "Vector") then
    return Vector(vector.x, vector.y, vector.z)
  end
end

function entload.tomarker(enttbl)
  local copy = table.copy(enttbl)
  local class = enttbl.classname
  local name = enttbl.targetname
  if class == "info_ff_script" then
    if markerffscript[name] then
      if type(markerffscript[name]) == "table" then
        copy.model = markerffscript[name].mdl
        if markerffscript[name].skin then copy.skin = markerffscript[name].skin end
      else
        copy.model = markerffscript[name]
      end
    else
      copy.model = "models/editor/ff_script_helper.mdl"
    end
  elseif markernotffscript[class] then
    copy.model = markernotffscript[class]
  end
  copy.classname = "info_ff_script"
  local namee = name
  if not name then namee = class end
  copy.targetname = "mk_" .. namee
  return copy
end

function entload.onuse(player)
  local player = CastToPlayer(player)
  local w = player:GetActiveWeaponName()
  if not entload.plyrtbl[player:GetSteamID()] then entload.plyrtbl[player:GetSteamID()] = {clickTimes = 0} end
  if w ~= "ff_weapon_spanner" then
    local plyrtbl = entload.plyrtbl[player:GetSteamID()]
    plyrtbl.clickTimes = plyrtbl.clickTimes + 1
    makehud(player)
    AddSchedule(player:GetSteamID() .. "_clicking", 1.0, function()
      plyrtbl.clickTimes = 0
      removehud(player)
    end)
    if plyrtbl.clickTimes == 3 then
      DeleteSchedule(player:GetSteamID() .. "_clicking")
      plyrtbl.clickTimes = 0
      removehud(player)
      local newent = {
        classname = "info_ff_script",
        origin = copyvector(player:GetOrigin()),
        angles = QAngle(player:GetEyeAngles().x, player:GetAngles().y ,player:GetEyeAngles().z)}
      if w == "ff_weapon_crowbar" then
        newent.classname = "info_ff_teamspawn"
        newent.targetname = "global"
      elseif w == "ff_weapon_umbrella" then
        newent.targetname = "bigpack"
      elseif w == "ff_weapon_knife" then
        newent.targetname = "armorkit"
      elseif w == "ff_weapon_medkit" then
        newent.targetname = "healthkit"
      else
        newent.targetname = w
      end
      local m = entload.spawn(entload.tomarker(newent))
      entload.newents[m:GetId()] = {actual = newent, marker = m, selected = false}
      ChatToAll("assume SOMETHING has been spawned at " .. tostring(newent.origin))
    end
  else
    mv_menu.ShowToPlayer(player, "spanner", "Spanner Menu (" .. entload.selectedcount .. " selected)")
  end
end

function makehud(player)
  local count = entload.plyrtbl[player:GetSteamID()].clickTimes + 1
  local down = "hud_secdown.vtf"
  local up = "hud_secup_red.vtf"
  AddHudIcon(player, (count>1 and up or down), "oneee", 10, 10, 16, 16, 0)
  AddHudIcon(player, (count>2 and up or down), "twooo", 30, 10, 16, 16, 0)
  AddHudIcon(player, (count>3 and up or down), "three", 50, 10, 16, 16, 0)
end

function removehud(player)
  RemoveHudItem(player, "oneee")
  RemoveHudItem(player, "twooo")
  RemoveHudItem(player, "three")
end

function table.copy(t)
  local u = { }
  for k, v in pairs(t) do u[k] = v end
  return setmetatable(u, getmetatable(t))
end

function deepdump( tbl )
    local checklist = {}
    local function innerdump( tbl, indent )
        checklist[ tostring(tbl) ] = true
        for k,v in pairs(tbl) do
            print(indent..k,v,type(v),checklist[ tostring(tbl) ])
            if (type(v) == "table" and not checklist[ tostring(v) ]) then innerdump(v,indent.."    ") end
        end
    end
    print("=== DEEPDUMP -----")
    checklist[ tostring(tbl) ] = true
    innerdump( tbl, "" )
    print("------------------")
end

-- initalize entcreator

IncludeScript("mv_chatsystem")
IncludeScript("mv_menusystem")
entload.devmodeon = true
entload["newents"] = {}
entload.plyrtbl = {}
mv_chat.prefix = "-"
entload.selectedcount = 0
player_onuse = entload.onuse
player_onmenuselect = mv_menu.onmenuselect
player_onchat = mv_chat.onchat
entload_marker = info_ff_script:new({touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}})

function entload_marker:touch(touch_entity)
    local player = CastToPlayer(touch_entity)
    local player_id = player:GetSteamID()
    if self.notouch[player_id] then return; end
    if player:GetActiveWeaponName() == "ff_weapon_spanner" then
      self.notouch[player_id] = true
      entload.newents[entity:GetId()].selected = not entload.newents[entity:GetId()].selected
      entity:SetRenderFx(entload.newents[entity:GetId()].selected and RenderFx.kFlickerFast or 0)

      if entload.newents[entity:GetId()].selected then -- i could've just done a = 0 for _,b in ipairs(newents) do if b.selected then a=a+1 end end
          entload.selectedcount = entload.selectedcount + 1 -- but i think this is much less intensive
      else
          entload.selectedcount = entload.selectedcount - 1
      end

      AddSchedule(entity:GetName() .. "-" .. player_id, 2, function()
          self.notouch[player_id] = nil
      end)
    end
end

function entload_marker:spawn()
    self.notouch = {}
    info_ff_script.spawn(self)
end

function getselected()
    local function iterator(tbl, key)
        local nextKey, nextValue = next(tbl, key)
        while nextKey do
            if nextValue.selected then
                return nextKey, nextValue
            end
            nextKey, nextValue = next(tbl, nextKey)
        end
        return nil
    end
    return iterator, entload.newents, nil
end

for _, player in ipairs(GetPlayers()) do
        player:GiveWeapon("ff_weapon_crowbar",  false)
        player:GiveWeapon("ff_weapon_medkit",   false)
        player:GiveWeapon("ff_weapon_knife",    false)
        player:GiveWeapon("ff_weapon_umbrella", false)
        player:GiveWeapon("ff_weapon_spanner",  false)
end

mv_chat.register("save", function(player, suffix)
  local data = {}
  for _,v in pairs(entload.newents) do
    local new = {}
    ent = v.actual
    new.classname = ent.classname
    new.origin = string.format("%.4f %.4f %.4f", ent.origin.x, ent.origin.y, ent.origin.z)
    if (ent.angles) then new.angles = string.format("%.4f %.4f %.4f", ent.angles.x, ent.angles.y, ent.angles.z) end
    if (ent.targetname) then new.targetname = ent.targetname end
    if (ent.model) then new.model = ent.model end
    table.insert(data,new)
  end

  if (suffix) then
    SaveMapData(data,suffix)
  else
    SaveMapData(data)
  end

  ChatToPlayer(player, "Saved " .. #data .. " entities")
end)

mv_chat.register("load", function(player, suffix)
  local data = nil
  if (suffix) then
    data = LoadMapData(suffix)
  else
    data = LoadMapData()
  end
  for _,def in pairs(data) do
      def.origin = strtovector(def.origin)
      def.angles = strtoqangle(def.angles)
      local m = entload.spawn(entload.tomarker(def))
      entload.newents[m:GetId()] = {actual = def, marker = m, selected = false}
  end
  ChatToPlayer(player, "Loaded " .. #data .. " entities")
end)

mv_chat.register("giveweapons", function(player)
  for weapon,_ in pairs(weaponmodels) do
    player:GiveWeapon(weapon, false)
  end
end)

mv_chat.register("spawn", function(player,arg1,arg2)
  if (false) then
    ChatToAll("Not enough params! usage: -spawn <classname> <targetname>")
  else
    local newent = {
      classname = arg1,
      targetname = arg2,
      origin = copyvector(player:GetOrigin()),
      angles = QAngle(player:GetEyeAngles().x,player:GetAngles().y,player:GetEyeAngles().z)
    }
    local m = entload.spawn(entload.tomarker(newent))
    entload.newents[m:GetId()] = {actual = newent, marker = m, selected = false}
  end
end)
mv_chat.register("translate", function(player,arg1,arg2,arg3)
  if not arg1  then
    ChatToAll("Not enough params! usage: -translate <x> [y] [z]")
  else
    local x,y,z = tonumber(arg1),(arg2==nil and 0 or tonumber(arg2)),(arg3==nil and 0 or tonumber(arg3))
    for id,tbl in getselected() do
      tbl.marker:SetOrigin(tbl.actual.origin + Vector(x,y,z))
      tbl.actual.origin = tbl.actual.origin + Vector(x,y,z)
    end
  end
end)
mv_chat.register("setrot", function(player,arg1,arg2,arg3)
  if not arg1 then
    ChatToAll("Not enough params! usage: -setrot <x> [y] [z]")
  else
    local x,y,z = tonumber(arg1),(arg2==nil and 0 or tonumber(arg2)),(arg3==nil and 0 or tonumber(arg3))
    for id,tbl in getselected() do
      tbl.actual.angles = QAngle(x, y, z)
      tbl.marker:SetAngles(QAngle(x, y, z))
    end
  end
end)

mv_chat.register("rotate", function(player,arg1,arg2,arg3)
  if not arg1 then
    ChatToAll("Not enough params! usage: -setrot <x> [y] [z]")
  else
    local x,y,z = tonumber(arg1),(arg2==nil and 0 or tonumber(arg2)),(arg3==nil and 0 or tonumber(arg3))
    for id,tbl in getselected() do
      tbl.actual.angles = tbl.actual.angles + QAngle(x, y, z)
      tbl.marker:SetAngles((tbl.actual.angles + QAngle(x, y, z)))
    end
  end
end)

mv_chat.register("stack", function(player,amount,_x,_y,_z,_rx,_ry,_rz)
  if not amount then
    ChatToAll("Not enough params! usage: -setrot <i> <x> [y] [z] [pitch] [yaw] [roll]")
  else
    local offset = Vector(_x,(_y==nil and 0 or _y),(_z==nil and 0 or _z))
    local pyr = QAngle(_rx,(_ry==nil and 0 or _ry),(_rz==nil and 0 or _rz))
     for i=1,amount do
      for id,tbl in getselected() do
      end
     end
  end
end)


mv_menu.makemenu("spanner", "Spanner Menu")
--||----------------------------------------------------------||--
local function removeall()
  for id,tbl in getselected() do
    RemoveEntity(tbl.marker)
    entload.newents[id] = nil
    entload.selectedcount = entload.selectedcount - 1
  end
end
mv_menu.register("spanner", "Remove", removeall)
mv_chat.register("removeall", removeall)
--||----------------------------------------------------------||--
local function rotate30()
  for id,tbl in getselected() do
    local angles = tbl.actual.angles
    local y = angles.y + 30
    y = y % 360 -- normalized between 0 and 360
    tbl.actual.angles = QAngle(angles.x, y, angles.z)
    tbl.marker:SetAngles(QAngle(angles.x, y, angles.z))
  end
end
mv_menu.register("spanner", "Rotate by 30°", rotate30)
mv_chat.register("rotate30", rotate30)
--||----------------------------------------------------------||--
local function droptofloorall()
  for id,tbl in getselected() do
    DropToFloor(tbl.marker)
    tbl.actual.origin = copyvector(tbl.marker:GetOrigin())
  end
end
mv_menu.register("spanner", "Drop to floor", droptofloorall)
mv_chat.register("droptofloor", droptofloorall)
--||----------------------------------------------------------||--
local function resetxz()
  for id,tbl in getselected() do
    local y = tbl.actual.angles.y
    tbl.actual.angles = QAngle(0, y, 0)
    tbl.marker:SetAngles(QAngle(0, y, 0))
  end
end
mv_menu.register("spanner", "Reset pitch and roll", resetxz)
mv_chat.register("resetxz", resetxz)
--||----------------------------------------------------------||--
local function deselectall()
  for id,tbl in getselected() do
    tbl.marker:SetRenderFx(0)
    tbl.selected = false
    entload.selectedcount = entload.selectedcount - 1
  end
end
mv_menu.register("spanner", "Deselect", deselectall)
mv_chat.register("deselectall", deselectall)
--||----------------------------------------------------------||--
mv_menu.register("spanner", "Quit", dummy) -- this has to be always last, remove this line if pagination happens
