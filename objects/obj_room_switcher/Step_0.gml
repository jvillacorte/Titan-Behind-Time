//Simple Transition Between levels for testing

if (keyboard_check_pressed(ord("1")))
{
    room_goto(rm_rhythm_test);
}

if (keyboard_check_pressed(ord("2")))
{
    room_goto(Platformer_Fighter);
}

if (keyboard_check_pressed(ord("3")))
{
    room_goto(RpgTest);
}

if (keyboard_check_pressed(ord("4")))
{
    room_goto(DrivingSq);
}