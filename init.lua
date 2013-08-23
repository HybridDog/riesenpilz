---------------------------------------------------riesenpilz 12.12--------------------------------------------------
--Textures (edited with gimp) from gamiano.de

local MAX_SIZE = 3




--Growing Functions

function riesenpilz_hybridpilz(pos)

	local t1 = os.clock()
	local manip = minetest.get_voxel_manip()
	local vwidth = MAX_SIZE + 1
	local vheight = vwidth + 1
	local emerged_pos1, emerged_pos2 = manip:read_from_map({x=pos.x-vwidth, y=pos.y, z=pos.z-vwidth},
		{x=pos.x+vwidth, y=pos.y+vheight, z=pos.z+vwidth})
	local area = VoxelArea:new({MinEdge=emerged_pos1, MaxEdge=emerged_pos2})

	local nodes = manip:get_data()

	local breite = math.random(MAX_SIZE)
	local br = breite+1
	local height = breite+2

	for i = 0, height, 1 do
		nodes[area:index(pos.x, pos.y+i, pos.z)] = riesenpilz_c_stem
	end

	for l = -br+1, br, 1 do
		for k = -1, 1, 2 do
			nodes[area:index(pos.x+br*k, pos.y+height, pos.z-l*k)] = riesenpilz_c_head_red
			nodes[area:index(pos.x+l*k, pos.y+height, pos.z+br*k)] = riesenpilz_c_head_red
		end
	end

	for k = -breite, breite, 1 do
		for l = -breite, breite, 1 do
			nodes[area:index(pos.x+l, pos.y+height+1, pos.z+k)] = riesenpilz_c_head_red
			nodes[area:index(pos.x+l, pos.y+height, pos.z+k)] = riesenpilz_c_lamellas
		end
	end

	manip:set_data(nodes)
	manip:write_to_map()
	print(string.format("[riesenpilz] a red mushroom grew at ("..pos.x.."|"..pos.y.."|"..pos.z..") in: %.2fs", os.clock() - t1))
	manip:update_map()
end


function riesenpilz_brauner_minecraftpilz(pos)

	local t1 = os.clock()
	local manip = minetest.get_voxel_manip()
	local vwidth = MAX_SIZE + 1
	local vheight = vwidth + 1
	local emerged_pos1, emerged_pos2 = manip:read_from_map({x=pos.x-vwidth, y=pos.y, z=pos.z-vwidth},
		{x=pos.x+vwidth, y=pos.y+vheight, z=pos.z+vwidth})
	local area = VoxelArea:new({MinEdge=emerged_pos1, MaxEdge=emerged_pos2})

	local nodes = manip:get_data()

	local random = math.random(MAX_SIZE-1)
	local br	 = random+1
	local breite = br+1
	local height = br+2

	for i = 0, height, 1 do
		nodes[area:index(pos.x, pos.y+i, pos.z)] = riesenpilz_c_stem
	end

	for l = -br, br, 1 do
		for k = -breite, breite, breite*2 do
			nodes[area:index(pos.x+k, pos.y+height+1, pos.z+l)] = riesenpilz_c_head_brown
			nodes[area:index(pos.x+l, pos.y+height+1, pos.z+k)] = riesenpilz_c_head_brown
		end
		for k = -br, br, 1 do
			nodes[area:index(pos.x+l, pos.y+height+1, pos.z+k)] = riesenpilz_c_head_brown
		end
	end

	manip:set_data(nodes)
	manip:write_to_map()
	print(string.format("[riesenpilz] a brown mushroom grew at ("..pos.x.."|"..pos.y.."|"..pos.z..") in: %.2fs", os.clock() - t1))
	manip:update_map()
end


