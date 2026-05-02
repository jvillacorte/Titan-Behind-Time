/// @function scr_load_game()
/// @returns {bool}
if (instance_exists(obj_game_controller))
{
    var _r = false;
    with (obj_game_controller) { _r = load_game(); }
    return _r;
}
return false;