prev_x = x;
prev_y = y;
real_speed = 0;

spawn_x = x;
spawn_y = y;

tread_timer = 0;
tread_interval = 2;
tread_side = 9;
tread_back = 22;
tread_min_speed = 0.8;

sprite_angle_offset = -90;
direction = image_angle - sprite_angle_offset;
spawn_dir = direction;

spd = 0;
max_fwd = 10;
max_rev = -4;

accel_rate = 0.18;
brake_rate = 0.30;
reverse_rate = 0.10;

rolling_friction = 0.05;
aero_drag = 0.003;

steer_angle = 0;
max_steer_angle = 3.8;
steer_return = 0.16;
steer_lerp = 0.22;

image_angle = direction + sprite_angle_offset;

