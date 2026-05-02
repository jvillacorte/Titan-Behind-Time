var up_key = keyboard_check_pressed(vk_up);
var down_key = keyboard_check_pressed(vk_down);
var left_key = keyboard_check_pressed(vk_left);
var right_key = keyboard_check_pressed(vk_right);
var accept_key = keyboard_check_pressed(vk_space);

var delta = right_key - left_key;

op_length = get_op_length();

pos += down_key - up_key;
if (pos >= op_length) pos = 0;
if (pos < 0) pos = op_length - 1;

if (delta != 0)
{
    switch (menu_level)
    {
        case 2:
            switch (pos)
            {
                case 0:
                    if (!global.fullscreen)
                    {
                        global.win_size_index += delta;

                        var max_i = array_length(global.win_sizes) - 1;
                        if (global.win_size_index > max_i) global.win_size_index = 0;
                        if (global.win_size_index < 0) global.win_size_index = max_i;

                        var w = global.win_sizes[global.win_size_index][0];
                        var h = global.win_sizes[global.win_size_index][1];
                        window_set_size(w, h);
                    }
                    break;

                case 1:
                    global.fullscreen = !global.fullscreen;
                    window_set_fullscreen(global.fullscreen);
                    break;

                case 2:
                    global.brightness = clamp(global.brightness - 0.05 * delta, 0, 0.75);
                    break;
            }
            break;

        case 3:
            switch (pos)
            {
                case 0:
                    global.vol_master = clamp(global.vol_master + 0.05 * delta, 0, 1);
                    audio_master_gain(global.vol_master);
                    break;

                case 1:
                    global.vol_sfx = clamp(global.vol_sfx + 0.05 * delta, 0, 1);
                    break;

                case 2:
                    global.vol_music = clamp(global.vol_music + 0.05 * delta, 0, 1);
                    break;
            }
            break;
    }

    if (instance_exists(obj_game_controller))
    {
        with (obj_game_controller)
        {
            apply_settings();
            settings_save();
        }
    }

    refresh_options();
}

if (accept_key)
{
    var prev = menu_level;

    switch (menu_level)
    {
        case 0:
        {
            var has_save = scr_save_exists();

            switch (pos)
            {
                case 0: // Resume (close pause)
                    with (obj_game_controller) pause_set(false);
                    global.pause_menu_inst = noone;
                    instance_destroy();
                    break;

                case 1: // Settings
                    menu_level = 1;
                    break;

                case 2: // Save
                    scr_save_game();
                    break;

                case 3:
                    if (has_save)
                    {
                        scr_save_delete();
                        pos = 0;
                    }
                    else
                    {
                        with (obj_game_controller) pause_set(false);
                        global.pause_menu_inst = noone;

                        if (instance_exists(rpg_player))
                        {
                            with (rpg_player) { active = false; visible = false; }
                        }

                        room_goto(rm_title_screen);
                    }
                    break;

                case 4:
                    if (has_save)
                    {
                        with (obj_game_controller) pause_set(false);
                        global.pause_menu_inst = noone;

                        if (instance_exists(rpg_player))
                        {
                            with (rpg_player) { active = false; visible = false; }
                        }

                        room_goto(rm_title_screen);
                    }
                    else
                    {
                        game_end();
                    }
                    break;

                case 5:
                    game_end();
                    break;
            }
        }
        break;

        case 1:
            switch (pos)
            {
                case 0: menu_level = 2; break;
                case 1: menu_level = 3; break;
                case 2: menu_level = 0; break;
            }
            break;

        case 2:
            if (pos == 3) menu_level = 1;
            break;

        case 3:
            if (pos == 3) menu_level = 1;
            break;
    }

    if (prev != menu_level) pos = 0;

    op_length = get_op_length();
    if (pos >= op_length) pos = 0;

    refresh_options();
}