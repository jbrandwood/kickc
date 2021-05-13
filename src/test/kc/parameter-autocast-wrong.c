// Illustrates problem with wrong type of parameters

char message[] = "CHAO0029 OPERATING SYSTEM STARTING...";

void main() {
    print_to_screen(*message); // Passes *(char*) - effectively char to function that takes char*
}

char* screen = (char*)0x0400;

void print_to_screen(char *message) {
    while(*message)
        *screen++ = *message++;
}