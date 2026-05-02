/// @function scr_save_delete()
if (instance_exists(obj_game_controller))
{
    with (obj_game_controller) { save_delete(); }
}