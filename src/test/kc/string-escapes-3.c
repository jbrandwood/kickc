// Test using some simple supported string escape \n in both string and char
// Uses encoding PETSCII mixed

#pragma encoding(petscii_mixed)

char MESSAGE[] = "hello\nworld";
char CH = '\n';

char* SCREEN = (char*)0x0400;

void main() {
    byte* line = (char*)0x0400;
    byte* cursor = line;
    byte* msg = MESSAGE;

    while(*msg) {
        switch(*msg) {
            case '\n':
                line += 0x28;
                cursor = line;
                break;
            default:
                *cursor++ = *msg & 0x3f;
        }
        msg++;
    }

    SCREEN[0x50] = CH;
    
}