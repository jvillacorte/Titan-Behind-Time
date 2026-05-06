// obj_highway_gen : Create

active = true;

seg_len     = max(1, 12);
gen_ahead   = 2000;
keep_behind = 650;

lane_count  = 7;
lane_w      = 55;
shoulder_w  = 0;

road_total_w = lane_count * lane_w + shoulder_w * 2;
road_half_w  = road_total_w * 0.5;

straight_run_len = 9000;

run_target   = straight_run_len;
run_progress = 0;
run_done     = false;

max_segments_per_step = 260;

pts_x = [];
pts_y = [];
pts_h = [];

var car = instance_find(obj_car, 0);

var sx = room_width * 0.5;
var sy = room_height * 0.8;
if (instance_exists(car)) { sx = car.x; sy = car.y; }

road_center_x = sx;

pts_x = [road_center_x];
pts_y = [sy];
pts_h = [0];

last_x = road_center_x;
last_y = sy;
last_h = 0;

prev_car_y = sy;

overdraw = 18;

dash_len = 14;
dash_gap = 14;
dash_w   = 2;

top_margin = 240;

border_w      = 6;
border_dash   = 18;
border_gap    = 12;
border_color  = c_white;
border_alpha  = 1;

lane_x = [780, 835, 890, 945, 1000, 1055, 1110];

obstacle_min_gap  = 120;
obstacle_max_gap  = 220;

obstacles_per_row = 3;
obstacles_per_row = min(obstacles_per_row, array_length(lane_x) - 1);

obstacle_next_y   = sy - 350;