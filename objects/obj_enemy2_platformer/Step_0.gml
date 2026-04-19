// if we are dead:
if (hp <= 0) && (!is_dead) 
{
    is_dead = true; 
    yspeed = -5; 
}


if (is_dead) 
{
    
    yspeed += grv;
    y += yspeed;
    
    if (y > room_height + 100) 
    {
        instance_destroy();
    }
}
else // if alive
{ yspeed += grv;

// Vertical Collision
if (place_meeting(x, y + yspeed, obj_block_parent)) {
    while (!place_meeting(x, y + sign(yspeed), obj_block_parent)) {
        y += sign(yspeed);
    }
    yspeed = 0;
}
y += yspeed;

// Face Player
if (instance_exists(obj_player_platformer)) {
    var _target_dir = sign(obj_player_platformer.x - x);
    if (_target_dir != 0) image_xscale = _target_dir;
}

// Animation Swap
if (is_attacking) {
    sprite_index = spr_enemy2attack;
} else {
    sprite_index = spr_enemy2;
}
}