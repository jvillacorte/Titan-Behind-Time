yspeed += grv;
xspeed = dir * walkspeed;

// 2. Ledge Detection
if (place_meeting(x, y + 1, obj_block)) 
{
   
    if (!place_meeting(x + (dir * 15), y + 1, obj_block)) 
    {
        dir *= -1;                // Flip the direction
        xspeed = dir * walkspeed; 
    }
}

// 3. Horizontal Collision
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


// 4. Vertical Collision 
if (place_meeting(x, y + yspeed, obj_block)) 
{
    while (!place_meeting(x, y + sign(yspeed), obj_block)) 
    {
        y += sign(yspeed);
    }
    yspeed = 0;
}
y += yspeed;