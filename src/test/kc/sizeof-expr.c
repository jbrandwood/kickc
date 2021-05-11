// Tests the sizeof() operator on values/expressions

byte* const SCREEN = (byte*)$400;

void main() {
    byte idx = 0;

    // Simple types
    volatile byte b = 0;
    volatile word w = 0;
    // Pointers
    byte* bp = (byte*)$1000;
    word* wp = &w;

    SCREEN[idx++] = '0'+(char)sizeof(0);
    SCREEN[idx++] = '0'+(char)sizeof(idx);
    SCREEN[idx++] = '0'+(char)sizeof(b);
    SCREEN[idx++] = '0'+(char)sizeof(b*2);
    idx++;
    SCREEN[idx++] = '0'+(char)sizeof($43ff);
    SCREEN[idx++] = '0'+(char)sizeof(w);
    idx++;
    SCREEN[idx++] = '0'+(char)sizeof(bp);
    SCREEN[idx++] = '0'+(char)sizeof(wp);

}