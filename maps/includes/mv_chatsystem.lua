mv_chat = {}
mv_chat.prefix = "!"
mv_chat.cmds = {}

function mv_chat.onchat(player,string)
  local player = CastToPlayer(player)
  local message = string.sub(string.gsub( string, "%c", "" ), string.len(player:GetName())+3)
  local prefix = string.sub(message,1,1)
  message = string.sub(message, 1+string.len(mv_chat.prefix))
  local command = string.lower(string.match(message, "%a+"))
  local params = explode(" ", string.sub(message, string.len(command)+2))
  for i,param in pairs(params) do
    if tonumber(param) ~= nil then
      params[i] = tonumber(param)
    end
  end
  table.insert( params, 1, player )
  if (prefix == mv_chat.prefix and mv_chat.cmds[command]) then
    mv_chat.cmds[command].func(unpack(params))
    return false;
  end
  return true
end

function mv_chat.register(name,func)
    if type(func) ~= "function" then return false; end
    if mv_chat.cmds[name] then return false; end
    mv_chat.cmds[name] = {func = func}
end

function explode(div,str) -- copied from base_chatcommands.lua
  if (div=='') then return false end
  if (str=='') then return {} end
  local pos,arr = 0,{}
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
    table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
    pos = sp + 1 -- Jump past current divider
  end
  table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
  return arr
end
