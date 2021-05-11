byte* const plots = (byte*)$1000;
byte* const SCREEN = (byte*)$0400;

void main() {
    for(byte i : 0..39) {
       plots[i] = i;
       SCREEN[i] = 0;
    }
    do {
        line(0, 10);
    } while (true);
}

void line(byte x0, byte x1) {
    if(x0<x1) {
        for(byte x = x0; x<=x1; x++) {
            plot(x);
        }
    } else {
        plot(x0);
    }
}

void plot(byte x) {
    byte idx = plots[x];
    SCREEN[idx] = SCREEN[idx]+1;
}
