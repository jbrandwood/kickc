// Adding a missing word-fragment for Travis Fisher

#include <c64-print.h>

byte action_count = 0;
const byte READY_FRAMES = 5;

void main() {
    for(byte i:0..5)
        if(game_ready())
            print_str_ln("ready!");
}

bool game_ready() {
    if (action_count == 0)
        action_count = READY_FRAMES;
    print_str_ln("ready");
    action_count--;
    return (action_count==0);
}
