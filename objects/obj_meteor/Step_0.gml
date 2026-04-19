
if (place_meeting(x, y, obj_block)) 
{
    
    if (instance_exists(obj_enemy2)) obj_enemy2.is_attacking = false;
    
    instance_destroy(); 
}