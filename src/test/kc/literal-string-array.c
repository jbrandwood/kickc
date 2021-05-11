// Tests literal string array

char* const SCREEN = (char*)0x0400;
void* const NUL = (void*)0;

// Works
// char*[] msgs = { (char*)"hello", (char*)"cruel", (char*)"world", (char*)NUL };
// Not working
char* msgs[] = { "hello", "cruel", "world", NUL };

void main() {
    char i=0;
    char** msg = msgs;
    while(*msg) {
        char* c = *msg;
        while(*c) {
            SCREEN[i++] = *c++;
        }
        msg++;
    }
}

