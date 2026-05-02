if (global.toast_time <= 0) exit;

var t = global.toast_time / global.toast_time_max;
var a = clamp(t, 0, 1);
a = a * a;

draw_set_font(global.font_main);
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(a);

var margin = 12;
var gui_width = display_get_gui_width();

draw_text(gui_width - margin, margin, global.toast_text);

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);