function riesenpilz_minecraft_fliegenpilz(pos)

	local t1 = os.clock()
	local manip = minetest.get_voxel_manip()
	local vwidth = 1
	local vheight = 4
	local emerged_pos1, emerged_pos2 = manip:read_from_map({x=pos.x-vwidth, y=pos.y, z=pos.z-vwidth},
		{x=pos.x+vwidth, y=pos.y+vheight, z=pos.z+vwidth})
	local area = VoxelArea:new({MinEdge=emerged_pos1, MaxEdge=emerged_pos2})
	local nodes = manip:get_data()

	local height = 3
	local tab = {}
	local num = 1

	for i = 0, height, 1 do
		nodes[area:index(pos.x, pos.y+i, pos.z)] = riesenpilz_c_stem
	end

	for j = -1, 1, 1 do
		for k = -1, 1, 1 do
			nodes[area:index(pos.x+j, pos.y+height+1, pos.z+k)] = riesenpilz_c_head_red
		end
		for l = 1, height, 1 do
			tab[num] = {{x=pos.x+j, y=pos.y+l, z=pos.z+2}, {name="riesenpilz:head_red_side", param2=0}}
			tab[num+1] = {{x=pos.x+j, y=pos.y+l, z=pos.z-2}, {name="riesenpilz:head_red_side", param2=2}}
			tab[num+2] = {{x=pos.x+2, y=pos.y+l, z=pos.z+j}, {name="riesenpilz:head_red_side", param2=1}}
			tab[num+3] = {{x=pos.x-2, y=pos.y+l, z=pos.z+j}, {name="riesenpilz:head_red_side", param2=3}}
			num = num+4
		end
	end

	manip:set_data(nodes)
	manip:write_to_map()
	manip:update_map()

	for _,v in ipairs(tab) do
		minetest.env:set_node(v[1], v[2])
	end
	print(string.format("[riesenpilz] a fly agaric grew at ("..pos.x.."|"..pos.y.."|"..pos.z..") in: %.2fs", os.clock() - t1))
end


local function ran_node(a, b, ran)
	if math.random(ran) == 1 then
		return a
	end
	return b
end

function riesenpilz_lavashroom(pos)

	local t1 = os.clock()
	local manip = minetest.get_voxel_manip()
	local vwidth = 4
	local vheight = MAX_SIZE+7
	local emerged_pos1, emerged_pos2 = manip:read_from_map({x=pos.x-vwidth, y=pos.y, z=pos.z-vwidth},
		{x=pos.x+vwidth, y=pos.y+vheight, z=pos.z+vwidth})
	local area = VoxelArea:new({MinEdge=emerged_pos1, MaxEdge=emerged_pos2})

	local nodes = manip:get_data()

	local height = 3+math.random(MAX_SIZE-2)
	nodes[area:index(pos.x, pos.y, pos.z)] = riesenpilz_c_air

	for i = -1, 1, 2 do
		local o = 2*i

		for n = 0, height, 1 do
			nodes[area:index(pos.x+i, pos.y+n, pos.z)] = riesenpilz_c_stem_brown
			nodes[area:index(pos.x, pos.y+n, pos.z+i)] = riesenpilz_c_stem_brown
		end

		for l = -1, 1, 1 do
			for k = 2, 3, 1 do
				nodes[area:index(pos.x+k*i, pos.y+height+2, pos.z+l)] = riesenpilz_c_head_brown_full
				nodes[area:index(pos.x+l, pos.y+height+2, pos.z+k*i)] = riesenpilz_c_head_brown_full
			end
			nodes[area:index(pos.x+l, pos.y+height+1, pos.z+o)] = riesenpilz_c_head_brown_full
			nodes[area:index(pos.x+o, pos.y+height+1, pos.z+l)] = riesenpilz_c_head_brown_full
		end

		for m = -1, 1, 2 do
			for k = 2, 3, 1 do
				for j = 2, 3, 1 do
					nodes[area:index(pos.x+j*i, pos.y+height+2, pos.z+k*m)] = ran_node(riesenpilz_c_head_yellow, riesenpilz_c_head_orange, 7)
				end
			end
			nodes[area:index(pos.x+i, pos.y+height+1, pos.z+m)] = riesenpilz_c_head_brown_full
			nodes[area:index(pos.x+m*2, pos.y+height+1, pos.z+o)] = riesenpilz_c_head_brown_full
		end

		for l = -3+1, 3, 1 do
			nodes[area:index(pos.x+3*i, pos.y+height+5, pos.z-l*i)] = ran_node(riesenpilz_c_head_yellow, riesenpilz_c_head_orange, 5)
			nodes[area:index(pos.x+l*i, pos.y+height+5, pos.z+3*i)] = ran_node(riesenpilz_c_head_yellow, riesenpilz_c_head_orange, 5)
		end

		for j = 0, 1, 1 do
			for l = -3, 3, 1 do
				nodes[area:index(pos.x+i*4, pos.y+height+3+j, pos.z+l)] = ran_node(riesenpilz_c_head_yellow, riesenpilz_c_head_orange, 6)
				nodes[area:index(pos.x+l, pos.y+height+3+j, pos.z+i*4)] = ran_node(riesenpilz_c_head_yellow, riesenpilz_c_head_orange, 6)
			end
		end

	end

	for k = -2, 2, 1 do
		for l = -2, 2, 1 do
			nodes[area:index(pos.x+k, pos.y+height+6, pos.z+l)] = ran_node(riesenpilz_c_head_yellow, riesenpilz_c_head_orange, 4)
		end
	end

	manip:set_data(nodes)
	manip:write_to_map()
	print(string.format("[riesenpilz] a lavashroom grew at ("..pos.x.."|"..pos.y.."|"..pos.z..") in: %.2fs", os.clock() - t1))
	manip:update_map()
