
void main() {
    byte* screen = (byte*)$400;
    byte j = 0;
    signed byte i = -127;
    while(i<127) {
        screen[j] = (byte)i;
        i++;
        j++;
    }

}