local load_time_start = os.clock()
local MAX_SIZE = 3

local function r_area(manip, width, height, pos)
	local emerged_pos1, emerged_pos2 = manip:read_from_map(
		{x=pos.x-width, y=pos.y, z=pos.z-width},
		{x=pos.x+width, y=pos.y+height, z=pos.z+width}
	)
	return VoxelArea:new({MinEdge=emerged_pos1, MaxEdge=emerged_pos2})
end

local function set_vm_data(manip, nodes, pos, t1, name)
	manip:set_data(nodes)
	manip:write_to_map()
	print(string.format("[riesenpilz] a "..name.." mushroom grew at ("..pos.x.."|"..pos.y.."|"..pos.z..") after ca. %.2fs", os.clock() - t1))
	local t1 = os.clock()
	manip:update_map()
	print(string.format("[riesenpilz] map updated after ca. %.2fs", os.clock() - t1))
end

--Growing Functions

function riesenpilz_hybridpilz(pos)

	local t1 = os.clock()
	local manip = minetest.get_voxel_manip()
	local area = r_area(manip, MAX_SIZE+1, MAX_SIZE+2, pos)
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

	set_vm_data(manip, nodes, pos, t1, "red")
end


function riesenpilz_brauner_minecraftpilz(pos)

	local t1 = os.clock()
	local manip = minetest.get_voxel_manip()
	local area = r_area(manip, MAX_SIZE+1, MAX_SIZE+2, pos)
	local nodes = manip:get_data()

	local random = math.random(MAX_SIZE-1)
	local br	 = random+1
	local breite = br+1
	local height = br+2

	for i in area:iterp(pos, {x=pos.x, y=pos.y+height, z=pos.z}) do
		nodes[i] = riesenpilz_c_stem
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

	set_vm_data(manip, nodes, pos, t1, "brown")
end


function riesenpilz_minecraft_fliegenpilz(pos)

	local t1 = os.clock()
	local manip = minetest.get_voxel_manip()
	local area = r_area(manip, 1, 4, pos)
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
		minetest.set_node(v[1], v[2])
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
	local area = r_area(manip, 4, MAX_SIZE+7, pos)
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

	set_vm_data(manip, nodes, pos, t1, "lavashroom")
end


function riesenpilz_glowshroom(pos)

	local t1 = os.clock()
	local manip = minetest.get_voxel_manip()
	local area = r_area(manip, 2, MAX_SIZE+5, pos)
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

	set_vm_data(manip, nodes, pos, t1, "glowshroom")
end


function riesenpilz_parasol(pos)
	local t1 = os.clock()

	local height = 6+math.random(MAX_SIZE)
	local br = math.random(MAX_SIZE+1,MAX_SIZE+2)

	local manip = minetest.get_voxel_manip()
	local area = r_area(manip, br, height, pos)
	local nodes = manip:get_data()

	local rh = math.random(2,3)
	local bhead1 = br-1
	local bhead2 = math.random(1,br-2)

	--stem
	for i in area:iterp(pos, {x=pos.x, y=pos.y+height-2, z=pos.z}) do
		nodes[i] = riesenpilz_c_stem
	end

	for _,j in ipairs({
		{bhead2, 0, riesenpilz_c_head_brown_bright},
		{bhead1, -1, riesenpilz_c_head_binge}
	}) do
		for i in area:iter(pos.x-j[1], pos.y+height+j[2], pos.z-j[1], pos.x+j[1], pos.y+height+j[2], pos.z+j[1]) do
			nodes[i] = j[3]
		end
	end

	for k = -1, 1, 2 do
		for l = 0, 1 do
			nodes[area:index(pos.x+k, pos.y+rh, pos.z-l*k)] = riesenpilz_c_head_white
			nodes[area:index(pos.x+l*k, pos.y+rh, pos.z+k)] = riesenpilz_c_head_white
		end
		for l = -br+1, br do
			nodes[area:index(pos.x+br*k, pos.y+height-2, pos.z-l*k)] = riesenpilz_c_head_binge
			nodes[area:index(pos.x+l*k, pos.y+height-2, pos.z+br*k)] = riesenpilz_c_head_binge
		end
		for l = -bhead1+1, bhead1 do
			nodes[area:index(pos.x+bhead1*k, pos.y+height-2, pos.z-l*k)] = riesenpilz_c_head_white
			nodes[area:index(pos.x+l*k, pos.y+height-2, pos.z+bhead1*k)] = riesenpilz_c_head_white
		end
	end

	set_vm_data(manip, nodes, pos, t1, "parasol")
