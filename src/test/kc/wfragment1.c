// Adding a missing word-fragment for Travis Fisher

#include <print.h>

const byte MAX_OBJECTS = 16;
word OBJ_WORLD_X[MAX_OBJECTS];
byte action_count = 0;
const byte READY_FRAMES = 5;

void main() {
    for(byte i:0..5)
        move_enemy(i);
}


bool move_enemy(byte obj_slot) {
    OBJ_WORLD_X[obj_slot] -= 1;
    return true;
}

bool game_ready() {
    if (action_count == 0)
        action_count = READY_FRAMES;
    print_str_ln("ready");
    action_count--;
    return (action_count==0);
}