end


function riesenpilz_glowshroom(pos)

	local t1 = os.clock()
	local manip = minetest.get_voxel_manip()
	local vwidth = 2
	local vheight = 5+MAX_SIZE
	local emerged_pos1, emerged_pos2 = manip:read_from_map({x=pos.x-vwidth, y=pos.y, z=pos.z-vwidth},
		{x=pos.x+vwidth, y=pos.y+vheight, z=pos.z+vwidth})
	local area = VoxelArea:new({MinEdge=emerged_pos1, MaxEdge=emerged_pos2})

	local nodes = manip:get_data()

	local height = 2+math.random(MAX_SIZE)
	local br = 2

	for i = 0, height, 1 do
		nodes[area:index(pos.x, pos.y+i, pos.z)] = riesenpilz_c_stem_blue
	end

	for i = -1, 1, 2 do

		for k = -br, br, 2*br do
			for l = 2, height, 1 do
				nodes[area:index(pos.x+i*br, pos.y+l, pos.z+k)] = riesenpilz_c_head_blue
			end
			nodes[area:index(pos.x+i*br, pos.y+1, pos.z+k)] = riesenpilz_c_head_blue_bright
		end

		for l = -br+1, br, 1 do
			nodes[area:index(pos.x+i*br, pos.y+height, pos.z-l*i)] = riesenpilz_c_head_blue
			nodes[area:index(pos.x+l*i, pos.y+height, pos.z+br*i)] = riesenpilz_c_head_blue
		end

	end

	for l = 0, br, 1 do
		for i = -br+l, br-l, 1 do
			for k = -br+l, br-l, 1 do
				nodes[area:index(pos.x+i, pos.y+height+1+l, pos.z+k)] = riesenpilz_c_head_blue
			end
		end
	end

	manip:set_data(nodes)
	manip:write_to_map()
	print(string.format("[riesenpilz] a glowshroom grew at ("..pos.x.."|"..pos.y.."|"..pos.z..") in: %.2fs", os.clock() - t1))
	manip:update_map()
end