end


function riesenpilz_apple(pos)

	local t1 = os.clock()
	local manip = minetest.get_voxel_manip()
	local area = r_area(manip, 5, 14, pos)
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
	print(string.format("[riesenpilz] an apple grew at ("..pos.x.."|"..pos.y.."|"..pos.z..") after ca. %.2fs", os.clock() - t1))
	manip:update_map()
end



--3D apple [3apple]


local tmp = minetest.registered_nodes["default:apple"]
minetest.register_node(":default:apple", {
	description = tmp.description,
	drawtype = "nodebox",
	visual_scale = tmp.visual_scale,
	tiles = {"3apple_apple_top.png","3apple_apple_bottom.png","3apple_apple.png"},
	inventory_image = tmp.inventory_image,
	sunlight_propagates = tmp.sunlight_propagates,
	walkable = tmp.walkable,
	paramtype = tmp.paramtype,
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
	groups = tmp.groups,
	on_use = tmp.on_use,
	sounds = tmp.sounds,
	after_place_node = tmp.after_place_node,
})



--Mushroom Nodes


local function pilz(name, desc, b)
	local box = {
		type = "fixed",
		fixed = b
	}
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
		selection_box = box
	})
end

local BOX = {
	RED = {
		{-1/16, -8/16, -1/16, 1/16, -6/16, 1/16},
		{-3/16, -6/16, -3/16, 3/16, -5/16, 3/16},
		{-4/16, -5/16, -4/16, 4/16, -4/16, 4/16},
		{-3/16, -4/16, -3/16, 3/16, -3/16, 3/16},
		{-2/16, -3/16, -2/16, 2/16, -2/16, 2/16}
	},
	BROWN = {
		{-0.15, -0.2, -0.15, 0.15, -0.1, 0.15},
		{-0.2, -0.3, -0.2, 0.2, -0.2, 0.2},
		{-0.05, -0.5, -0.05, 0.05, -0.3, 0.05}
	},
	FLY_AGARIC = {
		{-0.05, -0.5, -0.05, 0.05, 1/20, 0.05},
		{-3/20, -6/20, -3/20, 3/20, 0, 3/20},
		{-4/20, -2/20, -4/20, 4/20, -4/20, 4/20}
	},
	LAVASHROOM = {
		{-1/16, -8/16, -1/16, 1/16, -6/16, 1/16},
		{-2/16, -6/16, -2/16, 2/16,     0, 2/16},
		{-3/16, -5/16, -3/16, 3/16, -1/16, 3/16},
		{-4/16, -4/16, -4/16, 4/16, -2/16, 4/16}
	},
	GLOWSHROOM = {
		{-1/16, -8/16, -1/16, 1/16, -1/16, 1/16},
		{-2/16, -3/16, -2/16, 2/16, -2/16, 2/16},
		{-3/16, -5/16, -3/16, 3/16, -3/16, 3/16},
		{-3/16, -7/16, -3/16, -2/16, -5/16, -2/16},
		{3/16, -7/16, -3/16, 2/16, -5/16, -2/16},
		{-3/16, -7/16, 3/16, -2/16, -5/16, 2/16},
		{3/16, -7/16, 3/16, 2/16, -5/16, 2/16}
	},
	NETHER_SHROOM = {
		{-1/16, -8/16, -1/16, 1/16, -2/16, 1/16},
		{-2/16, -6/16, -2/16, 2/16, -5/16, 2/16},
		{-3/16, -2/16, -3/16, 3/16,     0, 3/16},
		{-4/16, -1/16, -4/16, 4/16,  1/16,-2/16},
		{-4/16, -1/16,  2/16, 4/16,  1/16, 4/16},
		{-4/16, -1/16, -2/16,-2/16,  1/16, 2/16},
		{ 2/16, -1/16, -2/16, 4/16,  1/16, 2/16}
	},
	PARASOL = {
		{-1/16, -8/16, -1/16, 1/16,	    0, 1/16},
		{-2/16, -6/16, -2/16, 2/16, -5/16, 2/16},
		{-5/16, -4/16, -5/16, 5/16, -3/16, 5/16},
		{-4/16, -3/16, -4/16, 4/16, -2/16, 4/16},
		{-3/16, -2/16, -3/16, 3/16, -1/16, 3/16}
	}
}


