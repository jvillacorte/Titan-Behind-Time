song_position += delta_time / 1000000;

var beat = floor((song_position + song_offset) / beat_interval);

if (beat != last_beat) {
    for (var b = last_beat + 1; b <= beat; b++) 
    {
        if (b mod beats_per_spawn == 0)
        {
            var a = instance_create_layer(room_width / 2 - 150, room_height + 50, "Instances", obj_alarm_note);

            if (!variable_instance_exists(id, "alarm_minutes")) alarm_minutes = 6 * 60;
            if (alarm_minutes > 8 * 60) alarm_minutes = 6 * 60;

            var hh = floor(alarm_minutes / 60);
            var mm = alarm_minutes mod 60;

            var hour12 = hh mod 12;
            if (hour12 == 0) hour12 = 12;

            var mm_str = string(mm);
            if (mm < 10) mm_str = "0" + mm_str;

            a.alarm_time = string(hour12) + ":" + mm_str + " AM";

            alarm_minutes += 5;
        }
    }
    last_beat = beat;
}

if (feedback_timer > 0) 
{
    feedback_timer -= delta_time / 1000000;
    if (feedback_timer <= 0) feedback_text = "";
}