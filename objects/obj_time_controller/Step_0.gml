// obj_time_controller : Step

if (!active) exit;

if (!global.game_paused && running)
{
    countdown -= 1 / room_speed;

    if (countdown <= 0)
    {
        countdown = 0;
        running = false;
    }
}

// Keep globals synced so saving works even if obj_time_controller isn't present later
global.timer_countdown_start = countdown_start;
global.timer_countdown       = countdown;
global.timer_running         = running;
global.timer_active          = active;