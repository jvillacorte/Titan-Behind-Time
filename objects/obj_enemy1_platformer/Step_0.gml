if (global.game_paused) exit;

// if we are dead:
if (hp <= 0) && (!is_dead) 
{
    is_dead = true; 
    yspeed = -5; 
    xspeed = 0; // Stop walking left/right
    
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
{
    yspeed += grv; 
	
	if (instance_exists(obj_player_platformer)) 
    {
        //tracks the player
        dir = sign(obj_player_platformer.x - x);
    }
    xspeed = dir * walkspeed;
	

    // Ledge Detection
    if (place_meeting(x, y + 1, obj_block_parent)) 
    {
        if (!place_meeting(x + (dir * 15), y + 1, obj_block_parent)) 
        {
            dir *= -1;                
            xspeed = dir * walkspeed; 
        }
    }

    // Horizontal Collision
    if (place_meeting(x + xspeed, y, obj_block_parent)) 
    {
        while (!place_meeting(x + sign(xspeed), y, obj_block_parent)) 
        {
            x += sign(xspeed);
        }
        dir *= -1;  
        xspeed = 0; 
    }
    x += xspeed; 

    // Vertical Collision
    if (place_meeting(x, y + yspeed, obj_block_parent)) 
    {
        while (!place_meeting(x, y + sign(yspeed), obj_block_parent)) 
        {
            y += sign(yspeed);
        }
        yspeed = 0;
    }
    y += yspeed; 
}