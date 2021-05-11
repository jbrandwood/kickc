// Test elimination of noop-casts (signed byte to byte)


void main() {
    signed word* const screen = (signed word*)0x400;
    signed word sw = 0x1234;
    for( byte i: 0..10) {
        sw += (signed byte)i;
        screen[i] = sw;
    }

}