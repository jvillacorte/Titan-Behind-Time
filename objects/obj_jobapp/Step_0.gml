//checks for enemies
var _enemy_hit = instance_place(x + xspeed, y + yspeed, obj_enemy_parent);

if (_enemy_hit != noone) 
{
    // Tell that specific enemy to take damage
    _enemy_hit.hp -= 1; 
    
    // Destroy the bullet
    instance_destroy();
    
    // Exit the Step Event immediately so we don't bother checking for walls
    exit; 
}

//wall check
if (place_meeting(x + xspeed, y + yspeed, obj_block)) 
{
    // Move 1 pixel at a time until flush with the wall
    while (!place_meeting(x + sign(xspeed), y + sign(yspeed), obj_block)) 
    {
        x += sign(xspeed);
        y += sign(yspeed);
    }
    
    instance_destroy();
} 
else 
{
    // normal bullet movement
    x += xspeed;
    y += yspeed;
}