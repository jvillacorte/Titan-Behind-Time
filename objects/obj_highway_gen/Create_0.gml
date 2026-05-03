// ---------------- Straight highway settings ----------------
active = true;

seg_len     = max(1, 12);
gen_ahead   = 1200;
keep_behind = 650;

lane_count  = 7;
lane_w      = 65;
shoulder_w  = 0;

road_total_w = lane_count * lane_w + shoulder_w * 2;
road_half_w  = road_total_w * 0.5;

// --- total straight run length in pixels (CHANGE THIS) ---
straight_run_len = 9000;

run_target   = straight_run_len;
run_progress = 0;
run_done     = false;

max_segments_per_step = 260;

// road centerline points
pts_x = [];
pts_y = [];
pts_h = [];

// start centered on car if it exists, otherwise screen center
var car = instance_find(obj_car, 0);

var sx = room_width * 0.5;
var sy = room_height * 0.8;
if (instance_exists(car)) { sx = car.x; sy = car.y; }

// Lock the straight road to one X value (centerline)
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

// --- striped border settings (visual only) ---
border_w      = 6;
border_dash   = 18;
border_gap    = 12;
border_color  = c_white;
border_alpha  = 1;