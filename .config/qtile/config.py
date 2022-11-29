import os
import subprocess
import re

from libqtile import bar, layout, widget, hook, qtile
from libqtile.config import (
    Click,
    Drag,
    Group,
    Key,
    Match,
    Screen,
    ScratchPad,
    DropDown,
    KeyChord,
)
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

# from graphical_notifications import Notifier

PATH = "/home/krishnan/Downloads/google-cloud-sdk/bin:/home/krishnan/.cabal/bin:/home/krishnan/.ghcup/bin:/home/krishnan/.nvm/versions/node/v14.15.0/bin:/home/krishnan/.cargo/bin:/home/krishnan/.deno/bin:/home/krishnan/.emacs.d/bin:/home/krishnan/go/bin:/home/krishnan/gems/bin:/home/krishnan/.cargo/bin:/home/krishnan/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/snap/bin"


def init_layout_theme():
    return {
        "margin": 0,
        "border_width": 1,
        "border_focus": "#61aeef",
        "border_normal": "#1D2330",
    }


def titleParser(text):
    for string in [" - Chromium", " - Firefox", " - Google Chrome"]:
        if string in text:
            text = string
            text = text.replace(" - ", "")
            return text
    return text


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.Popen([home])


mod = "mod4"
terminal = guess_terminal()
# notifier = Notifier(corner_radius=50)

CHROME_PROFILE = "Profile 1"
MAIL_LINK = "https://mail.google.com/mail/u/0/#inbox"

# [ "", "", "", "爵", "ﰩ", "", "", "", "ﱟ" ]
groups = [
    Group("main", layout="columns"),
    Group("dev", layout="columns", spawn=["env WINIT_X11_SCALE_FACTOR=1.4 alacritty -e tmux"]),
    Group(
        "code",
        layout="columns",
        matches=[Match(wm_class="Insomnia"), Match(wm_class="Code")],
    ),
    Group(
        "www",
        layout="columns",
        spawn=["google-chrome-work 'http://localhost:7311'"],
        matches=[Match(title="Quicklinks"), Match(wm_instance_class="google-chrome")],
    ),
    Group("extra", layout="columns"),
    Group("vi", layout="columns"),
    Group("vm", layout="columns"),
    Group(
        "meet",
        layout="columns",
        matches=[
            Match(wm_instance_class=r"meet.google.com.*"),
        ],
    ),
    Group(
        "comm",
        layout="columns",
        spawn=[
            f"google-chrome-stable --new-window --profile-directory='{CHROME_PROFILE}' --app='{MAIL_LINK}'"
        ],
        matches=[
            Match(wm_instance_class="mail.google.com__mail_u_0"),
        ],
    ),
]

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "n", lazy.layout.next(), desc="Move window focus to next window"),
    # Key([mod], "m", qtile.current_group.cmd_next_window(), desc="Toggle minimize window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    # Key([mod], "equal", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod], "w", lazy.next_screen(), desc="Switch to next screen/monitor"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod],
        "e",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key(
        [mod, "shift"],
        "Return",
        lazy.spawn("env WINIT_X11_SCALE_FACTOR=1.4 alacritty"),
        desc="Launch terminal",
    ),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle next layout"),
    Key([mod, "shift"], "Tab", lazy.prev_layout(), desc="Toggle previous layout"),
    Key([mod, "shift"], "c", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "q", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "shift"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key(
        [mod, "shift"],
        "z",
        lazy.spawn("xscreensaver-command -lock"),
        desc="Lock screen",
    ),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod], "p", lazy.spawn("dmenu_run -fn 'iosevka-13'"), desc="Spawn dmenu_run"),
    Key([mod], "o", lazy.spawn("rofi -show window"), desc="Spawn rofi -show"),
    Key(
        [mod], "f", lazy.spawn("rofi -show filebrowser"), desc="Spawn rofi filebrowser"
    ),
    Key(
        [mod, "shift"],
        "p",
        lazy.spawn("dmenu_cmd -fn 'iosevka-13'"),
        desc="Spawn dmenu_run",
    ),
    Key(
        [mod, "shift"],
        "semicolon",
        lazy.spawn("/home/krishnan/.local/bin/:"),
        desc="Spawn :",
    ),
    Key(
        [],
        "XF86AudioMicMute",
        lazy.spawn("amixer -D pulse sset Master toggle"),
        desc="Mute audio",
    ),
    Key(
        [],
        "XF86AudioMute",
        lazy.spawn("amixer -D pulse sset Master toggle"),
        desc="Mute audio",
    ),
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("amixer -D pulse sset Master 3%+"),
        desc="Increase volume",
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("amixer -D pulse sset Master 3%-"),
        desc="Decrease volume",
    ),
    Key(
        [],
        "XF86MonBrightnessUp",
        lazy.spawn("xbacklight -inc 10"),
        desc="Increase brightness",
    ),
    Key(
        [],
        "XF86MonBrightnessDown",
        lazy.spawn("xbacklight -dec 10"),
        desc="Decrease brightness",
    ),
    Key([], "Print", lazy.spawn("flameshot gui"), desc="Capture screenshot"),
    KeyChord(
        [mod],
        "space",
        [
            Key(
                [mod],
                "space",
                lazy.group["scratchpad"].hide_all(),
                desc="hide all dropdown windows",
            ),
            Key(
                [],
                "space",
                lazy.group["scratchpad"].hide_all(),
                desc="hide all dropdown windows",
            ),
            # Key([mod], "space", lazy.spawn(""), desc="clear keychord"),
            Key(
                [],
                "t",
                lazy.group["scratchpad"].dropdown_toggle("term"),
                desc="Dropdown terminal",
            ),
            Key(
                [],
                "r",
                lazy.group["scratchpad"].dropdown_toggle("ranger"),
                desc="Dropdown filemanager",
            ),
            Key(
                [],
                "s",
                lazy.group["scratchpad"].dropdown_toggle("spotify-tui"),
                desc="Dropdown spotify-tui client",
            ),
            Key(
                [],
                "n",
                lazy.group["scratchpad"].dropdown_toggle("notes"),
                desc="Dropdown notes",
            ),
            Key(
                [],
                "f",
                lazy.group["scratchpad"].dropdown_toggle("nautilus"),
                desc="Dropdown file explorer",
            ),
            Key(
                [],
                "c",
                lazy.group["scratchpad"].dropdown_toggle("chrome"),
                desc="Dropdown quicklinks",
            ),
            Key(
                [],
                "v",
                lazy.group["scratchpad"].dropdown_toggle("pavucontrol"),
                desc="Dropdown pavucontrol",
            ),
            Key(
                [],
                "b",
                lazy.group["scratchpad"].dropdown_toggle("firefox"),
                desc="Dropdown quicklinks",
            ),
            Key(
                [],
                "w",
                lazy.spawn(":ghw"),
                desc="Open a new web app",
            ),
            Key(
                [],
                "e",
                lazy.spawn(
                    f"env WINIT_X11_SCALE_FACTOR=1.4 PATH={PATH} neovide --multigrid --noidle"
                ),
                desc="Open a new editor",
            ),
            Key(
                [],
                "c",
                lazy.spawn("dmenu_clipboard"),
                desc="dmenu action from clipboard",
            ),
            Key(
                [],
                "l",
                lazy.spawn("redis-clear"),
                desc="clear redis",
            ),
        ],
        name="KEY-CHORD: CTRL-SPACE UP",
    ),
]

