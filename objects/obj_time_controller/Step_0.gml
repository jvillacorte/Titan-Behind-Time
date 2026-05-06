// obj_time_controller : Step

if (!active) exit;

if (!global.game_paused && running)
{
    countdown -= 1 / room_speed;

    if (countdown <= 0)
    {
        countdown = 0;
        running = false;

        // go to fail room (only if we're not already there)
        if (room != rm_fail)
        {
            // optional: clear pause/menu state so it doesn't carry over
            global.game_paused = false;
            global.pause_menu_inst = noone;

            room_goto(rm_fail);
        }
    }
}

// Keep globals synced so saving works even if obj_time_controller isn't present later
global.timer_countdown_start = countdown_start;
global.timer_countdown       = countdown;
global.timer_running         = running;
global.timer_active          = active;