function riesenpilz_apple(pos)

	local t1 = os.clock()
	local manip = minetest.get_voxel_manip()
	local vwidth = 5
	local vheight = 14
	local emerged_pos1, emerged_pos2 = manip:read_from_map({x=pos.x-vwidth, y=pos.y, z=pos.z-vwidth},
		{x=pos.x+vwidth, y=pos.y+vheight, z=pos.z+vwidth})
	local area = VoxelArea:new({MinEdge=emerged_pos1, MaxEdge=emerged_pos2})

	local nodes = manip:get_data()

	local size = 5
	local a = size*2
	local b = size-1

	for l = -b, b, 1 do
		for j = 1, a-1, 1 do
			for k = -size, size, a do
				nodes[area:index(pos.x+k, pos.y+j, pos.z+l)] = riesenpilz_c_red
				nodes[area:index(pos.x+l, pos.y+j, pos.z+k)] = riesenpilz_c_red
			end
		end
		for i = -b, b, 1 do
			nodes[area:index(pos.x+i, pos.y, pos.z+l)] = riesenpilz_c_red
			nodes[area:index(pos.x+i, pos.y+a, pos.z+l)] = riesenpilz_c_red
		end
	end

	for i = a+1, a+b, 1 do
		nodes[area:index(pos.x, pos.y+i, pos.z)] = riesenpilz_c_tree
	end

	local c = pos.y+1
	for i = -3,1,1 do
		nodes[area:index(pos.x+i, c, pos.z+1)] = riesenpilz_c_brown
	end
	for i = 0,1,1 do
		nodes[area:index(pos.x+i+1, c, pos.z-1-i)] = riesenpilz_c_brown
		nodes[area:index(pos.x+i+2, c, pos.z-1-i)] = riesenpilz_c_brown
	end
	nodes[area:index(pos.x+1, c, pos.z)] = riesenpilz_c_brown
	nodes[area:index(pos.x-3, c+1, pos.z+1)] = riesenpilz_c_brown

	manip:set_data(nodes)
	manip:write_to_map()
	print(string.format("[riesenpilz] an apple grew at ("..pos.x.."|"..pos.y.."|"..pos.z..") in: %.2fs", os.clock() - t1))
	manip:update_map()
end



--3D apple [3apple]


minetest.register_node(":default:apple", {
	description = "Apple",
	drawtype = "nodebox",
	visual_scale = 1.0,
	tiles = {"3apple_apple_top.png","3apple_apple_bottom.png","3apple_apple.png"},
	inventory_image = "default_apple.png",
	sunlight_propagates = true,
	walkable = false,
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
		{-3/16,	-7/16,	-3/16,	3/16,	1/16,	3/16},
		{-4/16,	-6/16,	-3/16,	4/16,	0,		3/16},
		{-3/16,	-6/16,	-4/16,	3/16,	0,		4/16},
		{-1/32,	1/16,	-1/32,	1/32,	4/16,	1/32},
		{-1/16,	1.6/16,	0,		1/16,	1.8/16,	1/16},
		{-2/16,	1.4/16,	1/16,	1/16,	1.6/16,	2/16},
		{-2/16,	1.2/16,	2/16,	0,		1.4/16,	3/16},
		{-1.5/16,	1/16,	.5/16,	0.5/16,		1.2/16,	2.5/16},
		}
	},
	groups = {fleshy=3,dig_immediate=3,flammable=2,leafdecay=3,leafdecay_drop=1},
	on_use = minetest.item_eat(1),
	sounds = default.node_sound_defaults(),
	after_place_node = function(pos, placer, itemstack)
		if placer:is_player() then
			minetest.env:set_node(pos, {name="default:apple", param2=1})
		end
	end,
})



--Mushroom Nodes


