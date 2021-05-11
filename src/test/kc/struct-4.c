// Minimal struct - initializing using a value list

struct Point {
    byte x;
    byte y;
};


void main() {
    byte x = 2;
    byte y = 3;

    struct Point p = { x, y+1 };
    byte* const SCREEN = (char*)0x0400;
    SCREEN[0] = p.x;
    SCREEN[1] = p.y;
}

