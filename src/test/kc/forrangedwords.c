
void main() {
    byte* SCREEN = $0400;
    for( word w: 0..$ffff) {
        SCREEN[0] = <w;
        SCREEN[1] = >w;
    }
    for( signed word sw: -$7fff..$7ffe) {
        SCREEN[3] = <sw;
        SCREEN[4] = >sw;
    }
}