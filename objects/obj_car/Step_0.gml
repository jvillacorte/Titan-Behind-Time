if (keyboard_check_pressed(ord("Q")))
{
    x = spawn_x;
    y = spawn_y;
    direction = spawn_dir;
    spd = 0;
    steer_angle = 0;
    image_angle = direction + sprite_angle_offset;
    exit;
}

var key_w = keyboard_check(ord("W"));
var key_s = keyboard_check(ord("S"));
var key_a = keyboard_check(ord("A"));
var key_d = keyboard_check(ord("D"));

if (key_w)
{
    spd += accel_rate;
}

if (key_s)
{
    if (spd > 0)
    {
        spd -= brake_rate;
    }
    else
    {
        spd -= reverse_rate;
    }
}

spd = clamp(spd, max_rev, max_fwd);

if (!key_w && !key_s)
{
    if (abs(spd) < rolling_friction)
    {
        spd = 0;
    }
    else
    {
        spd -= sign(spd) * rolling_friction;
    }
}

if (spd != 0)
{
    spd -= sign(spd) * (aero_drag * sqr(spd));
}

var steer_input = key_a - key_d;
var target_steer = steer_input * max_steer_angle;

steer_angle = lerp(steer_angle, target_steer, steer_lerp);

if (steer_input == 0)
{
    steer_angle = lerp(steer_angle, 0, steer_return);
}

var speed_factor = clamp(abs(spd) / max_fwd, 0, 1);
var reverse_mult = 1;

if (spd < 0)
{
    reverse_mult = -1;
}

direction += steer_angle * speed_factor * reverse_mult;

x += lengthdir_x(spd, direction);
y += lengthdir_y(spd, direction);

image_angle = direction + sprite_angle_offset;

if (abs(spd) > tread_min_speed)
{
    tread_timer += 1;

    if (tread_timer >= tread_interval)
    {
        tread_timer = 0;

        var rear_x = x - lengthdir_x(tread_back, direction);
        var rear_y = y - lengthdir_y(tread_back, direction);

        var lx = rear_x + lengthdir_x(tread_side, direction + 90);
        var ly = rear_y + lengthdir_y(tread_side, direction + 90);

        var rx = rear_x + lengthdir_x(tread_side, direction - 90);
        var ry = rear_y + lengthdir_y(tread_side, direction - 90);

        var m1 = instance_create_layer(lx, ly, layer, obj_tread_mark);
        m1.mark_dir = direction;

        var m2 = instance_create_layer(rx, ry, layer, obj_tread_mark);
        m2.mark_dir = direction;
    }
}
else
{
    tread_timer = 0;
}