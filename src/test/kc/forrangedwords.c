
void main() {
    byte* SCREEN = (byte*)$0400;
    for( word w: 0..$ffff) {
        SCREEN[0] = BYTE0(w);
        SCREEN[1] = BYTE1(w);
    }
    for( signed word sw: -$7fff..$7ffe) {
        SCREEN[3] = BYTE0(sw);
        SCREEN[4] = BYTE1(sw);
    }
}