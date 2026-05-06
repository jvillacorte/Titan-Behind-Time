
if (place_meeting(x, y, rpg_player))
{
    if (global.has_house_key) exit;

    global.has_house_key = true;

    if (instance_exists(obj_game_controller))
    {
        with (obj_game_controller)
        {
            toast_show("Key Acquired!", 90);

            // NEW: persist immediately so it can't be lost
            save_game();
        }
    }

    if (instance_exists(warpblock_to_drivingsq))
    {
        with (warpblock_to_drivingsq)
        {
            active = true;
            visible = true;
        }
    }

    instance_destroy();
}