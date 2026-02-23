key_left =  keyboard_check(ord("A"));
key_right = keyboard_check(ord("D"));
key_jump = keyboard_check_pressed(ord("W"));

// Calculate Movement
var move = key_right - key_left;
xspeed = move * walkspeed;

yspeed += gravitystrength;

if (place_meeting(x, y + 1, obj_block)) && (key_jump) // note to future: replcae obj_block with whatever the "base" will be
{
    yspeed = jumpheight;
}

// Horizontal Collision
if (place_meeting(x + xspeed, y, obj_block))
{
    while (!place_meeting(x + sign(xspeed), y, obj_block))
    {
        x = x + sign(xspeed);
    }
    xspeed = 0;
}
x = x + xspeed;

// Vertical Collision
if (place_meeting(x, y + yspeed,obj_block))
{
    while (!place_meeting(x, y + sign(yspeed),obj_block))
    {
        y = y + sign(yspeed);
    }
    yspeed = 0;
}
y += yspeed;
