// Hello World for MEGA 65 - putting chars directly to the screen
#pragma target(mega65)

char * SCREEN = (char*)0x0800;
char * COLORS = (char*)0xd800;

char MSG[] = "hello world!";

void main() {
    for(char i=0;MSG[i];i++) {
        SCREEN[i] = MSG[i];
        COLORS[i] = i;
    }
}