// Minimal range based for() loop

char* SCREEN1 = (char*)0x0400;
char* SCREEN2 = (char*)0x0500;

void main() {
    for(char i : 0..255) {
      SCREEN1[i] = i;
    }
    for(char j : 100..0) {
      SCREEN2[j] = j;
    }
}
