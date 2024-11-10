--[[ base_entloader.lua made by mv (mv@darkok.xyz) --]]
entload = {
  devmodeon = false
}

function entload.init(arr)
  for i, def in ipairs(arr) do
    if (def["classname"] == nil or def["origin"] == nil) then
      ConsoleToAll("index " .. i .. " is missing either classname or origin, skipping")
    else
      entload.spawn(def)
    end
  end
end

function strtovector(str)
  local tbl = {}
  for i in str:gmatch("%S+") do table.insert(tbl, tonumber(i)) end
  return Vector(tbl[1],tbl[2],tbl[3])
end

function strtoqangle(str)
  local tbl = {}
  for i in str:gmatch("%S+") do table.insert(tbl, tonumber(i)) end
  return QAngle(tbl[1],tbl[2],tbl[3])
end

function entload.spawn(tbl)
  local origin = {}
  local angles = {}
  local entity = nil
  local vector = nil
  local qangle = nil

  if (tbl["classname"] == "info_ff_script" and tbl["model"] ~= nil) then
    targetname = tbl["targetname"]
    if _G[targetname] == nil then
      if targetname:sub(1,3) == "mk_" and entload.devmodeon then
        _G[targetname] = entload_marker:new({ model = tbl["model"], modelskin = tbl["skin"] });
      else
        _G[targetname] = info_ff_script:new({ model = tbl["model"], modelskin = tbl["skin"] });
      end
    end
  end

  if (type(tbl["origin"]) == "userdata" and tostring(tbl["origin"]):sub(1,6) == "Vector") then
    vector = tbl["origin"]
  else
    vector = strtovector(tbl["origin"])
  end

  if tbl["angles"] ~= nil then
    if (type(tbl["angles"]) == "userdata" and tostring(tbl["angles"]):sub(1,6) == "QAngle") then
      qangle = tbl["angles"]
    else
      qangle = strtoqangle(tbl["angles"])
    end
  else
    qangle = QAngle(0,0,0)
  end

  if tbl["targetname"] == nil then
    entity = SpawnEntity(tbl["classname"])
  else
    entity = SpawnEntity(tbl["classname"], tbl["targetname"])
  end
  entity:Teleport(vector, qangle, Vector(0,0,0))
  if tbl["classname"] == "info_ff_script" then
    local casted = CastToInfoScript(entity)
    casted:SetStartOrigin(vector)
    casted:SetStartAngles(qangle)
  end
  return entity
end

function entload.devmode()
  if (GetConvar("cl_grenadetimer") ~= -1 and NumPlayers() == 1) then
    print("Local game detected! turning on entloader devmode")
    IncludeScript("entload_creator")
  else print("Not a local game!") end
end
