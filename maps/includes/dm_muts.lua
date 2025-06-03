mvdm.register("tdm")
mvdm.hook(function(player)
	local player = CastToPlayer(player)
	player:AddHealth(400)
	player:AddArmor(400)

	player:AddAmmo(Ammo.kNails,   400)
	player:AddAmmo(Ammo.kShells,  400)
	player:AddAmmo(Ammo.kRockets, 400)
	player:AddAmmo(Ammo.kCells,   400)
	player:AddAmmo(Ammo.kDetpack,   1)
	player:AddAmmo(Ammo.kManCannon, 1)
	player:AddAmmo(Ammo.kGren1,		4)
	player:AddAmmo(Ammo.kGren2,		4)
	if player:GetClass() == Player.kCivilian then
		player:GiveWeapon("ff_weapon_tommygun", true)
	end
end, "tdm", SPAWN)
mvdm.hook(function(player, damageinfo)
	-- suicides have no damageinfo
	if damageinfo ~= nil then
		local killer = damageinfo:GetAttacker()

		local player = CastToPlayer(player)
		if IsPlayer(killer) then
			killer = CastToPlayer(killer)
			--local victim = GetPlayer(player_id)

			if not (player:GetTeamId() == killer:GetTeamId()) then
				local killersTeam = killer:GetTeam()
				killersTeam:AddScore(1)
			end
		end
	end
end, "tdm", KILLED)
----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------
mvdm.register("dpm")
mvdm.hook(function(player)
	local player = CastToPlayer(player)

	player:AddHealth( 400 )
	--player:AddArmor( 400 )
	player:RemoveArmor( 400 )
	--removes armor to make pelletgun fighting bearable, if you want armor, comment this and uncomment the positive AddArmor function


	player:RemoveAllWeapons()
	player:GiveWeapon("ff_weapon_crowbar", true) -- LB:GOTY edit
	player:GiveWeapon("ff_weapon_deploydetpack", true)
	player:GiveWeapon("ff_weapon_shotgun", true)
	-- strips player off all weapons and gives detpack and pellet gun

	--player:RemoveAmmo( Ammo.kGren1, 4 )
	player:RemoveAmmo( Ammo.kGren2, 4 )
	-- removes all grenades upon spawning
	--player spawns with primary nades at the moment, uncomment both player functions if you dont want to have nades

end, "dpm", SPAWN, ORDER_FIRST)
mvdm.hook(function (_, damageinfo)
  local weapon = damageinfo:GetInflictor():GetClassName()

  if weapon == "ff_grenade_normal" then damageinfo:SetDamage( 40 ) end
  if weapon == "ff_weapon_shotgun" then damageinfo:ScaleDamage( 0.5 ) end
end, "dpm", ONDAMAGE, ORDER_FIRST)

