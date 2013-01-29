---------------------------------------------------riesenpilz 12.12--------------------------------------------------
--Textures (edited with gimp) from gamiano.de and minecraft

local MAX_SIZE = 3
local TIMT = 10


--Growing Functions

local function hybridpilz(pos)
	local random = math.random(MAX_SIZE)
	local height = 2 + random
	local breite = random
	local br = breite+1

	for i = height, 0, -1 do
		local p = {x=pos.x, y=pos.y+i, z=pos.z}
		minetest.env:add_node(p, {name="riesenpilz:stamm"})
	end

	for j = -br, br, 1 do
		for k = -br, br, 1 do
			local o = {x=pos.x+j, y=pos.y+height, z=pos.z+k}
	  		if	k == br
	  		or	k == -br
	  		or	j == br
	  		or	j == -br	then
				minetest.env:add_node(o, {name="riesenpilz:kappe"})
			else
				minetest.env:add_node(o, {name="riesenpilz:lamellen"})
			end
		end
	end

	for l = -breite, breite, 1 do
		for m = -breite, breite, 1 do
			local n = {x=pos.x+l, y=pos.y+height+1, z=pos.z+m}
			minetest.env:add_node(n, {name="riesenpilz:kappe"})
		end
	end
end

local function brauner_minecraftpilz(pos)
	local random = math.random(MAX_SIZE-1)
	local height = 3+random
	local breite = 2+random

	for i = height, 0, -1 do
		local p = {x=pos.x, y=pos.y+i, z=pos.z}
		minetest.env:add_node(p, {name="riesenpilz:stamm"})
	end

	for j = -breite, breite, 1 do
		for k = -(breite-1), breite-1, 1 do
			minetest.env:add_node({x=pos.x+j, y=pos.y+height+1, z=pos.z+k}, {name="riesenpilz:kappe2"})
			minetest.env:add_node({x=pos.x+k, y=pos.y+height+1, z=pos.z+j}, {name="riesenpilz:kappe2"})
		end
	end
end

local function minecraft_fliegenpilz(pos)
	local height = 3

	for i = height, 0, -1 do
		local p = {x=pos.x, y=pos.y+i, z=pos.z}
		minetest.env:add_node(p, {name="riesenpilz:stamm"})
	end

	for j = -1, 1, 1 do
		for k = -1, 1, 1 do
			minetest.env:add_node({x=pos.x+j, y=pos.y+height+1, z=pos.z+k}, {name="riesenpilz:kappe"})
		end
		for l = 1, height, 1 do
			minetest.env:set_node({x=pos.x+j, y=pos.y+l, z=pos.z+2}, {name="riesenpilz:kappe3", param2=0})
			minetest.env:set_node({x=pos.x+j, y=pos.y+l, z=pos.z-2}, {name="riesenpilz:kappe3", param2=2})
			minetest.env:set_node({x=pos.x+2, y=pos.y+l, z=pos.z+j}, {name="riesenpilz:kappe3", param2=1})
			minetest.env:set_node({x=pos.x-2, y=pos.y+l, z=pos.z+j}, {name="riesenpilz:kappe3", param2=3})
		end
	end
end


--Nodes

local function pilzsapling(name, desc, texture)
minetest.register_node("riesenpilz:sapling_"..name, {
	description = desc,
	tile_images = {texture..".png"},
	inventory_image = texture..".png",
	walkable = false,
	paramtype = "light",
	drawtype = "plantlike",
	groups = { snappy = 3 },
	sounds =  default.node_sound_leaves_defaults(),
})
end

pilzsapling("mc_fliegenpilz", "Giant Minecraft Mushroom Red", "pilzsapling2")
pilzsapling("mc_braun", "Giant Minecraft Mushroom Brown", "pilzsapling3")

local MUSHH = {
		type = "fixed",
		fixed = {
			{-1/16, -8/16, -1/16, 1/16, -6/16, 1/16},
			{-3/16, -6/16, -3/16, 3/16, -5/16, 3/16},
			{-4/16, -5/16, -4/16, 4/16, -4/16, 4/16},
			{-3/16, -4/16, -3/16, 3/16, -3/16, 3/16},
			{-2/16, -3/16, -2/16, 2/16, -2/16, 2/16},
		},
	}

minetest.register_node("riesenpilz:sapling_hybrid", {
	description = "Giant Mushroom",
	tile_images = {"pilzsapling_t.png", "pilzsapling_t.png^pilzsapling_u.png", "pilzsapling.png"},
	inventory_image = "pilzsapling.png",
	walkable = false,
	paramtype = "light",
	drawtype = "nodebox",
	groups = { snappy = 3 },
	sounds =  default.node_sound_leaves_defaults(),
	node_box = MUSHH,
	selection_box = MUSHH,
})

local function pilznode(name, desc, textures, sapling)
minetest.register_node("riesenpilz:"..name, {
	description = desc,
	tile_images = textures,
	groups = {oddly_breakable_by_hand=3},
	drop = {max_items = 1,
		items = {{items = {"riesenpilz:"..sapling},rarity = 20,},
				{items = {"riesenpilz:"..name},rarity = 1,}}},
})
end

pilznode("stamm", "Giant Mushroom Stem", {"pilzstamm2.png","pilzstamm2.png","pilzstamm.png"}, "stamm")
pilznode("lamellen", "Giant Mushroom Lamella", {"pilzlamellen.png"}, "lamellen")
pilznode("kappe", "Giant Mushroom Head", {"pilzkappe.png", "pilzlamellen.png", "pilzkappe.png"}, "sapling_hybrid")
pilznode("kappe2", "Giant Mushroom Head Brown", {"pilzbraun.png","pilzlamellen.png","pilzbraun.png"}, "sapling_mc_braun")

minetest.register_node("riesenpilz:kappe3", {
	description = "Giant Mushroom Head Side",
	tile_images = {"pilzkappe.png", "pilzlamellen.png", "pilzkappe.png",
				   "pilzkappe.png",  "pilzkappe.png","pilzlamellen.png"},
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3},
	drop = {max_items = 1,
		items = {{items = {"riesenpilz:sapling_mc_fliegenpilz"},rarity = 20,},
				{items = {"riesenpilz:kappe"},rarity = 1,}}},
})


--Growing

minetest.register_abm({
	nodenames = {"riesenpilz:sapling_hybrid"},
	interval = TIMT,
	chance = TIMT,
	action = function(pos)
		hybridpilz(pos)
	end
})

minetest.register_abm({
	nodenames = {"riesenpilz:sapling_mc_fliegenpilz"},
	interval = TIMT,
	chance = TIMT,
	action = function(pos)
		minecraft_fliegenpilz(pos)
	end
})

minetest.register_abm({
	nodenames = {"riesenpilz:sapling_mc_braun"},
	interval = TIMT,
	chance = TIMT,
	action = function(pos)
		brauner_minecraftpilz(pos)
	end
})
