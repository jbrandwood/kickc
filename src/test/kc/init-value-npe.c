// https://gitlab.com/camelot/kickc/-/issues/650
char * const myscreen = (char*)$7000;
char * bitmap_screen;
void main() {
    memset(myscreen);
    if (0) {
        bitmap_init(myscreen);
        memset(bitmap_screen);
    }
}

void bitmap_init(char* screen) {
    bitmap_screen = screen;
}

void memset(void *str) {
    char* dst = (char*)str;
    *dst = 0;
}