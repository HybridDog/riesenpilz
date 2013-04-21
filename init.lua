---------------------------------------------------riesenpilz 12.12--------------------------------------------------
--Textures (edited with gimp) from gamiano.de and minecraft

local MAX_SIZE = 3



--Growing Functions


local function hybridpilz(pos)
	local random = math.random(MAX_SIZE)
	local height = 2 + random
	local breite = random
	local br = breite+1

	for i = 0, height, 1 do
		minetest.env:add_node({x=pos.x, y=pos.y+i, z=pos.z}, {name="riesenpilz:stem"})
	end

	for j = -br, br, 1 do
		for k = -br, br, 1 do
			local o = {x=pos.x+j, y=pos.y+height, z=pos.z+k}
	  		if	k == br
	  		or	k == -br
	  		or	j == br
	  		or	j == -br	then
				minetest.env:add_node(o, {name="riesenpilz:head_red"})
			else
				minetest.env:add_node(o, {name="riesenpilz:lamellas"})
			end
		end
	end

	for l = -breite, breite, 1 do
		for m = -breite, breite, 1 do
			minetest.env:add_node({x=pos.x+l, y=pos.y+height+1, z=pos.z+m}, {name="riesenpilz:head_red"})
		end
	end
end


local function brauner_minecraftpilz(pos)
	local random = math.random(MAX_SIZE-1)
	local height = 3+random
	local breite = 2+random

	for i = 0, height, 1 do
		minetest.env:add_node({x=pos.x, y=pos.y+i, z=pos.z}, {name="riesenpilz:stem"})
	end

	for j = -breite, breite, 1 do
		for k = -(breite-1), breite-1, 1 do
			minetest.env:add_node({x=pos.x+j, y=pos.y+height+1, z=pos.z+k}, {name="riesenpilz:head_brown"})
			minetest.env:add_node({x=pos.x+k, y=pos.y+height+1, z=pos.z+j}, {name="riesenpilz:head_brown"})
		end
	end
end


local function minecraft_fliegenpilz(pos)
	local height = 3

	for i = 0, height, 1 do
		minetest.env:add_node({x=pos.x, y=pos.y+i, z=pos.z}, {name="riesenpilz:stem"})
	end

	for j = -1, 1, 1 do
		for k = -1, 1, 1 do
			minetest.env:add_node({x=pos.x+j, y=pos.y+height+1, z=pos.z+k}, {name="riesenpilz:head_red"})
		end
		for l = 1, height, 1 do
			minetest.env:set_node({x=pos.x+j, y=pos.y+l, z=pos.z+2}, {name="riesenpilz:head_red_side", param2=0})
			minetest.env:set_node({x=pos.x+j, y=pos.y+l, z=pos.z-2}, {name="riesenpilz:head_red_side", param2=2})
			minetest.env:set_node({x=pos.x+2, y=pos.y+l, z=pos.z+j}, {name="riesenpilz:head_red_side", param2=1})
			minetest.env:set_node({x=pos.x-2, y=pos.y+l, z=pos.z+j}, {name="riesenpilz:head_red_side", param2=3})
		end
	end
end


local function add_head_lavashroom(pos, ran)
	local head = "wool:orange"
	if math.random(ran) == 1 then
		head = "wool:yellow"
	else
		head = "wool:orange"
	end
	minetest.env:add_node(pos, {name=head})
end

local function lavashroom(pos)
	local height = 3+math.random(MAX_SIZE-2)
	minetest.env:remove_node(pos)	

	for i = 0, height, 1 do
		for k = -1, 1, 2 do
			minetest.env:add_node({x=pos.x+k, y=pos.y+i, z=pos.z}, {name="wool:brown"})
			minetest.env:add_node({x=pos.x, y=pos.y+i, z=pos.z+k}, {name="wool:brown"})
		end
	end

	for k = -3, 3, 1 do
		for l = -3, 3, 1 do
			if ( k <= 1 and k >= -1 )
			or( l <= 1 and l >= -1 ) then
				minetest.env:add_node({x=pos.x+k, y=pos.y+height+2, z=pos.z+l}, {name="wool:brown"})
			else
				add_head_lavashroom({x=pos.x+k, y=pos.y+height+2, z=pos.z+l}, 7)
			end
		end
	end

	for k = -2, 2, 1 do
		for l = -2, 2, 1 do
			minetest.env:add_node({x=pos.x+k, y=pos.y+height+1, z=pos.z+l}, {name="wool:brown"})
		end
	end

	for j = 0, 1, 1 do
		for k = -4, 4, 1 do
			for l = -4, 4, 1 do
				add_head_lavashroom({x=pos.x+k, y=pos.y+height+3+j, z=pos.z+l}, 6)
			end
		end
	end

	for k = -3, 3, 1 do
		for l = -3, 3, 1 do
			add_head_lavashroom({x=pos.x+k, y=pos.y+height+5, z=pos.z+l}, 5)
		end
	end

	for k = -2, 2, 1 do
		for l = -2, 2, 1 do
			add_head_lavashroom({x=pos.x+k, y=pos.y+height+6, z=pos.z+l}, 4)
		end
	end
end



--Mushroom Nodes


