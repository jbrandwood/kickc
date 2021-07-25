// Test intermediate vars

char * const SCREEN = (char*)0x0400;
char idx = 0;

void main() {

    for(char i=0;i<5;i++)
        for(char j=0;j<5;j++) {
            char x = i+j;
            SCREEN[idx++] = x;
            char y = sum(i,j);
            SCREEN[idx++] = y;
        }

}

char sum(char a,char b) {
    return a+b;
}

