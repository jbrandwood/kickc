// Tests simple word pointer iteration
void main() {
    byte* const SCREEN = $400+40*6;
    word* wp = $0400;
    wp++;
    SCREEN[0] = <*wp;
    SCREEN[1] = >*wp;
    wp++;
    SCREEN[2] = <*wp;
    SCREEN[3] = >*wp;
    wp--;
    SCREEN[4] = <*wp;
    SCREEN[5] = >*wp;

}
