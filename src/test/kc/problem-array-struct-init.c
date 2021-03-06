// Demonstrates initializing an array of structs

unsigned int words[] = { 1, 2, 3 };

struct Point {
    char x;
    char y;
};

struct Point points[] = {
    { 1, 2 },
    { 3, 4 },
    { 5, 6 }
};

/*
struct List {
    char id;
    char elm[3];
};

struct List aList = { 1, { 2, 3, 4 }};

struct List[] lists = { { 1, { 2, 3, 4 }}, { 5, { 6, 7, 8 }}, { 9, { 10, 11, 12 }} };
*/

void main() {
    char* const SCREEN = (char*)0x0400;
    char idx = 0;
    for ( char i: 0..2) {
        SCREEN[idx++] = points[i].x;
        SCREEN[idx++] = points[i].y;

        SCREEN[idx++] = <words[i];
        SCREEN[idx++] = >words[i];

//        SCREEN[idx++] = aList.elm[i];
//        SCREEN[idx++] = lists[i].elm[i];

    }
}