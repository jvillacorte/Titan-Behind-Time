var car = instance_find(obj_car, 0);
if (!instance_exists(car)) exit;

function _spawn_edge_beads_for_segment(x0, y0, x1, y1)
{
    var seg = point_distance(x0, y0, x1, y1);
    if (seg <= 0.001) return;

    var ang  = point_direction(x0, y0, x1, y1);
    var perp = ang + 90;

    var steps = max(1, floor(seg / edge_spacing));

    for (var s = 0; s <= steps; s++)
    {
        var t = s / steps;

        var cx = lerp(x0, x1, t);
        var cy = lerp(y0, y1, t);

        var lx = cx + lengthdir_x(road_half_w, perp);
        var ly = cy + lengthdir_y(road_half_w, perp);

        var rx = cx - lengthdir_x(road_half_w, perp);
        var ry = cy - lengthdir_y(road_half_w, perp);

        var wl = instance_create_layer(lx, ly, road_spawn_layer, obj_road_edge);
        var wr = instance_create_layer(rx, ry, road_spawn_layer, obj_road_edge);

        array_push(edge_left, wl);
        array_push(edge_right, wr);
    }
}

var dy = prev_car_y - car.y;
if (dy > 0) run_progress += dy;
prev_car_y = car.y;

if (!run_done && run_progress >= run_target)
{
    run_done = true;

    var made = 0;
    while (last_y > 0 && made < 5000)
    {
        var x0 = last_x;
        var y0 = last_y;

        var x1 = x0;
        var y1 = y0 - seg_len;

        if (spawn_edges) _spawn_edge_beads_for_segment(x0, y0, x1, y1);

        array_push(pts_x, x1);
        array_push(pts_y, y1);

        last_x = x1;
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
        var x0 = last_x;
        var y0 = last_y;

        var x1 = x0;
        var y1 = y0 - seg_len;

        if (spawn_edges) _spawn_edge_beads_for_segment(x0, y0, x1, y1);

        array_push(pts_x, x1);
        array_push(pts_y, y1);

        last_x = x1;
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

if (spawn_edges)
{
    var min_edge_y = car.y + keep_behind + 80;
    var killed = 0;

    while (array_length(edge_left) > 0 && killed < 700)
    {
        var instL = edge_left[0];
        var instR = edge_right[0];

        if (!instance_exists(instL) || !instance_exists(instR))
        {
            if (instance_exists(instL)) instance_destroy(instL);
            if (instance_exists(instR)) instance_destroy(instR);
            array_delete(edge_left, 0, 1);
            array_delete(edge_right, 0, 1);
            killed++;
            continue;
        }

        if (instL.y > min_edge_y && instR.y > min_edge_y)
        {
            instance_destroy(instL);
            instance_destroy(instR);
            array_delete(edge_left, 0, 1);
            array_delete(edge_right, 0, 1);
            killed++;
        }
        else break;
    }
}

if (!run_done && car.y < top_margin)
{
    var shift = (top_margin - car.y);

    car.y += shift;

    for (var i = 0; i < array_length(pts_y); i++) pts_y[i] += shift;
    last_y += shift;

    if (spawn_edges) with (obj_road_edge) y += shift;
    with (obj_tread_mark) y += shift;

    prev_car_y = car.y;
}