local function pilz(name, desc, box)
minetest.register_node("riesenpilz:"..name, {
	description = desc,
	tiles = {"riesenpilz_"..name.."_top.png", "riesenpilz_"..name.."_bottom.png", "riesenpilz_"..name.."_side.png"},
	inventory_image = "riesenpilz_"..name.."_side.png",
	walkable = false,
	buildable_to = true,
	drawtype = "nodebox",
	paramtype = "light",
	groups = {snappy=3,flammable=2,attached_node=1},
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

local BOX_NETHER_SHROOM = {
	type = "fixed",
	fixed = {
		{-1/16, -8/16, -1/16, 1/16, -2/16, 1/16},
		{-2/16, -6/16, -2/16, 2/16, -5/16, 2/16},
		{-3/16, -2/16, -3/16, 3/16,     0, 3/16},
		{-4/16, -1/16, -4/16, 4/16,  1/16,-2/16},
		{-4/16, -1/16,  2/16, 4/16,  1/16, 4/16},
		{-4/16, -1/16, -2/16,-2/16,  1/16, 2/16},
		{ 2/16, -1/16, -2/16, 4/16,  1/16, 2/16},
	},
}

pilz("brown", "Brown Mushroom", BOX_BROWN)
pilz("red", "Red Mushroom", BOX_RED)
pilz("fly_agaric", "Fly Agaric", BOX_FLY_AGARIC)
pilz("lavashroom", "Lavashroom", BOX_LAVASHROOM)
pilz("glowshroom", "Glowshroom", BOX_GLOWSHROOM)
pilz("nether_shroom", "Nether Mushroom", BOX_NETHER_SHROOM)



--Mushroom Blocks


local function pilznode(name, desc, textures, sapling)
minetest.register_node("riesenpilz:"..name, {
	description = desc,
	tiles = textures,
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
	tiles = {"riesenpilz_head.png",	"riesenpilz_lamellas.png",	"riesenpilz_head.png",
					"riesenpilz_head.png",	"riesenpilz_head.png",	"riesenpilz_lamellas.png"},
	paramtype2 = "facedir",
	groups = {oddly_breakable_by_hand=3},
	drop = {max_items = 1,
		items = {{items = {"riesenpilz:fly_agaric"},rarity = 20,},
				{items = {"riesenpilz:head_red"},rarity = 1,}}},
})

minetest.register_node("riesenpilz:ground", {
	description = "Grass?",
	tiles = {"riesenpilz_ground_top.png","default_dirt.png","default_dirt.png^riesenpilz_ground_side.png"},
	groups = {crumbly=3},
	sounds = default.node_sound_dirt_defaults(),
	drop = 'default:dirt'
})


riesenpilz_c_air = minetest.get_content_id("air")

riesenpilz_c_stem = minetest.get_content_id("riesenpilz:stem")
riesenpilz_c_head_red = minetest.get_content_id("riesenpilz:head_red")
riesenpilz_c_lamellas = minetest.get_content_id("riesenpilz:lamellas")

riesenpilz_c_head_brown = minetest.get_content_id("riesenpilz:head_brown")

riesenpilz_c_stem_brown = minetest.get_content_id("riesenpilz:stem_brown")
riesenpilz_c_head_brown_full = minetest.get_content_id("riesenpilz:head_brown_full")
riesenpilz_c_head_orange = minetest.get_content_id("riesenpilz:head_orange")
riesenpilz_c_head_yellow = minetest.get_content_id("riesenpilz:head_yellow")

riesenpilz_c_stem_blue = minetest.get_content_id("riesenpilz:stem_blue")
riesenpilz_c_head_blue = minetest.get_content_id("riesenpilz:head_blue")
riesenpilz_c_head_blue_bright = minetest.get_content_id("riesenpilz:head_blue_bright")

riesenpilz_c_red = minetest.get_content_id("default:copperblock")
riesenpilz_c_brown = minetest.get_content_id("default:desert_stone")
riesenpilz_c_tree = minetest.get_content_id("default:tree")




--Growing


minetest.register_tool("riesenpilz:growingtool", {
	description = "Growingtool",
	inventory_image = "riesenpilz_growingtool.png",
})

minetest.register_on_punchnode(function(pos, node, puncher)
	if puncher:get_wielded_item():get_name() == "riesenpilz:growingtool" then
		local name = node.name
		if name == "riesenpilz:red" then
			riesenpilz_hybridpilz(pos)
		elseif name == "riesenpilz:fly_agaric" then
			riesenpilz_minecraft_fliegenpilz(pos)
		elseif name == "riesenpilz:brown" then
			riesenpilz_brauner_minecraftpilz(pos)
		elseif name == "riesenpilz:lavashroom" then
			riesenpilz_lavashroom(pos)
		elseif name == "riesenpilz:glowshroom" then
			riesenpilz_glowshroom(pos)
		elseif name == "default:apple" then
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
