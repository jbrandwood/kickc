// Illustrates problem with struct return values from inlined functions

struct SplineVector {
    char x;
    char y;
};

void main() {
    struct SplineVector p1 = { 12, 24};
    struct SplineVector p2 = splineDouble(p1);

    char* const SCREEN = 0x0400;
    SCREEN[0] = p2.x;
    SCREEN[1] = p2.y;

}

inline struct SplineVector splineDouble(struct SplineVector p) {
    struct SplineVector pr = { p.x*2, p.y*2 };
    return pr;
}
