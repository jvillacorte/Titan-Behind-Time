if (is_fading_out) {
    fade_alpha += fade_speed;
    if (fade_alpha >= 1) {
        room_goto(target_room);
        is_fading_out = false; 
    }
} else {
    fade_alpha -= fade_speed;
    if (fade_alpha <= 0) {
        instance_destroy();
    }
}