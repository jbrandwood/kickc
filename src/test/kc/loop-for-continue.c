// Tests continue statement in a simple for()-loop

char* const SCREEN = (char*)$400;

const char MESSAGE[] = "hello brave new world!";

void main() {
    char idx = 0;
    for( char i =0; MESSAGE[i]; i++) {
        if(MESSAGE[i]==' ')
            continue;
        SCREEN[idx++] = MESSAGE[i];
    }
}