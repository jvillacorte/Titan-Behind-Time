global.game_paused = false;
global.pause_menu_inst = noone;

global.win_sizes = [[1280, 720], [1600, 900], [1920, 1080]];

if (!variable_global_exists("win_size_index")) global.win_size_index = 0;
if (!variable_global_exists("fullscreen"))     global.fullscreen = window_get_fullscreen();
if (!variable_global_exists("brightness"))     global.brightness = 0.25;

if (!variable_global_exists("vol_master")) global.vol_master = 1.0;
if (!variable_global_exists("vol_sfx"))    global.vol_sfx = 1.0;
if (!variable_global_exists("vol_music"))  global.vol_music = 1.0;

function apply_settings()
{
    global.win_size_index = clamp(global.win_size_index, 0, array_length(global.win_sizes) - 1);
    global.brightness = clamp(global.brightness, 0, 0.75);

    global.vol_master = clamp(global.vol_master, 0, 1);
    global.vol_sfx = clamp(global.vol_sfx, 0, 1);
    global.vol_music = clamp(global.vol_music, 0, 1);

    window_set_fullscreen(global.fullscreen);

    if (!global.fullscreen)
    {
        var w = global.win_sizes[global.win_size_index][0];
        var h = global.win_sizes[global.win_size_index][1];
        window_set_size(w, h);
    }

    audio_master_gain(global.vol_master);
}

function settings_load()
{
    if (file_exists("settings.ini"))
    {
        ini_open("settings.ini");

        global.win_size_index = ini_read_real("graphics", "win_size_index", global.win_size_index);
        global.fullscreen     = (ini_read_real("graphics", "fullscreen", global.fullscreen ? 1 : 0) == 1);
        global.brightness     = ini_read_real("graphics", "brightness", global.brightness);

        global.vol_master = ini_read_real("audio", "master", global.vol_master);
        global.vol_sfx    = ini_read_real("audio", "sfx", global.vol_sfx);
        global.vol_music  = ini_read_real("audio", "music", global.vol_music);

        ini_close();
    }

    apply_settings();
}

function settings_save()
{
    ini_open("settings.ini");

    ini_write_real("graphics", "win_size_index", global.win_size_index);
    ini_write_real("graphics", "fullscreen", global.fullscreen ? 1 : 0);
    ini_write_real("graphics", "brightness", global.brightness);

    ini_write_real("audio", "master", global.vol_master);
    ini_write_real("audio", "sfx", global.vol_sfx);
    ini_write_real("audio", "music", global.vol_music);

    ini_close();
}

function pause_set(_paused)
{
    global.game_paused = _paused;

    if (_paused)
    {
        audio_pause_all();
    }
    else
    {
        audio_resume_all();
    }
}

settings_load();