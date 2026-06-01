--==============================================================================
--[[
    HealBot GUI — clickable text panel, no external addon dependencies.
    Uses Windower's built-in texts library and mouse click event.

    Commands:
      //hb gui              — toggle panel
      //hb gui pos <x> <y>  — reposition panel

    Clicking:
      Left-click  row      — toggle / activate / decrease numeric value
      Right-click row      — increase numeric value (on rows with [–] [+])
      Left/right-click [–]/[+] — the panel splits at its midpoint; left half
                                 fires the decrease action, right fires increase
--]]
--==============================================================================

local gui   = {}
local texts = require('texts')

-- ── Layout ─────────────────────────────────────────────────────────────────
-- LINE_H and TOP_PAD control hit-test accuracy. Tune them if clicks
-- consistently land one row off (increase LINE_H) or feel top-shifted
-- (increase TOP_PAD).
local LINE_H  = 13   -- approximate pixel height of each text line
local TOP_PAD = 5    -- pixel gap above the first line inside the box

local panel_x = 50
local panel_y = 150
local panel_w = 290  -- approximate panel pixel width (for left/right split)

-- ── Panel text box ─────────────────────────────────────────────────────────
local panel = texts.new({
    pos    = {x=panel_x, y=panel_y},
    text   = {font='Arial', size=10},
    bg     = {alpha=220, red=12, green=12, blue=12, visible=true},
    stroke = {alpha=180, red=80,  green=80,  blue=80,  width=1},
    flags  = {},
})
panel:visible(false)

-- ── Section collapse state ─────────────────────────────────────────────────
local sections = {healing=true, job=true, follow=true, assist=true}

-- ── Row table — rebuilt each gui.render() call ─────────────────────────────
-- {text=string, left_fn=fn|nil, right_fn=fn|nil}
--   left_fn  : fires on left-click (or whole-line click when right_fn==nil)
--   right_fn : fires on right-click / right-half click (numeric increase)
local rows = {}

-- ── Markup helpers ─────────────────────────────────────────────────────────
local function cs(r,g,b,s) return ('\\cs(%d,%d,%d)%s\\cr'):format(r,g,b,s) end
local function chk(v)  return v and cs(100,255,100,'[✓]') or cs(155,155,155,'[ ]') end
local function hdr(s)  return cs(255,195,55, s) end
local function dim(s)  return cs(145,145,145, s) end
local function grn(s)  return cs(100,220,100, s) end
local function cyn(s)  return cs(100,195,255, s) end
local function adj(s)  return cyn(s) end   -- colour for [–] / [+] controls

