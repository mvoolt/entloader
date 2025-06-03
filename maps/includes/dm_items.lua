IncludeScript("base_teamplay")
-- Base entities
weapon_pickup = info_ff_script:new({
	model = "models/weapons/crowbar/w_crowbar.mdl",
	touchsound = "Item.Materialize",
	spawnsound = "Backpack.Touch",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function weapon_pickup:dropatspawn() return false end

function weapon_pickup:precache()
	PrecacheSound(self.touchsound)
	PrecacheSound(self.spawnsound)
	PrecacheModel(self.model)
end

function weapon_pickup:touch(player)
	local player = CastToPlayer(player)
	local item = CastToInfoScript(entity)
	local weaponname = ""

    if self.weapon then
        weaponname = self.weapon
    else
        weaponname = item:GetName()
    end

	player:GiveWeapon(weaponname, false)

	--if WEAPONSTAY then
		item:Respawn(5)
	--end
end

-- HL2: Deathmatch ammo types
item_ammo_crate = bigpack:new({model = "models/items/item_item_crate.mdl"})
item_ammo_357 = genericbackpack:new({ -- HL2 magnum
    model = "models/items/357ammo.mdl",
    shells = 35
})
item_ammo_357_large = genericbackpack:new({
    model = "models/items/357ammobox.mdl",
    shells = 80
})
item_ammo_ar2 = genericbackpack:new({
    model = "models/items/BoxBRounds.mdl",
    cells = 35
})
item_ammo_ar2_altfire = genericbackpack:new({
    model = "models/items/combine_rifle_ammo01.mdl",
    gren2 = 1
})
item_ammo_ar2_large = genericbackpack:new({
    model = "models/items/LargeBoxBRounds.mdl",
    cells = 80
})
item_ammo_crossbow = genericbackpack:new({
    model = "models/items/CrossbowRounds.mdl",
    rockets = 10
})
item_ammo_pistol = genericbackpack:new({
    model = "models/items/boxsrounds.mdl",
    nails = 45
})
item_ammo_pistol_large = genericbackpack:new({
    model = "models/items/largeBoxSRounds.mdl",
    nails = 90
})
item_ammo_smg1 = genericbackpack:new({
    model = "models/items/BoxMRounds.mdl",
    shells = 30
})
item_ammo_smg1_grenade = genericbackpack:new({
    model = "models/items/AR2_Grenade.mdl",
    gren1 = 1
})
item_ar2_grenade = item_ammo_smg1_grenade:new({})
item_ammo_smg1_large = genericbackpack:new({
    model = "models/items/LargeBoxMRounds.mdl",
    shells = 90
})
item_box_buckshot = genericbackpack:new({ -- HL2 shotgun
    model = "models/items/BoxBuckshot.mdl",
    shells = 100
})
item_rpg_round = genericbackpack:new({
    model = "models/weapons/w_missile_closed.mdl",
    rockets = 20
})
item_battery = genericbackpack:new({
    model = "models/items/battery.mdl",
    armor = 25
})
item_healthkit = genericbackpack:new({
    model = "models/items/healthkit.mdl",
    health = 25
})
item_healthvial = genericbackpack:new({
    model = "models/healthvial.mdl",
    health = 10
})
weapon_frag = genericbackpack:new({
    model = "models/weapons/w_grenade.mdl",
    gren1 = 2,
    gren2 = 1
})
-- Fortress Forever weapons
ff_weapon_assaultcannon   = weapon_pickup:new({model = "models/weapons/assaultcannon/w_assaultcannon.mdl"})
ff_weapon_autorifle       = weapon_pickup:new({model = "models/weapons/autorifle/w_autorifle.mdl"})
ff_weapon_flamethrower    = weapon_pickup:new({model = "models/weapons/flamethrower/w_flamethrower.mdl"})
ff_weapon_grenadelauncher = weapon_pickup:new({model = "models/weapons/grenadelauncher/w_grenadelauncher.mdl"})
ff_weapon_ic              = weapon_pickup:new({model = "models/weapons/incendiarycannon/w_incendiarycannon.mdl"})
ff_weapon_jumpgun         = weapon_pickup:new({model = "models/weapons/railgun/w_railgun.mdl"})
ff_weapon_nailgun         = weapon_pickup:new({model = "models/weapons/nailgun/w_nailgun.mdl"})
ff_weapon_pipelauncher    = weapon_pickup:new({model = "models/weapons/pipelauncher/w_pipelauncher.mdl"})
ff_weapon_railgun         = weapon_pickup:new({model = "models/weapons/railgun/w_railgun.mdl"})
ff_weapon_rpg             = weapon_pickup:new({model = "models/weapons/rpg/w_rpg.mdl"})
ff_weapon_shotgun         = weapon_pickup:new({model = "models/weapons/shotgun/w_shotgun.mdl"})
ff_weapon_sniperrifle     = weapon_pickup:new({model = "models/weapons/sniperrifle/w_sniperrifle.mdl"})
ff_weapon_supernailgun    = weapon_pickup:new({model = "models/weapons/supernailgun/w_supernailgun.mdl"})
ff_weapon_supershotgun    = weapon_pickup:new({model = "models/weapons/supershotgun/w_supershotgun.mdl"})
ff_weapon_tommygun        = weapon_pickup:new({model = "models/weapons/tommygun/w_tommygun.mdl"})
ff_weapon_tranq           = weapon_pickup:new({model = "models/weapons/tranq/w_tranq.mdl"})
