// Test using some simple supported string escape \n in both string and char

char MESSAGE[] = "hello\nworld";
char* SCREEN = 0x0400;

void main() {
    byte* line = 0x0400;
    byte* cursor = line;
    byte* msg = MESSAGE;

    while(*msg) {
        switch(*msg) {
            case '\n':
                line += 0x28;
                cursor = line;
                break;
            default:
                *cursor++ = *msg;
        }
        msg++;
    }
    
}