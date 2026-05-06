// obj_time_controller : Create

// Ensure globals exist even if init script hasn't run yet
if (!variable_global_exists("timer_countdown_start")) global.timer_countdown_start = 120;
if (!variable_global_exists("timer_countdown"))       global.timer_countdown       = global.timer_countdown_start;
if (!variable_global_exists("timer_running"))         global.timer_running         = true;
if (!variable_global_exists("timer_active"))          global.timer_active          = true;

// Start from globals (so timer persists even if this object isn't present when saving)
countdown_start = global.timer_countdown_start;
countdown       = global.timer_countdown;
running         = global.timer_running;
active          = global.timer_active;

// Apply pending loaded values (if any)
if (variable_global_exists("pending_load") && global.pending_load)
{
    if (variable_global_exists("pending_timer_start") && global.pending_timer_start >= 0)
        countdown_start = global.pending_timer_start;

    if (variable_global_exists("pending_timer_countdown") && global.pending_timer_countdown >= 0)
        countdown = global.pending_timer_countdown;

    if (variable_global_exists("pending_timer_running"))
        running = global.pending_timer_running;

    if (variable_global_exists("pending_timer_active"))
        active = global.pending_timer_active;

    // also update globals to match
    global.timer_countdown_start = countdown_start;
    global.timer_countdown       = countdown;
    global.timer_running         = running;
    global.timer_active          = active;

    // consume pending
    global.pending_timer_countdown = -1;
    global.pending_timer_running   = false;
    global.pending_timer_start     = -1;
    global.pending_timer_active    = true;
}