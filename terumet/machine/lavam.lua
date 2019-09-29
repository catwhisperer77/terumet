local opts = terumet.options.lavam

local base_mach = terumet.machine

local base_lavam = {}
base_lavam.unlit_id = terumet.id('mach_lavam')
base_lavam.lit_id = terumet.id('mach_lavam_lit')

-- state identifier consts
base_lavam.STATE = {}
base_lavam.STATE.IDLE = 0
base_lavam.STATE.MELT = 1
base_lavam.STATE.DISPENSE = 2

local FSDEF = {
    control_buttons = {
        base_mach.buttondefs.HEAT_XFER_TOGGLE
    },
    input = {true},
    fuel_slot = {true},
}

function base_lavam.init(pos)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    inv:set_size('in', 4)
    inv:set_size('fuel', 1)
    inv:set_size('upgrade', 2)

    local init_lavam = {
        class = base_lavam.unlit_nodedef._terumach_class,
        state = base_lavam.STATE.IDLE,
        state_time = 0,
        heat_level = 0,
        max_heat = opts.MAX_HEAT,
        status_text = 'New',
        inv = inv,
        meta = meta,
        pos = pos,
    }
    base_mach.write_state(pos, init_lavam)
end

function base_lavam.get_drop_contents(machine)
    local drops = {}
    default.get_inventory_drops(machine.pos, 'in', drops)
    default.get_inventory_drops(machine.pos, 'fuel', drops)
    default.get_inventory_drops(machine.pos, 'upgrade', drops)
    return drops
end

function base_lavam.do_processing(lavam, dt)
    if base_mach.has_upgrade(lavam, 'speed_up') then dt = dt * 2.0 end

    local heat_req = lavam.heat_cost * math.min(dt, lavam.state_time)
    if lavam.state == base_lavam.STATE.MELT and base_mach.expend_heat(lavam, heat_req, 'Melting stone') then
        lavam.state_time = lavam.state_time - dt
        if lavam.state_time <= 0 then
            lavam.state = base_lavam.STATE.DISPENSE
            lavam.state_time = 0
        else
            lavam.status_text = 'Melting stone... (' .. terumet.format_time(lavam.state_time) .. ')'
        end
    end
    if lavam.state == base_lavam.STATE.DISPENSE then
        local dispense_pos = terumet.util3d.get_relative_pos(lavam.rot, lavam.pos, 'front')
        local dispense_node = minetest.get_node_or_nil(dispense_pos)
        if dispense_node and dispense_node.name == 'air' then
            dispense_node.name = 'default:lava_source'
            minetest.set_node(dispense_pos, dispense_node)
            lavam.status_text = 'Lava dispensed'
            lavam.state = base_lavam.STATE.IDLE
        else
            lavam.status_text = 'Waiting for space to dispense lava'
        end
    end
end

function base_lavam.check_new_processing(lavam)
    if lavam.state ~= base_lavam.STATE.IDLE then return end
    local in_inv, in_list = base_mach.get_input(lavam)
    if not in_inv then
        lavam.status_text = "No input"
        return
    end
    for slot = 1,in_inv:get_size(in_list) do
        local input_stack = in_inv:get_stack(in_list, slot)
        local total_heat_required = opts.VALID_STONES[input_stack:get_name()]
        if total_heat_required then
            in_inv:remove_item(in_list, input_stack:get_name())
            lavam.state = base_lavam.STATE.MELT
            lavam.state_time = opts.MELT_TIME
            lavam.heat_cost = math.ceil(total_heat_required / opts.MELT_TIME)
            lavam.status_text = 'Accepting ' .. input_stack:get_definition().description .. ' for melting...'
            return
        end
    end
    -- at this point nothing we can do
    lavam.status_text = 'Idle'
end

function base_lavam.tick(pos, dt)
    -- read state from meta
    local lavam = base_mach.tick_read_state(pos)
    local reset_timer = false
    if not base_mach.check_overheat(lavam, opts.MAX_HEAT) then
        base_lavam.do_processing(lavam, dt)
        base_lavam.check_new_processing(lavam)
        base_mach.process_fuel(lavam)
    end

    if lavam.state ~= base_lavam.STATE.IDLE and (not lavam.need_heat) then
        -- if still processing and not waiting for heat, reset timer to continue processing
        reset_timer = true
        base_mach.set_node(pos, base_lavam.lit_id)
        base_mach.generate_smoke(pos)
    else
        base_mach.set_node(pos, base_lavam.unlit_id)
    end

    -- other states to automatically reset timer, but not appear lit
    if base_mach.has_ext_input(lavam) then
        reset_timer = true
    end
    -- write status back to meta
    base_mach.write_state(pos, lavam)

    -- if you return true from an on_timer callback, it automatically resets timer to last timeout
    return reset_timer
end

base_lavam.unlit_nodedef = base_mach.nodedef{
    -- node properties
    description = "Lava Melter",
    tiles = {
        terumet.tex('lavam_top'), terumet.tex('raw_mach_bot'),
        terumet.tex('raw_sides_unlit'), terumet.tex('raw_sides_unlit'),
        terumet.tex('raw_sides_unlit'), terumet.tex('lavam_front_unlit')
    },
    -- callbacks
    on_construct = base_lavam.init,
    on_timer = base_lavam.tick,
    -- machine class data
    _terumach_class = {
        name = 'Lava Melter',
        valid_upgrades = terumet.valid_upgrade_sets{'input'},
        timer = 1.0,
        fsdef = FSDEF,
        default_heat_xfer = base_mach.HEAT_XFER_MODE.ACCEPT,
        drop_id = base_lavam.unlit_id,
        get_drop_contents = base_lavam.get_drop_contents,
        on_read_state = function(lavam)
            lavam.heat_cost = lavam.meta:get_int('heatcost') or 0
        end,
        on_write_state = function(lavam)
            lavam.meta:set_int('heatcost', lavam.heat_cost or 0)
        end
    }
}

base_lavam.lit_nodedef = {}
for k,v in pairs(base_lavam.unlit_nodedef) do base_lavam.lit_nodedef[k] = v end
base_lavam.lit_nodedef.on_construct = nil -- lit node shouldn't be constructed by player
base_lavam.lit_nodedef.tiles = {
    terumet.tex('lavam_top'), terumet.tex('raw_mach_bot'),
    terumet.tex('raw_sides_lit'), terumet.tex('raw_sides_lit'),
    terumet.tex('raw_sides_lit'), terumet.tex('lavam_front_lit')
}
base_lavam.lit_nodedef.groups= terumet.create_lit_node_groups(base_lavam.unlit_nodedef.groups)
base_lavam.lit_nodedef.light_source = 10

base_mach.define_machine_node(base_lavam.unlit_id, base_lavam.unlit_nodedef)
base_mach.define_machine_node(base_lavam.lit_id, base_lavam.lit_nodedef)

minetest.register_craft{ output = base_lavam.unlit_id, recipe = {
    {terumet.id('ingot_ttin'), terumet.id('item_heater_basic'), terumet.id('ingot_ttin')},
    {terumet.id('item_heater_basic'), terumet.id('frame_raw'), terumet.id('item_heater_basic')},
    {terumet.id('ingot_ttin'), terumet.id('item_heater_basic'), terumet.id('ingot_ttin')}
}}