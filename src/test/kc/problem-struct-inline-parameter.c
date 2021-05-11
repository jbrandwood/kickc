// Illustrates problem with passing an inline struct value as a parameter

struct format {
    char prefix;
    char postfix;
};

void main() {
    print('c', (struct format){ '-', '-' } );
}

char * const SCREEN = (char*)0x0400;
char idx = 0;

void print(char c, struct format fmt) {
    SCREEN[idx++] = fmt.prefix;
    SCREEN[idx++] = c;
    SCREEN[idx++] = fmt.postfix;
}