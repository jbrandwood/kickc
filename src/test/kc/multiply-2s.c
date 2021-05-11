// Check that multiplication by factors of 2 is converted to shifts

void main() {
    byte* const SCREEN = (char*)$400;

    for(byte i: 0..10) {
        (SCREEN+0*40)[i] = i*1;
        (SCREEN+1*40)[i] = i*2;
        (SCREEN+2*40)[i] = i*4;
        (SCREEN+3*40)[i] = i*8;
        // And a single signed byte
        signed byte sb = -(signed byte)i;
        (SCREEN+5*40)[i] = (byte)(sb*2);

    }

}

