if (variable_global_exists("font_main"))
{
    if (global.font_main != -1)
    {
        font_delete(global.font_main);
        global.font_main = -1;
    }
}