# ScratchPad
geometry_conf = {
    "width": 0.8,
    "height": 0.7,
    "x": 0.1,
    "y": 0.125,
    "opacity": 1,
    "on_focus_lost_hide": False,
}

groups.append(
    ScratchPad(
        "scratchpad",
        [
            DropDown(
                "term", "env WINIT_X11_SCALE_FACTOR=1.4 alacritty", **geometry_conf
            ),
            DropDown(
                "ranger",
                "env WINIT_X11_SCALE_FACTOR=1.4 alacritty -e ranger",
                **geometry_conf,
            ),
            DropDown(
                "spotify-tui",
                "env WINIT_X11_SCALE_FACTOR=1.4 alacritty -e spt",
                **geometry_conf,
            ),
            DropDown(
                "pavucontrol",
                "pavucontrol",
                **geometry_conf,
            ),
            DropDown(
                "notes",
                'env WINIT_X11_SCALE_FACTOR=1.4 alacritty -e nvim /home/krishnan/notes',
                # 'neovide /home/krishnan/notes',
                **geometry_conf,
            ),
            DropDown("nautilus", "nautilus", **geometry_conf),
            DropDown(
                "chrome",
                'google-chrome-stable --new-window --profile-directory="Profile 1" --app=file:///home/krishnan/quicklinks.html',
                **geometry_conf,
            ),
            DropDown(
                "firefox", "firefox", width=0.9, height=0.85, x=0.05, y=0.05, opacity=1
            ),
        ],
        label="",
    )
)

for i, j in enumerate(groups[:-1]):
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                str(i + 1),
                lazy.group[j.name].toscreen(),
                desc="Switch to group {}".format(j.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                str(i + 1),
                lazy.window.togroup(
                    j.name,
                    # switch_group=True
                ),
                desc="Move focused window to group {}".format(j.name),
            ),
        ]
    )

keys.extend(
    [
        # mod1 + letter of group = switch to group
        Key(
            [mod],
            "0",
            lazy.group["scratchpad"].toscreen(),
            desc="Switch to group {}".format("scratchpad"),
        ),
        # mod1 + shift + letter of group = switch to & move focused window to group
        Key(
            [mod, "shift"],
            "0",
            lazy.window.togroup(
                "scratchpad",
                # switch_group=True
            ),
            desc="Move focused window to group {}".format("scratchpad"),
        ),
    ]
)

