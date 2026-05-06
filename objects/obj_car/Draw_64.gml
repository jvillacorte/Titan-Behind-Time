var px_per_step = abs(spd); // <-- use spd, not real_speed

var pixels_per_foot = 8;
var mph = (px_per_step / pixels_per_foot) * (room_speed * 3600 / 5280);

draw_set_color(c_black);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_text(16, 16, "Speed: " + string(round(px_per_step)) + " px/step");
draw_text(16, 32, "Speed: " + string(round(mph)) + " mph");

// obj_car : Draw GUI

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_text(16, 48, "car.x = " + string_format(x, 0, 2));
draw_text(16, 64, "car.y = " + string_format(y, 0, 2));