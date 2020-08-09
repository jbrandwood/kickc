// Hello World for MEGA 65

#pragma target(mega65)

char * SCREEN = 0x0800;
char * COLORS = 0xd800;

char MSG[] = "hello world!";

void main() {
    for(char i=0;MSG[i];i++) {
        SCREEN[i] = MSG[i];
        COLORS[i] = i;
    }
}