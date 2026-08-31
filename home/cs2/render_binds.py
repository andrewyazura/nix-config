import re
import sys
from xml.sax.saxutils import escape

CATS = {
    "move": ("#14532d", "#4ade80"),
    "combat": ("#7c2d12", "#fb923c"),
    "buy": ("#713f12", "#facc15"),
    "comms": ("#1e3a8a", "#93c5fd"),
    "practice": ("#581c87", "#d8b4fe"),
    "misc": ("#334155", "#cbd5e1"),
}

CAT_NAMES = {
    "move": "Movement",
    "combat": "Combat",
    "buy": "Buy & utility",
    "comms": "Communication",
    "practice": "Practice",
    "misc": "Misc",
}

RULES = [
    ("buy smokegrenade", "Buy smoke", "buy"),
    ("buy hegrenade", "Buy HE", "buy"),
    ("buy molotov", "Buy molly", "buy"),
    ("buy flashbang", "Buy flash", "buy"),
    ("buymenu", "Buy menu", "buy"),
    ("sv_rethrow_last_grenade", "Rethrow nade", "practice"),
    ("ent_fire", "Clear smokes", "practice"),
    ("bot_place", "Place bot", "practice"),
    ("bot_stop", "Bot stop", "practice"),
    ("bot_crouch", "Bot crouch", "practice"),
    ("bot_kick", "Kick bots", "practice"),
    ("noclip", "Noclip", "practice"),
    ("+forward", "Forward", "move"),
    ("+back", "Back", "move"),
    ("+left", "Left", "move"),
    ("+right", "Right", "move"),
    ("+jump", "Jump", "move"),
    ("+duck", "Duck", "move"),
    ("+sprint", "Walk", "move"),
    ("+attack2", "Alt fire", "combat"),
    ("+attack", "Fire", "combat"),
    ("autobuy", "Autobuy", "buy"),
    ("rebuy", "Rebuy", "buy"),
    ("buyammo2", "Buy ammo", "buy"),
    ("sellbackall", "Sell all", "buy"),
    ("jpeg", "Screenshot", "misc"),
    ("cancelselect", "Menu", "misc"),
    ("quit", "Quit", "misc"),
    ("save quick", "Quick save", "misc"),
    ("load quick", "Quick load", "misc"),
    ("show_loadout_toggle", "Loadout", "misc"),
    ("player_ping", "Ping", "comms"),
    ("cl_hud_telemetry_serverrecvmargin", "Net graph", "misc"),
    ("+lookatweapon", "Inspect", "misc"),
    ("+reload", "Reload", "combat"),
    ("+use", "Use", "combat"),
    ("+spray_menu", "Spray menu", "combat"),
    ("drop", "Drop", "combat"),
    ("slot10", "Molotov", "combat"),
    ("slot1", "Primary", "combat"),
    ("slot2", "Pistol", "combat"),
    ("slot3", "Knife", "combat"),
    ("slot4", "Cycle nade", "combat"),
    ("slot5", "Bomb", "combat"),
    ("slot6", "HE", "combat"),
    ("slot7", "Flash", "combat"),
    ("slot8", "Smoke", "combat"),
    ("slot9", "Decoy", "combat"),
    ("messagemode2", "Team chat", "comms"),
    ("messagemode", "All chat", "comms"),
    ("+voicerecord", "Push-to-talk", "comms"),
    ("+radialradio", "Radio wheel", "comms"),
    ("voice_modenable", "Voice on/off", "comms"),
    ("say ", "Say: eng?", "comms"),
    ("+showscores", "Scoreboard", "misc"),
    ("teammenu", "Team menu", "misc"),
    ("toggleconsole", "Console", "misc"),
    ("switchhands", "Swap hands", "misc"),
    ("toggle_viewmodel", "Viewmodel", "misc"),
    ("cl_crosshair_recoil", "XHair recoil", "misc"),
]

ROWS = [
    [("escape", "Esc", 1), ("f1", "F1", 1), ("f2", "F2", 1), ("f3", "F3", 1), ("f4", "F4", 1),
     ("f5", "F5", 1), ("f6", "F6", 1), ("f7", "F7", 1), ("f8", "F8", 1), ("f9", "F9", 1),
     ("f10", "F10", 1), ("f11", "F11", 1), ("f12", "F12", 1)],
    [("`", "`", 1), ("1", "1", 1), ("2", "2", 1), ("3", "3", 1), ("4", "4", 1),
     ("5", "5", 1), ("6", "6", 1), ("7", "7", 1), ("8", "8", 1), ("9", "9", 1),
     ("0", "0", 1), ("-", "-", 1), ("=", "=", 1), ("backspace", "Bksp", 2)],
    [("tab", "Tab", 1.5), ("q", "Q", 1), ("w", "W", 1), ("e", "E", 1), ("r", "R", 1),
     ("t", "T", 1), ("y", "Y", 1), ("u", "U", 1), ("i", "I", 1), ("o", "O", 1),
     ("p", "P", 1), ("[", "[", 1), ("]", "]", 1), ("\\", "\\", 1.5)],
    [("capslock", "Caps", 1.75), ("a", "A", 1), ("s", "S", 1), ("d", "D", 1), ("f", "F", 1),
     ("g", "G", 1), ("h", "H", 1), ("j", "J", 1), ("k", "K", 1), ("l", "L", 1),
     (";", ";", 1), ("'", "'", 1), ("enter", "Enter", 2.25)],
    [("shift", "Shift", 2.25), ("z", "Z", 1), ("x", "X", 1), ("c", "C", 1), ("v", "V", 1),
     ("b", "B", 1), ("n", "N", 1), ("m", "M", 1), (",", ",", 1), (".", ".", 1),
     ("/", "/", 1), ("rshift", "Shift", 2.75)],
    [("ctrl", "Ctrl", 1.25), ("lwin", "Win", 1.25), ("alt", "Alt", 1.25),
     ("space", "Space", 6.25), ("ralt", "Alt", 1.25), ("fn", "Fn", 1.25),
     ("menu", "Menu", 1.25), ("rctrl", "Ctrl", 1.25)],
]

