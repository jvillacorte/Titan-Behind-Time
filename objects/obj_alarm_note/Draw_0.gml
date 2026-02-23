draw_self();

draw_set_color(c_black);
draw_set_halign(fa_left);
draw_text(x + 10, y + 10, alarm_time);

var tx = x + sprite_width - 40;
var ty = y + sprite_height * 0.5 - 16;

if (is_toggled) draw_sprite(spr_toggle_on, 0, tx, ty);
else draw_sprite(spr_toggle_off, 0, tx, ty);

if (instance_exists(obj_rhythm_manager)) {
    var m = instance_find(obj_rhythm_manager, 0);
    if (m != noone) {
        var in_zone = (y >= m.hit_zone_y - m.hit_zone_range) && (y <= m.hit_zone_y + m.hit_zone_range);
        if (in_zone && !is_toggled) {
            draw_set_color(c_yellow);
            draw_set_halign(fa_center);
            draw_text(x + sprite_width * 0.5, y - 20, "[Z]");
        }
    }
}

draw_set_color(c_white);
draw_set_halign(fa_left);