function scr_room_change_if_touching(_changer_object)
{
    var inst = instance_place(x, y, _changer_object);
    if (inst != noone) room_goto(inst.target_room);
}