// Tests subtracting bytes from signed words

void main() {
    signed word w1 = 1234;
    signed word* screen = (signed word*)0x0400;
    for( byte i: 0..10 ) {
        w1 = w1 - 41;
        screen[i] = w1;
    }


}