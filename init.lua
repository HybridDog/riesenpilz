---------------------------------------------------riesenpilz 12.12--------------------------------------------------
--Textures (edited with gimp) from gamiano.de and minecraft

local MAX_SIZE = 3



--Growing Functions


function riesenpilz_hybridpilz(pos)
	local breite = math.random(MAX_SIZE)
	local br = breite+1
	local height = breite+2
	local head = "riesenpilz:head_red"

	for i = 0, height, 1 do
		minetest.env:add_node({x=pos.x, y=pos.y+i, z=pos.z}, {name="riesenpilz:stem"})
	end

	for l = -br+1, br, 1 do
		for k = -1, 1, 2 do
			minetest.env:add_node({x=pos.x+br*k, y=pos.y+height, z=pos.z-l*k}, {name=head})
			minetest.env:add_node({x=pos.x+l*k, y=pos.y+height, z=pos.z+br*k}, {name=head})
		end
	end

	for k = -breite, breite, 1 do
		for l = -breite, breite, 1 do
			minetest.env:add_node({x=pos.x+l, y=pos.y+height+1, z=pos.z+k}, {name=head})
			minetest.env:add_node({x=pos.x+l, y=pos.y+height,	z=pos.z+k}, {name="riesenpilz:lamellas"})
		end
	end
end


function riesenpilz_brauner_minecraftpilz(pos)
	local head = "riesenpilz:head_brown"
	local random = math.random(MAX_SIZE-1)
	local br	 = random+1
	local breite = br+1
	local height = br+2

	for i = 0, height, 1 do
		minetest.env:add_node({x=pos.x, y=pos.y+i, z=pos.z}, {name="riesenpilz:stem"})
	end

	for l = -br, br, 1 do
		for k = -breite, breite, breite*2 do
			minetest.env:add_node({x=pos.x+k, y=pos.y+height+1, z=pos.z+l}, {name=head})
			minetest.env:add_node({x=pos.x+l, y=pos.y+height+1, z=pos.z+k}, {name=head})
		end
		for k = -br, br, 1 do
			minetest.env:add_node({x=pos.x+l, y=pos.y+height+1, z=pos.z+k}, {name=head})
		end
	end
end


function riesenpilz_minecraft_fliegenpilz(pos)
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
	local head = "riesenpilz:head_orange"
	if math.random(ran) == 1 then
		head = "riesenpilz:head_yellow"
	else
		head = "riesenpilz:head_orange"
	end
	minetest.env:add_node(pos, {name=head})
end

function riesenpilz_lavashroom(pos)
	local stem = "riesenpilz:stem_brown"
	local brown = "riesenpilz:head_brown_full"
	local height = 3+math.random(MAX_SIZE-2)
	minetest.env:remove_node(pos)	

	for i = 0, height, 1 do
		for k = -1, 1, 2 do
			minetest.env:add_node({x=pos.x+k, y=pos.y+i, z=pos.z}, {name=stem})
			minetest.env:add_node({x=pos.x, y=pos.y+i, z=pos.z+k}, {name=stem})
		end
	end

	for k = -3, 3, 1 do
		for l = -3, 3, 1 do
			if ( k <= 1 and k >= -1 )
			or( l <= 1 and l >= -1 ) then
				if not ( k <= 1 and k >= -1 and l <= 1 and l >= -1 ) then
					minetest.env:add_node({x=pos.x+k, y=pos.y+height+2, z=pos.z+l}, {name=brown})
				end
			else
				add_head_lavashroom({x=pos.x+k, y=pos.y+height+2, z=pos.z+l}, 7)
			end
		end
	end

	for l = -2, 2, 4 do
		for k = -1, 1, 1 do
			minetest.env:add_node({x=pos.x+k, y=pos.y+height+1, z=pos.z+l}, {name=brown})
			minetest.env:add_node({x=pos.x+l, y=pos.y+height+1, z=pos.z+k}, {name=brown})
		end
		for i = -2, 2, 4 do
			minetest.env:add_node({x=pos.x+i, y=pos.y+height+1, z=pos.z+l}, {name=brown})
		end
	end

	for k = -1, 1, 2 do
		for l = -1, 1, 2 do
			minetest.env:add_node({x=pos.x+k, y=pos.y+height+1, z=pos.z+l}, {name=brown})
		end
		for l = -3+1, 3, 1 do
			add_head_lavashroom({x=pos.x+3*k, y=pos.y+height+5, z=pos.z-l*k}, 5)
			add_head_lavashroom({x=pos.x+l*k, y=pos.y+height+5, z=pos.z+3*k}, 5)
		end
	end

