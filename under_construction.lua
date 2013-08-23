--[[
function riesenpilz_circle(nam, pos, radius, rand, seed)
	local ra = seed
	for i = -radius, radius, 1 do
		for j = -radius, radius, 1 do
			if math.floor(	math.sqrt(i^2+j^2)	+0.5) == radius then
				random = PseudoRandom(ra)
				p={x=pos.x+i, y=pos.y, z=pos.z+j}
				if minetest.env:get_node(p).name == "air"
				and random:next(1,rand) == 1
				and minetest.env:get_node({x=pos.x+i, y=pos.y-1, z=pos.z+j}).name ~= "air" then
					minetest.env:add_node(p, {name=nam})
				end
				ra = ra+1
			end
		end
	end
end

						elseif pr:next(1,80) == 1 then
							riesenpilz_circle("riesenpilz:brown", boden, pr:next(2,3), 3, seed)
						elseif pr:next(1,90) == 1 then
							riesenpilz_circle("riesenpilz:red", boden, pr:next(3,4), 3, seed)
						elseif pr:next(1,100) == 1 then
							riesenpilz_circle("riesenpilz:fly_agaric", boden, 3, 3, seed)
						elseif pr:next(1,4000) == 1 then
							riesenpilz_circle("riesenpilz:lavashroom", boden, pr:next(4,5), 3, seed)
						elseif pr:next(1,5000) == 1 then
							riesenpilz_circle("riesenpilz:glowshroom", boden, 2, 3, seed)
]]
function riesenpilz_circle(nam, pos, radius, chance)
	for i = -radius, radius, 1 do
		for j = -radius, radius, 1 do
			if math.floor(	math.sqrt(i^2+j^2)	+0.5) == radius
			and minetest.env:get_node({x=pos.x+i, y=pos.y, z=pos.z+j}).name == "air"
			and math.random(1,chance) == 1
			and minetest.env:get_node({x=pos.x+i, y=pos.y-1, z=pos.z+j}).name == "riesenpilz:ground" then
				minetest.env:add_node({x=pos.x+i, y=pos.y, z=pos.z+j}, {name=nam})
			end
		end
	end
end

local function find_grond(a,list)
	for _,nam in ipairs(list) do			
		if a == nam then
			return true
		end
	end
	return false
end


local c_air = minetest.get_content_id("air")
local c_stone = minetest.get_content_id("default:stone")
local c_gr = minetest.get_content_id("default:dirt_with_grass")
local c_dirt = minetest.get_content_id("default:dirt")
local c_sand = minetest.get_content_id("default:sand")
local c_desert_sand = minetest.get_content_id("default:desert_sand")

local c_tree = minetest.get_content_id("default:tree")
local c_leaves = minetest.get_content_id("default:leaves")
local c_apple = minetest.get_content_id("default:apple")
local c_cactus = minetest.get_content_id("default:cactus")
local c_papyrus = minetest.get_content_id("default:papyrus")
local c_dry_shrub = minetest.get_content_id("default:dry_shrub")

