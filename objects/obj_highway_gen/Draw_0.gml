var count = array_length(pts_x);
if (count < 2) exit;

var w = road_half_w * 2 + overdraw;

draw_set_color(make_color_rgb(70, 70, 70));
for (var i = 1; i < count; i++)
{
    var x0 = round(pts_x[i-1]), y0 = round(pts_y[i-1]);
    var x1 = round(pts_x[i]),   y1 = round(pts_y[i]);
    draw_line_width(x0, y0, x1, y1, w);

    draw_circle(x0, y0, w * 0.5, false);
    if (i == count - 1) draw_circle(x1, y1, w * 0.5, false);
}

var dash_step = dash_len + dash_gap;
draw_set_color(make_color_rgb(200, 200, 200));

for (var i = 1; i < count; i++)
{
    var x0 = pts_x[i-1], y0 = pts_y[i-1];
    var x1 = pts_x[i],   y1 = pts_y[i];

    var seg = point_distance(x0, y0, x1, y1);
    if (seg <= 0.001) continue;

    for (var b = 0; b < lane_count - 1; b++)
    {
        var offset = ((b + 1) - lane_count * 0.5) * lane_w;

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