--	add_top_lavashroom(pos,height+3,6,4)
--	add_top_lavashroom(pos,height+4,6,4)
--	round edges:
	for j = 0, 1, 1 do
		for k = -4, 4, 8 do
			for l = -3, 3, 1 do
				add_head_lavashroom({x=pos.x+k, y=pos.y+height+3+j, z=pos.z+l}, 6)
				add_head_lavashroom({x=pos.x+l, y=pos.y+height+3+j, z=pos.z+k}, 6)
			end
		end
	end

	for k = -2, 2, 1 do
		for l = -2, 2, 1 do
			add_head_lavashroom({x=pos.x+k, y=pos.y+height+6, z=pos.z+l}, 4)
		end
	end
end


function riesenpilz_glowshroom(pos)
	local stem = "riesenpilz:stem_blue"
	local height = 2+math.random(MAX_SIZE)
	local br = 2

	for i = 0, height, 1 do
		minetest.env:add_node({x=pos.x, y=pos.y+i, z=pos.z}, {name=stem})
	end

	for l = 1, height, 1 do

		local head = "riesenpilz:head_blue"
		if l == 1 then
			head = "riesenpilz:head_blue_bright"
		end

		for i = -br, br, 2*br do
			for k = -br, br, 2*br do
				minetest.env:add_node({x=pos.x+i, y=pos.y+l, z=pos.z+k}, {name=head})
			end
		end
	end

	local head = "riesenpilz:head_blue"

	for l = 0, br, 1 do
		for i = -br+l, br-l, 1 do
			for k = -br+l, br-l, 1 do
				minetest.env:add_node({x=pos.x+i, y=pos.y+height+1+l, z=pos.z+k}, {name=head})
			end
		end
	end

	local a = br
	local h = height
	for k = -1, 1, 2 do
		for l = -a+1, a, 1 do
			minetest.env:add_node({x=pos.x+a*k, y=pos.y+h, z=pos.z-l*k}, {name=head})
			minetest.env:add_node({x=pos.x+l*k, y=pos.y+h, z=pos.z+a*k}, {name=head})
		end
	end
end


function riesenpilz_apple(pos)
	local size = 5
	local a = size*2
	local b = size-1
	local red = "default:copperblock"
	local brown = "default:desert_stone"
	for l = -b, b, 1 do
		for j = 1, a-1, 1 do
			for k = -size, size, a do
				minetest.env:add_node({x=pos.x+k, y=pos.y+j, z=pos.z+l}, {name=red})
				minetest.env:add_node({x=pos.x+l, y=pos.y+j, z=pos.z+k}, {name=red})
			end
		end
		for i = -b, b, 1 do
			minetest.env:add_node({x=pos.x+i, y=pos.y, z=pos.z+l}, {name=red})
			minetest.env:add_node({x=pos.x+i, y=pos.y+a, z=pos.z+l}, {name=red})
		end
	end

	for i = a+1, a+b, 1 do
		minetest.env:add_node({x=pos.x, y=pos.y+i, z=pos.z}, {name="default:tree"})
	end

	local c = pos.y+1
	for i = -3,1,1 do
		minetest.env:add_node({x=pos.x+i, y=c, z=pos.z+1}, {name=brown})
	end
	for i = 0,1,1 do
		minetest.env:add_node({x=pos.x+1+i, y=c, z=pos.z-1-i}, {name=brown})
		minetest.env:add_node({x=pos.x+2+i, y=c, z=pos.z-1-i}, {name=brown})
	end
	minetest.env:add_node({x=pos.x+1, y=c, z=pos.z}, {name=brown})
	minetest.env:add_node({x=pos.x-3, y=c+1, z=pos.z+1}, {name=brown})
end



--3D apple [3apple]


