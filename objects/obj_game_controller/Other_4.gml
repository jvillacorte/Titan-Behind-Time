// ------------------------------------------
// New Game initialization (runs once)
// ------------------------------------------
if (variable_global_exists("new_game") && global.new_game)
{
    global.new_game = false;

    if (room == rm_bedroom && instance_exists(rpg_player))
    {
        with (rpg_player)
        {
            active = true;
            visible = true;

            // spawn
            x = 136;
            y = 113;

            // clear motion
            if (variable_instance_exists(id, "xspd")) xspd = 0;
            if (variable_instance_exists(id, "yspd")) yspd = 0;

            // reset facing + sprite
            if (variable_instance_exists(id, "face")) face = DOWN;
            if (variable_instance_exists(id, "sprite")) sprite_index = sprite[DOWN_IDLE];
            else sprite_index = sprite_index; // no-op
        }
    }
}

// ------------------------------------------
// Load Game apply (runs after load_game())
// ------------------------------------------
if (variable_global_exists("pending_load") && global.pending_load)
{
    global.pending_load = false;

    switch (global.pending_mode)
    {
        case "rpg":
            if (instance_exists(rpg_player))
            {
                with (rpg_player)
                {
                    active = true;
                    visible = true;

                    x = global.pending_x;
                    y = global.pending_y;

                    if (variable_instance_exists(id, "face"))
                        face = global.pending_face;

                    if (variable_instance_exists(id, "xspd")) xspd = 0;
                    if (variable_instance_exists(id, "yspd")) yspd = 0;
                }
            }
            break;

        case "car":
            if (instance_exists(obj_car))
            {
                with (obj_car)
                {
					active = true;
                    visible = true;
					
                    x = global.pending_x;
                    y = global.pending_y;
                }
            }
            break;

        case "platformer":
            if (instance_exists(obj_player_platformer))
            {
                with (obj_player_platformer)
                {
                    x = global.pending_x;
                    y = global.pending_y;
                }
            }
            break;
    }
}