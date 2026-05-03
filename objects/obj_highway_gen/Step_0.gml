if (!active) exit;

// pause behavior (safe guard in case controller hasn't created global yet)
if (variable_global_exists("game_paused") && global.game_paused) exit;

var car = instance_find(obj_car, 0);
if (!instance_exists(car)) exit;

// ---------------- progress tracking ----------------
var dy = prev_car_y - car.y;
if (dy > 0) run_progress += dy;
prev_car_y = car.y;

if (!run_done && run_progress >= run_target)
{
    run_done = true;

    // Extend remaining road to y<=0 so the finish isn't a hard cutoff
    var made = 0;
    while (last_y > 0 && made < 5000)
    {
        var y0 = last_y;
        var y1 = y0 - seg_len;

        array_push(pts_x, road_center_x);
        array_push(pts_y, y1);

        last_y = y1;
        made++;
    }
}

// ---------------- generate ahead (straight line) ----------------
if (!run_done)
{
    var target_y = car.y - gen_ahead;

    var made2 = 0;
    while (last_y > target_y && made2 < max_segments_per_step)
    {
        var y0 = last_y;
        var y1 = y0 - seg_len;

        array_push(pts_x, road_center_x);
        array_push(pts_y, y1);

        last_y = y1;
        made2++;
    }
}

// ---------------- cleanup behind car ----------------
var min_y = car.y + keep_behind;

var removed = 0;
while (array_length(pts_y) > 2 && pts_y[0] > min_y && removed < 300)
{
    array_delete(pts_x, 0, 1);
    array_delete(pts_y, 0, 1);
    removed++;
}

// ---------------- keep car from going above top margin ----------------
if (!run_done && car.y < top_margin)
{
    var shift = (top_margin - car.y);

    car.y += shift;

    for (var i = 0; i < array_length(pts_y); i++) pts_y[i] += shift;
    last_y += shift;

    with (obj_tread_mark) y += shift;

    prev_car_y = car.y;
}