minetest.register_node(":default:apple", {
	description = "Apple",
	drawtype = "nodebox",
	visual_scale = 1.0,
	tiles = {"3apple_apple_top.png","3apple_apple_bottom.png","3apple_apple.png"},
	inventory_image = "default_apple.png",
	paramtype = "light",
	sunlight_propagates = true,
	node_box = {
		type = "fixed",
		fixed = {
		{-3/16,	-7/16,	-3/16,	3/16,	1/16,	3/16},
		{-1/4,	-3/8,	-3/16,	1/4,	0,		3/16},
		{-3/16,	-3/8,	-1/4,	3/16,	0,		1/4},
		{0,		1/16,	-1/16,	1/16,	1/4,	0},
		{-1/16,	1/16,		0,	0,		1/4,	1/16},
		}
	},
	groups = {fleshy=3,dig_immediate=3,flammable=2},
	on_use = minetest.item_eat(4),
	sounds = default.node_sound_defaults(),
})



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
pilznode("stem_brown", "Giant Mushroom Stem Brown",
{"riesenpilz_stem_top.png","riesenpilz_stem_top.png","riesenpilz_stem_brown.png"}, "stem_brown")
pilznode("lamellas", "Giant Mushroom Lamella", {"riesenpilz_lamellas.png"}, "lamellas")
pilznode("head_red", "Giant Mushroom Head Red", {"riesenpilz_head.png", "riesenpilz_lamellas.png", "riesenpilz_head.png"}, "red")
pilznode("head_orange", "Giant Mushroom Head Red", {"riesenpilz_head_orange.png"}, "lavashroom")
pilznode("head_yellow", "Giant Mushroom Head Red", {"riesenpilz_head_yellow.png"}, "lavashroom")
pilznode("head_brown", "Giant Mushroom Head Brown",
{"riesenpilz_brown_top.png","riesenpilz_lamellas.png","riesenpilz_brown_top.png"}, "brown")
pilznode("head_brown_full", "Giant Mushroom Head Full Brown", {"riesenpilz_brown_top.png"},"brown")
pilznode("head_blue_bright", "Giant Mushroom Head Blue Bright", {"riesenpilz_head_blue_bright.png"},"glowshroom")
pilznode("head_blue", "Giant Mushroom Head Blue", {"riesenpilz_head_blue.png"},"glowshroom")
pilznode("stem_blue", "Giant Mushroom Stem Blue",
{"riesenpilz_stem_top.png","riesenpilz_stem_top.png","riesenpilz_stem_blue.png"}, "stem_blue")

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

minetest.register_node("riesenpilz:ground", {
	description = "Grass?",
	tile_images = {"riesenpilz_ground_top.png","default_dirt.png","default_dirt.png^riesenpilz_ground_side.png"},
	groups = {crumbly=3},
	sounds = default.node_sound_dirt_defaults(),
	drop = 'default:dirt'
})



--Growing


minetest.register_tool("riesenpilz:growingtool", {
	description = "Growingtool",
	inventory_image = "riesenpilz_growingtool.png",
})

minetest.register_on_punchnode(function(pos, node, puncher)
	if puncher:get_wielded_item():get_name() == "riesenpilz:growingtool" then
		if minetest.env:get_node(pos).name == "riesenpilz:red" then
			riesenpilz_hybridpilz(pos)
		elseif minetest.env:get_node(pos).name == "riesenpilz:fly_agaric" then
			riesenpilz_minecraft_fliegenpilz(pos)
		elseif minetest.env:get_node(pos).name == "riesenpilz:brown" then
			riesenpilz_brauner_minecraftpilz(pos)
		elseif minetest.env:get_node(pos).name == "riesenpilz:lavashroom" then
			riesenpilz_lavashroom(pos)
		elseif minetest.env:get_node(pos).name == "riesenpilz:glowshroom" then
			riesenpilz_glowshroom(pos)
		elseif minetest.env:get_node(pos).name == "default:apple" then
			riesenpilz_apple(pos)
		end
	end
end)



riesenpilz = {}
dofile(minetest.get_modpath("riesenpilz").."/settings.lua")
if riesenpilz.enable_mapgen then
	dofile(minetest.get_modpath("riesenpilz") .. "/mapgen.lua")
end

print("[riesenpilz] Loaded!") 
