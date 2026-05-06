var up_key = keyboard_check_pressed(vk_up);
var down_key = keyboard_check_pressed(vk_down);
var left_key = keyboard_check_pressed(vk_left);
var right_key = keyboard_check_pressed(vk_right);
var accept_key = keyboard_check_pressed(vk_space);

var delta = right_key - left_key;

op_length = get_op_length();

// move cursor
pos += down_key - up_key;
if (pos >= op_length) pos = 0;
if (pos < 0) pos = op_length - 1;

// left/right changes
if (delta != 0)
{
    switch (menu_level)
    {
        case 2: // graphics
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

        case 3: // audio
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

        // NOTE: menu_level 4 (Background Music list) does NOT use left/right anymore
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

// accept
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
                case 0:
                    if (has_save)
                    {
                        scr_load_game();
                    }
                    else
                    {
                        with (obj_game_controller) start_new_game();
                    }
                    break;

                case 1:
                    menu_level = 1;
                    break;

                case 2:
                    if (has_save)
                    {
                        scr_save_delete();
                        pos = 0;
                    }
                    else
                    {
                        game_end();
                    }
                    break;

                case 3:
                    game_end();
                    break;
            }
        }
        break;

        case 1: // settings
            switch (pos)
            {
                case 0: menu_level = 2; break; // Graphics Settings
                case 1: menu_level = 3; break; // Audio Settings
                case 2: menu_level = 4; break; // Background Music (list)
                case 3: menu_level = 0; break; // Back
            }
            break;

        case 2: // graphics
            if (pos == 3) menu_level = 1;
            break;

        case 3: // audio
            if (pos == 3) menu_level = 1;
            break;

        case 4: // background music (song list)
        {
            var n = array_length(music_tracks);

            // last entry is Back
            if (pos == n)
            {
                menu_level = 1; // back to Settings
            }
            else
            {
                // select a song by row
                global.music_track_index = clamp(pos, 0, n - 1);

                // SAVE IMMEDIATELY so it persists between game launches
                if (instance_exists(obj_game_controller))
                {
                    with (obj_game_controller)
                    {
                        // apply_settings isn't strictly required for track index,
                        // but keeping it is fine and keeps your pattern consistent.
                        apply_settings();
                        settings_save();
                    }
                }

                // Update menu text so the ">" marker moves
                refresh_options();
            }
        }
        break;
    }

    if (prev != menu_level) pos = 0;

    op_length = get_op_length();
    if (pos >= op_length) pos = 0;

    refresh_options();
}