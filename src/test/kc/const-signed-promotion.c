// Test fragment promotion of a constant (400) to signed word even if it also matches an unsigned word

signed word world[3];

void main() {
    for(byte i:0..2) {
        world[i]= 400;
    }
    signed word* screen = (signed word*)$400;
    *screen = world[0];
}