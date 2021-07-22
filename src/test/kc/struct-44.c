// Demonstrates nested struct/enum definitions.

struct Circle {
    unsigned int radius;
    struct Point {
            unsigned int x;
            unsigned int y;
    } center;
    enum Color {
        COL_BLACK,
        COL_WHITE,
        COL_RED
    } color;
} circle = { 100,  { 200, 300 }, COL_RED };


struct Circle c2 = { 50,  { 150, 350 }, COL_WHITE };

void main(void) {
    print_circle(circle);
    print_ln();
    print_circle(c2);
}

void print_circle(struct Circle c) {
    print_str("r:");
    print_uint(c.radius);
    print_str(" c:(");
    print_uint(c.center.x);
    print_str(",");
    print_uint(c.center.y);
    print_str(") ");
    print_uchar(c.color);
}

char HEX[] = "0123456789abcdef";

void print_uint(unsigned int i) {
    print_char(HEX[BYTE1(i)>>4]);
    print_char(HEX[BYTE1(i)&0x0f]);
    print_char(HEX[BYTE0(i)>>4]);
    print_char(HEX[BYTE0(i)&0x0f]);
}

void print_uchar(unsigned char c) {
    print_char(HEX[c>>4]);
    print_char(HEX[c&0x0f]);
}

void print_str(char * str) {
    while(*str)
        print_char(*(str++));
}

char * screen_line = (char*)0x0400 + 40*10;
char screen_idx = 0;

void print_char(char c) {
    screen_line[screen_idx++] = c;
    if(screen_idx==40)
        print_ln();
}

void print_ln() {
    screen_line +=40;
    screen_idx = 0;
}
