// Minimal union with C-Standard behavior - union initializer

typedef unsigned long uint32_t;
typedef unsigned char byte_t;

typedef union IPV4 {
   uint32_t d;
   byte_t b[4];
} IPV4;

IPV4 ipv4 = { 0x12345678ul };

char* const SCREEN = (char*)0x0400;

void main() {
    SCREEN[0] = ipv4.b[3];
    SCREEN[1] = ipv4.b[2];
    SCREEN[2] = ipv4.b[1];
    SCREEN[3] = ipv4.b[0];
}