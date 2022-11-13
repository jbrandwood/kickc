// Check that multiplication by factors of 2 on the left side is converted to shifts

void main() {
    byte* const SCREEN = (char*)$400;

    for(byte i: 0..10) {
        (SCREEN+0*40)[i] = 1*i;
        (SCREEN+1*40)[i] = 2*i;
        (SCREEN+2*40)[i] = 4*i;
        (SCREEN+3*40)[i] = 8*i;
        // And a single signed byte
        signed byte sb = -(signed byte)i;
        (SCREEN+5*40)[i] = (byte)(2*sb);

    }

}