local function pilz(name, desc, box)
minetest.register_node("riesenpilz:"..name, {
	description = desc,
	tile_images = {"riesenpilz_"..name.."_top.png", "riesenpilz_"..name.."_bottom.png", "riesenpilz_"..name.."_side.png"},
	inventory_image = "riesenpilz_"..name.."_side.png",
	walkable = false,
	drawtype = "nodebox",
	paramtype = "light",
	groups = {snappy=3,flammable=2},
	sounds =  default.node_sound_leaves_defaults(),
	node_box = box,
	selection_box = box,
})
end

local BOX_RED = {
	type = "fixed",
	fixed = {
		{-1/16, -8/16, -1/16, 1/16, -6/16, 1/16},
		{-3/16, -6/16, -3/16, 3/16, -5/16, 3/16},
		{-4/16, -5/16, -4/16, 4/16, -4/16, 4/16},
		{-3/16, -4/16, -3/16, 3/16, -3/16, 3/16},
		{-2/16, -3/16, -2/16, 2/16, -2/16, 2/16},
	},
}

local BOX_BROWN = {
	type = "fixed",
	fixed = {
		{-0.15, -0.2, -0.15, 0.15, -0.1, 0.15},
		{-0.2, -0.3, -0.2, 0.2, -0.2, 0.2},
		{-0.05, -0.5, -0.05, 0.05, -0.3, 0.05}
	},
}

local BOX_FLY_AGARIC = {
	type = "fixed",
	fixed = {
		{-0.05, -0.5, -0.05, 0.05, 1/20, 0.05},
		{-3/20, -6/20, -3/20, 3/20, 0, 3/20},
		{-4/20, -2/20, -4/20, 4/20, -4/20, 4/20},
	},
}

local BOX_LAVASHROOM = {
	type = "fixed",
	fixed = {
		{-1/16, -8/16, -1/16, 1/16, -6/16, 1/16},
		{-2/16, -6/16, -2/16, 2/16,     0, 2/16},
		{-3/16, -5/16, -3/16, 3/16, -1/16, 3/16},
		{-4/16, -4/16, -4/16, 4/16, -2/16, 4/16},
	},
}

local BOX_GLOWSHROOM = {
	type = "fixed",
	fixed = {
		{-1/16, -8/16, -1/16, 1/16, -1/16, 1/16},
		{-2/16, -3/16, -2/16, 2/16, -2/16, 2/16},
		{-3/16, -5/16, -3/16, 3/16, -3/16, 3/16},
		{-3/16, -7/16, -3/16, -2/16, -5/16, -2/16},
		{3/16, -7/16, -3/16, 2/16, -5/16, -2/16},
		{-3/16, -7/16, 3/16, -2/16, -5/16, 2/16},
		{3/16, -7/16, 3/16, 2/16, -5/16, 2/16},
	},
}

pilz("brown", "Brown Mushroom", BOX_BROWN)
pilz("red", "Red Mushroom", BOX_RED)
pilz("fly_agaric", "Fly Agaric", BOX_FLY_AGARIC)
pilz("lavashroom", "Lavashroom", BOX_LAVASHROOM)
pilz("glowshroom", "Glowshroom", BOX_GLOWSHROOM)



--Mushroom Blocks


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

pilznode("stem", "Giant Mushroom Stem", {"riesenpilz_stem_top.png","riesenpilz_stem_top.png","riesenpilz_stem.png"}, "stem")
pilznode("lamellas", "Giant Mushroom Lamella", {"riesenpilz_lamellas.png"}, "lamellas")
pilznode("head_red", "Giant Mushroom Head Red", {"riesenpilz_head.png", "riesenpilz_lamellas.png", "riesenpilz_head.png"}, "red")
pilznode("head_brown", "Giant Mushroom Head Brown", {"riesenpilz_brown_top.png","riesenpilz_lamellas.png","riesenpilz_brown_top.png"}, "brown")

minetest.register_node("riesenpilz:head_red_side", {
	description = "Giant Mushroom Head Side",
	tile_images = {"riesenpilz_head.png",	"riesenpilz_lamellas.png",	"riesenpilz_head.png",
					"riesenpilz_head.png",	"riesenpilz_head.png",	"riesenpilz_lamellas.png"},
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3},
	drop = {max_items = 1,
		items = {{items = {"riesenpilz:fly_agaric"},rarity = 20,},
				{items = {"riesenpilz:head_red"},rarity = 1,}}},
})



--Growing


minetest.register_tool("riesenpilz:growingtool", {
	description = "Growingtool",
	inventory_image = "riesenpilz_growingtool.png",
})

minetest.register_on_punchnode(function(pos, node, puncher)
	if puncher:get_wielded_item():get_name() == "riesenpilz:growingtool" then
		if minetest.env:get_node(pos).name == "riesenpilz:red" then
			hybridpilz(pos)
		elseif minetest.env:get_node(pos).name == "riesenpilz:fly_agaric" then
			minecraft_fliegenpilz(pos)
		elseif minetest.env:get_node(pos).name == "riesenpilz:brown" then
			brauner_minecraftpilz(pos)
		elseif minetest.env:get_node(pos).name == "riesenpilz:lavashroom" then
			lavashroom(pos)
		end
	end
end)
