#include <c64.h>

byte* const SCREEN = (byte*)$400;
byte* const SPRITES_PTR = SCREEN+$3f8;
byte* const SPRITE = (byte*)$2000;

void main() {
    init();
    do {
        do { } while (*RASTER!=$ff);
        anim();
    } while(true);
}

// Fill and show a sprite, clear the screen
void init() {
    *SPRITES_ENABLE = %00000001;
    *SPRITES_EXPAND_X = 0;
    *SPRITES_EXPAND_Y = 0;
    SPRITES_XPOS[0] = 100;
    SPRITES_YPOS[0] = 100;
    SPRITES_COLOR[0] = WHITE;
    SPRITES_PTR[0] = (byte)(SPRITE/$40);
    for(byte* sc=SCREEN; sc!=SCREEN+1000; sc++ ) {
        *sc = ' ';
    }
    for(byte i : 0..63) {
        SPRITE[i] = $ff;
    }
}

signed word xpos = 0;
signed word ypos = 0;

signed word yvel_init = 100;

signed word xvel = 200;
signed word yvel = yvel_init;

const signed word g = -5;

void anim() {

    // Check if the object has hit the ground
    if(ypos<0) {
        // Reset position
        xpos = 0;
        ypos = 0;
        // Modify initial velocities
        xvel = -xvel;
        yvel_init = yvel_init-10;
        if(yvel_init<-200) {
            // Reset y velocity
            yvel_init = 200;
        }
        yvel = yvel_init;
    }

    // Move object
    yvel = yvel + g;
    xpos = xpos + xvel;
    ypos = ypos + yvel;


   signed word sprite_x = xpos>>7 + 160;
   signed word sprite_y = 230 - ypos>>5;

   SPRITES_XPOS[0] = (byte)sprite_x;
   SPRITES_YPOS[0] = (byte)sprite_y;
   *SPRITES_XMSB = >sprite_x;

}
