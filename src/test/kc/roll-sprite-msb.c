// Tests rolling sprite MSB by variable amount

#include <c64.c>

void main() {
    word xpos = 200;
    for(byte s: 0..7) {
        position_sprite(s, xpos, 50);
        xpos += 10;
    }
}

void position_sprite(byte spriteno, word x, byte y) {
    SPRITES_YPOS[spriteno * 2] = y;
    SPRITES_XPOS[spriteno * 2] = <x;
    if (x > 255) {
        *SPRITES_XMSB |= 1 << spriteno;
    } else {
        *SPRITES_XMSB &= (1 << spriteno) ^ $ff;
    }
}