// volume from sliders
var vm  = variable_global_exists("vol_master") ? global.vol_master : 1;
var vmu = variable_global_exists("vol_music")  ? global.vol_music  : 1;

// clamp selection
if (!variable_global_exists("music_track_index")) global.music_track_index = 0;
global.music_track_index = clamp(global.music_track_index, 0, array_length(music_tracks) - 1);

// if selection changed (or we haven't started yet), swap tracks
if (global.music_track_index != cur_index)
{
    cur_index = global.music_track_index;

    if (audio_is_playing(title_channel))
        audio_stop_sound(title_channel);

    title_channel = audio_play_sound(music_tracks[cur_index], 0, true);

    // set gain immediately so it doesn't blast at full volume for a frame
    audio_sound_gain(title_channel, vm * vmu, 0);
}
else
{
    // keep gain synced
    if (audio_is_playing(title_channel))
        audio_sound_gain(title_channel, vm * vmu, 0);
}