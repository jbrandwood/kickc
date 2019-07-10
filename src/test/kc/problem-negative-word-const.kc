// Problem with assigning negative word constant (vwuz1=vbuc1)

word* screen = 0x0400;

void main() {
    for( byte i:0..7) {
        word w = i;
        if(i&1)
            w = -1;
        screen[i] = w;
    }
}