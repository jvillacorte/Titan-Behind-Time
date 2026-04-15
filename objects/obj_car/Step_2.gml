// target camera top-left so car is centered
var cam = view_camera[0];

var tx = obj_car.x - camera_get_view_width(cam) * 0.5;
var ty = obj_car.y - camera_get_view_height(cam) * 0.5;

// snap camera to integer pixels to prevent jitter
tx = round(tx);
ty = round(ty);

camera_set_view_pos(cam, tx, ty);