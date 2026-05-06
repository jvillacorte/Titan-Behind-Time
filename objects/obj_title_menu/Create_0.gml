// hide persistent RPG player on title screen
if (instance_exists(rpg_player))
{
    with (rpg_player)
    {
        active = false;
        visible = false;
    }
}

menu_off_x = 0;    // + moves right, - moves left
menu_off_y = 65;  // + moves down,  - moves up

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
            return scr_save_exists() ? 4 : 3;
        case 1:
            return 3;
        case 2:
            return 4;
        case 3:
            return 4;
    }
    return 0;
}

function refresh_options()
{
    var has_controller = instance_exists(obj_game_controller);
    var has_save = scr_save_exists();

    option[0, 0] = has_save ? "Resume" : "Start Game";
    option[0, 1] = "Settings";

    if (has_save)
    {
        option[0, 2] = "Delete Save";
        option[0, 3] = "Quit Game";
    }
    else
    {
        option[0, 2] = "Quit Game";
    }

    option[1, 0] = "Graphics Settings";
    option[1, 1] = "Audio Settings";
    option[1, 2] = "Back";

    if (!has_controller || !variable_global_exists("win_sizes") || !variable_global_exists("win_size_index"))
    {
        option[2, 0] = "Window Size: (loading)";
        option[2, 1] = "Fullscreen: (loading)";
        option[2, 2] = "Brightness: (loading)";
        option[2, 3] = "Back";

        option[3, 0] = "Master: (loading)";
        option[3, 1] = "SFX: (loading)";
        option[3, 2] = "Music: (loading)";
        option[3, 3] = "Back";
        return;
    }

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