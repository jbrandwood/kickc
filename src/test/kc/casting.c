byte* SCREEN = (byte*)$0400;
byte* SCREEN2 = SCREEN+40*3;
byte* SCREEN3 = SCREEN+40*6;
byte* SCREEN4 = SCREEN+40*9;

void main() {
    for( byte b: 0..100) {
        //Subtract unsigned byte from unsigned byte
        byte b2 = 200-b;
        SCREEN[b] = b2;
        // Cast unsigned byte to signed byte & negate
        signed byte sb = - (signed byte)b;
        SCREEN2[b] = (byte)sb;
    }
    w();
}


void w() {
    for(byte i : 0..10) {
        word w1 = 1300;
        word w2 = 1250;
        byte b = (byte)(w1-w2);
        byte b2 = 1400-1350+i;
        SCREEN3[i] = b;
        SCREEN4[i] = b2;
    }
}
