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

if (place_meeting(x, y + 1, obj_block_parent)) && (key_jump)
{
    yspeed = jumpheight;
}

// Horizontal Collision
if (place_meeting(x + xspeed, y, obj_block_parent))
{
    while (!place_meeting(x + sign(xspeed), y, obj_block_parent))
    {
        x = x + sign(xspeed);
    }
    xspeed = 0;
}
x = x + xspeed;

// Vertical Collision
if (place_meeting(x, y + yspeed,obj_block_parent))
{
    while (!place_meeting(x, y + sign(yspeed),obj_block_parent))
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

if (_enemy != noone) && (!TITLECARD) && (_enemy.is_dead == false) && (_enemy != obj_meteor)
{
    playerhp -= 1;
    if (playerhp <= 0) 
    {
        instance_destroy();
        // logic to move to gameover ui HERE
    }
    TITLECARD = true;
    alarm[1] = 90; 
    
    is_knocked_back = true;
    alarm[2] = 15; 
    
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

