// obj_time_controller : Room Start

// Hide/disable timer on title screen AND victory room
active = (room != rm_title_screen) && (room != rm_victory);

// If timer is not active, also stop it from counting down
if (!active) running = false;

// IMPORTANT: if we just loaded, apply the loaded timer to this persistent instance
if (variable_global_exists("pending_load") && global.pending_load)
{
    if (variable_global_exists("pending_timer_start") && global.pending_timer_start >= 0)
        countdown_start = global.pending_timer_start;

    if (variable_global_exists("pending_timer_countdown") && global.pending_timer_countdown >= 0)
        countdown = global.pending_timer_countdown;
    else
        countdown = countdown_start;

    if (variable_global_exists("pending_timer_running"))
        running = global.pending_timer_running;
    else
        running = true;

    if (variable_global_exists("pending_timer_active"))
        active = global.pending_timer_active;

    // BUT: never allow timer to be active in victory room
    if (room == rm_victory)
    {
        active = false;
        running = false;
    }

    // sync globals (so save_game() writes correct values)
    global.timer_countdown_start = countdown_start;
    global.timer_countdown       = countdown;
    global.timer_running         = running;
    global.timer_active          = active;

    // consume pending timer values
    global.pending_timer_countdown = -1;
    global.pending_timer_running   = false;
    global.pending_timer_start     = -1;
    global.pending_timer_active    = true;
}