local base_mach = terumet.machine
local util3d = terumet.util3d

local FMT = string.format

local SPECIAL_OWNERS = {
    [''] = '<None>',
    ['*'] = '<Everyone>'
}

-- UNUSED TEST
-- local fs_container = function(fsx,fsy,machine,content_func)
--    return FMT('container[%f,%f]%scontainer_end[]', fsx, fsy, func(machine))
-- end

base_mach.buttondefs = {}
-- standard control button to toggle on/off heat transfer
base_mach.buttondefs.HEAT_XFER_TOGGLE = {
    flag = function(machine)
        return machine.heat_xfer_mode == machine.class.default_heat_xfer
    end,
    icon = 'terumet_gui_heatxfer.png',
    name = 'hxfer_toggle',
    on_text = 'Adjacent Heat Transfer on',
    off_text = 'Adjacent Heat transfer off'
}


-- build and return a formspec given a machine state
-- takes fsdef table from machine's class definition to define what is shown and where
-- _terumach_class.fsdef guidelines: is a table with definitions for sections or elements. Nearly all info is optional and will be given standard defaults (or omitted) if not provided
--      .size  -> must be a table with {x=width, y=height} (in item slots, like normal formspec dimensions), size defaults to 11x9 if not given
--      .theme -> string that provides full background, listcolors
--      .bg -> filename (without terumet or png) of backgroud image
--      .before  -> fn(machine) that returns formspec string to insert after preamble
--      .control -> fn(machine) that returns formspec string to insert inside machine controls container
--      .control_buttons -> table of machine buttondefs:
--              .flag -> string of machine flag or function that returns whether control is on/off
--              .icon -> image to use as base icon for button
--              .name -> id to assign to button (returned as field to machine's on_form_action)
--              .on_text + .off_text -> tooltips when on/off
--      .machine -> fn(machine) that returns formspec string to insert inside main machine container
--      .status_text -> {x,y} to reposition status text or 'hide' to not show
--      .input -> {true} or {x,y,w,h} that input slots/info should be shown (2x2 slots if no width/height provided)
--      .output -> {true} or {x,y,w,h} that output slots/info should be shown (2x2 slots if no width/height provided)
--      .fuel_slot -> {true} or {x,y} that fuel slot should be shown in control section
--      .player_inv -> {x,y} that repositions player inventory, or 'hide' to not show
--      .list_rings -> formspec string that defines list rings, otherwise: player;main -> machine;in -> player;main -> machine;out ->
--      .after -> fn(machine) that returns formspec string to insert after all other formspec content
function base_mach.build_fs(machine)
    local ext_output = base_mach.has_ext_output(machine)
    local ext_input = base_mach.has_ext_input(machine)
    --minetest.log('info', dump(machine))
    local fsdef = machine.class.fsdef
    -- start/misc section
    local fs_width = (fsdef.size and fsdef.size.x) or 11
    local fs_height = (fsdef.size and fsdef.size.y) or 9
    local fs = FMT('size[%f,%f]', fs_width, fs_height)
    fs = fs .. (fsdef.theme or FMT('background[0,0;%f,%f;terumet_%s.png;true]listcolors[#00000060;#000000C0;#00000000;#404040;#f0f0f0]', fs_width, fs_height, fsdef.bg or 'gui_back'))
    if fsdef.before then
        fs = fs .. fsdef.before(machine)
    end
    -- control container
    fs = fs..'container[0,0]'
    fs = fs..FMT('label[0,0;%s]', machine.class.name)
    if machine.heat_level > machine.max_heat then
        fs = fs..'image[0,0.5;3.5,1;terumet_gui_overheat.png^[transformR270]label[1.2,0.9;Overheated]'
    else
        fs = fs..base_mach.fs_meter(0,0.5, 'heat', base_mach.heat_pct(machine), FMT('%d HU', base_mach.get_current_heat(machine)))
    end
    -- DEBUG
    --fs=fs..FMT('label[0.3,1.3;Pending: %d]', machine.meta:get_int('pending_heat_xfer') or -1)
    -- control: fuel_slot
    if fsdef.fuel_slot then
        local fsx = fsdef.fuel_slot.x or 0
        local fsy = fsdef.fuel_slot.y or 1.5
        fs = fs..FMT('label[%f,%f;Heat In]list[context;fuel;%f,%f;1,1;]', fsx, fsy, fsx, fsy+0.5)
    end
    -- control: battery_slot
    if fsdef.battery_slot then
        local fsx = fsdef.battery_slot.x or 1.5
        local fsy = fsdef.battery_slot.y or 1.5
        fs = fs..FMT('label[%f,%f;Heat Out]list[context;battery;%f,%f;1,1;]', fsx, fsy, fsx, fsy+0.5)
    end
    -- control: upgrade slots
    local upg_ct = machine.inv:get_size('upgrade')
    if upg_ct and upg_ct > 0 then
        local upx = 0
        local upy = fs_height - 2.5
        fs = fs..FMT('label[%f,%f;Upgrades]list[context;upgrade;%f,%f;3,%d]', upx, upy, upx, upy+0.5, math.ceil(upg_ct/3))
    end
    --fs = fs..FMT('label[0,%f;HU Xfer: %s]', fs_height - 1, opts.HEAT_TRANSFER_MODE_NAMES[machine.heat_xfer_mode])
    fs = fs..FMT('label[0,%f;Owner: %s]', fs_height - 0.25, SPECIAL_OWNERS[machine.owner] or machine.owner or "(BUG)none")
    if fsdef.control then
        fs = fs .. fsdef.control(machine)
    end
    -- DEBUG
    -- fs = fs..FMT('label[0,%f;State: %d]', fs_height - 0.25, machine.state or 'nil')
    -- control: buttons container
    fs = fs..'container[0,3]'

    local btx = 0
    local bty = 0
    for _, buttondef in ipairs(fsdef.control_buttons) do
        if buttondef.flag then
            local flag_on = false
            if type(buttondef.flag) == 'string' then
                flag_on = machine[buttondef.flag]
            elseif type(buttondef.flag) == 'function' then
                flag_on = buttondef.flag(machine)
            end
            if flag_on then
                fs = fs .. FMT('image_button[%f,%f;0.75,0.75;%s;%s; ]tooltip[%s;%s]',
                    btx, bty, buttondef.icon, buttondef.name, buttondef.name, buttondef.on_text)
            else
                fs = fs .. FMT('image_button[%f,%f;0.75,0.75;(%s^terumet_gui_disabled.png);%s; ]tooltip[%s;%s]',
                    btx, bty, buttondef.icon, buttondef.name, buttondef.name, buttondef.off_text)
            end
            btx = btx + 0.75
            if btx >= 4 then
                btx = 0
                bty = bty + 0.75
            end
        end
    end

    -- machine container
    fs = fs..'container_end[]container_end[]container[3,0]'
    if 'hide' ~= fsdef.status_text then
        local sttx = (fsdef.status_text and fsdef.status_text.x) or 0
        local stty = (fsdef.status_text and fsdef.status_text.y) or 0
        fs = fs..FMT('label[%f,%f;%s]', sttx, stty, machine.status_text)
    end
    if fsdef.machine then
        fs = fs .. fsdef.machine(machine)
    end

    -- machine: input
    if fsdef.input then
        local inpx = fsdef.input.x or 0.5
        local inpy = fsdef.input.y or 1
        local inpw = fsdef.input.w or 2
        local inph = fsdef.input.h or 2
        local inname = fsdef.input.label or "Input"
        if ext_input then
            local input_node = minetest.get_node(util3d.get_relative_pos(machine.rot, machine.pos, machine.input_side))
            fs = fs .. FMT('label[%f,%f;External %s]item_image[%f,%f;%d,%d;%s]', inpx, inpy, inname, inpx, inpy+0.5, inpw, inph, input_node.name)
            fs = fs .. FMT('image_button[%f,%f;1.0,1.0;%s;%s; ]tooltip[%s;%s]',
                inpx+0.5, inpy+2.5, FMT('terumet_gui_side%d.png', machine.input_side), 'input_side', 'input_side', FMT('External %s Side', inname))
        else
            fs = fs .. FMT('label[%f,%f;%s]list[context;in;%f,%f;%d,%d;]', inpx, inpy, inname, inpx, inpy+0.5, inpw, inph)
        end
    end
    -- machine: output
    if fsdef.output then
        local outx = fsdef.output.x or 5.5
        local outy = fsdef.output.y or 1
        local outw = fsdef.output.w or 2
        local outh = fsdef.output.h or 2
        local outname = fsdef.output.label or "Output"
        if ext_output then
            local output_node = minetest.get_node(util3d.get_relative_pos(machine.rot, machine.pos, machine.output_side))
            fs = fs .. FMT('label[%f,%f;External %s]item_image[%f,%f;%d,%d;%s]', outx, outy, outname, outx, outy+0.5, outw, outh, output_node.name)
            fs = fs .. FMT('image_button[%f,%f;1.0,1.0;%s;%s; ]tooltip[%s;%s]',
                outx+0.5, outy+2.5, FMT('terumet_gui_side%d.png', machine.output_side), 'output_side', 'output_side', FMT('External %s Side', outname))
        else
            fs = fs .. FMT('label[%f,%f;%s]list[context;out;%f,%f;%d,%d;]', outx, outy, outname, outx, outy+0.5, outw, outh)
        end
    end
    fs = fs..'container_end[]'
    -- player inventory
    if 'hide' ~= fsdef.player_inv then
        local pix = (fsdef.player_inv and fsdef.player_inv.x) or 3
        local piy = (fsdef.player_inv and fsdef.player_inv.y) or fs_height - 4.25
        fs = fs..FMT('list[current_player;main;%f,%f;8,1;]list[current_player;main;%f,%f;8,3;8]', pix, piy, pix, piy+1.25)
    end
    -- list rings
    if fsdef.list_rings then
        fs = fs..fsdef.list_rings
    else
        fs = fs..'listring[current_player;main]listring[context;in]listring[current_player;main]listring[context;out]'
    end
    if fsdef.after then
        fs = fs .. fsdef.after(machine)
    end
    --minetest.log('warn', fs)
    return fs
end

function base_mach.build_infotext(machine)
    return FMT('%s (%.1f%% HU): %s', machine.class.name, base_mach.heat_pct(machine), machine.status_text)
end

-- basic process display
function base_mach.fs_proc(fsx, fsy, proc, itemstack)
    if itemstack and not itemstack:is_empty() then
        local count = itemstack:get_count()
        if count > 1 then
            return FMT('image[%f,%f;2,2;terumet_gui_proc_%s.png]item_image[%f,%f;1,1;%s]label[%f,%f;x%d]',
                fsx, fsy, proc, fsx+0.4, fsy+0.4, itemstack:get_name(), fsx+1,fsy+1.3, count)
        else
            return FMT('image[%f,%f;2,2;terumet_gui_proc_%s.png]item_image[%f,%f;1,1;%s]',
                fsx, fsy, proc, fsx+0.4, fsy+0.4, itemstack:get_name())
        end
    else
        return FMT('image[%f,%f;2,2;terumet_gui_proc_%s.png]', fsx, fsy, proc)
    end
end

-- basic meter display
function base_mach.fs_meter(fsx, fsy, id, fill, text)
    return FMT('label[%f,%f;%s]image[%f,%f;3.5,1;(terumet_gui_bg_%s.png^[lowpart:%f:terumet_gui_fg_%s.png)^[transformR270]',
        fsx+0.7,fsy+0.4,text, fsx, fsy, id, fill, id)
end

-- double meter display (no text)
function base_mach.fs_double_meter(fsx, fsy, mainid, mainfill, oppid, oppfill)
    return FMT('image[%f,%f;3.5,1;(terumet_gui_bg_%s.png^[lowpart:%f:terumet_gui_fg_%s.png^[lowpart:%f:terumet_gui_fg_%s.png)^[transformR270]',
        fsx, fsy, mainid, mainfill, mainid, oppfill, oppid)
end