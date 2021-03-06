// Test rewriting of constant comparisons

void main() {
    byte* const SCREEN = (byte*)$0400;

    for(byte* sc : SCREEN..SCREEN+1000) *sc=' ';

    byte header[] = "  <  <= == >= >";
    for( byte i=0; header[i]!=0; i++)
        SCREEN[i] = header[i];

    byte* screen = SCREEN;

    for(byte i=0;i<=9;i++) {
        screen +=40;
        screen[0] = '0'+i;
        if(i<5) screen[2] = '+';
        if(i<=5) screen[5] = '+';
        if(i==5) screen[8] = '+';
        if(i>=5) screen[11] = '+';
        if(i>5) screen[14] = '+';
    }
}