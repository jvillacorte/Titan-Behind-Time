// obj_highway_gen : Step

if (!active) exit;
if (variable_global_exists("game_paused") && global.game_paused) exit;

var car = instance_find(obj_car, 0);
if (!instance_exists(car)) exit;

var dy = prev_car_y - car.y;
if (dy > 0) run_progress += dy;
prev_car_y = car.y;

if (!run_done && run_progress >= run_target)
{
    run_done = true;

    var made = 0;
    while (last_y > 0 && made < 5000)
    {
        var y1 = last_y - seg_len;
        array_push(pts_x, road_center_x);
        array_push(pts_y, y1);
        last_y = y1;
        made++;
    }
}

if (!run_done)
{
    var target_y = car.y - gen_ahead;

    var made2 = 0;
    while (last_y > target_y && made2 < max_segments_per_step)
    {
        var y1 = last_y - seg_len;
        array_push(pts_x, road_center_x);
        array_push(pts_y, y1);
        last_y = y1;
        made2++;
    }
}

var min_y = car.y + keep_behind;

var removed = 0;
while (array_length(pts_y) > 2 && pts_y[0] > min_y && removed < 300)
{
    array_delete(pts_x, 0, 1);
    array_delete(pts_y, 0, 1);
    removed++;
}

if (!run_done && car.y < top_margin)
{
    var shift = (top_margin - car.y);

    car.y += shift;

    for (var i = 0; i < array_length(pts_y); i++) pts_y[i] += shift;
    last_y += shift;

    with (obj_tread_mark) y += shift;
    with (obj_car_obstacle) y += shift;

    obstacle_next_y += shift;

    prev_car_y = car.y;
}

if (!run_done)
{
    while (obstacle_next_y > car.y - gen_ahead)
    {
        var lane_count_local = array_length(lane_x);
        var max_this_row = lane_count_local - 1;

        var want = clamp(obstacles_per_row, 0, max_this_row);

        var used = array_create(lane_count_local, false);

        var spawned = 0;
        var tries = 0;

        while (spawned < want && tries < 200)
        {
            tries++;

            var li = irandom(lane_count_local - 1);
            if (used[li]) continue;
            used[li] = true;

            var ox = lane_x[li];
            var oy = obstacle_next_y;

            if (!place_meeting(ox, oy, obj_car_obstacle))
            {
                instance_create_depth(ox, oy, car.depth + 1, obj_car_obstacle);
                spawned++;
            }
        }

        obstacle_next_y -= irandom_range(obstacle_min_gap, obstacle_max_gap);
    }
}