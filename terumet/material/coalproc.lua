local coke_id = terumet.id('item_coke')

minetest.register_craftitem( coke_id, {
    description = 'Coke Lump',
    inventory_image = terumet.tex(coke_id),
    groups = {coal = 1, flammable = 1},
})

minetest.register_craft({
	type = "fuel",
	recipe = coke_id,
	burntime = 80,
})

local coke_block_id = terumet.id('block_coke')

minetest.register_node( coke_block_id, {
    description = 'Coke Block',
    tiles = {terumet.tex(coke_block_id)},
	is_ground_content = false,
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	type = "fuel",
	recipe = coke_block_id,
	burntime = 740,
})

minetest.register_craft{ output = coke_block_id,
    recipe = terumet.recipe_3x3(coke_id)
}

minetest.register_craft{ type = 'shapeless', output = coke_id .. ' 9',
    recipe = {coke_block_id},
}

local tarball_id = terumet.id('item_tarball')

minetest.register_craftitem( tarball_id, {
    description = 'Tarball',
    inventory_image = terumet.tex(tarball_id),
    groups = {glue=1}
})

minetest.register_craft({
	type = "fuel",
	recipe = tarball_id,
	burntime = 30,
})

local tarblock_id = terumet.id('block_tar')

minetest.register_node( tarblock_id, {
    description = 'Tar Block',
    tiles = {terumet.tex(tarblock_id)},
    is_ground_content = false,
    groups = {level=2, crumbly=2, cracky=1, snappy=2, choppy=2, disable_jump=1, fall_damage_add_percent=-100},
    sounds = terumet.squishy_node_sounds
})


minetest.register_craft{ output = tarblock_id,
    recipe = terumet.recipe_box(tarball_id, '')
}

minetest.register_craft{ type = 'shapeless', output = tarball_id .. ' 8', recipe = {tarblock_id} }

local prerubber_id = terumet.id('item_prerub')

minetest.register_craftitem( prerubber_id, {
    description = 'Bio-tar Mixture',
    inventory_image = terumet.tex(prerubber_id)
})

minetest.register_craft{ output = prerubber_id,
    recipe = {
        {'', tarball_id, ''},
        {tarball_id, 'terumet:item_dust_bio', tarball_id},
        {'', tarball_id, ''}
    }
}

local rubber_bar_id = terumet.id('item_rubber')

terumet.options.vulcan.recipes[prerubber_id] = {rubber_bar_id, 1}

minetest.register_craftitem( rubber_bar_id, {
    description = 'Synthetic Rubber Bar',
    inventory_image = terumet.tex(rubber_bar_id)
})

local rsuit_mat = terumet.id('item_rsuitmat')

minetest.register_craftitem( rsuit_mat, {
    description = 'Vulcansuit Plate',
    inventory_image = terumet.tex(rsuit_mat)
})

terumet.register_alloy_recipe{result=rsuit_mat, flux=8, time=20.0, input={rubber_bar_id, 'terumet:ingot_cgls', 'terumet:item_ceramic'}}

local asphalt_id = terumet.id('block_asphalt')

minetest.register_node( asphalt_id, {
    description = 'Asphalt Block',
    tiles = {terumet.tex(asphalt_id)},
	is_ground_content = false,
	groups = {cracky = 3, crumbly = 1, level = 1},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
    output = asphalt_id..' 8',
    recipe = terumet.recipe_box('default:gravel', tarball_id)
})

terumet.register_convertible_block(asphalt_id, 'asphalt')
walls.register(terumet.id('wall_asphalt'), 'Asphalt Wall', terumet.tex(asphalt_id), asphalt_id, default.node_sound_stone_defaults())
if minetest.get_modpath('stairs') then
    stairs.register_stair_and_slab('asphalt', asphalt_id, {cracky = 3, crumbly = 1, level = 1}, {terumet.tex(asphalt_id)}, 'Asphalt Stair', 'Asphalt Slab', default.node_sound_stone_defaults(), false )
end