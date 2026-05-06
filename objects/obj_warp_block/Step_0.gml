if (place_meeting(x, y, rpg_player) && !instance_exists(obj_warp))
{
    // Locked warp block behavior (only blocks if player doesn't have key)
    if (variable_instance_exists(id, "active") && !active && !global.has_house_key)
    {
        if (instance_exists(obj_game_controller))
        {
            with (obj_game_controller)
            {
                toast_show("You need the house keys!", 90);
            }
        }
        exit;
    }

    // Normal warp
    var inst = instance_create_depth(0, 0, -9999, obj_warp);
    inst.target_x = target_x;
    inst.target_y = target_y;
    inst.target_rm = target_rm;
    inst.target_face = target_face;
}