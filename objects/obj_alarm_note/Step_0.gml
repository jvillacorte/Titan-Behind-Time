y -= scroll_speed;

if (!instance_exists(obj_rhythm_manager)) exit;
var m = instance_find(obj_rhythm_manager, 0);
if (m == noone) exit;

var in_zone = (y >= m.hit_zone_y - m.hit_zone_range) && (y <= m.hit_zone_y + m.hit_zone_range);

if (keyboard_check_pressed(ord("Z")) && in_zone && !is_toggled)
{
    var diff = abs(y - m.hit_zone_y);

    if (diff <= m.perfect_threshold) 
	{
        m.player_score += 100;
        m.combo += 1;
        m.show_feedback("PERFECT!", c_yellow);
        audio_play_sound(snd_toggle_hit, 1, false);
        is_toggled = true;
    } else if (diff <= m.good_threshold)
	{
        m.player_score += 50;
        m.combo += 1;
        m.show_feedback("GOOD", c_lime);
        audio_play_sound(snd_toggle_hit, 1, false);
        is_toggled = true;
    }
}

if (y < m.hit_zone_y - m.hit_zone_range && !is_toggled && !missed) 
{
    m.combo = 0;
    m.show_feedback("MISS", c_red);
    missed = true;
}

if (y < -sprite_height) instance_destroy();