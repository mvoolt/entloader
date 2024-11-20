IncludeScript("base_teamplay")
IncludeScript("base_ctf") -- we'll need team CTF flags

entcap = info_ff_script:new({
	model = "models/props_c17/substation_stripebox01a.mdl",
	invisible = true,
	health = 100,
	armor = 300,
	grenades = 200,
	shells = 200,
	nails = 200,
	rockets = 200,
	cells = 200,
	detpacks = 1,
	mancannons = 1,
	gren1 = 4,
	gren2 = 4,
	item = "",
	team = 0,
	jetpackfuelpct = 100,
	teampoints = function(cap, team) return POINTS_PER_CAPTURE end,
	fortpoints = function(cap, player) return FORTPOINTS_PER_CAPTURE end,
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function entcap:spawn()
	-- make it invisible
	if (self.invisible) then
		entity:SetRenderFx(RenderFx.kFadeFast)
		entity:SetRenderMode(6) -- RENDERMODE_ENVIROMENTAL
	end
	info_ff_script.spawn(self)
end

function entcap:touch(touch_entity)
   if IsPlayer(touch_entity) then
        local player = CastToPlayer(touch_entity)
        local team = player:GetTeam()
        if team:GetTeamId() ~= self.team then return false end

        for i,v in ipairs( self.item ) do
            local flag = GetInfoScriptByName(v)
            -- check if the player is carrying the flag
            if flag and player:HasItem(flag:GetName()) then
                flag.status = 0
                local fortpoints = (type(self.fortpoints) == "function" and self.fortpoints(self, player) or self.fortpoints)
                player:AddFortPoints(fortpoints, "#FF_FORTPOINTS_CAPTUREFLAG")

                local teampoints = (type(self.teampoints) == "function" and self.teampoints(self, team) or self.teampoints)
                team:AddScore(teampoints)

                LogLuaEvent(player:GetId(), 0, "flag_capture","flag_name",flag:GetName())
                ObjectiveNotice( player, "captured the flag" )
                UpdateObjectiveIcon( player, nil )
                RemoveHudItem( player, flag:GetName() )
                -- return the flag
                flag:Return()

                player:RemoveEffect(EF.kOnfire)
                player:RemoveEffect(EF.kConc)
                player:RemoveEffect(EF.kGas)
                player:RemoveEffect(EF.kInfect)
                player:RemoveEffect(EF.kRadiotag)
                player:RemoveEffect(EF.kTranq)
                player:RemoveEffect(EF.kLegshot)
                player:RemoveEffect(EF.kRadiotag)

                if self.health         then player:AddHealth(self.health)                     end
                if self.armor          then player:AddArmor(self.armor)                       end
                if self.nails          then player:AddAmmo(Ammo.kNails,     self.nails)       end
                if self.shells         then player:AddAmmo(Ammo.kShells,    self.shells)      end
                if self.rockets        then player:AddAmmo(Ammo.kRockets,   self.rockets)     end
                if self.cells          then player:AddAmmo(Ammo.kCells,     self.cells)       end
                if self.detpacks       then player:AddAmmo(Ammo.kDetpack,   self.detpacks)    end
                if self.mancannons     then player:AddAmmo(Ammo.kManCannon, self.mancannons)  end
                if self.gren1          then player:AddAmmo(Ammo.kGren1,     self.gren1)       end
                if self.gren2          then player:AddAmmo(Ammo.kGren2,     self.gren2)       end
                if self.jetpackfuelpct then player:SetJetpackFuelPercent(self.jetpackfuelpct) end

                self:oncapture( player, v )
            end
        end
    end
end

function entcap:oncapture(player, item)
	-- let the teams know that a capture occured
	SmartSound(player, "yourteam.flagcap", "yourteam.flagcap", "otherteam.flagcap")
	SmartSpeak(player, "CTF_YOUCAP", "CTF_TEAMCAP", "CTF_THEYCAP")
	SmartMessage(player, "#FF_YOUCAP", "#FF_TEAMCAP", "#FF_OTHERTEAMCAP", Color.kGreen, Color.kGreen, Color.kRed)
end

red_entcap    = entcap:new({team = Team.kRed,
                            item = {"blue_flag","yellow_flag","green_flag"}})
blue_entcap   = entcap:new({team = Team.kBlue,
                            item = {"red_flag","yellow_flag","green_flag"}})
yellow_entcap = entcap:new({team = Team.kYellow,
                            item = {"blue_flag","red_flag","green_flag"}})
green_entcap  = entcap:new({team = Team.kGreen,
                            item = {"blue_flag","red_flag","yellow_flag"}})


agnosticallowedmethod = function(_,player) return player:GetTeamId() ~= Team.kSpectator end
global = { validspawn = agnosticallowedmethod }
marine = { validspawn = agnosticallowedmethod } -- Currently global spawns for both marine and hidden in hdn_ maps till we have a Hidden gamemode in FF
hidden = { validspawn = agnosticallowedmethod }

function baseflag:touch( touch_entity ) -- overridden to update objective marker to correct entity as we're not spawning {team}_cap but rather {team}_entcap
	local player = CastToPlayer( touch_entity )
	-- pickup if they can
	if self.notouch[player:GetId()] then return; end

	if player:GetTeamId() ~= self.team then
		-- let the teams know that the flag was picked up
		SmartSound(player, "yourteam.flagstolen", "yourteam.flags`tolen", "otherteam.flagstolen")
		RandomFlagTouchSpeak( player )
		SmartMessage(player, "#FF_YOUPICKUP", "#FF_TEAMPICKUP", "#FF_OTHERTEAMPICKUP", Color.kGreen, Color.kGreen, Color.kRed)

		-- if the player is a spy, then force him to lose his disguise
		player:SetDisguisable( false )
		-- if the player is a spy, then force him to lose his cloak
		player:SetCloakable( false )

		-- note: this seems a bit backwards (Pickup verb fits Player better)
		local flag = CastToInfoScript(entity)
		flag:Pickup(player)
		AddHudIcon( player, self.hudicon, flag:GetName(), self.hudx, self.hudy, self.hudwidth, self.hudheight, self.hudalign )

		-- show on the deathnotice board
		--ObjectiveNotice( player, "grabbed the flag" )
		-- log action in stats
		LogLuaEvent(player:GetId(), 0, "flag_touch", "flag_name", flag:GetName(), "player_origin", (string.format("%0.2f",player:GetOrigin().x) .. ", " .. string.format("%0.2f",player:GetOrigin().y) .. ", " .. string.format("%0.1f",player:GetOrigin().z) ), "player_health", "" .. player:GetHealth());

		local team = nil
		-- get team as a lowercase string
		if player:GetTeamId() == Team.kBlue then team = "blue" end
		if player:GetTeamId() == Team.kRed then team = "red" end
		if player:GetTeamId() == Team.kGreen then team = "green" end
		if player:GetTeamId() == Team.kYellow then team = "yellow" end

		-- objective icon pointing to the cap
		UpdateObjectiveIcon( player, GetEntityByName( team.."_entcap" ) )

		-- 100 points for initial touch on flag
		if self.status == 0 then player:AddFortPoints(FORTPOINTS_PER_INITIALTOUCH, "#FF_FORTPOINTS_INITIALTOUCH") end
		self.status = 1
		self.carriedby = player:GetName()
		self:refreshStatusIcons(flag:GetName())

	end
end

upjet = info_ff_script:new({
	model = "models/editor/scriptedsequence.mdl",
	invisible = true,
	velocity = Vector(0,0,800),
	notouch = {},
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function upjet:touch(player)
	local player = CastToPlayer(player)
	local startvel = player:GetVelocity()
	local player_id = player:GetSteamID()
	if startvel.z < -20 then
		self.notouch[player_id] = true
		AddSchedule(entity:GetName() .. "-" .. player_id, 1.2, function()
			self.notouch[player_id] = nil
		end)
		return;
	end
	if self.notouch[player_id] then return; end
	self.notouch[player_id] = true

	AddSchedule(entity:GetName() .. "-" .. player_id, 2, function()
		self.notouch[player_id] = nil
	end)
	AddSchedule("wait" .. tostring(RandomInt(1,9999)), 0.1, function()
		player:Teleport(copyvector(player:GetOrigin()) + Vector(0,0,10), player:GetAngles(), copyvector(startvel) + copyvector(self.velocity))
	end)
end

function upjet:spawn()
	-- make it invisible
	if (self.invisible) then
		entity:SetRenderFx(RenderFx.kFadeFast)
		entity:SetRenderMode(6) -- RENDERMODE_ENVIROMENTAL
	end
	info_ff_script.spawn(self)
end