local GROUND	=	{c_gr, c_sand, c_dirt, c_desert_sand}
--local USUAL_STUFF =	{"default:leaves","default:apple","default:tree","default:cactus","default:papyrus"}
minetest.register_on_generated(function(minp, maxp, seed)
	if minp.y <= -10 then
		return
	end
	local x0,z0,x1,z1 = minp.x,minp.z,maxp.x,maxp.z	-- Assume X and Z lengths are equal
	local env = minetest.env	--Should make things a bit faster.
	local perlin1 = env:get_perlin(11,3, 0.5, 200)	--Get map specific perlin

	--[[if not (perlin1:get2d({x=x0, y=z0}) > 0.53) and not (perlin1:get2d({x=x1, y=z1}) > 0.53)
	and not (perlin1:get2d({x=x0, y=z1}) > 0.53) and not (perlin1:get2d({x=x1, y=z0}) > 0.53)
	and not (perlin1:get2d({x=(x1-x0)/2, y=(z1-z0)/2}) > 0.53) then]]
	if not ( perlin1:get2d( {x=x0, y=z0} ) > 0.53 ) 					--top left
	and not ( perlin1:get2d( { x = x0 + ( (x1-x0)/2), y=z0 } ) > 0.53 )--top middle
	and not (perlin1:get2d({x=x1, y=z1}) > 0.53) 						--bottom right
	and not (perlin1:get2d({x=x1, y=z0+((z1-z0)/2)}) > 0.53) 			--right middle
	and not (perlin1:get2d({x=x0, y=z1}) > 0.53)  						--bottom left
	and not (perlin1:get2d({x=x1, y=z0}) > 0.53)						--top right
	and not (perlin1:get2d({x=x0+((x1-x0)/2), y=z1}) > 0.53) 			--left middle
	and not (perlin1:get2d({x=(x1-x0)/2, y=(z1-z0)/2}) > 0.53) 			--middle
	and not (perlin1:get2d({x=x0, y=z1+((z1-z0)/2)}) > 0.53) then		--bottom middle
		print("[riesenpilz] abort")
		return
	end
	local divs = (maxp.x-minp.x);
	local pr = PseudoRandom(seed+68)

	if riesenpilz.info then
		local geninfo = "[riesenpilz] tries to generate a mushroom biome at: x=["..minp.x.."; "..maxp.x.."]; y=["..minp.y.."; "..maxp.y.."]; z=["..minp.z.."; "..maxp.z.."]"
		print(geninfo)
		minetest.chat_send_all(geninfo)
	end

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local data = vm:get_data()
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}

	for p_pos in area:iterp(minp, maxp) do	--remove tree stuff
		local d_p_pos = data[p_pos]
		for _,nam in ipairs({c_tree, c_leaves, c_apple}) do			
			if d_p_pos == nam then
				data[p_pos] = c_air
				break
			end
		end
	end
		--[[remove usual stuff
		local trees = env:find_nodes_in_area(minp, maxp, USUAL_STUFF)
		for i,v in pairs(trees) do
			env:remove_node(v)
		end]]


	local smooth = riesenpilz.smooth

	for j=0,divs do
		for i=0,divs do
			local x,z = x0+i,z0+j

			--Check if we are in a "riesenpilz biome"
			local in_biome = false
			local test = perlin1:get2d({x=x, y=z})
			--smooth mapgen
			if smooth and (test > 0.73 or (test > 0.43 and pr:next(0,29) > (0.73 - test) * 100 )) then
				in_biome = true
			elseif (not smooth) and test > 0.53 then
				in_biome = true
			end

			if in_biome then

				for b = minp.y,maxp.y,1 do	--remove usual stuff
					local p_pos = area:index(x, b, z)
					local d_p_pos = data[p_pos]
					for _,nam in ipairs({c_cactus, c_papyrus}) do			
						if d_p_pos == nam then
							data[p_pos] = c_air
							break
						end
					end
				end

				local ground_y = nil --Definition des Bodens:
