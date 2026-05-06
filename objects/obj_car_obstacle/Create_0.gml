depth = 0;

// Randomize sprite
var r = irandom(3);
switch (r)
{
    case 0: sprite_index = compact_blue;   break;
    case 1: sprite_index = compact_green;  break;
    case 2: sprite_index = compact_orange; break;
    case 3: sprite_index = compact_red;    break;
}

image_speed = 0;
image_index = 0;

// optional: if you want slight random orientation
image_angle = 0;

// how much this obstacle slows the player (tune)
slow_amount = 2.0;  // pixels/step to subtract when hit

// prevents multiple hits per second if car overlaps for a few frames
hit_cooldown = 0;