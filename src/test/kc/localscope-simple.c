// Tests anonymous scopes inside functions

byte* const BGCOL = $d021;

void main() {
    {
        byte i = 0;
        *BGCOL = i;
    }

    {
        byte i = 1;
        *BGCOL = i;
    }

}