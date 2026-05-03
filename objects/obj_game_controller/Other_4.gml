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

            // clear motion (if vars exist)
            if (variable_instance_exists(id, "xspd")) xspd = 0;
            if (variable_instance_exists(id, "yspd")) yspd = 0;

            // reset facing + sprite
            if (variable_instance_exists(id, "face")) face = DOWN;
            // If you keep sprite[] arrays as in your Create, set the idle sprite:
            if (variable_instance_exists(id, "sprite")) sprite_index = sprite[DOWN_IDLE];
        }
    }
}

// ------------------------------------------
// Load Game apply (runs after room_goto from load_game())
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
            else
            {
                // create persistent rpg_player if missing
                var p = instance_create_depth(global.pending_x, global.pending_y, 0, rpg_player);
                with (p)
                {
                    active = true;
                    visible = true;
                    if (variable_instance_exists(id, "xspd")) xspd = 0;
                    if (variable_instance_exists(id, "yspd")) yspd = 0;
                    if (variable_instance_exists(id, "face")) face = global.pending_face;
                }
            }
            break;

        case "car":
            // Ensure we have a car instance in this room (create if missing)
            var car_inst = noone;
            if (instance_exists(obj_car))
            {
                car_inst = instance_find(obj_car, 0);
            }
            else
            {
                // Create the car at the pending location (adjust layer/depth if needed)
                car_inst = instance_create_depth(global.pending_x, global.pending_y, 0, obj_car);
            }

            if (car_inst != noone && instance_exists(car_inst))
            {
                with (car_inst)
                {
                    x = global.pending_x;
                    y = global.pending_y;

                    // restore driving state only if the pending globals are defined
                    if (variable_global_exists("pending_car_direction") && !is_undefined(global.pending_car_direction))
                        direction = global.pending_car_direction;

                    if (variable_global_exists("pending_car_spd") && !is_undefined(global.pending_car_spd))
                        spd = global.pending_car_spd;

                    if (variable_global_exists("pending_car_steer") && !is_undefined(global.pending_car_steer))
                        steer_angle = global.pending_car_steer;

                    // avoid a one-frame speed spike
                    if (variable_instance_exists(id, "prev_x")) prev_x = x;
                    if (variable_instance_exists(id, "prev_y")) prev_y = y;
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
            else
            {
                // optionally create platformer instance if missing
                var pinst = instance_create_depth(global.pending_x, global.pending_y, 0, obj_player_platformer);
            }
            break;
    }
}