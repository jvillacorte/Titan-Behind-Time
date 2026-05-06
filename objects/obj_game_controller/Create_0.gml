
// -------------------- pause state --------------------
global.game_paused = false;
global.pause_menu_inst = noone;

// -------------------- graphics/audio settings --------------------
global.win_sizes =
[
    [1024, 576],
    [1152, 648],
    [1280, 720],
    [1366, 768],
    [1600, 900],
    [1920, 1080],
    [2560, 1440]
];

if (!variable_global_exists("win_size_index")) global.win_size_index = 2;
if (!variable_global_exists("fullscreen"))     global.fullscreen = window_get_fullscreen();
if (!variable_global_exists("brightness"))     global.brightness = 0.25;

if (!variable_global_exists("vol_master")) global.vol_master = 1.0;
if (!variable_global_exists("vol_sfx"))    global.vol_sfx = 1.0;
if (!variable_global_exists("vol_music"))  global.vol_music = 1.0;

if (!variable_global_exists("music_track_index")) global.music_track_index = 0;

function apply_settings()
{
    global.win_size_index = clamp(global.win_size_index, 0, array_length(global.win_sizes) - 1);
    global.brightness = clamp(global.brightness, 0, 0.75);

    global.vol_master = clamp(global.vol_master, 0, 1);
    global.vol_sfx = clamp(global.vol_sfx, 0, 1);
    global.vol_music = clamp(global.vol_music, 0, 1);

    global.music_track_index = max(0, floor(global.music_track_index));

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

        global.music_track_index = ini_read_real("audio", "music_track_index", global.music_track_index);

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

    ini_write_real("audio", "music_track_index", global.music_track_index);

    ini_close();
}

// -------------------- pause helpers --------------------
function pause_set(_paused)
{
    global.game_paused = _paused;

    if (_paused) audio_pause_all();
    else audio_resume_all();
}

// -------------------- key / gate flags --------------------
if (!variable_global_exists("has_house_key")) global.has_house_key = false;

// -------------------- TIMER GLOBALS (NEW: robust saving even if obj_time_controller is not in room) --------------------
if (!variable_global_exists("timer_countdown_start")) global.timer_countdown_start = 120;
if (!variable_global_exists("timer_countdown"))       global.timer_countdown       = global.timer_countdown_start;
if (!variable_global_exists("timer_running"))         global.timer_running         = true;
if (!variable_global_exists("timer_active"))          global.timer_active          = true;

// -------------------- SAVE SYSTEM --------------------
global.save_filename = "save.ini";

global.pending_load = false;
global.pending_mode = "rpg";
global.pending_room_name = "rm_bedroom";
global.pending_x = 0;
global.pending_y = 0;
global.pending_face = 0;

global.pending_timer_countdown = -1;
global.pending_timer_running   = false;
global.pending_timer_start     = -1;
global.pending_timer_active    = true;

function save_exists()
{
    return file_exists(global.save_filename);
}

function save_delete()
{
    if (file_exists(global.save_filename))
    {
        file_delete(global.save_filename);
    }

    global.has_house_key = false;

    // reset timer globals when deleting save (optional but nice)
    global.timer_countdown_start = 120;
    global.timer_countdown       = global.timer_countdown_start;
    global.timer_running         = true;
    global.timer_active          = true;

    toast_show("Save deleted", 90);
}

// Detect mode by what's in the current room
function detect_mode()
{
    if (instance_exists(obj_car)) return "car";
    if (instance_exists(obj_player_platformer)) return "platformer";
    return "rpg";
}

function save_game()
{
    var mode = detect_mode();

    ini_open(global.save_filename);

    ini_write_string("meta", "version", "1");
    ini_write_string("state", "mode", mode);
    ini_write_string("state", "room", room_get_name(room));

    ini_write_real("flags", "has_house_key", global.has_house_key ? 1 : 0);

    // -------------------- TIMER (UPDATED) --------------------
    // Save from globals so Quit/Save works even if obj_time_controller doesn't exist in this room.
    ini_write_real("timer", "countdown",       global.timer_countdown);
    ini_write_real("timer", "running",         global.timer_running ? 1 : 0);
    ini_write_real("timer", "countdown_start", global.timer_countdown_start);
    ini_write_real("timer", "active",          global.timer_active ? 1 : 0);

    switch (mode)
    {
        case "rpg":
            if (instance_exists(rpg_player))
            {
                ini_write_real("rpg", "x", rpg_player.x);
                ini_write_real("rpg", "y", rpg_player.y);

                if (variable_instance_exists(rpg_player.id, "face"))
                    ini_write_real("rpg", "face", rpg_player.face);
            }
            break;

        case "car":
            if (instance_exists(obj_car))
            {
                ini_write_real("car", "x", obj_car.x);
                ini_write_real("car", "y", obj_car.y);

                if (variable_instance_exists(obj_car.id, "direction")) ini_write_real("car", "direction", obj_car.direction);
                if (variable_instance_exists(obj_car.id, "spd"))       ini_write_real("car", "spd", obj_car.spd);
                if (variable_instance_exists(obj_car.id, "steer_angle")) ini_write_real("car", "steer_angle", obj_car.steer_angle);
                if (variable_instance_exists(obj_car.id, "spawn_x")) ini_write_real("car", "spawn_x", obj_car.spawn_x);
                if (variable_instance_exists(obj_car.id, "spawn_y")) ini_write_real("car", "spawn_y", obj_car.spawn_y);
            }
            break;

        case "platformer":
            if (instance_exists(obj_player_platformer))
            {
                ini_write_real("platformer", "x", obj_player_platformer.x);
                ini_write_real("platformer", "y", obj_player_platformer.y);
            }
            break;
    }

    ini_close();
	
    toast_show("Game saved", 90);
}

