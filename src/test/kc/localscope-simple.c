// Tests anonymous scopes inside functions

byte* const BG_COLOR = $d021;

void main() {
    {
        byte i = 0;
        *BG_COLOR = i;
    }

    {
        byte i = 1;
        *BG_COLOR = i;
    }

}