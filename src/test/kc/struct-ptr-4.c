// Minimal struct - accessing pointer to struct  in memory in a loop

struct Point {
    byte x;
    byte y;
};

struct Point* POINTS = 0x1000;

void main() {
    // Fill points
    struct Point* points = POINTS;
    for( byte i: 0..3) {
        (*points).x = i;
        (*points).y = i+5;
        points++;
    }

    // Print points
    byte* const SCREEN = 0x0400;
    byte idx = 0;
    points = POINTS;
    for( byte i: 0..3) {
        SCREEN[idx++] = (*points).x;
        SCREEN[idx++] = (*points).y;
        SCREEN[idx++] = ' ';
        points++;
    }

}