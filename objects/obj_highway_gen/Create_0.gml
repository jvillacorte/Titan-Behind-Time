seg_len     = max(1, 12);
gen_ahead   = 1200;
keep_behind = 650;

lane_count  = 5;
lane_w      = 50;
shoulder_w  = 0;

road_total_w = lane_count * lane_w + shoulder_w * 2;
road_half_w  = road_total_w * 0.5;

min_run_len = 6000;
max_run_len = 12000;

run_target   = irandom_range(min_run_len, max_run_len);
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

pts_x = [sx];
pts_y = [sy];
pts_h = [0];

last_x = sx;
last_y = sy;
last_h = 0;

prev_car_y = sy;

spawn_edges = true;
edge_spacing = 10;

edge_left  = [];
edge_right = [];

road_spawn_layer = "Instances_1";

overdraw = 18;

dash_len = 14;
dash_gap = 14;
dash_w   = 2;

top_margin = 240;

// gentle curvature
turn_rate   = 0.08;  // change per segment
heading_damp = 0.985;
max_heading = 6;     // degrees