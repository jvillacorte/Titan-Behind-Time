music_tracks = [
    itsjustaburningmemoryquiet,
    Susumu_Hirasawa___Parade,
	Mice_On_Venus
];

// current playing state
cur_index = -1;
title_channel = -1;

// make sure the global exists
if (!variable_global_exists("music_track_index")) global.music_track_index = 0;
global.music_track_index = clamp(global.music_track_index, 0, array_length(music_tracks) - 1);