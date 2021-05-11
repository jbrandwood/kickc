// Tests break statement in a simple loop

byte* const SCREEN = (char*)$400;

void main() {
    for( byte i: 0..40*6) {
        if(SCREEN[i]=='a')
            break;
        SCREEN[i] = 'a';
    }
}