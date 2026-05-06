if (global.game_paused) exit;

if (place_meeting(x, y, obj_block_parent)) 
{
    if (instance_exists(obj_enemy2_platformer))
    {
        obj_enemy2_platformer.is_attacking = false;
    }

    instance_destroy(); 
}