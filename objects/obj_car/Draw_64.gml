var px_per_step = real_speed;

var pixels_per_foot = 8;
var mph = (px_per_step / pixels_per_foot) * (3600 / 5280);

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_text(16, 16, "Speed: " + string(round(px_per_step)) + " px/step");