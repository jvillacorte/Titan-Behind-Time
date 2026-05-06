if (global.game_paused)
{
    if (!was_paused)
    {
        stored_vspeed = vspeed;
        was_paused = true;
    }

    vspeed = 0;
    exit;
}

if (was_paused)
{
    vspeed = stored_vspeed;
    was_paused = false;
}