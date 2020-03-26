// Tests treating a function like an array
// Should produce an error
// https://gitlab.com/camelot/kickc/issues/276

void main() {
    // Add a ball
    new_ball(0);
    new_ball[4];
}

const char BALLS[0x10];

void new_ball(char i) {
    BALLS[i]++;
}