import math
import os
from pathlib import Path

from kitty.boss import get_boss
from kitty.fast_data_types import Screen
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb, draw_title


def createLogDir():
    xdg_state_home = os.getenv("XDG_STATE_HOME", Path.home() / ".local" / "state")

    log_dir = Path(xdg_state_home) / "kitty"
    try:
        log_dir.mkdir(parents=True, exist_ok=True)
    except OSError:
        log_dir = Path("/tmp") / "kitty"
        log_dir.mkdir(parents=True, exist_ok=True)

    return log_dir


background = as_rgb(int("090B10", 16))
background_color = int("090B10", 16)
lavender = as_rgb(int("B4BEFE", 16))
surface1 = as_rgb(int("45475A", 16))
window_icon = ""
layout_icon = ""
active_tab_layout_name = ""
active_tab_num_windows = 1
left_status_length = 0
log_dir = createLogDir()


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    global active_tab_layout_name
    global active_tab_num_windows

    try:
        draw_tab_with_separator(
            draw_data,
            screen,
            tab,
            before,
            max_title_length,
            index,
            is_last,
            extra_data,
            background,
        )
    except Exception as e:
        with open(log_dir / "tab_bar.log", "a") as f:
            f.write(f"Error: {e}\n")

    return screen.cursor.x


def draw_tab_with_separator(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
    background: int,
) -> int:
    screen.cursor.bg = background
    screen.cursor.fg = as_rgb(draw_data.active_fg.rgb)
    screen.cursor.bold = screen.cursor.italic = False

    if index == 1:
        screen.draw(draw_data.sep)

    screen.cursor.bg = background
    screen.cursor.fg = as_rgb(
        draw_data.active_fg.rgb if tab.is_active else draw_data.inactive_fg.rgb
    )
    screen.cursor.bold = tab.is_active

    draw_title(draw_data, screen, tab, index, max_tab_length)

    screen.cursor.bg = background
    screen.cursor.fg = as_rgb(draw_data.inactive_fg.rgb)
    screen.cursor.bold = screen.cursor.italic = False

    if not is_last:
        screen.draw(draw_data.sep)

    if is_last:
        remaining_size = screen.columns - screen.cursor.x
        cwd = truncate_str(get_cwd() + draw_data.sep, remaining_size)

        screen.cursor.bg = background
        screen.cursor.fg = as_rgb(draw_data.inactive_fg.rgb)
        screen.cursor.bold = screen.cursor.italic = False
        screen.draw(" " * (remaining_size - len(cwd)))
        screen.draw(cwd)

    end = screen.cursor.x
    return end


def truncate_str(input_str, max_length):
    if len(input_str) <= max_length:
        return input_str
    if max_length <= 0:
        return ""
    if max_length == 1:
        return "…"

    return "…" + input_str[-(max_length - 1):]


def get_cwd():
    cwd = ""
    tab_manager = get_boss().active_tab_manager
    if tab_manager is not None:
        window = tab_manager.active_window
        if window is not None:
            cwd = window.cwd_of_child

    cwd_parts = list(Path(cwd).parts)

    if len(cwd_parts) > 1:
        if cwd_parts[1] == "home" or str(Path(*cwd_parts[:3])) == os.getenv("HOME") and len(cwd_parts) > 3:
            cwd_parts = ["~"] + cwd_parts[3:]
            if len(cwd_parts) > 1:
                cwd_parts[0] = "~/"
        else:
            cwd_parts[0] = "/"
    else:
        cwd_parts[0] = "/"

    cwd = cwd_parts[0] + "/".join(
        [
            s
            for s in cwd_parts[1:]
        ]
    )
    return cwd