MOUSE = [
    [("mouse1", "M1", 1.5), ("mouse2", "M2", 1.5)],
    [("mwheelup", "Whl up", 1.5), ("mouse4", "M4", 1.5)],
    [("mwheeldown", "Whl dn", 1.5), ("mouse5", "M5", 1.5)],
]

ARROWS = [
    (0, [("mouse3", "M3", 1.5), ("del", "Del", 1.5)]),
    (1, [("uparrow", "Up", 1)]),
    (0, [("leftarrow", "Left", 1), ("downarrow", "Down", 1), ("rightarrow", "Right", 1)]),
]

U = 58
PAD = 24
TOP = 70


def parse_binds(path):
    binds = {}
    for line in open(path, encoding="utf-8"):
        m = re.match(r'\s*bind\s+"([^"]+)"\s+"([^"]+)"', line)
        if m:
            binds[m.group(1).lower()] = m.group(2)
    return binds


def describe(cmd):
    for needle, label, cat in RULES:
        if needle in cmd:
            return label, cat
    return cmd.split()[0][:12], "misc"


def wrap(label):
    if len(label) <= 8 or " " not in label:
        return [label]
    i = min(range(len(label)), key=lambda j: abs(j - len(label) // 2) if label[j] == " " else 999)
    return [label[:i], label[i + 1:]]


def draw_key(out, x, y, w, cap, bind):
    kw, kh = w * U - 6, U - 6
    if bind:
        label, cat = describe(bind)
        fill, accent = CATS[cat]
        cap_fill, stroke = accent, accent
    else:
        label, fill, stroke, cap_fill = None, "#16202f", "#233043", "#475569"
    out.append(f'<rect x="{x + 3}" y="{y + 3}" width="{kw}" height="{kh}" rx="8" '
               f'fill="{fill}" stroke="{stroke}" stroke-opacity="0.55"/>')
    out.append(f'<text x="{x + 10}" y="{y + 17}" font-size="10" fill="{cap_fill}">{escape(cap)}</text>')
    if label:
        lines = wrap(label)
        cy = y + U / 2 + (7 if len(lines) == 1 else 1)
        for i, ln in enumerate(lines):
            squeeze = f' textLength="{kw - 10}" lengthAdjust="spacingAndGlyphs"' if len(ln) * 6.5 > kw - 8 else ""
            out.append(f'<text x="{x + w * U / 2}" y="{cy + i * 13}" font-size="11.5" '
                       f'font-weight="600" text-anchor="middle" fill="#e2e8f0"{squeeze}>{escape(ln)}</text>')


def main():
    binds = parse_binds(sys.argv[1])
    rows_n = len(ROWS)
    kb_w = 15 * U
    right_x = PAD + kb_w + 30
    width = right_x + 3 * U + PAD
    height = TOP + rows_n * U + 90
    out = [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" '
        f'viewBox="0 0 {width} {height}" font-family="ui-sans-serif, -apple-system, Segoe UI, sans-serif">',
        f'<rect width="{width}" height="{height}" fill="#0f172a"/>',
        f'<text x="{PAD}" y="42" font-size="20" font-weight="700" fill="#f1f5f9">CS2 binds</text>',
        f'<text x="{right_x + 3}" y="{TOP - 8}" font-size="11" fill="#64748b">MOUSE</text>',
    ]
    for r, row in enumerate(ROWS):
        x = PAD
        for key, cap, w in row:
            draw_key(out, x, TOP + r * U, w, cap, binds.get(key))
            x += w * U
    for r, row in enumerate(MOUSE):
        x = right_x
        for key, cap, w in row:
            draw_key(out, x, TOP + r * U, w, cap, binds.get(key))
            x += w * U
    for r, (off, row) in enumerate(ARROWS):
        x = right_x + off * U
        for key, cap, w in row:
            draw_key(out, x, TOP + (rows_n - 3 + r) * U, w, cap, binds.get(key))
            x += w * U
    lx, ly = PAD, TOP + rows_n * U + 38
    for cat, name in CAT_NAMES.items():
        fill, accent = CATS[cat]
        out.append(f'<rect x="{lx}" y="{ly - 12}" width="14" height="14" rx="4" '
                   f'fill="{fill}" stroke="{accent}" stroke-opacity="0.55"/>')
        out.append(f'<text x="{lx + 20}" y="{ly}" font-size="12" fill="#94a3b8">{escape(name)}</text>')
        lx += 20 + 8 * len(name) + 34
    out.append('</svg>')
    print("\n".join(out))


main()
