key_left =  keyboard_check(ord("A"));
key_right = keyboard_check(ord("D"));
key_jump = keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_space);

// Calculate Movement
var move = key_right - key_left;
xspeed = move * walkspeed;
// sprite mirror logic: + idle logic
if (move != 0) 
{
    // Currently moving (A or D is held)
    sprite_index = spr_platform_walk; 
    image_speed = animwalkspeed; 
	image_xscale = move;
} 
else 
{
    // Standing still
    sprite_index = spr_platform_idle;
    image_speed = animidlespeed;
}

// gravity
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


// Bullet / Attack Logic Here:
if (mouse_check_button_pressed(mb_left)) 
{
    // Create the bullet
    var bullet = instance_create_layer(x, y-50, "Instances", obj_jobapp);
	bullet.speed = 50;
    show_debug_message("Bullet created! ID: " + string(bullet));
    // Set direction based on where the player is facing (image_xscale)
    if (image_xscale > 0) bullet.direction = 0;   // Right
    else bullet.direction = 180;                  // Left
}



