width = 90;
height = 70;

op_border = 8;
op_space = 16;

pos = 0;
menu_level = 0;

option = [];

function get_op_length()
{
    switch (menu_level)
    {
        case 0:
            return scr_save_exists() ? 6 : 5;
        case 1: return 3;
        case 2: return 4;
        case 3: return 4;
    }
    return 0;
}

function refresh_options()
{
    var has_save = scr_save_exists();

    option[0, 0] = "Resume";
    option[0, 1] = "Settings";
    option[0, 2] = "Save Game";

    if (has_save)
    {
        option[0, 3] = "Delete Save";
        option[0, 4] = "Quit to Main Menu";
        option[0, 5] = "Quit to Desktop";
    }
    else
    {
        option[0, 3] = "Quit to Main Menu";
        option[0, 4] = "Quit to Desktop";
    }

    option[1, 0] = "Graphics Settings";
    option[1, 1] = "Audio Settings";
    option[1, 2] = "Back";

    global.win_size_index = clamp(global.win_size_index, 0, array_length(global.win_sizes) - 1);
    var w = global.win_sizes[global.win_size_index][0];
    var h = global.win_sizes[global.win_size_index][1];

    option[2, 0] = "Window Size: " + string(w) + "x" + string(h);
    option[2, 1] = "Fullscreen: " + (global.fullscreen ? "On" : "Off");
    option[2, 2] = "Brightness: " + string(round((1 - global.brightness) * 100)) + "%";
    option[2, 3] = "Back";

    option[3, 0] = "Master: " + string(round(global.vol_master * 100)) + "%";
    option[3, 1] = "SFX: " + string(round(global.vol_sfx * 100)) + "%";
    option[3, 2] = "Music: " + string(round(global.vol_music * 100)) + "%";
    option[3, 3] = "Back";
}

refresh_options();
op_length = get_op_length();