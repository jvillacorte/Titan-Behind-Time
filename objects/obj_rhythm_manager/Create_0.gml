song_position = 0;
bpm = 120;
beat_interval = 60 / bpm;

beats_per_spawn = 2;
last_beat = -1;
song_offset = 0.0;

player_score = 0;
combo = 0;

hit_zone_y = room_height / 2;
hit_zone_range = 30;

perfect_threshold = 15;
good_threshold = 30;

perfect_hit = 0;
good_hit = 0;
miss_hit = 0;

feedback_text = "";
feedback_color = c_white;
feedback_timer = 0;

function show_feedback(_text, _color) 
{
    feedback_text = _text;
    feedback_color = _color;
    feedback_timer = 1.0;
}

audio_play_sound(snd_rhythm_bgm, 1, true);