function load_game()
{
    if (!file_exists(global.save_filename))
    {
        toast_show("No save found", 90);

        // reset timer globals if no save
        global.timer_countdown       = global.timer_countdown_start;
        global.timer_running         = true;
        global.timer_active          = true;

        return false;
    }

    ini_open(global.save_filename);

    var ver = ini_read_string("meta", "version", "");
    if (ver != "1")
    {
        ini_close();
        toast_show("Unsupported save version", 120);
        return false;
    }

    var mode = ini_read_string("state", "mode", "rpg");
    var room_name = ini_read_string("state", "room", "rm_bedroom");

    global.has_house_key = (ini_read_real("flags", "has_house_key", global.has_house_key ? 1 : 0) == 1);

    // -------------------- TIMER (UPDATED) --------------------
    global.pending_timer_countdown = ini_read_real("timer", "countdown", -1);
    global.pending_timer_running   = (ini_read_real("timer", "running", 0) == 1);
    global.pending_timer_start     = ini_read_real("timer", "countdown_start", -1);
    global.pending_timer_active    = (ini_read_real("timer", "active", 1) == 1);

    // also set globals immediately (so value exists even before obj_time_controller is created)
    if (global.pending_timer_start >= 0)     global.timer_countdown_start = global.pending_timer_start;
    if (global.pending_timer_countdown >= 0) global.timer_countdown       = global.pending_timer_countdown;
    global.timer_running = global.pending_timer_running;
    global.timer_active  = global.pending_timer_active;

    var sx = 0;
    var sy = 0;
    var sface = 0;

    global.pending_car_direction = undefined;
    global.pending_car_spd       = undefined;
    global.pending_car_steer     = undefined;
    global.pending_car_spawnx    = undefined;
    global.pending_car_spawny    = undefined;

    switch (mode)
    {
        case "rpg":
            sx = ini_read_real("rpg", "x", 0);
            sy = ini_read_real("rpg", "y", 0);
            sface = ini_read_real("rpg", "face", 0);
            break;

        case "car":
            sx = ini_read_real("car", "x", 0);
            sy = ini_read_real("car", "y", 0);

            var tmp = ini_read_string("car", "direction", "");
            if (tmp != "") global.pending_car_direction = real(tmp);

            tmp = ini_read_string("car", "spd", "");
            if (tmp != "") global.pending_car_spd = real(tmp);

            tmp = ini_read_string("car", "steer_angle", "");
            if (tmp != "") global.pending_car_steer = real(tmp);

            tmp = ini_read_string("car", "spawn_x", "");
            if (tmp != "") global.pending_car_spawnx = real(tmp);

            tmp = ini_read_string("car", "spawn_y", "");
            if (tmp != "") global.pending_car_spawny = real(tmp);
            break;

        case "platformer":
            sx = ini_read_real("platformer", "x", 0);
            sy = ini_read_real("platformer", "y", 0);
            break;
    }

    ini_close();

    global.pending_load = true;
    global.pending_mode = mode;
    global.pending_room_name = room_name;
    global.pending_x = sx;
    global.pending_y = sy;
    global.pending_face = sface;

    var target_room = asset_get_index(room_name);
    if (target_room == -1)
    {
        global.pending_load = false;
        toast_show("Save room missing", 120);
        return false;
    }

    toast_show("Resuming...", 90);
    room_goto(target_room);
    return true;
}

function apply_loaded_timer()
{
    if (!global.pending_load) return;

    if (instance_exists(obj_time_controller))
    {
        if (global.pending_timer_start >= 0)
            obj_time_controller.countdown_start = global.pending_timer_start;

        if (global.pending_timer_countdown >= 0)
        {
            obj_time_controller.countdown = global.pending_timer_countdown;
            obj_time_controller.running = global.pending_timer_running;
            obj_time_controller.active = global.pending_timer_active;
        }
        else
        {
            obj_time_controller.countdown = obj_time_controller.countdown_start;
            obj_time_controller.running = true;
            obj_time_controller.active = true;
        }

        // keep globals in sync with what we applied
        global.timer_countdown_start = obj_time_controller.countdown_start;
        global.timer_countdown       = obj_time_controller.countdown;
        global.timer_running         = obj_time_controller.running;
        global.timer_active          = obj_time_controller.active;
    }

    global.pending_timer_countdown = -1;
    global.pending_timer_running = false;
    global.pending_timer_start = -1;
    global.pending_timer_active = true;
}

// -------------------- New Game helper --------------------
global.new_game = false;

function start_new_game()
{
    global.new_game = true;

    global.has_house_key = false;

    // reset timer globals
    global.timer_countdown_start = 120;
    global.timer_countdown       = global.timer_countdown_start;
    global.timer_running         = true;
    global.timer_active          = true;

    if (instance_exists(obj_time_controller))
    {
        obj_time_controller.countdown_start = global.timer_countdown_start;
        obj_time_controller.countdown       = global.timer_countdown;
        obj_time_controller.running         = global.timer_running;
        obj_time_controller.active          = global.timer_active;
    }

    room_goto(rm_bedroom);
}

// -------------------- UI Toast (top-right message) --------------------
if (!variable_global_exists("toast_text"))     global.toast_text = "";
if (!variable_global_exists("toast_time"))     global.toast_time = 0;
if (!variable_global_exists("toast_time_max")) global.toast_time_max = 90;

function toast_show(_text, _time)
{
    global.toast_text = _text;
    global.toast_time_max = max(1, _time);
    global.toast_time = global.toast_time_max;
}

// init
settings_load();