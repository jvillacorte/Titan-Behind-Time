if (!variable_global_exists("font_main"))
{
    global.font_main = -1;
}

if (global.font_main == -1)
{
    global.font_main = font_add_sprite(spr_main_font, 32, true, 1);
}