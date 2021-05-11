// Typedef an array

char* const SCREEN = (char*)0x0400;

typedef char STR[7];

STR a = "cml";

void main() {
    for(char i:0..6)
        SCREEN[i] = a[i];
}