draw_set_font(global.font_main);

op_length = get_op_length();

var _new_w = 0;
for (var i = 0; i < op_length; i++)
{
    _new_w = max(_new_w, string_width(option[menu_level, i]));
}

width = _new_w + op_border * 2;

height = op_border * 2
    + string_height(option[menu_level, 0])
    + (op_length - 1) * op_space;

x = camera_get_view_x(view_camera[0])
    + camera_get_view_width(view_camera[0]) / 2
    - width / 2;

y = camera_get_view_y(view_camera[0])
    + camera_get_view_height(view_camera[0]) / 2
    - height / 2;

draw_sprite_ext(sprite_index, image_index, x, y,
    width / sprite_width, height / sprite_height,
    0, c_white, 1);

draw_set_valign(fa_top);
draw_set_halign(fa_left);

for (var i = 0; i < op_length; i++)
{
    var _c = (pos == i) ? c_yellow : c_white;

    draw_text_color(
        x + op_border,
        y + op_border + op_space * i,
        option[menu_level, i],
        _c, _c, _c, _c,
        1
    );
}

if (global.brightness > 0)
{
    draw_set_color(c_black);
    draw_set_alpha(global.brightness);

    var vx = camera_get_view_x(view_camera[0]);
    var vy = camera_get_view_y(view_camera[0]);
    var vw = camera_get_view_width(view_camera[0]);
    var vh = camera_get_view_height(view_camera[0]);

    draw_rectangle(vx, vy, vx + vw, vy + vh, false);
    draw_set_alpha(1);
}