if (keyboard_check_pressed(vk_escape))
{
    if (room != rm_title_screen)
    {
        if (!instance_exists(global.pause_menu_inst))
        {
            pause_set(true);
            global.pause_menu_inst = instance_create_depth(0, 0, -100000, obj_pause_menu);
        }
        else
        {
            with (global.pause_menu_inst)
            {
                instance_destroy();
            }

            global.pause_menu_inst = noone;
            pause_set(false);
        }
    }
}