--				for y=maxp.y,0,-1 do
				for y=maxp.y,-5,-1 do	--because of the caves
					if find_grond(data[area:index(x, y, z)], GROUND) then
						ground_y = y
						break
					end
				end
				if ground_y then
					local p_ground = area:index(x, ground_y, z)
					local p_boden = area:index(x, ground_y+1, z)
					local d_p_ground = data[p_ground]
					local d_p_boden = data[p_boden]

					data[p_ground] = c_rp_ground
					for i = -1,-5,-1 do
						local p_pos = area:index(x, ground_y+i, z)
						local d_p_pos = data[p_pos]
						if d_p_pos == c_desert_sand
							data[p_pos] = c_dirt
						else
							break
						end
					end
					local boden = {x=x,y=ground_y+1,z=z}
					if pr:next(1,15) == 1 then
						data[p_boden] = c_dry_shrub
						env:add_node(boden, {name="default:dry_shrub"})
					elseif pr:next(1,80) == 1 then
						riesenpilz_circle("riesenpilz:brown", boden, pr:next(3,4), 3)
					elseif pr:next(1,90) == 1 then
						riesenpilz_circle("riesenpilz:red", boden, pr:next(4,5), 3)
					elseif pr:next(1,100) == 1 then
						riesenpilz_circle("riesenpilz:fly_agaric", boden, 4, 3)
					elseif pr:next(1,4000) == 1 then
						riesenpilz_circle("riesenpilz:lavashroom", boden, pr:next(5,6), 3)
					elseif pr:next(1,5000) == 1 then
						riesenpilz_circle("riesenpilz:glowshroom", boden, 3, 3)
					--[[elseif pr:next(1,80) == 1 then
						env:add_node(boden, {name="riesenpilz:brown"})
					elseif pr:next(1,90) == 1 then
						env:add_node(boden, {name="riesenpilz:red"})
					elseif pr:next(1,100) == 1 then
						env:add_node(boden, {name="riesenpilz:fly_agaric"})
					elseif pr:next(1,4000) == 1 then
						env:add_node(boden, {name="riesenpilz:lavashroom"})
					elseif pr:next(1,5000) == 1 then
						env:add_node(boden, {name="riesenpilz:glowshroom"})]]
					elseif pr:next(1,380) == 1 then
						riesenpilz_hybridpilz(boden)
					elseif pr:next(1,340) == 10 then
						riesenpilz_brauner_minecraftpilz(boden)
					elseif pr:next(1,390) == 20 then
						riesenpilz_minecraft_fliegenpilz(boden)
					elseif pr:next(1,6000) == 2 and pr:next(1,200) == 15 then
						riesenpilz_lavashroom(boden)
					end
				end
			end
		end
	end
	vm:set_data(data)
	--vm:set_lighting({day=0, night=0})
	vm:calc_lighting()
	vm:update_liquids()
	vm:write_to_map()
end)
--[[	if maxp.y < -10 then
		local x0,z0,x1,z1 = minp.x,minp.z,maxp.x,maxp.z	-- Assume X and Z lengths are equal
		local env = minetest.env	--Should make things a bit faster.
		local perlin1 = env:get_perlin(11,3, 0.5, 200)	--Get map specific perlin

		--[if not (perlin1:get2d({x=x0, y=z0}) > 0.53) and not (perlin1:get2d({x=x1, y=z1}) > 0.53)
		and not (perlin1:get2d({x=x0, y=z1}) > 0.53) and not (perlin1:get2d({x=x1, y=z0}) > 0.53)
		and not (perlin1:get2d({x=(x1-x0)/2, y=(z1-z0)/2}) > 0.53) then]
		if not ( perlin1:get2d( {x=x0, y=z0} ) > 0.53 ) 					--top left
		and not ( perlin1:get2d( { x = x0 + ( (x1-x0)/2), y=z0 } ) > 0.53 )--top middle
		and not (perlin1:get2d({x=x1, y=z1}) > 0.53) 						--bottom right
		and not (perlin1:get2d({x=x1, y=z0+((z1-z0)/2)}) > 0.53) 			--right middle
		and not (perlin1:get2d({x=x0, y=z1}) > 0.53)  						--bottom left
		and not (perlin1:get2d({x=x1, y=z0}) > 0.53)						--top right
		and not (perlin1:get2d({x=x0+((x1-x0)/2), y=z1}) > 0.53) 			--left middle
		and not (perlin1:get2d({x=(x1-x0)/2, y=(z1-z0)/2}) > 0.53) 			--middle
		and not (perlin1:get2d({x=x0, y=z1+((z1-z0)/2)}) > 0.53) then		--bottom middle
			print("abortsumpf")
			return
		end
		local divs = (maxp.x-minp.x);
		local pr = PseudoRandom(seed+68)

		for j=0,divs do
			for i=0,divs do
				local x,z = x0+i,z0+j

				for y=minp.y,maxp.y,1 do
					local pos = {x=x, y=y, z=z}

					if env:get_node(pos).name == "air"
					and env:get_node({x=x, y=y-1, z=z}).name == "default:stone"
					and pr:next(1,40) == 33
					and env:find_node_near(pos, 4, "group:igniter")
					and not env:find_node_near(pos, 3, "group:igniter") then
						env:add_node(pos, {name="riesenpilz:lavashroom"})
					end
				end
			end
		end
	end
end)]]
