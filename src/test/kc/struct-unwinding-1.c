// Test combining unwind structs with classic structs

struct Point {
    char x;
    char y;
};

struct Point * const SCREEN = (struct Point *)0x0400;

void main() {
    // Initialize classic struct
    __ma struct Point p1 = { 1, 2 };
    SCREEN[0] = p1;
    // Copy classic struct to unwound struct
    struct Point p2 = p1;
    SCREEN[2] = p2;
    // Set in classic struct
    p1.x = 3;
    SCREEN[4] = p1;
    // Set in unwound struct
    p2.x = 4;
    SCREEN[6] = p2;
    // Copy unwound struct to classic struct
    p1 = p2;
    SCREEN[8] = p1;
}
