// obj_time_controller : Draw GUI

if (!active) exit;

// use BigFont for the timer UI
var _old_font = draw_get_font();
draw_set_font(BigFont);

draw_set_color(c_white);

var mins = floor(countdown / 60);
var secs = floor(countdown) mod 60;

var secs_text = string(secs);
if (secs < 10) secs_text = "0" + secs_text;

draw_text(24, 24, string(mins) + ":" + secs_text);

// restore previous font (so other UI isn't affected)
draw_set_font(_old_font);