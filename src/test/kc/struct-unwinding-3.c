// Test combining unwind structs with classic structs
// Function calls return value

struct Point {
    char x;
    char y;
};

struct Point * const SCREEN = (char*)0x0400;

void main() {
    // Initialize classic struct from function returning unwound
    __ma struct Point p1 = point1(1, 2);
    SCREEN[0] = p1;
    // Initialize classic struct from function returning classic
    //p1 = point2(2, 3);
    //SCREEN[2] = p1;

    // Initialize unwound struct from function returning unwound
    //struct Point p2 = point1(3,4);
    //SCREEN[4] = p2;
    // Initialize unwound struct from function returning classic
    //p2 = point2(5,6);
    //SCREEN[6] = p2;
}

// Function returning unwound struct
struct Point point1(char x, char y) {
    // Print unwound struct
    struct Point p = { x, y };
    return p;
}

// Function returning classic struct
//__ma struct Point point2(char x, char y) {
//    // Print unwound struct
//    struct Point p = { x, y };
//    return p;
//}
