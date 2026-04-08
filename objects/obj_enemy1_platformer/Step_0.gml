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
    xspeed = dir * walkspeed;

    // Ledge Detection
    if (place_meeting(x, y + 1, obj_block)) 
    {
        if (!place_meeting(x + (dir * 15), y + 1, obj_block)) 
        {
            dir *= -1;                
            xspeed = dir * walkspeed; 
        }
    }

    // Horizontal Collision
    if (place_meeting(x + xspeed, y, obj_block)) 
    {
        while (!place_meeting(x + sign(xspeed), y, obj_block)) 
        {
            x += sign(xspeed);
        }
        dir *= -1;  
        xspeed = 0; 
    }
    x += xspeed; 

    // Vertical Collision
    if (place_meeting(x, y + yspeed, obj_block)) 
    {
        while (!place_meeting(x, y + sign(yspeed), obj_block)) 
        {
            y += sign(yspeed);
        }
        yspeed = 0;
    }
    y += yspeed; 
}