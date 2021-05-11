// Classic for() does not allow assignment as increment, eg. for(byte i=0;i<40;i=i+2) {}
// The following should give a program rendering a char on every second char of the first line - but results in a syntax error

byte* SCREEN = (byte*)$0400;
void main() {
    for(byte i=0;i<40;i=i+2) {
       SCREEN[i] = i;
    }
}