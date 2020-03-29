// Tests statement sequence locality of if(cond) { stmt1; } else { stmt2; }

void main() {

    byte* const screen = 0x0400;
    byte idx = 0;

    for(byte i: 0..10) {
        if(i>5) {
            screen[idx++] = i;
        } else {
            screen[idx++] = i-5;
        }
    }


}