// Example of inline kickasm data

__address(0x1000) char sintab[] = kickasm {{
    .fill 25, 20 + 20*sin(toRadians(i*360/25))
}};

void main() {
    byte* screen = $400;
    byte* cols = $d800;
    for(byte i:0..24) {
        byte sin = sintab[i];
        screen[sin] = '*';
        screen += 40;
        cols[sin] = 1;
        cols += 40;
    }
}
