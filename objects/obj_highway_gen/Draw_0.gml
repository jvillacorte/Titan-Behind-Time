var count = array_length(pts_x);
if (count < 2) exit;

// ---------- road body ----------
var road_w = road_half_w * 2 + overdraw;

draw_set_color(make_color_rgb(70, 70, 70));
for (var i = 1; i < count; i++)
{
    var x0 = round(pts_x[i-1]), y0 = round(pts_y[i-1]);
    var x1 = round(pts_x[i]),   y1 = round(pts_y[i]);
    draw_line_width(x0, y0, x1, y1, road_w);

    draw_circle(x0, y0, road_w * 0.5, false);
    if (i == count - 1) draw_circle(x1, y1, road_w * 0.5, false);
}

// ---------- lane dashes ----------
var dash_step = dash_len + dash_gap;
draw_set_color(make_color_rgb(200, 200, 200));

for (var i = 1; i < count; i++)
{
    var x0 = pts_x[i-1], y0 = pts_y[i-1];
    var x1 = pts_x[i],   y1 = pts_y[i];

    var seg = point_distance(x0, y0, x1, y1);
    if (seg <= 0.001) continue;

    for (var lane = 0; lane < lane_count - 1; lane++)
    {
        var offset = ((lane + 1) - lane_count * 0.5) * lane_w;

        var pos = 0;
        while (pos < seg)
        {
            var a = pos / seg;
            var bpos = min(pos + dash_len, seg);
            var b2 = bpos / seg;

            var ax = lerp(x0, x1, a);
            var ay = lerp(y0, y1, a);
            var bx = lerp(x0, x1, b2);
            var by = lerp(y0, y1, b2);

            ax += offset;
            bx += offset;

            draw_line_width(round(ax), round(ay), round(bx), round(by), dash_w);

            pos += dash_step;
        }
    }
}

// ---------- striped borders (visual only) ----------
draw_set_color(border_color);
draw_set_alpha(border_alpha);

var border_step = border_dash + border_gap;

for (var i = 1; i < count; i++)
{
    var x0 = pts_x[i-1], y0 = pts_y[i-1];
    var x1 = pts_x[i],   y1 = pts_y[i];

    var seg = point_distance(x0, y0, x1, y1);
    if (seg <= 0.001) continue;

    var ang  = point_direction(x0, y0, x1, y1);
    var perp = ang + 90;

    var pos = 0;
    while (pos < seg)
    {
        var a0 = pos / seg;
        var pos2 = min(pos + border_dash, seg);
        var a1 = pos2 / seg;

        var cx0 = lerp(x0, x1, a0);
        var cy0 = lerp(y0, y1, a0);
        var cx1 = lerp(x0, x1, a1);
        var cy1 = lerp(y0, y1, a1);

        // left border
        var lx0 = cx0 + lengthdir_x(road_half_w, perp);
        var ly0 = cy0 + lengthdir_y(road_half_w, perp);
        var lx1 = cx1 + lengthdir_x(road_half_w, perp);
        var ly1 = cy1 + lengthdir_y(road_half_w, perp);

        // right border
        var rx0 = cx0 - lengthdir_x(road_half_w, perp);
        var ry0 = cy0 - lengthdir_y(road_half_w, perp);
        var rx1 = cx1 - lengthdir_x(road_half_w, perp);
        var ry1 = cy1 - lengthdir_y(road_half_w, perp);

        draw_line_width(round(lx0), round(ly0), round(lx1), round(ly1), border_w);
        draw_line_width(round(rx0), round(ry0), round(rx1), round(ry1), border_w);

        pos += border_step;
    }
}

draw_set_alpha(1);