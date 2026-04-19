if (instance_exists(obj_player) && !is_dead) 
{
    is_attacking = true;
    
    // Spawn the warning at the player's CURRENT position
    var _warn = instance_create_layer(obj_player.x, obj_player.y - 20, "Instances", obj_warning_indicator);
    
    // Tell the warning to spawn a meteor in 3 seconds (180 frames)
    // We pass the location to the warning object so it knows where to drop the rock
    _warn.alarm[0] = 3 * 60; 
}

alarm[0] = attack_cooldown;