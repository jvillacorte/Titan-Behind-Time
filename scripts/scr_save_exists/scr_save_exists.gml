/// @function scr_save_exists()
/// @returns {bool}
if (instance_exists(obj_game_controller))
{
    var _r = false;
    with (obj_game_controller) { _r = save_exists(); }
    return _r;
}
return false;