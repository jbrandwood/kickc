
typedef byte uint8;

typedef struct PointDef {
    uint8 x;
    uint8 y;
} Point;

typedef Point* PointPtr;

void main() {
    Point p = { 4, 7 };
    PointPtr SCREEN = (PointPtr)0x0400;
    *SCREEN = p;
}