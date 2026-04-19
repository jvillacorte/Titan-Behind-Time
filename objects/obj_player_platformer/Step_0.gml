key_left =  keyboard_check(ord("A"));
key_right = keyboard_check(ord("D"));
key_jump = keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_space);

// Calculate Movement
var move = key_right - key_left;

// ONLY let the player walk if they aren't currently being knocked back
if (!is_knocked_back) 
{
    xspeed = move * walkspeed;
}
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


// Bullet Logic:
if (mouse_check_button_pressed(mb_left)) && (can_shoot)
{
    var bullet = instance_create_layer(x, y-50, "Instances", obj_jobapp);
    bullet.speed = 25;
    
    if (image_xscale > 0) bullet.direction = 0;   
    else bullet.direction = 180;                  

    // START THE RELOAD TIMER
    can_shoot = false;
    alarm[0] = reload_time; 
}

// Enemy Collision / Knockback
var _enemy = instance_place(x, y, obj_enemy_parent);

if (_enemy != noone) && (!TITLECARD)
{
    TITLECARD = true;
    alarm[1] = 90; 
    
    is_knocked_back = true;
    alarm[2] = 15; // 0.25 seconds of being stunned in the air
    
    yspeed = -5;
    
    if (x < _enemy.x) 
    {
        xspeed = -6;
    } 
    else 
    {
        xspeed = 6; 
    }
}

// Visual Feedback: Make the player flash slightly transparent while invincible
if (TITLECARD) {
    // This flips alpha between 0 and 1 every few frames
    image_alpha = (current_time % 100 < 50) ? 0 : 1; 
} else {
    image_alpha = 1; // Ensure they are solid when not invincible
}

