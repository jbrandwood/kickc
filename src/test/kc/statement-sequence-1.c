// Tests statement sequence  generation

void main() {

    byte* const SCREEN = (char*)0x0400;

    for(byte i: 0..10) {
        byte c = i+5;
        if((i&1)==0 || i>5)
            c++;
        SCREEN[i] = c;
    }


}