# keys.extend([
#     Key([mod], 'grave', lazy.function(notifier.prev)),
#     Key([mod, 'shift'], 'grave', lazy.function(notifier.next)),
#     Key([mod, 'control'], 'grave', lazy.function(notifier.close)),
# ])

layout_theme = init_layout_theme()

layouts = [
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], **layout_theme),
    layout.Max(border_width=0),
    layout.Stack(num_stacks=2, **layout_theme),
    # layout.Bsp(**layout_theme),
    # layout.Matrix(**layout_theme),
    layout.MonadTall(single_border_width=0, single_margin=0, **layout_theme),
    layout.MonadWide(single_border_width=0, single_margin=0, **layout_theme),
    # layout.RatioTile(**layout_theme),
    # layout.Tile(**layout_theme),
    # layout.VerticalTile(**layout_theme),
    # layout.TreeTab(**layout_theme),
    # layout.Zoomy(**layout_theme),
    layout.Floating(
        margin=0, border_width=2, border_focus="#61aeef", border_normal="#ffffff"
    ),
]

widget_defaults = dict(
    font="FiraCode Nerd Font",
    fontsize=13,
    padding=3,
)

extension_defaults = widget_defaults.copy()

mysep = widget.Sep(
    padding=5,
    size_percent=40,
)

mypulsevolume = widget.PulseVolume(
    fmt="醙 {}",
    mouse_callbacks={
        "Button3": lambda: qtile.cmd_spawn("pavucontrol"),
    },
)


def mynotifyparser(text):
    return re.sub(" +", " ", text.replace("\n", " ", -1))


screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentScreen(
                    active_text="",
                    inactive_text="",
                    active_color="#98C379",
                    padding=10,
                ),
                widget.CurrentLayout(),
                mysep,
                widget.WindowCount(),
                mysep,
                widget.GroupBox(
                    highlight_method="line",
                    block_highlight_text_color="#98C379",
                    this_current_screen_border="#98C379",
                    this_screen_border="#61aeef",
                    hide_unused=True,
                    disable_drag=True,
                ),
                mysep,
                widget.WidgetBox(
                    widgets=[
                        widget.WindowTabs(),
                    ],
                    text_open=" [] ",
                    text_closed=" · ",
                ),
                widget.Prompt(),
                widget.WindowName(parse_text=titleParser),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.Systray(),
                mysep,
                widget.Notify(
                    foreground="62aeef",
                    parse_text=mynotifyparser,
                ),
                mysep,
                widget.Net(format=" {up}↑ {down}↓"),  # Ͳ
                widget.Wlan(
                    interface="wlp0s20f3",
                    # format=" ",
                    format="  {percent:2.0%}",
                    disconnected_message="睊",
                ),
                mysep,
                widget.CPU(format=" {load_percent}%"),
                mysep,
                widget.Memory(format="ⵂⵂⵂⵂ {MemUsed:.0f}{mm} "),
                mysep,
                widget.Bluetooth(fmt=" {}"),
                mypulsevolume,
                mysep,
                widget.Clock(
                    format="%Y-%m-%d %a %I:%M %p",
                    mouse_callbacks={
                        "Button1": lambda: qtile.cmd_spawn("gnome-calendar"),
                    },
                ),
                mysep,
                widget.Battery(
                    charge_char="⚡",
                    discharge_char="",
                    empty_char="_",
                    full_char="█",
                    notify_below=20,
                    show_short_text=False,
                    hide_threshold=0.9,
                    format="{percent:2.0%} {char}",
                ),
                widget.StatusNotifier(),
            ],
            24,
            opacity=0.85,
        ),
        # bottom=bar.Bar(
        #     [
        #         # widget.Notify(
        #         #     foreground="62aeef",
        #         #     scroll=True,
        #         # ),
        #         widget.Spacer(),
        #         widget.GroupBox(
        #             center_aligned=True,
        #         ),
        #         # widget.Spacer(),
        #     ],
        #     24,
        #     opacity=0.85,
        # ),
    ),
    Screen(
        top=bar.Bar(
            [
                widget.CurrentScreen(
                    active_text="",
                    inactive_text="",
                    active_color="#98C379",
                    padding=10,
                ),
                widget.CurrentLayout(),
                mysep,
                widget.WindowCount(),
                mysep,
                widget.GroupBox(
                    highlight_method="line",
                    block_highlight_text_color="#98C379",
                    this_current_screen_border="#98C379",
                    this_screen_border="#61aeef",
                    hide_unused=True,
                    disable_drag=True,
                ),
                mysep,
                widget.WindowName(parse_text=titleParser),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                mypulsevolume,
                mysep,
                widget.Clock(format="%d %a %I:%M %p"),
                mysep,
                widget.BatteryIcon(),
            ],
            24,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ],
    margin=0,
    border_width=2,
    border_focus="#61aeef",
    border_normal="#ffffff",
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
