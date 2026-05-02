/// @function scr_save_game()
if (instance_exists(obj_game_controller))
{
    with (obj_game_controller) { save_game(); }
}