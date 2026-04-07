var _cam = view_camera[0];
var _cam_width = camera_get_view_width(_cam);
var _cam_height = camera_get_view_height(_cam);

// X axis follows the player
var _target_x = x - (_cam_width / 2);


var _target_y = 150; 

// Clamp X so the camera doesn't show black voids on the left/right
_target_x = clamp(_target_x, 0, room_width - _cam_width);

// Update the camera
camera_set_view_pos(_cam, _target_x, _target_y);