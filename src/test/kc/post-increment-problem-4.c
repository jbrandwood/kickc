// Illustrates a problem with post-incrementing inside the while loop condition
// https://gitlab.com/camelot/kickc/-/issues/486

char MESSAGE[] = "hello world!";
char * const SCREEN = 0x0400;

void main(void) {
    char * s = MESSAGE;
    char c, i=0;
    while(c=*s++)
        SCREEN[i++] = c;
}
