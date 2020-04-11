// Check that division by factors of 2 is converted to shifts

void main() {
    byte* const SCREEN = $400;

    for(byte i: 0..10) {
        (SCREEN+40*0)[i] = i/1;
        (SCREEN+40*1)[i] = i/2;
        (SCREEN+40*2)[i] = i/4;
        (SCREEN+40*3)[i] = i/8;
        // And a single signed byte
        signed byte sb = -(signed byte)i;
        (SCREEN+40*5)[i] = (byte)(sb/2);
    }

}

