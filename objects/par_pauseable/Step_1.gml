if (global.game_paused)
{
    // stop common built-in motion
    speed = 0;
    hspeed = 0;
    vspeed = 0;

    // stop your custom motion vars (yours are xpsd/yspd)
    if (variable_instance_exists(id, "xpsd")) xpsd = 0;
    if (variable_instance_exists(id, "yspd")) yspd = 0;
	if (variable_instance_exists(id, "xspeed")) xspeed = 0;
	if (variable_instance_exists(id, "yspeed")) yspeed = 0;

    exit;
}