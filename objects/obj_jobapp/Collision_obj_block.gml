// Check for collision with a wall/block
if (place_meeting(x, y, obj_block)) 
{
    instance_destroy();
}

//future code for enemies n stuff
/*
if (place_meeting(x, y, obj_enemy)) 
{
    // 1. Tell the enemy it took damage

    instance_destroy(); // Remove the bullet
}
*/