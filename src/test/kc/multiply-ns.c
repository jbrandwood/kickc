// Check that multiplication by constants is converted to shift/add

void main() {
    byte* const SCREEN = (char*)0x0400;

    for(byte i: 0..17) {
        (SCREEN+0*40)[i] = i*1;
        (SCREEN+1*40)[i] = i*2;
        (SCREEN+2*40)[i] = i*3;
        (SCREEN+3*40)[i] = i*4;
        (SCREEN+4*40)[i] = i*5;
        (SCREEN+5*40)[i] = i*6;
        (SCREEN+6*40)[i] = i*7;
        (SCREEN+7*40)[i] = i*8;
        (SCREEN+8*40)[i] = i*9;
        (SCREEN+9*40)[i] = i*10;
        (SCREEN+10*40)[i] = i*11;
        (SCREEN+11*40)[i] = i*12;
        (SCREEN+12*40)[i] = i*13;
        (SCREEN+13*40)[i] = i*14;
        (SCREEN+14*40)[i] = i*15;
    }

}

