var _cam_x = camera_get_view_x(view_camera[0]);
var _cam_w = camera_get_view_width(view_camera[0]);

// Check if the enemy is within the left and right bounds of the screen
if (x > _cam_x && x < _cam_x + _cam_w) 
{
	if (instance_exists(obj_player_platformer) && !is_dead) 
	{
    is_attacking = true;
    
    // Spawn warning
    var _warn = instance_create_layer(obj_player_platformer.x, obj_player_platformer.y-75, "Instances", obj_warning);
    
    // Make the warning speed up! 
    // If 3 seconds (180) feels too slow for an "instant" feel, lower this to 60 (1 second)
    _warn.alarm[0] = 1 * 60;
	alarm[0] = attack_cooldown;
	}
}
else 
{
    alarm[0] = 10; 
}