local mushrooms_list = {
	{"brown", "Brown Mushroom", BOX.BROWN},
	{"red", "Red Mushroom", BOX.RED},
	{"fly_agaric", "Fly Agaric", BOX.FLY_AGARIC},
	{"lavashroom", "Lavashroom", BOX.LAVASHROOM},
	{"glowshroom", "Glowshroom", BOX.GLOWSHROOM},
	{"nether_shroom", "Nether Mushroom", BOX.NETHER_SHROOM},
	{"parasol", "Parasol Mushroom", BOX.PARASOL},
}

for _,i in ipairs(mushrooms_list) do
	pilz(i[1], i[2], i[3])
end



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


local r = "riesenpilz_"
local h = "head_"
local s = "stem_"
local rh = r..h
local rs = r..s

local GS = "Giant Mushroom "
local GSH = GS.."Head "
local GSS = GS.."Stem "

local pilznode_list = {
	{"stem", GSS.."Beige", {rs.."top.png", rs.."top.png", "riesenpilz_stem.png"}, "stem"},
	{s.."brown", GSS.."Brown", {rs.."top.png", rs.."top.png", rs.."brown.png"}, s.."brown"},
	{s.."blue", GSS.."Blue", {rs.."top.png",rs.."top.png",rs.."blue.png"}, s.."blue"},
	{"lamellas", "Giant Mushroom Lamella", {"riesenpilz_lamellas.png"}, "lamellas"},
	{h.."red", GSH.."Red", {"riesenpilz_head.png", "riesenpilz_lamellas.png", "riesenpilz_head.png"}, "red"},
	{h.."orange", GSH.."Orange", {rh.."orange.png"}, "lavashroom"},
	{h.."yellow", GSH.."Yellow", {rh.."yellow.png"}, "lavashroom"},
	{h.."brown", GSH.."Brown", {r.."brown_top.png", r.."lamellas.png", r.."brown_top.png"}, "brown"},
	{h.."brown_full", GSH.."Full Brown", {r.."brown_top.png"},"brown"},
	{h.."blue_bright", GSH.."Blue Bright", {rh.."blue_bright.png"},"glowshroom"},
	{h.."blue", GSH.."Blue", {rh.."blue.png"},"glowshroom"},
	{h.."white", GSH.."White", {rh.."white.png"},"parasol"},
	{h.."binge", GSH.."Binge", {rh.."binge.png", rh.."white.png", rh.."binge.png"},"parasol"},
	{h.."brown_bright", GSH.."Brown Bright", {rh.."brown_bright.png", rh.."white.png", rh.."brown_bright.png"},"parasol"},
}

for _,i in ipairs(pilznode_list) do
	pilznode(i[1], i[2], i[3], i[4])
end


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

riesenpilz_c_head_white = minetest.get_content_id("riesenpilz:head_white")
riesenpilz_c_head_binge = minetest.get_content_id("riesenpilz:head_binge")
riesenpilz_c_head_brown_bright = minetest.get_content_id("riesenpilz:head_brown_bright")

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
		elseif name == "riesenpilz:parasol" then
			riesenpilz_parasol(pos)
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

print(string.format("[riesenpilz] loaded after ca. %.2fs", os.clock() - load_time_start))
