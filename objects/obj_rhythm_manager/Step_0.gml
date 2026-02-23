song_position += delta_time / 1000000;

var beat = floor((song_position + song_offset) / beat_interval);

if (beat != last_beat) {
    for (var b = last_beat + 1; b <= beat; b++) 
	{
        if (b mod beats_per_spawn == 0)
		{
            var a = instance_create_layer(room_width / 2 - 150, room_height + 50, "Instances", obj_alarm_note);
            a.alarm_time = string(irandom(11) + 1) + ":00 PM";
        }
    }
    last_beat = beat;
}

if (feedback_timer > 0) 
{
    feedback_timer -= delta_time / 1000000;
    if (feedback_timer <= 0) feedback_text = "";
}