-- ── Row builder helpers ────────────────────────────────────────────────────
local function add(text, left_fn, right_fn)
    rows[#rows+1] = {text=text, left_fn=left_fn, right_fn=right_fn}
end
local function gap() add('', nil, nil) end

local function section_hdr(key, label)
    add(hdr((sections[key] and '[v]' or '[>]')..' '..label),
        function() sections[key] = not sections[key] end)
end

-- ── Panel content builder ──────────────────────────────────────────────────
local function build()
    rows = {}

    -- Title bar
    add(hdr('== HealBot =================================='), nil)

    -- Active toggle
    local on_str = hb.active
        and cs(80,220,80,'[ON ]')..'  Active'
        or  cs(220,80,80,'[OFF]')..' Active'
    add('  '..on_str, function()
        if hb.active then hb.active = false; printStatus() else hb.activate() end
    end)

    gap()

    -- ── Healing ──────────────────────────────────────────────────────────
    section_hdr('healing', 'Healing')

    if sections.healing then
        local heal_al = settings.heal_alliance or false
        add('  '..chk(heal_al)..' Alliance Healing', function()
            settings.heal_alliance = not heal_al
            atc('Alliance healing '..(settings.heal_alliance and 'ON' or 'OFF'))
        end)

        local no_cga = settings.disable and settings.disable.curaga
        add('  '..chk(not no_cga)..' Use Curaga', function()
            windower.send_command('hb '..(no_cga and 'enable' or 'disable')..' curaga')
        end)

        local mc = settings.healing and settings.healing.min and settings.healing.min.cure or 3
        add('  Min Cure Tier : '..cyn(mc)..'   '..adj('[–]')..'  '..adj('[+]'),
            function() windower.send_command('hb mincure '..math.max(1, mc - 1)) end,
            function() windower.send_command('hb mincure '..math.min(6, mc + 1)) end)

        local cmt = settings.healing and settings.healing.curaga_min_targets or 3
        add('  Curaga Min    : '..cyn(cmt)..'   '..adj('[–]')..'  '..adj('[+]'),
            function()
                settings.healing.curaga_min_targets = math.max(1, cmt - 1)
                atc('Curaga min targets: '..settings.healing.curaga_min_targets)
            end,
            function()
                settings.healing.curaga_min_targets = math.min(6, cmt + 1)
                atc('Curaga min targets: '..settings.healing.curaga_min_targets)
            end)
    end

    gap()

    -- ── Job Abilities ─────────────────────────────────────────────────────
    section_hdr('job', 'Job Abilities')

    if sections.job then
        local use_dc = settings.use_divine_caress or false
        add('  '..chk(use_dc)..' Divine Caress', function()
            windower.send_command('hb divinecaress '..(use_dc and 'off' or 'on'))
        end)

        local aoe = settings.aoe_na or false
        add('  '..chk(aoe)..' AoE NA  (Accession / Divine Seal)', function()
            settings.aoe_na = not aoe
            atc('AoE NA '..(settings.aoe_na and 'ON' or 'OFF'))
        end)

        local na_s = settings.na_stratagem and grn(settings.na_stratagem) or dim('(none)')
        add('  NA Stratagem  : '..na_s, function()
            atc(cyn('Set via: ')..'//hb nastratagem <name>  '..dim('| nastrat off to clear'))
        end)

        local cu_s = settings.cure_stratagem and grn(settings.cure_stratagem) or dim('(none)')
        add('  Cure Stratagem: '..cu_s, function()
            atc(cyn('Set via: ')..'//hb curestratagem <name>  '..dim('| curestrat off to clear'))
        end)
    end

    gap()

    -- ── Follow ────────────────────────────────────────────────────────────
    section_hdr('follow', 'Follow')

    if sections.follow then
        local fon = settings.follow and settings.follow.active or false
        add('  '..chk(fon)..' Following', function()
            windower.send_command('hb follow '..(fon and 'off' or 'resume'))
        end)

        local ft = settings.follow and settings.follow.target
        add('  Target   : '..(ft and grn(ft) or dim('(none)')), function()
            atc(cyn('Set via: ')..'//hb follow <player name>')
        end)

        local fd = settings.follow and settings.follow.distance or 3.0
        add('  Distance : '..cyn(('%.1f'):format(fd))..'   '..adj('[–]')..'  '..adj('[+]'),
            function() windower.send_command('hb follow dist '..math.max(0.5, fd - 0.5)) end,
            function() windower.send_command('hb follow dist '..math.min(44.0, fd + 0.5)) end)
    end

    gap()

    -- ── Assist ────────────────────────────────────────────────────────────
    section_hdr('assist', 'Assist')

    if sections.assist then
        local aon = offense.assist and offense.assist.active or false
        add('  '..chk(aon)..' Assisting', function()
            windower.send_command('hb assist '..(aon and 'off' or 'resume'))
        end)

        local at = offense.assist and offense.assist.name
        add('  Target   : '..(at and grn(at) or dim('(none)')), function()
            atc(cyn('Set via: ')..'//hb assist <player name>')
        end)

        local eng = offense.assist and offense.assist.engage or false
        add('  '..chk(eng)..' Engage', function()
            windower.send_command('hb assist attack '..(eng and 'off' or 'on'))
        end)

        local noa = offense.assist and offense.assist.noapproach or false
        add('  '..chk(noa)..' No Approach', function()
            windower.send_command('hb assist noapproach '..(noa and 'off' or 'on'))
        end)
    end

    gap()
    add(dim('  left-click: toggle/decrease   right-click: increase'), nil)

    -- Push to text box
    local lines = {}
    for _, r in ipairs(rows) do lines[#lines+1] = r.text end
    panel:text(table.concat(lines, '\n'))
end

-- ── Click dispatcher ───────────────────────────────────────────────────────
local function dispatch(is_right, x, y)
    local rel_y = y - panel_y - TOP_PAD
    if rel_y < 0 then return end
    local idx = math.floor(rel_y / LINE_H) + 1
    if idx < 1 or idx > #rows then return end

    local r = rows[idx]
    -- Right-half of panel → prefer the right_fn (increase); left-half → left_fn
    local right_side = (x >= panel_x + panel_w / 2)

    if (is_right or right_side) and r.right_fn then
        r.right_fn()
    elseif r.left_fn then
        r.left_fn()
    end
end

windower.register_event('mouse click', function(btn, x, y, delta, blocked)
    if not gui.visible or blocked then return end
    -- Coarse bounds check to avoid intercepting every game click
    if x < panel_x or x > panel_x + panel_w or y < panel_y then return end

    if btn == 0 then       -- left press
        dispatch(false, x, y)
        return true        -- block click from reaching the game
    elseif btn == 2 then   -- right press
        dispatch(true, x, y)
        return true
    end
end)

-- ── Public API ─────────────────────────────────────────────────────────────
gui.visible = false

function gui.init() end   -- no imgui buffers; build() reads live from settings

function gui.render()
    if not gui.visible or not hb.configs_loaded then return end
    build()
end

function gui.show()
    gui.visible = true
    panel:visible(true)
    atc('HealBot GUI shown.  Left-click: toggle/decrease.  Right-click: increase.')
end

function gui.hide()
    gui.visible = false
    panel:visible(false)
end

function gui.toggle()
    if gui.visible then gui.hide() else gui.show() end
end

function gui.set_pos(x, y)
    panel_x = x
    panel_y = y
    panel:pos(x, y)
    atc(('GUI repositioned to %d, %d'):format(x, y))
end

return gui

--==============================================================================
