// A test of boolean conditions using && || and !

void main() {
    char* const screen = (char*)0x400;
    for( char i : 0..20) {
        if( (i<10) && ((i&1)==0) ) {
            screen[i] = '*';
        }
    }
}


