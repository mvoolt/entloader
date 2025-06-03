-- ENUMS
INIT = 0 -- to be used for i.e. class selection
SPAWN = 1
KILLED = 2
ONDAMAGE = 3
ONUSE = 4
ORDER_FIRST = 10
ORDER_LAST = 12
ORDER_ANY = 13

mvdm = {
	chains = {
		[INIT] = {},
		[SPAWN] = {},
		[KILLED] = {},
		[ONDAMAGE] = {},
		[ONUSE] = {}
	},
	mutators = {}
}

function mvdm.register(mut)
	if mvdm.mutators[mut] ~= nil then return; end
	mvdm.mutators[mut] = {callback = {}}
end

function mvdm.hook(func,mut,cb,order)
	if type(func) ~= "function" then return; end
	if type(mvdm.mutators[mut]) ~= "table" then return; end
	if order == nil then order = ORDER_ANY end
	mvdm.mutators[mut].callback[cb] = {order = order, func = func}
end

function mvdm.createchain()
	for cb,chain in pairs(mvdm.chains) do
		mvdm.chains[cb] = {}
	end
	for cb,chain in pairs(mvdm.chains) do
		for _,mut in ipairs(mvdm.enabled_muts) do
			local callback = mvdm.mutators[mut].callback[cb]
			if callback then
			if callback.order == ORDER_FIRST then
				table.insert(chain, callback.func)
			elseif callback.order == ORDER_LAST then
				table.insert(chain, 1, callback.func)
			else
				table.insert(chain, math.ceil(#mvdm.enabled_muts / 2), callback.func)
			end
			end
		end
	end
end

-- master
function mvdm.spawn(player)
	for _,cb in ipairs(mvdm.chains[SPAWN]) do
		cb(player)
	end
end
function mvdm.killed(player, damageinfo)
	for _,cb in ipairs(mvdm.chains[KILLED]) do
		cb(player, damageinfo)
	end
end
function mvdm.ondamage(player,damageinfo)
	for _,cb in ipairs(mvdm.chains[ONDAMAGE]) do
		cb(player, damageinfo)
	end
end

-- default
IncludeScript("dm_muts")
mvdm.enabled_muts = {"tdm"}
