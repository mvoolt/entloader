mv_menu = {}
mv_menu.entries = {} -- for storing information about each menu
mv_menu.players = {} -- for cursor, determiting location to go to next or previous page

function mv_menu.onmenuselect(player, key, num)
    local entry = mv_menu.entries[key]
    local pgn = (#entry.options > 10) -- pagination
    local functorun = dummy
    if mv_menu.players[player:GetSteamID()] == nil then mv_menu.players[player:GetSteamID()] = {cursor = 0} end
    local plyrtbl = mv_menu.players[player:GetSteamID()]

    if (entry.options[plyrtbl.cursor + num] ~= nil) then
        local number = (num == 0 and 10 or num)
        functorun = entry.options[plyrtbl.cursor + number].func
    end
    if pgn then
        if num == 8 then functorun = mv_menu.pgnprevious end
        if num == 9 then functorun = mv_menu.pgnnext end
        if num == 0 then functorun = dummy end
    end

    functorun(player, key)
    if (not (pgn and (num == 8 or num == 9))) then plyrtbl.cursor = 0 end
end

function mv_menu.pgnprevious(player,key)
    mv_menu.players[player:GetSteamID()].cursor = mv_menu.players[player:GetSteamID()].cursor - 7
    AddSchedule("openmenu" .. tostring(RandomInt(1,9999)), 0.1, function() mv_menu.ShowToPlayer(player, key) end)
end

function mv_menu.pgnnext(player,key)
    mv_menu.players[player:GetSteamID()].cursor = mv_menu.players[player:GetSteamID()].cursor + 7
    AddSchedule("openmenu" .. tostring(RandomInt(1,9999)), 0.1, function() mv_menu.ShowToPlayer(player, key) end)
end

function dummy() end

function mv_menu.ShowToPlayer(player, key, title)
    if mv_menu.players[player:GetSteamID()] == nil then mv_menu.players[player:GetSteamID()] = {cursor = 0} end
    local entry = mv_menu.entries[key]
    local count = 0
    local cursor = mv_menu.players[player:GetSteamID()].cursor
    local pgn = (#entry.options > 10) -- pagination
    DestroyMenu(key)
    CreateMenu(key, (title and title or entry.title))
    for i = cursor+1, #entry.options do
        local e = entry.options[i]
        count = count + 1
        if (pgn and count > 7) then break; end
        if (count == 10) then count = 0 end
        AddMenuOption(key, count, e.name)
    end
    if (pgn) then
        if (cursor ~= 0) then AddMenuOption(key, 8, "Previous") end
        if (#entry.options - cursor > 7) then AddMenuOption(key, 9, "Next") end
        AddMenuOption(key, 0, "Quit")
    end
    ShowMenuToPlayer(player, key)
end

function mv_menu.makemenu(key, title)
    if mv_menu.entries[key] then return false; end
    mv_menu.entries[key] = {title = title, options = {}}
end

function mv_menu.register(key, option, func)
    if type(func) ~= "function" then return false; end
    if not mv_menu.entries[key] then return false; end
    local entry = mv_menu.entries[key]
    table.insert(entry.options, {name = option, func = func})
end
