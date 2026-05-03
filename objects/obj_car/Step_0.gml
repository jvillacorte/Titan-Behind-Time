if (!active) exit;
if (variable_global_exists("game_paused") && global.game_paused) exit;

if (keyboard_check_pressed(ord("Q")))
{
    x = spawn_x;
    y = spawn_y;
    direction = spawn_dir;
    spd = 0;
    steer_angle = 0;

    image_angle = 0;

    prev_x = x;
    prev_y = y;
    real_speed = 0;

    exit;
}

var key_w = keyboard_check(ord("W")) || keyboard_check(vk_up);
var key_s = keyboard_check(ord("S")) || keyboard_check(vk_down);
var key_a = keyboard_check(ord("A")) || keyboard_check(vk_left);
var key_d = keyboard_check(ord("D")) || keyboard_check(vk_right);

if (key_w) spd += accel_rate;

if (key_s)
{
    if (spd > 0) spd -= brake_rate;
    else         spd -= reverse_rate;
}

spd = clamp(spd, max_rev, max_fwd);

if (!key_w && !key_s)
{
    if (abs(spd) < rolling_friction) spd = 0;
    else spd -= sign(spd) * rolling_friction;
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
var reverse_mult = (spd < 0) ? -1 : 1;

direction += steer_angle * speed_factor * reverse_mult;

var xspd = lengthdir_x(spd, direction);
var yspd = lengthdir_y(spd, direction);

// apply movement
x += xspd;
y += yspd;

// ------------------------------------------------------------
// Clamp car within road borders (requires obj_highway_gen)
// ------------------------------------------------------------
var gen = instance_find(obj_highway_gen, 0);
if (instance_exists(gen))
{
    // More reliable "half width" than sprite_width:
    // bbox_* uses the current mask bounds.
    var half_car = max(1, (bbox_right - bbox_left) * 0.5);

    // If you want clamp to match the *drawn* road including overdraw,
    // use the next line instead:
    // var half_road = gen.road_half_w + gen.overdraw * 0.5;

    var half_road = gen.road_half_w; // clamp to actual road width (no overdraw)

    var left_bound  = gen.road_center_x - half_road + half_car;
    var right_bound = gen.road_center_x + half_road - half_car;

    // If car is wider than road bounds, avoid inverted clamp:
    if (left_bound > right_bound)
    {
        var mid = gen.road_center_x;
        left_bound = mid;
        right_bound = mid;
    }

    // Clamp and cancel horizontal movement when hitting wall
    var oldx = x;
    x = clamp(x, left_bound, right_bound);

    if (x != oldx)
    {
        // If you want: lose speed when scraping wall
        // spd *= 0.98;

        // prevent continuous "push" into wall from xspd
        // (not strictly required but feels better)
        // Note: xspd is local; we just zero real_speed effect is fine.
    }
}
else
{
    // Debug helper: if clamp isn't working, it's usually because gen isn't in the room.
    // Uncomment to verify at runtime:
    // show_debug_message("No obj_highway_gen instance found; clamp skipped");
}

// stop at end of run (optional; only if generator exists)
if (instance_exists(gen) && gen.run_done && y <= 0)
{
    y = 0;
    spd = 0;
    steer_angle = 0;
}

image_angle = 0;

// tread marks
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

real_speed = point_distance(x, y, prev_x, prev_y);
prev_x = x;
prev_y = y;

scr_room_change_if_touching(obj_room_changer);