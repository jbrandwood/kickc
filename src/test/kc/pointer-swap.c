
byte buffer1[10];
byte buffer2[10];

byte *newbuffer = buffer1;
byte *oldbuffer = buffer2;
byte *tempbuffer;

char* screen = (char*)0x0400;
char hextab[] = "0123456789abcdef"z;

void print() {
    screen[0] = hextab[(char)tempbuffer&0x0f];
    screen[2] = hextab[(char)newbuffer&0x0f];
    screen[4] = hextab[(char)oldbuffer&0x0f];
    screen += 40;
}

void swap() {
    tempbuffer = newbuffer;
    newbuffer = oldbuffer;
    oldbuffer = tempbuffer;
    print();
}

void main() {
    print();
    swap();
    swap();
    swap();
}
