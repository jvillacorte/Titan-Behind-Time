var a = (life / life_max) * 0.45;

draw_set_alpha(a);
draw_set_color(make_color_rgb(20, 20, 20));

var x1 = x + lengthdir_x(mark_len * 0.5, mark_dir);
var y1 = y + lengthdir_y(mark_len * 0.5, mark_dir);
var x2 = x - lengthdir_x(mark_len * 0.5, mark_dir);
var y2 = y - lengthdir_y(mark_len * 0.5, mark_dir);

draw_line_width(x1, y1, x2, y2, mark_w);

draw_set_alpha(1);
draw_set_color(c_white);