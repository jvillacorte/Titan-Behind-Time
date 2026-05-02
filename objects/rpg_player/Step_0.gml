if (global.game_paused)
{
    xspd = 0;
    yspd = 0;
    exit;
}

right_key = keyboard_check(vk_right) || keyboard_check(ord("D"));
left_key = keyboard_check(vk_left) || keyboard_check(ord("A"));
up_key = keyboard_check(vk_up) || keyboard_check(ord("W"));
down_key = keyboard_check(vk_down) || keyboard_check(ord("S"));

//xspd and yspd
xspd = (right_key - left_key) * move_spd;
yspd = (down_key - up_key) * move_spd;

//pause
if instance_exists(obj_pauser)
{
	xspd = 0;
	yspd = 0;
}

//Delete Player


//collisions
if place_meeting(x + xspd, y, obj_wall) == true
{
xspd = 0;	
}

if place_meeting(x, y + yspd, obj_wall) == true
{
yspd = 0;	
}

//move player
x += xspd;
y += yspd;

//set sprite
mask_index = sprite[DOWN];

if yspd == 0
{
	if xspd > 0 {face = RIGHT};
	if xspd < 0 {face = LEFT};
}

if xspd == 0
{
	if yspd > 0 {face = DOWN};
	if yspd < 0 {face = UP};
}

sprite_index = sprite[face];


//animate

if (xspd == 0 && yspd == 0 && face == DOWN)  { sprite_index = sprite[DOWN_IDLE]; }
if (xspd == 0 && yspd == 0 && face == UP)    { sprite_index = sprite[UP_IDLE];}
if (xspd == 0 && yspd == 0 && face == LEFT)  { sprite_index = sprite[LEFT_IDLE];}
if (xspd == 0 && yspd == 0 && face == RIGHT) { sprite_index = sprite[RIGHT_IDLE];}


//if xspd == 0 && yspd == 0 
//{
//image_index = 0;
//}

//depth
depth = -bbox_bottom;